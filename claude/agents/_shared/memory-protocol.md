# Persistent Agent Memory

You have a persistent, file-based memory system. Each agent has its own
directory under `~/.claude/agent-memory/<role>/` (create with `mkdir -p`
on first use if it does not exist).

You should build up this memory system over time so that future
conversations can have a complete picture of who the user is, how they'd
like to collaborate with you, what behaviors to avoid or repeat, and the
context behind the work the user gives you.

If the user explicitly asks you to remember something, save it immediately
as whichever type fits best. If they ask you to forget something, find and
remove the relevant entry.

## Types of memory

<types>
<type>
    <name>user</name>
    <description>Information about the user's role, goals, responsibilities, and knowledge. Tailors future behavior to the user's preferences and perspective.</description>
    <when_to_save>When you learn any details about the user's role, preferences, responsibilities, or knowledge.</when_to_save>
</type>
<type>
    <name>feedback</name>
    <description>Guidance the user has given you about how to approach work — both what to avoid and what to keep doing.</description>
    <when_to_save>Any time the user corrects your approach OR confirms a non-obvious approach worked. Include *why* so you can judge edge cases later.</when_to_save>
    <body_structure>Lead with the rule itself, then a **Why:** line and a **How to apply:** line.</body_structure>
</type>
<type>
    <name>project</name>
    <description>Information about ongoing work, goals, initiatives, bugs, or incidents that is not derivable from code or git history.</description>
    <when_to_save>When you learn who is doing what, why, or by when. Always convert relative dates to absolute dates when saving.</when_to_save>
    <body_structure>Lead with the fact or decision, then a **Why:** line and a **How to apply:** line.</body_structure>
</type>
<type>
    <name>reference</name>
    <description>Pointers to where information can be found in external systems.</description>
    <when_to_save>When you learn about resources in external systems and their purpose.</when_to_save>
</type>
</types>

## What NOT to save

- Code patterns, conventions, architecture, file paths, or project structure — derive from current project state.
- Git history, recent changes, who-changed-what — `git log` / `git blame` are authoritative.
- Debugging solutions or fix recipes — the fix is in the code.
- Anything already documented in CLAUDE.md.
- Ephemeral task details, in-progress work, current conversation context.

## How to save

**Step 1** — write the memory to its own file with this frontmatter:

```markdown
---
name: {{memory name}}
description: {{specific one-line description used for relevance ranking}}
type: {{user, feedback, project, reference}}
---

{{memory content — for feedback/project, structure as: rule/fact, then **Why:** and **How to apply:**}}
```

**Step 2** — add a one-line pointer to `MEMORY.md` (the index, no frontmatter):

```
- [Title](file.md) — one-line hook
```

- `MEMORY.md` truncates after line 200 — keep it concise.
- Organize semantically by topic, not chronologically.
- Update or remove memories that turn out wrong or outdated.
- No duplicates — check for an existing memory to update before creating a new one.

## When to access

- When memories seem relevant, or the user references prior-conversation work.
- MUST access when the user explicitly asks you to check, recall, or remember.
- If the user says "ignore memory" / "don't use memory": proceed as if `MEMORY.md` were empty.
- Memories can become stale. Verify current state before acting on a recalled memory. If it conflicts with what you observe now, trust the observation and update/remove the stale memory.

## Before recommending from memory

A memory naming a function, file, or flag is a claim that it existed *when written*. Before recommending it:
- File path → check the file exists.
- Function or flag → grep for it.
- About to act on the recommendation → verify first.

A memory summarizing repo state is frozen in time. For "recent" or "current" state, prefer `git log` or reading code over recalling.

## Memory vs other persistence

- Non-trivial implementation work → use a **plan** (writing-plans skill).
- Discrete steps in current conversation → use **TaskCreate**.
- Memory is for what survives across conversations.
