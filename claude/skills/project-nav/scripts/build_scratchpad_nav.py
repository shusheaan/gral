#!/usr/bin/env python3
from __future__ import annotations

import argparse
import ast
import re
import sys
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import Iterator, Sequence


BEGIN_MARKER = "<!-- project-nav:begin -->"
END_MARKER = "<!-- project-nav:end -->"
LEGACY_BEGIN_MARKER = "<!-- scratchpad-nav:begin -->"
LEGACY_END_MARKER = "<!-- scratchpad-nav:end -->"

EXCLUDED_DIRS = frozenset(
    {
        ".git",
        ".hg",
        ".mypy_cache",
        ".pytest_cache",
        ".ruff_cache",
        ".tox",
        ".venv",
        "__pycache__",
        "build",
        "dist",
        "node_modules",
        "target",
        "tmp",
        "vendor",
        "workmux",
    }
)

TEXT_EXTENSIONS = frozenset(
    {
        ".bash",
        ".c",
        ".cc",
        ".cpp",
        ".go",
        ".h",
        ".hpp",
        ".js",
        ".jsx",
        ".lua",
        ".mjs",
        ".py",
        ".rs",
        ".sh",
        ".ts",
        ".tsx",
        ".vim",
        ".zsh",
    }
)

SPECIAL_FILENAMES = frozenset(
    {
        "bashrc",
        "profile",
        "vimrc",
        "zshrc",
    }
)


@dataclass(frozen=True)
class Symbol:
    rel_path: Path
    line: int
    column: int
    kind: str
    name: str
    signature: str


@dataclass(frozen=True)
class RegexRule:
    kind: str
    pattern: re.Pattern[str]


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build or check work/scratchpad.md with Neovim-friendly code navigation locators."
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path.cwd(),
        help="Repository root. Defaults to current directory.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Scratchpad path. Defaults to <root>/work/scratchpad.md.",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Exit non-zero if the scratchpad would change.",
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str]) -> int:
    args = parse_args(argv)
    root = args.root.resolve()
    output = (
        args.output.resolve()
        if args.output is not None
        else root / "work" / "scratchpad.md"
    )

    if not root.exists() or not root.is_dir():
        raise ValueError(f"Root is not a directory: {root}")

    existing = read_optional_text(output)
    symbols = collect_symbols(root)
    generated = render_generated_section(
        root=root,
        output=output,
        symbols=symbols,
        start_line=generated_start_line(existing),
    )
    validate_generated_section(generated)
    next_text = update_scratchpad(
        existing=existing,
        generated=generated,
    )

    if args.check:
        current_text = read_optional_text(output)
        if current_text != next_text:
            print(f"{output} is stale; rerun without --check", file=sys.stderr)
            return 1
        print(f"{output} is up to date")
        return 0

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(next_text, encoding="utf-8")
    print(f"Wrote {output} with {len(symbols)} symbols")
    return 0


def read_optional_text(path: Path) -> str | None:
    if not path.exists():
        return None
    return path.read_text(encoding="utf-8")


def generated_start_line(existing: str | None) -> int:
    if existing is None:
        return default_scratchpad_prefix().count("\n") + 1

    marker_span = find_generated_span(existing)
    if marker_span is None:
        separator = "\n" if existing.endswith("\n") else "\n\n"
        return (existing + separator).count("\n") + 1

    start, _, _ = marker_span
    prefix = existing[:start].rstrip() + "\n\n"
    return prefix.count("\n") + 1


def collect_symbols(root: Path) -> tuple[Symbol, ...]:
    symbols: list[Symbol] = []
    for path in iter_source_files(root):
        rel_path = path.relative_to(root)
        text = path.read_text(encoding="utf-8", errors="replace")
        symbols.extend(extract_symbols(rel_path, text))
    return tuple(
        sorted(
            symbols,
            key=lambda item: (item.rel_path.as_posix(), item.line, item.column, item.name),
        )
    )


def iter_source_files(root: Path) -> Iterator[Path]:
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        rel_path = path.relative_to(root)
        if is_excluded(rel_path):
            continue
        if is_source_file(path):
            yield path


def is_excluded(rel_path: Path) -> bool:
    return any(part in EXCLUDED_DIRS or part.startswith(".") for part in rel_path.parts[:-1])


def is_source_file(path: Path) -> bool:
    return path.suffix in TEXT_EXTENSIONS or path.name in SPECIAL_FILENAMES


def extract_symbols(rel_path: Path, text: str) -> tuple[Symbol, ...]:
    if rel_path.suffix == ".py":
        return extract_python_symbols(rel_path, text)
    if rel_path.suffix == ".lua":
        return extract_regex_symbols(rel_path, text, lua_rules())
    if rel_path.suffix in {".sh", ".bash", ".zsh"} or rel_path.name in {
        "bashrc",
        "zshrc",
    }:
        return extract_regex_symbols(rel_path, text, shell_rules())
    if rel_path.suffix in {".js", ".jsx", ".mjs", ".ts", ".tsx"}:
        return extract_regex_symbols(rel_path, text, js_rules())
    if rel_path.suffix == ".rs":
        return extract_regex_symbols(rel_path, text, rust_rules())
    if rel_path.suffix in {".vim"} or rel_path.name == "vimrc":
        return extract_regex_symbols(rel_path, text, vim_rules())
    if rel_path.suffix in {".c", ".cc", ".cpp", ".h", ".hpp", ".go"}:
        return extract_regex_symbols(rel_path, text, c_like_rules())
    return tuple()


def extract_python_symbols(rel_path: Path, text: str) -> tuple[Symbol, ...]:
    try:
        module = ast.parse(text)
    except SyntaxError:
        return tuple()

    lines = text.splitlines()
    return tuple(visit_python_node(rel_path, lines, module, tuple()))


def visit_python_node(
    rel_path: Path,
    lines: Sequence[str],
    node: ast.AST,
    scope: tuple[str, ...],
) -> Iterator[Symbol]:
    if isinstance(node, ast.ClassDef):
        yield make_python_symbol(rel_path, lines, node, "class", scope)
        for child in node.body:
            yield from visit_python_node(rel_path, lines, child, scope + (node.name,))
        return

    if isinstance(node, ast.AsyncFunctionDef):
        kind = "async method" if scope else "async function"
        yield make_python_symbol(rel_path, lines, node, kind, scope)
        for child in node.body:
            yield from visit_python_node(rel_path, lines, child, scope + (node.name,))
        return

    if isinstance(node, ast.FunctionDef):
        kind = "method" if scope else "function"
        yield make_python_symbol(rel_path, lines, node, kind, scope)
        for child in node.body:
            yield from visit_python_node(rel_path, lines, child, scope + (node.name,))
        return

    for child in ast.iter_child_nodes(node):
        yield from visit_python_node(rel_path, lines, child, scope)


def make_python_symbol(
    rel_path: Path,
    lines: Sequence[str],
    node: ast.ClassDef | ast.AsyncFunctionDef | ast.FunctionDef,
    kind: str,
    scope: tuple[str, ...],
) -> Symbol:
    name = ".".join(scope + (node.name,))
    return Symbol(
        rel_path=rel_path,
        line=node.lineno,
        column=node.col_offset + 1,
        kind=kind,
        name=name,
        signature=signature_at(lines, node.lineno),
    )


def extract_regex_symbols(
    rel_path: Path,
    text: str,
    rules: Sequence[RegexRule],
) -> tuple[Symbol, ...]:
    symbols: list[Symbol] = []
    for line_number, line in enumerate(text.splitlines(), start=1):
        stripped = line.strip()
        if is_comment_line(stripped, rel_path.suffix):
            continue
        for rule in rules:
            match = rule.pattern.search(line)
            if not match:
                continue
            name = match.group("name")
            symbols.append(
                Symbol(
                    rel_path=rel_path,
                    line=line_number,
                    column=match.start("name") + 1,
                    kind=rule.kind,
                    name=name,
                    signature=compact_signature(line),
                )
            )
            break
    return tuple(symbols)


def is_comment_line(stripped: str, suffix: str) -> bool:
    if suffix == ".lua":
        return stripped.startswith("--")
    if suffix in {".py", ".sh", ".bash", ".zsh"}:
        return stripped.startswith("#")
    if suffix in {".js", ".jsx", ".mjs", ".ts", ".tsx", ".rs", ".c", ".cc", ".cpp", ".h", ".hpp", ".go"}:
        return stripped.startswith("//")
    if suffix == ".vim":
        return stripped.startswith('"')
    return False


def lua_rules() -> tuple[RegexRule, ...]:
    return (
        RegexRule("function", re.compile(r"^\s*(?:local\s+)?function\s+(?P<name>[\w_.:]+)\s*\(")),
        RegexRule("function", re.compile(r"^\s*(?P<name>[\w_.:]+)\s*=\s*function\s*\(")),
    )


def shell_rules() -> tuple[RegexRule, ...]:
    return (
        RegexRule("function", re.compile(r"^\s*(?:function\s+)?(?P<name>[A-Za-z_][\w.-]*)\s*\(\s*\)\s*\{?")),
        RegexRule("function", re.compile(r"^\s*function\s+(?P<name>[A-Za-z_][\w.-]*)\b")),
    )


def js_rules() -> tuple[RegexRule, ...]:
    return (
        RegexRule("class", re.compile(r"^\s*(?:export\s+default\s+|export\s+)?class\s+(?P<name>[A-Za-z_$][\w$]*)\b")),
        RegexRule("function", re.compile(r"^\s*(?:export\s+)?(?:async\s+)?function\s+(?P<name>[A-Za-z_$][\w$]*)\s*\(")),
        RegexRule("function", re.compile(r"^\s*(?:export\s+)?(?:const|let|var)\s+(?P<name>[A-Za-z_$][\w$]*)\s*=\s*(?:async\s*)?\(")),
        RegexRule("method", re.compile(r"^\s*(?:async\s+)?(?P<name>[A-Za-z_$][\w$]*)\s*\([^)]*\)\s*\{")),
    )


def rust_rules() -> tuple[RegexRule, ...]:
    visibility = r"(?:pub(?:\([^)]*\))?\s+)?"
    return (
        RegexRule("function", re.compile(rf"^\s*{visibility}(?:async\s+)?(?:unsafe\s+)?fn\s+(?P<name>[A-Za-z_]\w*)\b")),
        RegexRule("struct", re.compile(rf"^\s*{visibility}struct\s+(?P<name>[A-Za-z_]\w*)\b")),
        RegexRule("enum", re.compile(rf"^\s*{visibility}enum\s+(?P<name>[A-Za-z_]\w*)\b")),
        RegexRule("trait", re.compile(rf"^\s*{visibility}trait\s+(?P<name>[A-Za-z_]\w*)\b")),
        RegexRule("impl", re.compile(r"^\s*impl(?:<[^>]+>)?\s+(?P<name>[A-Za-z_]\w*)\b")),
    )


def vim_rules() -> tuple[RegexRule, ...]:
    return (
        RegexRule("function", re.compile(r"^\s*function!?\s+(?P<name>[A-Za-z_][\w#.]*)(?:\s*\(|$)")),
    )


def c_like_rules() -> tuple[RegexRule, ...]:
    return (
        RegexRule("function", re.compile(r"^\s*(?:[A-Za-z_][\w:<>*&\s]+)\s+(?P<name>[A-Za-z_]\w*)\s*\([^;]*\)\s*\{?\s*$")),
    )


def signature_at(lines: Sequence[str], line: int) -> str:
    if 1 <= line <= len(lines):
        return compact_signature(lines[line - 1])
    return ""


def compact_signature(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip())[:140]


def update_scratchpad(existing: str | None, generated: str) -> str:
    if existing is None:
        return default_scratchpad(generated)

    marker_span = find_generated_span(existing)
    if marker_span is None:
        separator = "\n" if existing.endswith("\n") else "\n\n"
        return existing + separator + generated

    start, end, end_marker = marker_span
    end_after_marker = end + len(END_MARKER)
    if end_marker == LEGACY_END_MARKER:
        end_after_marker = end + len(LEGACY_END_MARKER)
    prefix = existing[:start].rstrip() + "\n\n"
    suffix = existing[end_after_marker:].lstrip("\n")
    if suffix:
        return prefix + generated + "\n\n" + suffix
    return prefix + generated + "\n"


def find_generated_span(existing: str) -> tuple[int, int, str] | None:
    for begin_marker, end_marker in (
        (BEGIN_MARKER, END_MARKER),
        (LEGACY_BEGIN_MARKER, LEGACY_END_MARKER),
    ):
        start = existing.find(begin_marker)
        end = existing.find(end_marker)
        if start != -1 and end != -1 and start <= end:
            return start, end, end_marker
    return None


def default_scratchpad(generated: str) -> str:
    return default_scratchpad_prefix() + f"{generated}\n"


def default_scratchpad_prefix() -> str:
    return (
        "# Project Nav — 项目导航白板\n\n"
        "这个文件用于用户和 agent 协作梳理项目结构、功能入口、调用顺序、测试编排和架构知识。"
        "自由编辑 `## 交互记录`；自动导航图只更新标记之间的内容。\n\n"
        "## 交互记录\n\n"
        "- 待补充：当前想看的功能、入口、测试、疑问、下一步导航路线。\n\n"
    )


def render_generated_section(
    root: Path,
    output: Path,
    symbols: Sequence[Symbol],
    start_line: int,
) -> str:
    source_files = len({symbol.rel_path for symbol in symbols})
    symbol_groups = group_symbols(symbols)
    section_line_placeholders: list[tuple[int, int]] = []
    section_locators: dict[int, str] = {}
    lines = [
        BEGIN_MARKER,
        "## 自动生成项目符号索引",
        "",
        "- Generated by: `project-nav`",
        f"- Root: `{root}`",
        f"- Source files with symbols: `{source_files}`",
        f"- Symbols: `{len(symbols)}`",
        "",
        "### 使用方式",
        "",
        "- Neovim：把光标放在裸 locator（`../path:line:column`）上，用 `gF`（或你的 `gd` 映射）跳到定义。",
        "- locator 相对 `work/scratchpad.md`；它是主导航入口，不依赖 Markdown 预览或鼠标点击。",
        "- 代码移动后，重新运行 `python3 claude/skills/project-nav/scripts/build_scratchpad_nav.py --root .`。",
        "- 这个索引用来找全局入口；具体功能解释写在上面的 `## 交互记录`。",
        "",
        "### 文件索引",
        "",
    ]

    for index, (rel_path, file_symbols) in enumerate(symbol_groups):
        locator = relative_locator(output, root, rel_path, 1, 1)
        placeholder = f"__PROJECT_NAV_SECTION_{index}__"
        section_line_placeholders.append((len(lines), index))
        lines.append(
            f"{locator} — {rel_path.as_posix()} — {len(file_symbols)} symbols — section {placeholder}"
        )

    lines.extend(["", "### Symbols by file", ""])

    for index, (rel_path, file_symbols) in enumerate(symbol_groups):
        section_line = start_line + len(lines)
        section_locators[index] = relative_self_locator(output, root, section_line, 1)
        lines.append(f"#### {rel_path.as_posix()}")
        lines.append("")
        for symbol in file_symbols:
            lines.append(
                f"{relative_symbol_locator(output, root, symbol)} — `{symbol.kind}` {symbol.name}"
            )
            if symbol.signature:
                lines.append(f"  signature: `{symbol.signature}`")
        lines.append("")

    lines.append(END_MARKER)
    for line_index, section_index in section_line_placeholders:
        lines[line_index] = lines[line_index].replace(
            f"__PROJECT_NAV_SECTION_{section_index}__",
            section_locators[section_index],
        )
    return "\n".join(lines)


def validate_generated_section(generated: str) -> None:
    forbidden_patterns = (
        re.compile(r"\[[^\]]+\]\([^)]+\)"),
        re.compile(r"<a\s+id=", re.IGNORECASE),
        re.compile(r"\bsection\s+#"),
    )
    bad_lines: list[str] = []
    for line_number, line in enumerate(generated.splitlines(), start=1):
        if any(pattern.search(line) for pattern in forbidden_patterns):
            bad_lines.append(f"{line_number}: {line}")

    if bad_lines:
        raise ValueError(
            "Generated section contains Markdown-only navigation targets; "
            "use gd-jumpable path:line:column locators instead:\n"
            + "\n".join(bad_lines)
        )


def group_symbols(symbols: Sequence[Symbol]) -> tuple[tuple[Path, tuple[Symbol, ...]], ...]:
    groups: list[tuple[Path, tuple[Symbol, ...]]] = []
    current_path: Path | None = None
    current_symbols: list[Symbol] = []

    for symbol in symbols:
        if current_path is None:
            current_path = symbol.rel_path
        if symbol.rel_path != current_path:
            groups.append((current_path, tuple(current_symbols)))
            current_path = symbol.rel_path
            current_symbols = []
        current_symbols.append(symbol)

    if current_path is not None:
        groups.append((current_path, tuple(current_symbols)))
    return tuple(groups)


def relative_symbol_locator(output: Path, root: Path, symbol: Symbol) -> str:
    return relative_locator(output, root, symbol.rel_path, symbol.line, symbol.column)


def relative_self_locator(output: Path, root: Path, line: int, column: int) -> str:
    return relative_locator(output, root, output.relative_to(root), line, column)


def relative_locator(
    output: Path,
    root: Path,
    target_rel_path: Path,
    line: int,
    column: int,
) -> str:
    output_dir_rel = output.parent.resolve().relative_to(root)
    relative_path = relative_posix_path(output_dir_rel, target_rel_path)
    return f"{relative_path}:{line}:{column}"


def relative_posix_path(from_dir: Path, to_path: Path) -> str:
    from_parts = tuple(part for part in from_dir.parts if part not in {"", "."})
    to_parts = tuple(part for part in to_path.parts if part not in {"", "."})

    common = 0
    for left, right in zip(from_parts, to_parts):
        if left != right:
            break
        common += 1

    up_parts = ("..",) * (len(from_parts) - common)
    down_parts = to_parts[common:]
    if not up_parts and not down_parts:
        return "."
    return PurePosixPath(*up_parts, *down_parts).as_posix()

if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv[1:]))
    except ValueError as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(2)
