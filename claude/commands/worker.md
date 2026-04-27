---
description: Force-invoke the worker subagent for the given task.
---

Use the `worker` subagent to handle this request. The worker MUST follow
its own convergence protocol (auto-dispatch reviewer, hard 3-round cap,
write handoff doc on failure). Do not substitute or re-route to a
different agent.

Task:
$ARGUMENTS
