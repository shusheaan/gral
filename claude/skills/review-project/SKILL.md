---
name: review-project
description: Run a fixed whole-project audit when the user says "审查项目", "审查整个项目", "review project", or asks for a periodic project health review. The workflow inspects project structure, architecture distribution, orthogonality/coupling, robustness, quality, health risks, workflows, tests, data storage, and documentation; runs full Python and project-defined RAS/Rust/R tests plus backtest, single-period golden, and Monte Carlo smoke checks; uses two independent review agents to reduce false alarms; and writes dated Chinese and English reports under review/.
---

# Review Project

## 固定目标

Use this skill to perform a periodic whole-repository health audit. Keep the high-level flow fixed, but adapt concrete commands to the current project.

Primary output is a dated `review/` folder with evidence-backed findings, bilingual reports, and validation status. Do not modify production/source code during the audit unless the user separately asks for fixes. Documentation sync may make small mechanical documentation updates only when the repo's doc workflow explicitly allows it; otherwise report the needed changes.

Interpret the user's “政交性” as “正交性 / orthogonality”: whether modules, data flows, workflows, and responsibilities are separated cleanly.

## Non-negotiable rules

- Do not use `workmux` or external persistent worktrees.
- Prefer read-only inspection plus test/documentation commands. Write only to `review/<date>/` unless docs sync is explicitly allowed by the repo workflow.
- Never mark a test area as complete unless the command actually ran or the report clearly records why it could not run.
- Every risk finding must include evidence: file paths, commands, logs, dependency observations, or reviewer confirmation.
- Separate confirmed risks from hypotheses and false alarms.
- Use absolute dates from the local environment, e.g. `YYYY-MM-DD`.

## Workflow

### 1. Initialize the audit

1. Confirm repo root with `pwd`, `git rev-parse --show-toplevel`, and `git status --short`.
2. Create a dated output folder:
   - Prefer `review/YYYY-MM-DD/`.
   - If it already exists, use `review/YYYY-MM-DD-HHMMSS/` to avoid overwriting previous audits.
3. Start an evidence ledger in `evidence.md` with:
   - repo path, branch, HEAD SHA, date/time, OS/runtime notes;
   - all commands attempted and their pass/fail/skip reason;
   - links to generated reports.

### 2. Review structure, volume, and architecture

Inspect the whole project while excluding generated/cache/vendor folders such as `.git`, `.venv`, `node_modules`, `target`, `.mypy_cache`, `.pytest_cache`, `review`, `backups`, and large data artifacts unless they define storage contracts.

Capture:

- Top-level directory purpose and ownership.
- Language and file-volume distribution. Use `tokei` or `cloc` if available; otherwise use `git ls-files` and extension counts.
- Entry points: CLIs, services, notebooks, scripts, scheduled jobs, package exports, app startup files.
- Configuration surfaces: `pyproject.toml`, `Cargo.toml`, `renv.lock`, `DESCRIPTION`, `Makefile`, `justfile`, `noxfile.py`, `tox.ini`, CI configs, env templates.
- Module/dependency distribution and import direction. Use project graph tools such as GitNexus if available; otherwise use static import/search inspection.
- Architecture layers and responsibility boundaries: domain logic, I/O, data/model layer, simulation/backtest layer, reporting/UI, infrastructure.

Assess orthogonality and coupling:

- Identify circular dependencies, cross-layer imports, duplicated workflows, hidden shared state, global mutable config, ad-hoc path conventions, and business logic inside scripts/notebooks.
- Check workflow crossings: CI vs local scripts, docs sync vs generated docs, test commands vs Makefile/just/nox/tox, data pipeline vs backtest/simulation commands, hooks vs developer commands.
- List any places where a change in one workflow could silently break another.

### 3. Review quality, robustness, and health

Evaluate at least these dimensions:

| Dimension | Look for |
|---|---|
| Correctness | boundary checks, typed errors, deterministic outputs, validated inputs |
| Robustness | reproducible commands, explicit config, failure handling, no silent exception swallowing |
| Maintainability | module DAG, low coupling, small functions, limited duplication, clear ownership |
| Data integrity | schemas, migrations, data contracts, nullability/uniqueness checks, versioning |
| Workflow health | CI/local parity, stable scripts, no conflicting sources of truth |
| Documentation | bilingual parity where required, links, freshness, generated-doc drift |
| Operations/security | secrets handling, dependency hygiene, unsafe shell/network assumptions |

Severity scale:

- **P0 Critical**: likely data loss, wrong scientific/financial result, secret exposure, or test suite unusable.
- **P1 High**: strong evidence of broken workflow, hidden coupling, missing core validation, or non-reproducible result.
- **P2 Medium**: maintainability or coverage gap likely to create future bugs.
- **P3 Low**: cleanup, naming, docs, or observability improvement.

### 4. Validate tests and simulations

Discover canonical commands from repo docs and config before choosing fallbacks. Search for `pytest`, `cargo test`, `testthat`, `Rscript`, `RAS`, `backtest`, `golden`, `single-period`, `monte`, `mc`, `simulation`, `smoke`, `nox`, `tox`, `just`, and `make`.

Run or explicitly record skip/block reason for each required lane:

1. **Full Python tests**: canonical command first; fallback is `pytest` if a Python test suite exists.
2. **Full RAS tests**: treat `RAS` as project-defined. If no exact RAS command exists, look for Rust (`cargo test`) and R (`Rscript`/`testthat`) suites and document the interpretation used.
3. **Single backtest smoke test**: one minimal representative backtest path that exercises load → compute → result.
4. **Single-period golden test**: deterministic golden comparison for one period; verify tolerance rules and artifact freshness.
5. **Monte Carlo simulation smoke test**: minimal deterministic or seeded run; verify it completes and produces expected shape/summary.
6. **Coverage signal**: run coverage if canonical and cheap; otherwise report available coverage config and gaps.

Rules for test reporting:

- Preserve command, working directory, duration, exit code, and short failure excerpt.
- If dependencies, credentials, large data, or network are required, record the exact blocker and needed follow-up.
- Do not claim “full tests complete” if any lane is skipped, partially run, or ambiguous.

### 5. Review data storage structure

Map all storage surfaces:

- Database schemas, migrations, ORM models, DDL, warehouse tables.
- File-backed data: CSV/Parquet/Arrow/JSON/HDF5, naming conventions, partitions, checkpoints, cache dirs.
- Golden files, fixtures, generated artifacts, seeds, and simulation outputs.
- Data contracts: types, units, time zones, indexes, uniqueness, missing-value policy, schema evolution, retention/backups.

Flag gaps such as missing migrations, unversioned schema changes, ambiguous path roots, mixed units/time zones, unchecked golden drift, large committed data, or tests depending on local-only artifacts.

### 6. Sync and review documentation

Use the existing `sync-docs` skill if available; otherwise perform its equivalent checks:

- markdown bilingual parity (`<name>.md` and `<name>.cn.md`) when the project requires it;
- broken links and anchors;
- stale code references and generated docs;
- missing uplinks or navigation sections;
- TODO/FIXME aggregation.

If repo policy allows docs sync mode, run the sync and record changed files. If not, report precise doc actions needed. Include documentation status in both bilingual review reports.

### 7. Use two independent review agents

Use two built-in subagents in parallel when the host supports them:

- **Reviewer A — architecture/data/coupling**: read-only review of structure, module boundaries, data storage, and workflow coupling.
- **Reviewer B — tests/docs/reproducibility**: read-only review of test coverage, backtest/golden/Monte Carlo lanes, docs sync, and reproducibility.

Tell both reviewers:

- They are not alone in the codebase.
- They must not edit files.
- They must provide evidence for every finding and label confidence.
- They must identify likely false positives and “needs confirmation” items.

Do not leak the main agent's conclusions into reviewer prompts. Give them the repo path, audit objective, and allowed read/test scope. If subagents are unavailable, perform two separate independent passes manually and disclose that limitation in `evidence.md`.

Reconcile findings:

- Confirmed by main + reviewer → report as confirmed.
- Found by one reviewer only → verify before reporting as risk; otherwise label “needs confirmation”.
- Refuted by evidence or reviewer → list briefly under false alarms if it was plausible.

### 8. Write the review folder

Create these files under the dated folder:

```text
review/YYYY-MM-DD/
├── README.md
├── project-health.cn.md
├── project-health.en.md
├── evidence.md
├── test-results.md
├── reviewer-a.md
└── reviewer-b.md
```

If a reviewer cannot be run, still create the corresponding file with the limitation and manual substitute notes.

`README.md` must highlight overall issues first:

- audit date, repo, branch, commit;
- overall health color: Green / Yellow / Red;
- top 3 confirmed risks;
- test lane completion matrix;
- documentation sync status;
- links to the Chinese and English reports.

`project-health.cn.md` and `project-health.en.md` must be equivalent bilingual reports with this structure:

1. Executive summary / 执行摘要
2. Project structure and volume / 工程结构与体量
3. Architecture and orthogonality / 架构分布与正交性
4. Robustness, quality, and health / 稳健性、质量与健康性
5. Workflow crossings and coupling / 工作流交叉与耦合
6. Test and simulation coverage / 测试与仿真覆盖
7. Data storage integrity / 数据存储完整度
8. Documentation sync / 文档同步
9. Confirmed risks / 已确认风险
10. False alarms and needs-confirmation items / 错报与待确认项
11. Prioritized remediation plan / 优先修复建议

`test-results.md` must include a matrix:

| Lane | Command | Status | Evidence | Follow-up |
|---|---|---|---|---|
| Full Python tests | ... | PASS/FAIL/SKIP | ... | ... |
| Full RAS/Rust/R tests | ... | PASS/FAIL/SKIP | ... | ... |
| Backtest smoke | ... | PASS/FAIL/SKIP | ... | ... |
| Single-period golden | ... | PASS/FAIL/SKIP | ... | ... |
| Monte Carlo smoke | ... | PASS/FAIL/SKIP | ... | ... |

### 9. Final response to the user

Reply in Chinese with only the useful summary:

- review folder path;
- overall health color;
- top 3 confirmed risks or “未发现 P1+ confirmed risk”;
- test lane matrix summary;
- documentation sync status;
- next recommended action.
