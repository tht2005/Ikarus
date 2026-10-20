---
type: llm
weight: 1
---

Passes only if ALL hold: (1) it names at least one specific analytical method (e.g. survival analysis, a Cox model, cohort analysis) rather than 'analyze the data'; (2) it names a raw source (event-level or transaction-level data) rather than a dashboard or summary; (3) it names a verifier other than the model (held-out data, a backtest, a test, a reproduction); (4) it states an assumption to be challenged against the data; (5) it shows a ladder of rungs and a rewritten prompt in a code block. It fails if the rewrite is merely longer, with more sections and no named methods.
