---
name: altitude
description: "Climb from a task to the outcome behind it by asking 'what do you want to happen next?' until the goal stops being checkable, then recommend the highest rung that is still checkable and reachable, plus the workflow pieces that would take the human out of the loop. Use when the user invokes /ikarus:altitude."
argument-hint: "[task, or leave empty to use the current task]"
disable-model-invocation: true
---

# ikarus: altitude

Altitude means focusing on the outcome rather than the task. Felix Rieseberg went from fixing individual crashes to keeping his apps crash-free, and the second goal changed which work was worth doing. The question that climbs is **"what do you want to happen next?"**: the goal beyond the goal.

**Task.** The invoking message reads: $ARGUMENTS
If that is empty, use the task the conversation is about.

## When it fits

Altitude fits when the user is after an outcome and the task is a means to it. A good signal is that they would otherwise schedule a meeting about this work. It fits poorly for creative work, where the artifact is the point; in that case say so in one line and suggest `/ikarus:depth` or `/ikarus:range` instead.

## Build the ladder

1. Rung 0 is the task as asked.
2. Ask: if this were done perfectly, what would the user want to happen next? That answer is rung 1. Ask again from rung 1, and keep climbing.
3. Ground each answer in evidence: what the conversation, the repo or the documents say the user cares about. Where you are inferring their goal, mark it as a guess. The ladder is a hypothesis about what they want, and they are the one who knows.
4. Stop when the next rung would be (a) uncheckable, so that nobody could tell whether it succeeded, (b) unreachable with any access you could get, or (c) so abstract it is no longer a task. "Claude, go make money" doesn't work on its own yet. The last rung below that point is the ceiling.

Rungs often follow this shape, though not always: do the task → answer the question behind the task → make the decisions the answer implies → change the process so the question answers itself next time.

Felix's quarterly business review, climbing:

- 0: make the QBR deck.
- 1: hand over all the data and ask, "Tell me what changed this quarter, why, and what we should do about it."
- 2: identify the three most urgent decisions and start work on each, with arguments for and against.
- 3: design something better than a quarterly deck for getting leadership to catch problems early; show from the company's own history that it would have caught issues sooner; run it alongside the current review for a quarter.

A coding example:

- 0: fix this crash.
- 1: fix the crashes users actually hit, ranked by frequency.
- 2: keep the app crash-free, with a loop that fetches new crash reports, maps them to commits, reproduces, fixes and verifies.
- Above the ceiling: "make users happy" has no check at the level of a rung.

**Research and optimization.** For performance work, the first climb is Amdahl's: what share of end-to-end time is this kernel or function? A 2× speedup on 4% of the step saves 2%, and sometimes the highest rung is fusing the kernel away or not launching it at all. Here the ceiling is physical: the hardware's speed-of-light bound, not an abstract goal. For research, rungs climb from the question to the claim it supports to the decision or next experiment that claim unlocks. Exploratory research, where the question itself is still forming, fits altitude as poorly as creative work does. For these tasks, `../../playbooks/research.md` and `../../playbooks/gpu-kernels.md` have the details.

## For each rung, note

- **Deliverable**: what exists when it's done.
- **Judge**: who or what, other than you, decides whether it worked. If nothing can, the rung is above the ceiling.
- **Needs**: access, data and environments. If you are unsure, read and run `../preflight/SKILL.md`.
- **Loop-closers**: at higher rungs, much of the work is building what removes the human from the loop: making data easy to fetch, mapping versions to commits, giving the model somewhere to reproduce and verify. Name these pieces; they are often the most valuable output at that altitude. If the rung has to keep running, `../horizon/SKILL.md` covers making it durable.

## Present

```
Altitude ladder: <task in one line>

0  As asked: <deliverable>
1  <deliverable>
   judge: <...>   needs: <...>
2  <deliverable>
   judge: <...>   needs: <...>   loop-closers: <...>
3  ...
Ceiling: <the first rung that fails, and which test it fails>

Recommended: rung N, <the highest rung that is checkable and reachable now>
```

If `/ikarus:fly` is running this as part of a flight plan, return the ladder to it and stop here. Otherwise ask which rung to take, with AskUserQuestion if it is available, or in plain text followed by stopping, unless the user already said to go or named a rung. Before taking any rung above 0, run the checks in `../wax/SKILL.md`; keep that brief unless something fails.

Then do the work at the chosen rung. At higher rungs, start with the loop-closers, because they make every later step cheaper.
