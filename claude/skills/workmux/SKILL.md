---
name: workmux
description: Deprecated legacy workmux reference. Do not use for new agent work; use built-in subagents and host-managed worktree/workspace isolation instead.
disable-model-invocation: true
---

# workmux (legacy)

`workmux` is retired for Codex/Claude task orchestration in this repo.

## Hard rule

- Do **not** run `workmux add/list/status/wait/send/capture/merge/remove/open`
  for new work.
- Do **not** use workmux-backed flows such as `/worktree` or `/coordinator` to
  create, monitor, communicate with, merge, or clean up agents.
- If a task needs internal parallelism, use the host's built-in subagent
  delegation and let the host manage any isolated worktree/workspace
  automatically:
  - Codex: `spawn_agent`, `send_input`, `wait_agent`, `close_agent`.
  - Claude: `Agent` / `Task` subagents.
- Persistent branches, PRs, and external worktrees are user-level actions; ask
  before creating, merging, or deleting them.

## Native replacement workflow

1. Keep the immediate blocking task local.
2. Split only independent side tasks with disjoint file/module ownership.
3. Delegate each side task with the built-in subagent tool.
4. Integrate returned changes intentionally in the current workspace.
5. Close subagents when their result is no longer needed.

## Legacy maintenance exception

If the user explicitly asks to inspect or edit old `workmux` configuration or
historical docs, limit the task to those files. Still do not run `workmux`
commands unless the user separately authorizes a one-off legacy operation.
