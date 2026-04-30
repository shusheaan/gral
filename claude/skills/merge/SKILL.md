---
name: merge
description: Commit, rebase, and merge the current branch without workmux.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- Customize the commit style and rebase behavior to match your workflow. -->

**Arguments:** `$ARGUMENTS`

Commit, rebase, and merge the current branch using plain `git` only. Do **not**
run `workmux` or clean up external worktrees/tmux windows.

## Flags

- `--base <branch>` → merge into this local base branch. Default: `main`.
- `--no-verify`, `-n` → pass `--no-verify` to `git commit` and `git merge`.
- `--keep`, `-k` → accepted as a legacy no-op; this workflow never deletes the
  branch or worktree automatically.

Strip flags from the remaining commit-message arguments.

## Step 1: Identify branches

Record the current branch:

```bash
git branch --show-current
```

If the current branch is empty or already equals the base branch, stop and ask
for guidance.

## Step 2: Commit staged changes

If there are staged changes, commit them. Use lowercase, imperative mood, no
conventional commit prefixes. Skip if nothing is staged.

Use `--no-verify` only when the flag was passed.

## Step 3: Rebase

Rebase the current branch onto the local base branch:

```bash
git rebase <base-branch>
```

IMPORTANT: Do NOT run `git fetch`. Do NOT rebase onto `origin/<branch>`. Only
rebase onto the local branch name (e.g., `git rebase main`, not
`git rebase origin/main`).

If conflicts occur:

- BEFORE resolving any conflict, understand what changes were made to each
  conflicting file in the base branch.
- For each conflicting file, run `git log -p -n 3 <base-branch> -- <file>` to
  see recent changes to that file in the base branch.
- Preserve BOTH the base branch's changes AND the current branch's changes.
- After resolving each conflict, stage the file and continue with
  `git rebase --continue`.
- If a conflict is too complex or unclear, ask for guidance before proceeding.

## Step 4: Fast-forward merge

Switch to the base branch and fast-forward merge the rebased branch:

```bash
git switch <base-branch>
git merge --ff-only <current-branch>
```

Pass `--no-verify` to `git merge` only when the flag was passed.

## Step 5: Stop before cleanup

Do not delete the branch, remove worktrees, close tmux windows, or push. Report
the merge result and ask before any cleanup or remote operation.
