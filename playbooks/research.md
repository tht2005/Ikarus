# Research playbook: theory, intuition, analysis, hypotheses

Read this when the task is research: building intuition for a theoretical result, explaining a phenomenon, analyzing data, or generating and testing hypotheses. The ikarus axes apply unchanged. This file supplies the instruments, judges and failure modes research needs, which the business-flavored examples in the skills don't cover.

## The research trap

A model can produce a fluent explanation for almost anything, and fluency is not evidence. In research the judge matters more than anywhere else, because a wrong explanation that sounds right gets built on. So mark every claim in a research deliverable as one of:

- **derived**, with the derivation checked by something other than re-reading it;
- **measured**, with the measurement and how it was taken;
- **cited**, from a primary source you actually opened;
- **conjectured**, said plainly.

## Building intuition for a theoretical result

The moves experts reach for (Pólya's *How to Solve It* covers several):

- **Toy model**: the smallest system that still shows the phenomenon. Two particles, a 2×2 matrix, one layer, n = 3.
- **Limiting cases and symmetries**: what happens as a parameter goes to 0 or ∞, and what the answer must be invariant under. A formula that fails a limit is wrong.
- **Dimensions and scaling**: check units, and decide how the quantity should scale with each input before deriving it.
- **Order of magnitude**: a Fermi estimate before the exact calculation, so a wrong exact answer gets noticed.
- **Specialize, then generalize**: brute-force small cases, look for the pattern, conjecture, then prove it or break it.
- **Try to break it**: search for a counterexample, numerically where possible.
- **Say the mechanism** in one paragraph a smart outsider could follow. If you can't, the intuition isn't there yet.

Judges for theory: evaluate a derived expression numerically at random points against a direct computation; enumerate small cases by brute force; reproduce known limits; check algebra with a CAS (sympy); for a lemma that carries real weight, a proof assistant (Lean). Algebra no tool has checked is a draft. If the session can't run code, hand over the check as a script, mark what it would verify as unverified, and move on; don't burn turns looking for a way to execute it.

## Hypotheses: strong inference

For "why does X happen?" use strong inference (Platt, 1964), which builds on Chamberlin's method of multiple working hypotheses:

1. List at least three competing hypotheses, including the boring ones: a measurement artifact, noise, a bug, a confounder, a change in the inputs.
2. For each, write what it predicts that the others don't.
3. Design the crucial experiment: the cheapest observation or perturbation whose outcome rules hypotheses out. Prefer perturbations (change one thing, see what moves) over passive correlation.
4. Write the predictions down before running it. Afterwards, report results against them, including the hypothesis you liked that lost.
5. Recycle: the survivors get sharper sub-hypotheses.

The failure mode is a single favored story with supporting evidence. Evidence that fits one hypothesis usually fits two.

## Data analysis

- Look at the raw data before modeling it: distributions, a sample of rows, a plot over time. Most surprises are data problems.
- Reproduce the headline number from raw data before explaining it. If you can't, the definition is the story.
- Report effect sizes with uncertainty, not just "significant".
- Check robustness: does the conclusion survive a reasonable alternative specification, a different window, a placebo or negative control?
- Mind the garden of forking paths (Gelman and Loken): every choice made after seeing the data is a chance to fit noise. Confirm exploratory findings on data held back or collected afterwards.

## Sources

Read primary sources rather than citing from memory. Models misremember paper details, theorem conditions and numbers. When a claim rests on a paper, open it and quote the exact statement and its conditions.

## What each axis means here

- **altitude**: question → the claim it supports → the decision or next experiment that claim unlocks. Exploratory research, where the question is still forming, fits altitude poorly; don't force an outcome onto it.
- **depth**: plausible story → competing hypotheses with predictions → crucial experiment run against predictions stated in advance → a mechanism or model that predicts conditions it wasn't built from.
- **range**: analogies from other fields are the main source of new hypotheses, and the main source of seductive wrong ones. For every borrowed idea, write the mapping (what corresponds to what) and where it breaks. The break point is usually where the interesting question is.
- **breadth**: one condition, dataset or regime → all of them. If the effect doesn't hold everywhere, the boundary is a finding.
- **horizon**: an analysis that reruns from raw data with one command, with the environment and seeds recorded and each run's results logged.
- **wax**: no judge, no climb. Watch for forking paths, for the compute cost of sweeps, and for the model checking its own derivation.
