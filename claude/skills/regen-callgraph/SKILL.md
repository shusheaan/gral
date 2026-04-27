---
name: regen-callgraph
description: Re-run the project's call-graph generator script and refresh the auto-generated docs. Use when the user says 'regen callgraph' or '重生成 call graph' and the curator agent is active.
allowed-tools: Bash, Read, Glob
---

# Regen-callgraph workflow

## Purpose

Refresh auto-generated call-graph docs after non-trivial code changes.
This skill is a thin orchestrator — it runs the project's own generator
script and verifies the output looks reasonable.

## Recommended generator contract

A well-formed call-graph generator produces **three orthogonal views**
(this is the contract the FEAT project follows; new projects should
mirror it):

1. **Static call graphs** — graphviz `.dot` text (renderable to SVG/PDF
   with `dot`, also grep-friendly as text).
   - `pyan3` for function-level, module-grouped graphs with `use`-edges
     (`--dot` output to avoid hard graphviz dependency at generate time).
   - `code2flow` for a coarser flow graph + JSON (the JSON is the input
     for the text views below).

2. **Runtime profile** — `pyinstrument` HTML, self-contained, no
   rendering needed. One profile per representative script-config pair.

3. **Pure-text views** — markdown derived from the `code2flow` JSON, so
   readers can grep / diff without opening a browser:
   - module dependency matrix (rows × columns) + isolation summary
     (leaf / sink / hub / isolated / transit roles)
   - edges grouped by source module (sorted, cross-module marked `[X]`)
   - per-entry-point indented callee tree

The three views answer different questions: static = "where is X
called?", runtime = "where does the time go?", text = "what's the shape
of dependencies and how does it grep?".

## Steps

### 1. Locate the generator script

Look for these in order; use the first that exists:

```bash
ls scripts/gen_callgraph.py 2>/dev/null
ls scripts/regen_callgraph.sh 2>/dev/null
ls tools/callgraph/regen.py 2>/dev/null
```

If none exists, abort and tell the user the project has no generator
configured. Do NOT invent one. Point them at the FEAT generator
(`feat/scripts/gen_callgraph.py`) as a reference if they want to author
one.

### 2. Identify output directory

Read the generator script for its output target. Common locations:

- `docs/views/callgraphs/` (FEAT convention)
- `docs/35-call-graphs/`
- `docs/auto/callgraph/`

### 3. Snapshot the existing output

```bash
cp -R <output-dir> <output-dir>.before-regen
```

(Local snapshot for diffing; NOT committed.)

### 4. Run the generator

Use the project's documented invocation (read `CLAUDE.md` or the
script's own header). FEAT's invocation:

```bash
.venv/bin/python scripts/gen_callgraph.py             # all stages
.venv/bin/python scripts/gen_callgraph.py --no-runtime  # skip pyinstrument (fast)
.venv/bin/python scripts/gen_callgraph.py --include-scripts  # include scripts/
```

Runtime profiles can be slow (they actually execute the target script);
prefer `--no-runtime` when the user only changed module structure.

### 5. Verify output

```bash
diff -rq <output-dir>.before-regen <output-dir> | head -20
```

Sanity checks:

- At least one file was modified.
- No file was emptied (`wc -l <output-dir>/*` should not contain zeros
  for the dot / gv / json / md outputs).
- For the recommended four-view contract, all of these should exist
  after a full run:
  - `pyan3_*.dot`
  - `code2flow_*.gv` and `code2flow_*.json`
  - `pyinstrument_*.html` (if runtime stage was run)
  - `text_module_matrix.md`, `text_edges_by_module.md`, `text_callee_trees.md`

If `dot` is unavailable on the box, the generator should still succeed
(emit `.dot` text); rendering to SVG is a separate step.

### 6. Clean up snapshot

```bash
rm -rf <output-dir>.before-regen
```

### 7. Report

Output a one-paragraph summary:

- Generator script used.
- Stages run (static / runtime / text).
- Number of files refreshed.
- Any sanity-check failures (DO NOT silently swallow).

Do NOT auto-commit. The curator persona will decide whether to commit
based on the user's intent.

## Curator hand-off

After this skill returns, curator should:

- Verify the README index in the output directory still describes every
  artifact correctly (filenames, sizes, what each shows).
- Maintain bilingual parity for any human-authored README in the output
  directory (the generated artifacts themselves are exempt — they are
  machine output, not docs).
- Update `docs/views/orthogonal-views.md` (or equivalent) if a new view
  was added.
