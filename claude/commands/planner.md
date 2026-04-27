---
description: Force-invoke the planner subagent for the given task.
---

Use the `planner` subagent to handle this request. The planner MUST follow
its own workflow (invoke `superpowers:brainstorming` first, then
`superpowers:writing-plans`). Do not substitute or re-route to a
different agent.

Request:
$ARGUMENTS
