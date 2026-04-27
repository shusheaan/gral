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

## Steps

### 1. Locate the generator script

Look for these in order; use the first that exists:

```bash
ls scripts/gen_callgraph.py 2>/dev/null
ls scripts/regen_callgraph.sh 2>/dev/null
ls tools/callgraph/regen.py 2>/dev/null
```

If none exists, abort and tell the user the project has no generator
configured. Do NOT invent one.

### 2. Identify output directory

Read the generator script for its output target. Common locations:
- `docs/35-call-graphs/`
- `docs/auto/callgraph/`

### 3. Snapshot the existing output

```bash
cp -R <output-dir> <output-dir>.before-regen
```

(This is a local snapshot for diffing; it is NOT committed.)

### 4. Run the generator

Use the project's documented invocation (read `CLAUDE.md` or the script's
own header). Common patterns:

```bash
.venv/bin/python scripts/gen_callgraph.py
```

If the project has no `.venv`, fall back to whatever the script's
shebang specifies.

### 5. Verify output

```bash
diff -rq <output-dir>.before-regen <output-dir> | head -20
```

Sanity checks:
- At least one file was modified.
- No file was emptied (`wc -l <output-dir>/*` should not contain zeros).
- Mermaid syntax is valid (no half-finished `graph TD` blocks).

### 6. Clean up snapshot

```bash
rm -rf <output-dir>.before-regen
```

### 7. Report

Output a one-paragraph summary:
- Generator script used.
- Number of files refreshed.
- Any sanity-check failures (DO NOT silently swallow).

Do NOT auto-commit. The curator persona will decide whether to commit
based on the user's intent.
