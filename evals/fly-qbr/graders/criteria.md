---
type: llm
weight: 1
---

Passes only if ALL hold: (1) the response scores the task on all five axes (altitude, depth, range, breadth, horizon) with a 0-3 score and a task-specific reason for the high ones; (2) it picks at most two axes and shows a ladder of rungs (rung 0 = as asked, higher rungs concrete) for each chosen axis; (3) it recommends a specific rung; (4) it gives a wax verdict (CLIMB, TRIM, GROUND or HIGHER) and names a fallback rung; (5) it asks the user which rung to take, or stops for a choice, rather than producing a finished deck.
