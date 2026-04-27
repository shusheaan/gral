---
name: split-doc
description: Split an over-cap markdown document into smaller orthogonal files and insert cross-links. Use when the user says 'split <file>' or '拆 <文件>' and the curator agent is active.
allowed-tools: Bash, Read, Write, Edit, Grep
---

# Split-doc workflow

## Purpose

Take a single docs file that has grown beyond the project's line cap and
split it into several shorter files, preserving content and adding
cross-links so the network stays navigable.

## Steps

### 1. Read the target file

Identify section boundaries (headings of level 2: `^## `).

### 2. Propose a split

For each H2 section, decide whether it becomes its own file. Heuristics:
- A section ≥ 50 lines is a strong candidate for its own file.
- Sections that share heavy cross-references should stay together.
- Index / TOC sections stay in the parent file.

Present the proposed split to the user as a tree:

```
parent.md (was 600 lines, will be ~120)
├── parent-data-model.md (new, ~180 lines)
├── parent-pipeline.md (new, ~150 lines)
└── parent-config.md (new, ~150 lines)
```

Wait for user approval before writing any file.

### 3. Write the new files

Each new file:
- Has the same frontmatter as the parent (if any).
- Starts with a brief context paragraph + an "up-link" to the parent.
- Contains the original H2 content, demoted by one level (H2 → H1).

```markdown
> Split from [parent](./parent.md). See parent for context.

# <Original H2 title>

<original content>
```

### 4. Update the parent file

Replace each extracted section with a one-paragraph summary + a link to
the new file:

```markdown
## <Original H2 title>

<one-paragraph summary>

→ Full detail: [parent-data-model](./parent-data-model.md)
```

### 5. Update inbound links

```bash
grep -rln 'parent\.md#<section-anchor>' .
```

For each file referencing the moved section, update the link to point at
the new file.

### 6. Verify

- All new files are under cap.
- The parent file is under cap.
- All inbound links resolve.
- `git status` shows the expected set of new and modified files.

### 7. Use `git mv` if a section is being relocated rather than split

If the user asked to relocate a section (not split), use `git mv` to
preserve history.

Do NOT auto-commit. The curator persona will decide.
