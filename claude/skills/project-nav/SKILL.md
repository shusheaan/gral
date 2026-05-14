---
name: project-nav
description: Interactive project navigation workflow using `work/scratchpad.md` as a shared whiteboard with clickable links to files, tests, functions, methods, classes, and symbol definitions. Use when the user says "项目导航", "开始项目导航", "project nav", asks to understand a feature, entry point, test orchestration, project architecture, call sequence, dependency impact, or wants a dynamic scratchpad for navigating source code with exact `path#Lline` / `path:line:column` locators.
---

# Project Nav

## Purpose

Use `work/scratchpad.md` as a live whiteboard for understanding a project.
The agent appends focused navigation cards for each user question, while the
generator maintains a disposable clickable symbol index.

This is for reading, architecture understanding, feature tracing, and test
orientation. Do not edit product code unless the user explicitly switches
from navigation to implementation.

## Link contract

Use both formats for every symbol:

- Markdown link: `[symbol](../path/to/file.ext#L42)` from
  `work/scratchpad.md`; this is clickable in GitHub-style Markdown and
  many editor previews.
- Agent locator: ``path/to/file.ext:42:1``; this is copy/paste-friendly
  for tools that open `file:line:column`.

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
- [`symbol`](../path/to/file.ext#L10) · `path/to/file.ext:10:1` — <meaning>

#### 主要调用顺序
1. [`caller`](../path/to/file.ext#L20) · `path/to/file.ext:20:1`
   → [`callee`](../path/to/file.ext#L45) · `path/to/file.ext:45:1`

#### 相关测试
- [`test_name`](../tests/test_file.py#L12) · `tests/test_file.py:12:1` — <what it proves>

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
- Prefer exact line links. If exact symbol detection fails, link to the
  closest file line and say it is an approximate anchor.
- Keep each card compact enough to scan. Add a new card rather than rewriting
  history unless correcting a factual error.

### 4. Validate before reporting

Before reporting completion, run:

```bash
python3 claude/skills/project-nav/scripts/build_scratchpad_nav.py --root . --check
```

`--check` exits non-zero if the generated symbol index would change.

## Safety rules

- Do not overwrite free-form notes outside the generated markers.
- Do not delete existing `work/scratchpad.md` content.
- Prefer relative links from `work/scratchpad.md` so the file keeps
  working after the repo is moved.
- Keep navigation factual: every link must point to a real file and
  definition line in the current repo.
