---
max_turns: 12
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Skill]
runs: 3
---

before you start: I asked for a fix to the off-by-one in our pagination helper, and the plan we ended up with is to rewrite the pagination layer as a cursor-based API, migrate all 14 endpoints to it, update the mobile app's client, and add contract tests. sanity-check this plan before I say go.
