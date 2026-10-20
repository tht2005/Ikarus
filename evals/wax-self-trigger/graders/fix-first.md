---
type: llm
weight: 1
---

Passes only if the response recommends doing the off-by-one fix now (ideally with a regression test) and treating the cursor-based rewrite as a separate, later proposal. FAILS if it endorses doing the full rewrite now, or only lists pros and cons without a recommendation.
