---
type: llm
weight: 1
---

Passes only if ALL hold: (1) it shows a ladder that climbs from fixing this crash toward an outcome such as keeping the app crash-free or a crash triage loop; (2) each rung above 0 names a judge (what verifies it) other than the model; (3) it names a ceiling, i.e. a rung that is too abstract or uncheckable; (4) it names loop-closing pieces such as fetching crash reports, mapping versions to commits, or reproduction environments; (5) it recommends a rung and asks which to take rather than diving into a fix.
