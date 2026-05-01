#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence


@dataclass(frozen=True)
class OutlineItem:
    line_number: int
    text: str


@dataclass(frozen=True)
class RegexRule:
    pattern: re.Pattern[str]
    excluded_prefixes: tuple[str, ...] = ()

    @classmethod
    def from_pattern(
        cls,
        pattern: str,
        excluded_prefixes: tuple[str, ...] = (),
    ) -> RegexRule:
        return cls(re.compile(pattern), excluded_prefixes)

    def matches(self, text: str) -> bool:
        stripped = text.lstrip()
        if any(stripped.startswith(prefix) for prefix in self.excluded_prefixes):
            return False
        return self.pattern.match(text) is not None


CONTROL_PREFIXES = (
    "if",
    "else",
    "for",
    "while",
    "switch",
    "catch",
    "do",
    "return",
)


def extension_for(path: Path) -> str:
    return path.suffix.lower().lstrip(".")


def rules_for_extension(extension: str) -> tuple[RegexRule, ...]:
    if extension == "py":
        return (
            RegexRule.from_pattern(r"^\s*class\s+\w+.*:\s*$"),
            RegexRule.from_pattern(r"^\s*(?:async\s+)?def\s+\w+.*"),
        )

    if extension == "rs":
        visibility = r"(?:pub(?:\([^)]*\))?\s+)?"
        return (
            RegexRule.from_pattern(rf"^\s*{visibility}(?:struct|enum|trait)\s+\w+"),
            RegexRule.from_pattern(r"^\s*(?:unsafe\s+)?impl(?:<[^>]*>)?\s+"),
            RegexRule.from_pattern(
                rf"^\s*{visibility}(?:async\s+|unsafe\s+|extern\s+|const\s+)*fn\s+\w+"
            ),
        )

    if extension == "go":
        return (
            RegexRule.from_pattern(r"^\s*type\s+\w+\s+(?:struct|interface)\b"),
            RegexRule.from_pattern(r"^\s*func(?:\s*\([^)]*\))?\s+\w+"),
        )

    if extension == "lua":
        return (
            RegexRule.from_pattern(r"^\s*(?:local\s+)?function\s+[\w.:]+"),
            RegexRule.from_pattern(r"^\s*[\w.]+\s*=\s*function\b"),
        )

    if extension == "vim":
        return (RegexRule.from_pattern(r"^\s*fu(?:nction)?!?\s+[\w#:<>.]+"),)

    if extension in ("sh", "bash", "zsh", "fish"):
        return (
            RegexRule.from_pattern(r"^\s*(?:function\s+)?[\w.-]+\s*(?:\(\))?\s*\{"),
        )

    if extension in ("js", "jsx", "ts", "tsx"):
        return (
            RegexRule.from_pattern(
                r"^\s*(?:export\s+)?(?:abstract\s+)?(?:class|interface|enum)\s+\w+"
            ),
            RegexRule.from_pattern(r"^\s*(?:export\s+)?type\s+\w+\s*="),
            RegexRule.from_pattern(r"^\s*(?:export\s+)?(?:async\s+)?function\s+\w+"),
            RegexRule.from_pattern(
                r"^\s*(?:export\s+)?(?:const|let|var)\s+\w+\s*=.*=>"
            ),
            RegexRule.from_pattern(
                r"^\s*(?:public\s+|private\s+|protected\s+|static\s+|async\s+|get\s+|set\s+)*\w+\s*\([^)]*\)\s*(?::[^{]+)?\{",
                CONTROL_PREFIXES,
            ),
        )

    if extension == "swift":
        return (
            RegexRule.from_pattern(r"^\s*(?:public\s+|private\s+|internal\s+|open\s+|final\s+)*"
                                   r"(?:class|struct|enum|protocol)\s+\w+"),
            RegexRule.from_pattern(r"^\s*(?:public\s+|private\s+|internal\s+|static\s+)*func\s+\w+"),
        )

    if extension in ("c", "h", "cpp", "hpp", "cc", "cxx", "java", "kt"):
        return (
            RegexRule.from_pattern(
                r"^\s*(?:public\s+|private\s+|protected\s+|internal\s+|open\s+|final\s+|static\s+|extern\s+|template\s*<[^>]+>\s*|inline\s+|virtual\s+|override\s+|export\s+)*"
                r"(?:struct|class|enum|interface)\s+\w+"
            ),
            RegexRule.from_pattern(
                r"^\s*(?:public\s+|private\s+|protected\s+|internal\s+|open\s+|final\s+|static\s+|extern\s+|template\s*<[^>]+>\s*|inline\s+|virtual\s+|override\s+|async\s+|func\s+)*"
                r"[\w:<>,~*&\[\]\s]+\s+\w+\s*\([^;]*\)\s*(?:const\s*)?(?:->\s*[\w:<>,~*&\[\]\s]+)?\s*\{",
                CONTROL_PREFIXES,
            ),
        )

    return ()


def leading_spaces(text: str) -> int:
    return len(text) - len(text.lstrip(" "))


def compact_indent(text: str) -> str:
    stripped = text.lstrip()
    level = min(leading_spaces(text) // 4, 6)
    return ("  " * level) + stripped


def strip_inline_comment(text: str, extension: str) -> str:
    comment_markers = ("//",) if extension in {
        "c",
        "h",
        "cpp",
        "hpp",
        "cc",
        "cxx",
        "go",
        "java",
        "js",
        "jsx",
        "kt",
        "rs",
        "swift",
        "ts",
        "tsx",
    } else ("#",)

    if extension == "lua":
        comment_markers = ("--",)
    elif extension == "vim":
        comment_markers = ('"',)

    result = text
    for marker in comment_markers:
        marker_index = result.find(f" {marker}")
        if marker_index != -1:
            result = result[:marker_index]

    return result.rstrip()


def compact_signature(text: str, extension: str) -> str:
    without_comment = strip_inline_comment(text.rstrip(), extension)
    indent = "  " * min(leading_spaces(without_comment) // 4, 6)
    body = re.sub(r"\s+", " ", without_comment.lstrip())
    body = re.sub(r"\s*\{\s*$", "", body).strip()
    compacted = indent + normalized_signature(body, extension)

    if len(compacted) > 140:
        return compacted[:137].rstrip() + "..."

    return compacted


def strip_rust_visibility(text: str) -> str:
    return re.sub(r"^pub(?:\([^)]*\))?\s+", "", text)


def normalized_signature(body: str, extension: str) -> str:
    if extension == "py":
        match = re.match(r"(?:async\s+)?def\s+(\w+)", body)
        if match:
            return f"def {match.group(1)}"

        match = re.match(r"class\s+(\w+)", body)
        if match:
            return f"class {match.group(1)}"

    if extension == "rs":
        rust_body = strip_rust_visibility(body)
        match = re.match(r"(struct|enum|trait)\s+(\w+)", rust_body)
        if match:
            return f"{match.group(1)} {match.group(2)}"

        match = re.match(r"impl(?:<[^>]*>)?\s+(.+)", rust_body)
        if match:
            target = re.split(r"\s+where\s+", match.group(1), maxsplit=1)[0].strip()
            return f"impl {target}"

        match = re.match(r"(?:async\s+|unsafe\s+|extern\s+|const\s+)*fn\s+(\w+)", rust_body)
        if match:
            return f"fn {match.group(1)}"

    if extension == "go":
        match = re.match(r"type\s+(\w+)\s+(struct|interface)\b", body)
        if match:
            return f"{match.group(2)} {match.group(1)}"

        match = re.match(r"func\s+\(([^)]*)\)\s*(\w+)", body)
        if match:
            receiver = normalized_go_receiver(match.group(1))
            if receiver:
                return f"func {receiver}.{match.group(2)}"
            return f"func {match.group(2)}"

        match = re.match(r"func\s+(\w+)", body)
        if match:
            return f"func {match.group(1)}"

    if extension == "lua":
        match = re.match(r"(?:local\s+)?function\s+([\w.:]+)", body)
        if match:
            return f"function {match.group(1)}"

        match = re.match(r"([\w.]+)\s*=\s*function\b", body)
        if match:
            return f"function {match.group(1)}"

    if extension == "vim":
        match = re.match(r"fu(?:nction)?!?\s+([\w#:<>.]+)", body)
        if match:
            return f"function {match.group(1)}"

    if extension in ("sh", "bash", "zsh", "fish"):
        match = re.match(r"(?:function\s+)?([\w.-]+)\s*(?:\(\))?", body)
        if match:
            return f"function {match.group(1)}"

    if extension in ("js", "jsx", "ts", "tsx"):
        js_body = re.sub(r"^(?:export\s+|default\s+|abstract\s+|async\s+)+", "", body)
        match = re.match(r"(class|interface|enum)\s+(\w+)", js_body)
        if match:
            return f"{match.group(1)} {match.group(2)}"

        match = re.match(r"type\s+(\w+)", js_body)
        if match:
            return f"type {match.group(1)}"

        match = re.match(r"function\s+(\w+)", js_body)
        if match:
            return f"function {match.group(1)}"

        match = re.match(r"(?:const|let|var)\s+(\w+)\s*=", js_body)
        if match:
            return f"fn {match.group(1)}"

        match = re.match(
            r"(?:public\s+|private\s+|protected\s+|static\s+|async\s+|get\s+|set\s+)*(\w+)\s*\(",
            js_body,
        )
        if match:
            return f"method {match.group(1)}"

    if extension == "swift":
        match = re.match(r"(class|struct|enum|protocol)\s+(\w+)", body)
        if match:
            return f"{match.group(1)} {match.group(2)}"

        match = re.match(r"func\s+(\w+)", body)
        if match:
            return f"func {match.group(1)}"

    if extension in ("c", "h", "cpp", "hpp", "cc", "cxx", "java", "kt"):
        match = re.match(
            r"(?:public\s+|private\s+|protected\s+|internal\s+|open\s+|final\s+|static\s+|extern\s+|template\s*<[^>]+>\s*|inline\s+|virtual\s+|override\s+|export\s+)*"
            r"(struct|class|enum|interface)\s+(\w+)",
            body,
        )
        if match:
            return f"{match.group(1)} {match.group(2)}"

        function_name = c_like_function_name(body)
        if function_name:
            return f"fn {function_name}"

    return fallback_signature(body)


def normalized_go_receiver(receiver: str) -> str:
    parts = receiver.replace("*", " ").split()
    if not parts:
        return ""

    return parts[-1]


def c_like_function_name(body: str) -> str:
    if "(" not in body:
        return ""

    before_paren = body.split("(", maxsplit=1)[0].rstrip()
    match = re.search(r"([~\w]+)$", before_paren)
    if not match:
        return ""

    return match.group(1)


def fallback_signature(body: str) -> str:
    body = re.sub(r"\([^)]*\)", "", body)
    body = re.sub(r"\s+", " ", body)
    return body.strip()


def is_comment_or_import(text: str, extension: str) -> bool:
    stripped = text.lstrip()
    if stripped == "":
        return True

    comment_prefixes = ("#",)
    if extension in {
        "c",
        "h",
        "cpp",
        "hpp",
        "cc",
        "cxx",
        "go",
        "java",
        "js",
        "jsx",
        "kt",
        "rs",
        "swift",
        "ts",
        "tsx",
    }:
        comment_prefixes = ("//", "/*", "*")
    elif extension == "lua":
        comment_prefixes = ("--",)
    elif extension == "vim":
        comment_prefixes = ('"',)

    if stripped.startswith(comment_prefixes):
        return True

    import_prefixes = {
        "py": ("import ", "from "),
        "rs": ("use ", "extern crate "),
        "go": ("import ",),
        "java": ("import ", "package "),
        "kt": ("import ", "package "),
        "swift": ("import ",),
        "js": ("import ", "export {"),
        "jsx": ("import ", "export {"),
        "ts": ("import ", "export {"),
        "tsx": ("import ", "export {"),
        "c": ("#include",),
        "h": ("#include",),
        "cpp": ("#include",),
        "hpp": ("#include",),
        "cc": ("#include",),
        "cxx": ("#include",),
    }

    return stripped.startswith(import_prefixes.get(extension, ()))


def outline_items(lines: Sequence[str], extension: str, max_items: int) -> tuple[OutlineItem, ...]:
    rules = rules_for_extension(extension)
    if not rules:
        return ()

    items: list[OutlineItem] = []
    for index, line in enumerate(lines, start=1):
        if len(items) >= max_items:
            break

        if is_comment_or_import(line, extension):
            continue

        if any(rule.matches(line) for rule in rules):
            items.append(OutlineItem(index, compact_signature(line, extension)))

    return tuple(items)


def read_lines(path: Path) -> tuple[str, ...]:
    return tuple(path.read_text(encoding="utf-8", errors="replace").splitlines())


def render(items: Sequence[OutlineItem]) -> str:
    return "\n".join(f"{item.line_number}\t{item.text}" for item in items)


def parse_max_items(raw_value: str) -> int:
    try:
        value = int(raw_value)
    except ValueError:
        return 40

    return max(1, value)


def main(argv: Sequence[str]) -> int:
    if len(argv) != 3:
        return 2

    path = Path(argv[1])
    max_items = parse_max_items(argv[2])
    items = outline_items(read_lines(path), extension_for(path), max_items)
    if not items:
        return 1

    print(render(items))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
