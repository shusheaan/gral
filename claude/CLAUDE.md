# Global Instructions

## Communication

- Reply to the user in Chinese (中文). Code, function names, identifiers, and technical terms stay in English.

## First Principles

- **Start from why**: if motivation, goal, or success criteria are unclear, stop and discuss before acting; every decision must answer the basic “why”.
- **Prefer the direct path**: when the goal is clear but the requested path is not the best, shortest, or simplest, first suggest the better approach.
- **Root cause + focus**: when problems appear, identify the core cause before fixing; summarize at most three key points first and keep the work centered on them.

## Agent Orchestration

- Do **not** use `workmux` for new work. Do not run `workmux add/list/status/wait/send/capture/merge/remove/open`, and do not invoke workflows that dispatch through `workmux` such as `/worktree` or `/coordinator`.
- For task-internal parallelism, use only the host's built-in delegation: Codex `spawn_agent` / `wait_agent`, or Claude `Agent` / `Task` subagents. Let the host manage any isolated worktree/workspace automatically.
- Parallelize only independent subtasks with disjoint files/modules. Keep blocking work local, and integrate subagent results intentionally.
- Treat persistent branches, PRs, and externally managed worktrees as user-level actions; ask before creating, merging, or deleting them.

## Context Management

- When context usage reaches or exceeds 60%, proactively compact the conversation before reading more files, spawning agents, or starting another large task step.
- Prefer the host-native compact action (`/compact` or configured auto-compact) and preserve the current goal, decisions, changed files, blockers, and next step in the compact summary.
- After compaction, continue from the summary and do not restart the task from scratch.

## Engineering Principles

- **Correctness first**: boundary checks, complete typing, explicit errors; never rely on runtime coincidence
- **Minimal design**: write only the code needed now; no extension points for hypothetical futures
- **Orthogonal + modular**: single responsibility, module DAG, composition over inheritance
- **Reject over-engineering**: abstract only after three repetitions; no abstractions without concrete need

## Rust-style Python (preparing for Rust port)

- Data structures use `@dataclass(frozen=True)`, immutable
- struct + classmethod factories, avoid inheritance
- Pure functions first: separate I/O from computation, no side effects
- Full type annotations on every signature; ban `Any`
- Short functions, single responsibility

## Rust

- `unsafe` only for C FFI
- Must pass `cargo clippy` + `cargo test`
- Split workspace crates by responsibility, not by file size

## Data / IO

- DataFrame: **polars** (pandas forbidden)
- Paths: **pathlib** (os.path forbidden)
- Externalize config to TOML/YAML; no hardcoded parameters
- Pure functions for computation; wrap I/O at the outer layer

## Error Handling

- Explicit Result or typed exceptions
- Validate at boundaries, trust internally
- No silent exception swallowing or bare `except`

## Project Structure

- Flat directories (≤3 levels), descriptive names
- Module DAG, no circular dependencies
- Cross-language interop via PyO3

## Testing

- Python: pytest; tolerance-based comparison for golden files
- Rust: `cargo test`, unit + integration
- Property tests (hypothesis) for invariants

## Git Commits

- Single-line subject, no body
- No `Co-Authored-By`, no AI signatures, no trailing emoji
- Describe why, not what

## Anti-patterns (forbidden)

- Stateful classes (`self.x = None` then filled by `fit()`)
- God functions (>100 lines)
- Mutable default arguments
- Global mutable state, singletons
- metaclass, `__getattr__` and other Python magic
- Deep inheritance hierarchies
- Extension points for hypothetical future needs
- Unnecessary fallbacks / wrapper try-except
- Premature abstraction before duplication is real
