---
name: bitig-ops
description: Use this subagent for ALL bitig MCP task queries, task updates, and git diff/status summaries.
model: claude-haiku-4-5
---
Execute the requested `bitig` MCP tool or git command. Do not output raw JSON. Return only task IDs, titles, statuses, and a brief bulleted summary under 10 lines.
