---
name: sync-docs
description: Inspect docs/ tree for broken links, missing template sections, bilingual EN/CN parity (mandatory globally — every markdown needs both <name>.md and <name>.cn.md), and stale references; report issues sorted by severity. Use when the user says 'sync docs' or 'review docs' and the curator agent is active.
allowed-tools: Bash, Read, Grep, Glob
---

# Sync-docs workflow

## Purpose

Read-only inspection of the project's `docs/` tree. Emit a severity-sorted
markdown report. Auto-fix small issues only when invoked in `sync` mode
(default is `review` mode = read-only).

## Inspection passes (run in order, accumulate issues)

### 1. Line-count cap

```bash
find docs -name '*.md' \
  -not -path 'docs/_historical/*' \
  -not -path 'docs/_design/*' \
  | xargs wc -l | sort -rn
```

Compare each file against the project's documented cap (read
`docs/_design/doc-system.md` if present; otherwise default 300 lines).

- File > 150% of cap → 🔴 over-cap
- File > 100% of cap → 🟡 approaching cap

### 2. Bilingual parity (MANDATORY — applies to every project)

Every markdown file under `docs/` must exist in both languages:
`<name>.md` (English) AND `<name>.cn.md` (Chinese).

Exempt paths:
- `docs/_historical/`, `docs/archive/`
- machine-generated files (call graphs, etc.)
- files the project explicitly opts out of in `CLAUDE.md`

For each `<name>.md` not in an exempt path:
- Missing `<name>.cn.md` → 🔴 missing-translation (CN side absent).
- Missing `<name>.md` while `<name>.cn.md` exists → 🔴
  missing-translation (EN side absent).
- Both exist but `stat -f %m` differs by > 1 day → 🟡 bilingual-drift,
  list the stale side.

The legacy `<name>_CN.md` naming is also accepted if the project's
`CLAUDE.md` declares it; otherwise normalize to `<name>.cn.md`.

In `sync` mode the curator generates the missing side from the fresh
side and refreshes the stale side; in `review` mode just report.

### 3. Link integrity

For every `[text](path.md)` reference:
- Resolve the path. Missing file → 🔴 broken-link.
- For `[text](path.md#anchor)` references, open the target and search
  for the heading. Missing anchor → 🟡 broken-anchor.

### 4. Network completeness

Every non-meta file should end with a "Links / 链接" section containing
at least one up-link to the parent doc.

- Missing → 🟡 missing-uplink.

### 5. Code drift (where docs reference code line numbers)

For each `path/to/file.rs:<line>` reference in docs:
- Verify the file exists.
- Check whether `git log -1 --format=%ct path/to/file.rs` is newer than
  the doc by > 1 day. If yes → 🟡 stale-reference.

### 6. TODO aggregation

```bash
grep -rEn '⚠|PENDING|TODO|FIXME' docs/ --include='*.md' \
  | grep -v 'docs/50-todo.md'
```

Items not in the project's todo file → list them. In `sync` mode,
append them.

## Output

Always emit one markdown table, severity-sorted:

```markdown
| Severity | File | Issue |
|---|---|---|
| 🔴 | docs/L4-batch-sim.md | line 312 / cap 300 |
| 🟡 | docs/DroneState.md | broken-anchor → ../L99 |
```

Then a 2-line summary: `<N> issues; look at <highest-severity> first.`

## Modes

- **review** (default): emit report, change nothing.
- **sync**: emit report + auto-fix link rewrites, missing up-link
  insertion, TODO aggregation. Do NOT auto-fix line-cap (that requires
  human judgment on where to split).

When invoked from the curator agent, `sync` mode is allowed only for
issues the curator has explicit authority to fix per its persona.
