# Global Instructions

## Communication

- Reply to the user in Chinese (中文). Code, function names, identifiers, and technical terms stay in English.

## First Principles

- **Start from why**: if motivation, goal, or success criteria are unclear, stop and discuss before acting; every decision must answer the basic “why”.
- **Prefer the direct path**: when the goal is clear but the requested path is not the best, shortest, or simplest, first suggest the better approach.
- **Root cause + focus**: when problems appear, identify the core cause before fixing; summarize at most three key points first and keep the work centered on them.

## Work Intake Workflow

- **Why**: `work/draft.md` 是用户的原始需求池；`work/to do.md` 是 agent 的可执行任务板。每次开工前先整理需求，避免漏项、重复做、或在没有优先级的情况下直接改代码。
- **Explicit trigger**: 当用户单独说 `work`，或明确说“开始 work / run work / 看 work / 处理 work”时，固定启动本 workflow：先读 draft，再整理 TODO，再按 TODO 执行。不要把 `work` 当成普通闲聊或泛泛的“工作”概念处理。
- **Startup check**: 每个新 session 或新任务开始时，在当前项目根目录先查找 `work/draft.md`；若不存在，再查找 `Work/draft.md`。两者都不存在时跳过此 workflow，不要为了流程强行创建文件。
- **TODO file**: 如果存在 draft，则同时读取现有 `work/to do.md`；若项目已有 `work_todo.md` 作为约定，沿用现有文件名；否则创建 `work/to do.md`。所有文件都应放在同一个 `work/` 目录内。
- **Default `work` output**: 触发 `work` 后，先整理 `draft.md` 与 TODO 中的剩余 unchecked 内容，然后向用户列出一份简短执行 list（按优先级/依赖排序）。默认只给可执行 list，不展开精细 plan；只有用户明确说“精细 plan / detailed plan”时，才写更细的分阶段计划。
- **整理规则**:
  - 参考 `../star/work_todo.md` 的结构：标题、目标说明、状态图例、draft 覆盖索引、按功能/领域分组的任务段落、当前验证记录。
  - 使用中文描述需求和验收标准；代码标识符、文件名、命令、API 名保持 English。
  - 每个任务使用 Markdown checkbox：`- [ ]` 未完成，`- [x]` 已完成；必要时加 `部分完成：`、`阻塞：`、`需要确认：`。
  - 把 draft 中所有可执行项目拆成最小可验证任务，按功能/领域归类，并在覆盖索引里保证每条 draft 内容都能追踪到某个 TODO；不确定的内容先标为 `需要确认`，不要丢弃。
  - 不要主动删除 `draft.md` 内容；不要主动删除已完成 TODO。完成后只打勾、补充验证记录和必要备注，用户 review 后自行删除或要求清理。
- **执行规则**:
  - TODO 整理完成后，从 `work/to do.md` 中选择最高优先级且未阻塞的 unchecked item 开始工作。
  - 如果剩余 TODO 中有多个相互独立、文件/模块写入范围不冲突的任务，可以使用内置 subagents 并行推进：worker 负责实现，reviewer 负责独立审查或验证，最后由主 agent converge/integrate。不要使用 `workmux`。
  - 并行前先确认任务边界：每个 worker 拥有明确且互不重叠的文件/模块范围；reviewer 不改同一写入范围，优先做测试、风险审查、验收清单。
  - 如果任务强耦合、下一步被某个结果阻塞、或并行会增加冲突，就保持单线程直接做。
  - 工作中保持 TODO 同步：开始前确认目标，完成后更新 checkbox、验证命令/结果、剩余缺口。
  - 若用户给出明确且紧急的单点任务，先快速同步相关 draft/TODO 条目，再直接完成该任务；不要陷入纯整理而阻塞实际交付。

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
