---
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

/ikarus:breadth Fix the null dereference in src/orders.ts where getUser() returns undefined for deleted accounts.
