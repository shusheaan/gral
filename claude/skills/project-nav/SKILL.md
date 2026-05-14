---
name: project-nav
description: Interactive project navigation workflow using `work/scratchpad.md` as a shared whiteboard with Neovim-friendly jump locators to files, tests, functions, methods, classes, and symbol definitions. Use when the user says "项目导航", "开始项目导航", "project nav", asks to understand a feature, entry point, test orchestration, project architecture, call sequence, dependency impact, or wants a dynamic scratchpad for navigating source code with exact `path:line:column` locators.
---

# Project Nav

## Purpose

Use `work/scratchpad.md` as a live whiteboard for understanding a project.
The agent appends focused navigation cards for each user question, while the
generator maintains a disposable Neovim-jumpable symbol index.

This is for reading, architecture understanding, feature tracing, and test
orientation. Do not edit product code unless the user explicitly switches
from navigation to implementation.

## Jump contract

All navigation targets must be jumpable from Neovim with `gd`.

Treat "link" as a bare `path:line:column` locator, not as Markdown link
syntax. For every symbol, file, test, or scratchpad section, write a bare
locator at the beginning of the navigation line or immediately before the
label it describes:

- `../path/to/file.ext:42:1` from `work/scratchpad.md`; put the cursor on
  this token and use Neovim `gF` (or the user's `gd` mapping if it delegates
  to file locators) to jump to the exact file and line.
- `scratchpad.md:88:1` for another section inside `work/scratchpad.md`; do
  not use `#heading` / `#anchor` as the primary target.
- Keep the symbol name as plain text after the locator. Do not make the
  symbol name the only navigable target.
- Do not emit Markdown-only navigation such as `[symbol](../path#L42)`,
  `[section](#anchor)`, `section #anchor`, or `<a id="...">` unless the same
  line also contains a verified bare locator. Prefer avoiding Markdown links
  entirely in `work/scratchpad.md`.

## Workflow

### 1. Refresh the symbol index

Preserve existing user notes in `work/scratchpad.md`. Refresh only the
generated region between:

   - `<!-- project-nav:begin -->`
   - `<!-- project-nav:end -->`

Run the bundled generator from the repo root:

   ```bash
   python3 claude/skills/project-nav/scripts/build_scratchpad_nav.py --root .
   ```

Treat the generated navigation map as disposable; rerun the script after
code moves or edits.

### 2. For each user question, append a navigation card

Write cards under `## 交互记录`. Use this format:

```markdown
### Q: <用户问题>

#### 结论先行
- <1-3 bullets: what matters and why>

#### 入口
../path/to/file.ext:10:1 — symbol — <meaning>

#### 主要调用顺序
../path/to/file.ext:20:1 — caller
../path/to/file.ext:45:1 — callee（由 caller 调用）

#### 相关测试
../tests/test_file.py:12:1 — test_name — <what it proves>

#### 放大 / 忽略
- 放大：<files/functions worth opening next>
- 暂时忽略：<irrelevant paths and why>

#### 下一步问题
- <one or two precise follow-up questions the user can ask>
```

### 3. Navigation judgment rules

- Start from the user’s feature/question, not from every file in the repo.
- Identify entry points first: CLI command, API handler, UI event, test, main
  script, config hook, or public function.
- Trace only the main path first. Expand side paths only when they affect the
  answer.
- Always include related tests when the user asks about behavior,
  orchestration, or meaning.
- "该放大的放大，无视的无视": explicitly separate important files/functions
  from incidental plumbing.
- Prefer exact `../path:line:column` locators. If exact symbol detection
  fails, use the closest file line and say it is an approximate anchor.
- If you refer to another Markdown section in `work/scratchpad.md`, use a
  `scratchpad.md:line:column` locator rather than a Markdown anchor.
- Keep each card compact enough to scan. Add a new card rather than rewriting
  history unless correcting a factual error.

### 4. Validate before reporting

Before reporting completion, run:

```bash
python3 claude/skills/project-nav/scripts/build_scratchpad_nav.py --root . --check
```

`--check` exits non-zero if the generated symbol index would change.
Also scan newly generated or appended navigation text for Markdown-only links:
there must be no `](#...)`, `section #...`, or `<a id="...">` navigation
target without a nearby bare locator.

## Safety rules

- Do not overwrite free-form notes outside the generated markers.
- Do not delete existing `work/scratchpad.md` content.
- Prefer locators relative to `work/scratchpad.md` so Neovim jumps keep
  working after the repo is moved.
- Keep navigation factual: every locator must point to a real file and
  definition line in the current repo.
