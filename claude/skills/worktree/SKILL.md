---
name: worktree
description: Deprecated workmux dispatcher. For parallel work, use built-in subagents and host-managed worktree/workspace isolation instead.
disable-model-invocation: true
allowed-tools: Task
---

# worktree (native only)

This skill no longer creates external `workmux` worktrees.

## Hard rule

Do **not** run `workmux add` or create/monitor external worktrees for task
parallelism. The host runtime owns any temporary worktree/workspace isolation.

## What to do instead

- Decompose only when the request has independent subtasks.
- Prefer sequential execution unless parallel subtasks touch fully disjoint
  files/modules.
- Dispatch with the built-in subagent mechanism:
  - Codex: `spawn_agent` / `wait_agent`.
  - Claude: `Agent` / `Task` with the appropriate `subagent_type`.
- Give each subagent a bounded task, clear file/module ownership, and explicit
  instruction not to revert other agents' edits.
- Integrate results in the current workspace; ask before creating persistent
  branches, PRs, or external worktrees.
