---
type: llm
weight: 1
---

Passes only if ALL hold: (1) it defines the class precisely enough to search for (e.g. calls to getUser() whose result is used without a null check); (2) it attempts to search for members, or clearly states it could not find the code and treats the member count as unknown, without inventing a count; (3) it shows a ladder from the instance to all members, the mechanism, and a guardrail such as a type change, lint rule or CI check; (4) it recommends a rung.
