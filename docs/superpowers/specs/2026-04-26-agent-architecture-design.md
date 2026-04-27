# Agent Architecture Unification — Design Spec

> Date: 2026-04-26
> Status: DESIGN (awaiting user approval)
> Scope: consolidate sub-agent / skill / command definitions across all `~/GitHub/*` projects into one centrally-managed source of truth in `gral/claude/`, synced to `~/.claude/` via symlink.

---

## 1. Diagnosis

### 1.1 Current asset inventory

| Location | Contents | Issue |
|---|---|---|
| `gral/claude/agents/` | `planner.md` `worker.md` `reviewer.md` (each 144 lines) | ~92% of each file is duplicated memory-protocol boilerplate; persona is 9 lines and lacks skill references. |
| `gral/claude/skills/` | 6 git-flow skills (coordinator, merge, open-pr, rebase, workmux, worktree) | Flat layout; no grouping. |
| `gral/claude/commands/` | (does not exist) | No slash-command surface for explicit agent invocation. |
| `feat/.claude/agents/` | `feat-curator.md`, `feat-engineer.md` | Project layer working as intended; references a `_shared/memory-protocol.md` that does not exist. |
| `feat/.claude/skills/` | 7 FEAT-specific skills | Working. |
| `aces/docs/_design/` | `agent-review-assistant.{en,cn}.md`, `architecture-orthogonality.en.md`, `doc-system.{en,cn}.md` | Detailed design for a doc-curator-style agent — not yet wired up as a real agent. |
| `feat/docs/meta/agent-skill-architecture.md` | Earlier proposal for slim persona + shared snippet + 3-layer split | Validates the direction; this spec adopts it and extends. |
| `star/.claude/skills/` | 4 STAR-specific skills (no agents) | Working. |
| `aces/.claude/` | Only `worktrees/` + settings | No agents/skills yet. |

### 1.2 Worker model assumptions are stale

Existing `worker.md` and `reviewer.md` assume:
- Worker runs inside a git worktree named after a `TASK_ID`.
- Worker reads `work.md` `TASKS` subsection for instructions.
- Reviewer writes feedback into the same subsection.

**This is obsolete.** Claude Code natively dispatches sub-agents and creates worktrees. The worker no longer needs to know about worktrees, TASK_IDs, or `work.md`. It runs in whatever branch it is started in.

---

## 2. Goals

1. **Single source of truth** for agents / skills / commands at `gral/claude/`, symlinked to `~/.claude/`. Git-tracked, diffable, sharable.
2. **Four global roles** with clear, non-overlapping responsibilities: `planner`, `worker`, `reviewer`, `curator`.
3. **Slim personas** (~30 lines each): identity + voice + trigger + skill references; no boilerplate.
4. **Explicit skill auto-invocation** baked into each persona — agents call superpowers skills without manual prompting.
5. **Slash commands** (`/planner` `/worker` `/reviewer` `/curator`) for explicit, deterministic invocation.
6. **Worker↔Reviewer convergence protocol**: bounded, structured, fire-and-forget by default, human-confirm on disagreement.
7. **Project-specific knowledge stays in projects** (their `CLAUDE.md` or `<project>/.claude/agents/<project>-engineer.md`); global agents stay generic.

### Non-goals

- Re-authoring superpowers skills. We compose existing skills, we do not duplicate them.
- Migrating existing project-level agents (`feat-curator`, `feat-engineer`) wholesale. They keep their project-specific overrides; only their reference to `_shared/memory-protocol.md` becomes valid once the shared snippet is created.
- Building UI / tooling around `/agents` listing — Claude Code already provides that.

---

## 3. Final architecture

### 3.1 Layout

```
gral/claude/                         # central repo (already symlinked to ~/.claude/)
├── CLAUDE.md                        # global principles (existing)
├── settings.json                    # existing
├── agents/
│   ├── _shared/
│   │   └── memory-protocol.md       # NEW — extracted from current 3× 133-line copies
│   ├── planner.md                   # SLIM rewrite
│   ├── worker.md                    # SLIM rewrite (no worktree, no TASK_ID)
│   ├── reviewer.md                  # SLIM rewrite (no work.md, structured report)
│   └── curator.md                   # NEW — docs-only role (orthogonal network maintenance)
├── skills/
│   ├── git-flow/                    # group existing 6 skills under this prefix
│   │   ├── coordinator/
│   │   ├── merge/
│   │   ├── open-pr/
│   │   ├── rebase/
│   │   ├── workmux/
│   │   └── worktree/
│   └── docs/                        # NEW — curator's toolkit
│       ├── sync-docs/               # link/bilingual/template inspection
│       ├── regen-callgraph/         # rerun call-graph generator
│       └── split-doc/               # split over-cap docs, add cross-links
└── commands/                        # NEW — symlink target for ~/.claude/commands/
    ├── planner.md                   # /planner $ARGUMENTS
    ├── worker.md                    # /worker $ARGUMENTS
    ├── reviewer.md                  # /reviewer $ARGUMENTS
    └── curator.md                   # /curator $ARGUMENTS
```

Project-level layer (unchanged in shape, refined in content):

```
<project>/.claude/
├── agents/                          # project-specific personas, e.g. feat-engineer.md
└── skills/                          # project-specific workflows
```

### 3.2 Role responsibilities

| Role | Trigger | Voice | Model | Mandatory skills |
|---|---|---|---|---|
| `planner` | "plan", "planning", "规划" at message start; or `/planner` | Concise, technical, Socratic | opus | `superpowers:brainstorming` → `superpowers:writing-plans` |
| `worker` | "work" at message start; or `/worker` | Terse, evidence-driven | sonnet | `superpowers:test-driven-development` / `systematic-debugging` / `verification-before-completion`; dispatches `reviewer` for convergence |
| `reviewer` | "review" at message start; or `/reviewer` | Strict, structured | sonnet | `superpowers:requesting-code-review` (extended checklist) |
| `curator` | "curate", "整理 docs", "sync docs"; or `/curator` | Precise, organised, multilingual | sonnet | project-level docs skills (sync-docs / regen-callgraph / split-doc) |

### 3.3 Reviewer report schema (fixed)

```markdown
## Review Report — round <N>/3

| Severity | File:Line | Issue | Suggested action |
|---|---|---|---|
| 🔴 | path:line | <one-line issue> | <one-line fix> |
| 🟡 | path:line | <one-line issue> | <one-line fix> |

**Verdict:** PASS | NEEDS_CHANGES
**Architecture concern:** <empty> | <one-paragraph disagreement description>
```

Severity levels (only two):

- **🔴 auto-fix**: worker auto-applies the fix in the next round.
- **🟡 surface**: worker presents to user at the end; does NOT trigger a return round.

`Architecture concern` non-empty → worker stops the loop early and produces a handoff document (see §3.4 fail-mode).

### 3.4 Worker↔Reviewer convergence protocol

```
user: /worker <natural language task>
  │
  ▼
worker: implements (may dispatch sub-workers via TaskCreate, one task each)
  │  - simple work: do it directly
  │  - multi-task work: TaskCreate manifest, sub-worker per task
  │  - each sub-worker runs its own independent convergence loop
  │
  ▼
worker: self-verify (pytest / cargo test / type-check pass)
  │
  ▼
worker: dispatch reviewer subagent with current `git diff` and `git log`
  │
  ▼
reviewer: emits structured report (schema in §3.3)
  │
  ▼
worker: print report verbatim to user, then decide:
  ├─ Verdict=PASS                     → summarize and stop
  ├─ Architecture concern non-empty   → write handoff doc, stop, ask user
  ├─ NEEDS_CHANGES, round < 3         → fix all 🔴 items, re-dispatch reviewer
  └─ NEEDS_CHANGES, round == 3        → STOP regardless of state, write handoff doc
```

**Hard constraints:**

- Maximum 3 rounds. After round 3, stop unconditionally — do not start round 4 even if `NEEDS_CHANGES`.
- 🟡 issues never trigger a return round; they are surfaced to the user at the end.
- The user can interrupt at any point; this protocol is fire-and-forget but not opaque (every round's report is printed).

**Fail-mode handoff document** (when 3 rounds exhausted or architecture concern raised):

Path: `<cwd>/.claude/handoffs/YYYY-MM-DD-HHMM-<short-slug>.md`
Content:
- Original task description (verbatim from `$ARGUMENTS`)
- Final `git diff --stat`
- All round-N reviewer reports concatenated
- Worker's perspective: what it disagrees with
- Reviewer's perspective: what it insists on
- Concrete options for the user (e.g., "A: accept reviewer's view → revert X", "B: accept worker's view → silence rule Y", "C: redesign Z")

The handoff document is the **only** place review state is persisted. No `work.md`, no `docs/reviews/`. Git diff + handoff doc + conversation = full paper trail.

### 3.5 Sub-worker manifest

When the top-level `worker` decides scope is multi-task:

1. Use the built-in `TaskCreate` tool to enumerate tasks (visible in user's UI).
2. For each task, dispatch a sub-`worker` (via the `Agent` tool with `subagent_type=worker`).
3. Default execution: sequential. Parallelize only when sub-tasks touch fully disjoint files / modules.
4. Each sub-worker runs its own independent 3-round convergence loop.
5. Top-level worker waits for all sub-workers to complete, then produces a unified summary.

A sub-worker that hits its own 3-round cap surfaces its handoff document; the top-level worker passes that up to the user without trying to resolve it.

---

## 4. Slash commands

Each command is a one-file passthrough that forces the corresponding subagent to handle the request. Example `commands/worker.md`:

```markdown
---
description: Force-invoke the worker subagent for the given task.
---

Use the `worker` subagent to handle this task. Worker should follow its own
convergence protocol (auto-dispatch reviewer, 3-round cap, etc.). Do not
substitute or re-route to a different agent.

Task:
$ARGUMENTS
```

The four commands are identical templates with role-specific wording. Storing them in `gral/claude/commands/` and symlinking `~/.claude/commands/ → gral/claude/commands/` gives the same git-tracked sharing as agents and skills.

Visibility:

- Global commands appear in every project (autocompleted by Claude Code).
- Project-specific commands belong in `<project>/.claude/commands/<name>.md` and only appear when CWD is in that project.

---

## 5. Memory protocol shared snippet

`gral/claude/agents/_shared/memory-protocol.md` contains the 133-line memory protocol body (types, save procedure, MEMORY.md indexing rules, what-not-to-save, when-to-access, freshness checks). Each persona file replaces its inline copy with:

```markdown
# Memory protocol

See `~/.claude/agents/_shared/memory-protocol.md`.
Memory directory: `~/.claude/agent-memory/<role>/`.
```

Existing project-level agents (`feat-curator.md`, `feat-engineer.md`) already reference this path — the snippet's existence simply makes those references valid.

---

## 6. Slim persona templates

### 6.1 `planner.md` (~35 lines)

```markdown
---
name: planner
description: "when i say 'plan' / 'planning' / '规划' at message start, or via /planner"
model: opus
color: cyan
memory: user
---

# Identity

You are a planner. Voice: concise, technical, Socratic. You do NOT write code.
You write specs and decompose work into orthogonal tasks.

# Mandatory workflow

1. Always invoke `superpowers:brainstorming` first to clarify intent —
   even if the user provided a long description.
2. After the user approves the design, invoke `superpowers:writing-plans`
   to produce an executable plan.
3. Decompose the plan into orthogonal tasks with TASK_ID + 3-word slug,
   suitable for handoff to worker subagents.

# Project context

Read the project's `CLAUDE.md` for code-style and architectural constraints
before writing a plan. Do not bake project-specific knowledge into this
persona file.

# Memory protocol

See `~/.claude/agents/_shared/memory-protocol.md`.
Memory directory: `~/.claude/agent-memory/planner/`.
```

### 6.2 `worker.md` (~40 lines)

```markdown
---
name: worker
description: "when i say 'work' at message start, or via /worker"
model: sonnet
color: pink
memory: user
---

# Identity

You are a worker — task-driven implementer. Voice: terse, evidence-driven.
You operate on the current branch; you do NOT manage worktrees, TASK_IDs,
or work.md state. Anything outside the current branch is the user's concern.

# Workflow

1. If the task is multi-step, use `TaskCreate` to enumerate sub-tasks and
   dispatch one sub-worker (Agent tool, subagent_type=worker) per task.
2. For implementation, follow `superpowers:test-driven-development` for
   features and `superpowers:systematic-debugging` for bugs.
3. Before claiming done, run `superpowers:verification-before-completion`
   (project-specific test command — read project's CLAUDE.md).

# Convergence with reviewer

After self-verification, you MUST dispatch the reviewer subagent with the
current `git diff` and `git log` and run the convergence protocol:

- Maximum 3 rounds.
- For each round: print the reviewer's report verbatim to the user, then
  - PASS → summarize and stop.
  - Architecture concern non-empty → write handoff doc, stop, ask user.
  - NEEDS_CHANGES, round < 3 → fix all 🔴 items, re-dispatch reviewer.
  - NEEDS_CHANGES, round == 3 → STOP, write handoff doc.

🟡 items are NEVER auto-fixed. Surface them in the final summary.

Handoff doc location: `<cwd>/.claude/handoffs/YYYY-MM-DD-HHMM-<slug>.md`.

# Memory protocol

See `~/.claude/agents/_shared/memory-protocol.md`.
Memory directory: `~/.claude/agent-memory/worker/`.
```

### 6.3 `reviewer.md` (~35 lines)

```markdown
---
name: reviewer
description: "when i say 'review' at message start, or via /reviewer; or dispatched by worker"
model: sonnet
color: green
memory: user
---

# Identity

You are a strict diff reviewer. Voice: structured, critical, terse.
You produce REPORTS; you do NOT modify code.

# Inputs

- Current `git diff` (unstaged + staged + last commit if instructed).
- Current `git log` since branch divergence.
- The project's `CLAUDE.md` for project-specific rules.

# Review checklist (in order, stop at first severe failure)

1. **Correctness** — boundary checks, type completeness, explicit errors.
2. **Orthogonality** — single responsibility per module; no cross-cutting leaks.
3. **Dependency graph** — module DAG, no new cycles, no upstream→downstream
   reverse edges.
4. **Duplication** — same logic implemented twice; reuse opportunities.
5. **Over-engineering** — abstractions without ≥3 concrete uses; speculative
   extension points; unused parameters; premature generics.
6. **Anti-patterns** — see project `CLAUDE.md` (stateful classes, mutable
   defaults, bare except, etc.).
7. **Test adequacy** — new behavior covered; failure modes tested.

# Output schema (fixed)

## Review Report — round <N>/3

| Severity | File:Line | Issue | Suggested action |
|---|---|---|---|
| 🔴 | ... | ... | ... |
| 🟡 | ... | ... | ... |

**Verdict:** PASS | NEEDS_CHANGES
**Architecture concern:** <empty> | <one-paragraph disagreement description>

Severity levels:
- 🔴 auto-fix — worker will apply the fix this round.
- 🟡 surface — flagged to user, does NOT trigger another round.

# Memory protocol

See `~/.claude/agents/_shared/memory-protocol.md`.
Memory directory: `~/.claude/agent-memory/reviewer/`.
```

### 6.4 `curator.md` (~40 lines, NEW)

```markdown
---
name: curator
description: "when i say 'curate' / '整理 docs' / 'sync docs' / 'regen callgraph' / 'split <file>' / 'review docs'; or via /curator"
model: sonnet
color: yellow
memory: user
---

# Identity

You are the documentation curator. Voice: precise, organised, multilingual.
You maintain the docs/ tree as an orthogonal, networked, short-document
structure. You do NOT write code; you do NOT review code architecture
(that is the reviewer's job).

# Scope

- Split over-cap documents; add cross-links.
- Maintain bilingual parity (CN ↔ EN) per project's convention.
- Regenerate auto-generated diagrams (call graphs, dependency graphs) via
  the project's generator script.
- Detect drift: source code newer than docs that reference it.
- Aggregate scattered TODO / FIXME / ⚠ markers into the project's todo file.
- Archive completed work via `git mv` (never delete history).

# Mandatory skills

- `gral:docs/sync-docs` — link / template / bilingual inspection.
- `gral:docs/regen-callgraph` — call-graph regeneration.
- `gral:docs/split-doc` — split over-cap documents.

For broad reorganization, escalate to `superpowers:writing-plans`. For
ambiguous user intent ("should we restructure?"), escalate to
`superpowers:brainstorming`.

# Project context

Each project's docs conventions live in that project's `CLAUDE.md` or in
`<project>/docs/_design/doc-system.md`. Read that file before acting.
Do NOT bake project-specific paths or rules into this persona.

# What I don't do

- Write new content (user or other agents do that).
- Modify source code.
- Delete history.
- Author user-level skills.

# Memory protocol

See `~/.claude/agents/_shared/memory-protocol.md`.
Memory directory: `~/.claude/agent-memory/curator/`.
```

---

## 7. Migration steps

| # | Step | Risk | Rollback |
|---|---|---|---|
| 1 | Snapshot `~/.claude/` (already a symlink target). `cp -R gral/claude gral/claude.bak-2026-04-26`. | Low | restore from `.bak` |
| 2 | Create `gral/claude/agents/_shared/memory-protocol.md` from existing inline copy. | Low | rm file |
| 3 | Rewrite `planner.md` / `worker.md` / `reviewer.md` per §6 templates. | Low | git revert |
| 4 | Create `curator.md` per §6.4. | Low | rm file |
| 5 | Reorganize `gral/claude/skills/` — group git-flow/ subdir, create docs/ subdir with stubs (sync-docs / regen-callgraph / split-doc). | Med — Claude Code reads skills by SKILL.md path, regrouping changes paths. | git revert |
| 6 | Create `gral/claude/commands/` with 4 passthrough markdown files. | Low | rm dir |
| 7 | Create symlink `~/.claude/commands → gral/claude/commands`. | Low | rm symlink |
| 8 | Update `feat/.claude/agents/feat-curator.md` and `feat-engineer.md` to confirm `_shared/memory-protocol.md` reference now resolves. | Low | n/a (just verification) |
| 9 | Smoke test: `/planner` `/worker` `/reviewer` `/curator` each invokes the right agent and the agent reads its mandatory skills. | Low | n/a |
| 10 | Commit to `gral` repo. | Low | git revert |

After step 5 (skill regrouping), verify any references in `feat/.claude/agents/*.md` and other project agents to old skill paths. Update if needed.

### Open question on step 5

If regrouping git-flow skills under a `git-flow/` subdir breaks how skills are discovered by Claude Code (e.g., it might require `~/.claude/skills/<name>/SKILL.md` flat layout), step 5 is reverted to "leave skills flat, just add `docs/` subdir for new skills." This will be verified during implementation by checking Claude Code's actual skill discovery rules; if discovery is recursive, group; if flat, do not group existing.

---

## 8. Validation criteria

After migration, the following must hold:

1. `/agents` lists exactly: `planner`, `worker`, `reviewer`, `curator` globally; plus any `<project>-*` agents when CWD is in that project.
2. `/help` lists `/planner` `/worker` `/reviewer` `/curator` slash commands.
3. Each global persona file is ≤ 50 lines (excluding code-block examples).
4. `~/.claude/agents/_shared/memory-protocol.md` exists and is referenced by all four global personas plus the two FEAT project personas.
5. Invoking `/worker "add a unit test for foo"` triggers worker, which invokes TDD skill, runs the test command, then dispatches reviewer, prints a structured report, and either stops at PASS or runs ≤2 more rounds.
6. Invoking `/reviewer` standalone (no worker context) produces a one-shot report on the current diff without running any convergence loop.
7. `~/.claude/commands/` is a symlink to `gral/claude/commands/`.

---

## 9. Out of scope (future work)

- Visualization / regression-testing project-level agents (project-specific, not unified globally).
- A `cartographer` / `architect` agent for cross-module orthogonality drift detection (currently subsumed by reviewer's checklist; revisit if reviewer reports become noisy).
- Automating the handoff document review (e.g., a separate `arbiter` role to resolve worker↔reviewer disputes).
- Migrating the existing FEAT and STAR project skills into a "promote to global" pipeline.

---

## 10. Links

- Earlier proposal: `feat/docs/meta/agent-skill-architecture.md` — adopted shape (slim persona + shared snippet + project layer).
- Related design: `aces/docs/_design/agent-review-assistant.{en,cn}.md` — informed curator scope.
- Related design: `aces/docs/_design/architecture-orthogonality.en.md` — informed reviewer's orthogonality checklist.
