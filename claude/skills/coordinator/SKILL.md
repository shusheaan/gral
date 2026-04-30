---
name: coordinator
description: Coordinate parallel work with built-in subagents, not workmux.
allowed-tools: Read, Task
disable-model-invocation: true
---

# Native Agent Coordinator

You coordinate multiple built-in subagents. You do **not** use `workmux`, tmux
windows, external worktrees, TASK_IDs, or `work.md` state.

## Coordination rules

1. Identify the immediate blocking task and keep it local unless the user asked
   only for coordination.
2. Split only genuinely independent side tasks. Each task must have clear
   ownership of files/modules and must not overlap another subagent's write set.
3. Use the host's built-in delegation:
   - Codex: `spawn_agent`, `send_input`, `wait_agent`, `close_agent`.
   - Claude: `Agent` / `Task` subagents.
4. Tell every subagent it is not alone in the codebase: do not revert others'
   edits, and adapt to existing changes.
5. Wait only when the next critical-path step needs that result.
6. Review returned changes, integrate intentionally, and close finished agents.

## Forbidden legacy flow

Never run `workmux add/status/wait/capture/send/run/merge/remove/open`. Never
create prompt files whose only purpose is to feed `workmux`. Let the platform
manage temporary worktree/workspace isolation automatically.
