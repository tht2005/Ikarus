---
name: fly
description: "Find where a task has the most room to be more ambitious and climb there: altitude (the goal beyond the goal), depth (expert-grade methods and raw data), range (borrowing from other fields), breadth (the whole class, not one instance), horizon (make it last). Scores the task on each axis, builds a ladder for the best one or two, checks the plan with wax, then does the rung the user picks. Use when the user invokes /ikarus:fly or explicitly asks to think bigger, be more ambitious, aim higher, take this seriously, 'what's the most ambitious version of this', or 'what am I not asking for'. Do not use on ordinary tasks the user has not asked to expand, including requests to merely 'look deeper' at a bug."
argument-hint: "[task, or leave empty to use the current task]"
---

# ikarus: fly

Most prompts aim low. People calibrate to what used to be possible, and a model given a timid prompt returns a timid result. This skill finds where the task has the most headroom and climbs there, without flying into the sun.

Altitude, depth and range come from Felix Rieseberg's "How to be more ambitious: a tutorial for humans with models". Breadth, horizon, and the preflight and wax checks are this plugin's additions. Each axis has its own skill next to this one; this skill decides which to use.

**Task.** The invoking message reads: $ARGUMENTS
If that is empty, the task is the one the conversation is about. If there is no task anywhere, ask for one in a sentence and stop.

## 1. Restate and preflight

Restate the task in one line. This is rung 0, "as asked".

Then take a quick look at what this session can actually reach: tools (shell, web, subagents, connectors), the data the task depends on (look for it in files, databases, logs and APIs rather than assuming), whether you can install software, and what could verify the result. Ambition is capped by access, and a ladder built without this look produces plans that can't be carried out. If access looks like the main constraint, read `../preflight/SKILL.md` (relative to this skill's base directory) and run it in full.

## 2. Score the headroom

For each axis, score 0–3 how far the task as asked sits below what's possible on that axis, with a one-line reason specific to this task.

| Axis | Question | High headroom when |
|---|---|---|
| altitude | Is this a step toward an outcome the user actually wants? | They'd otherwise call a meeting about it; the task is a means, not the end |
| depth | Would a top professional use rawer material, real instruments, or a real verifier? | The plan says "analyze", "check" or "summarize" without naming a method or a judge |
| range | Does another field do this job for a living, and do it better? | The deliverable is a familiar noun (deck, report, README) made the usual way |
| breadth | Is this one instance of a class? | One bug, one customer, one file, and there are more like it |
| horizon | Will this need doing again, or be worth more if it kept running? | It recurs, or the answer goes stale |

Scores are judgments, so say where you are unsure. A 0 is a fine answer; not every task has headroom on every axis.

## 3. Pick one or two axes

Take the one or two axes with the most headroom. Stacking all five is how you get the sun: the plan balloons, nothing is checkable, and nothing ships.

For each chosen axis, read its skill file (`../altitude/SKILL.md`, `../depth/SKILL.md`, `../range/SKILL.md`, `../breadth/SKILL.md`, `../horizon/SKILL.md`) and build its ladder the way that file says. When combining axes, go in this order, because each depends on the one before: altitude picks the goal; depth, range and breadth decide how to reach it; horizon makes the result last. Depth spent on the wrong goal is wasted.

## 4. Wax check

Read `../wax/SKILL.md` and run its checks on the rung you would recommend. If wax says to trim, lower the recommendation, and name the fallback rung either way.

## 5. Present the flight plan

```
Flight plan: <task in one line>

Headroom   altitude 2 · depth 3 · range 1 · breadth 0 · horizon 2
           <one line for each axis scored 2 or 3: why>

<the ladder for each chosen axis, in the format its skill gives>

Recommended: <axis> rung N, <why it's the highest rung that's still checkable and reachable>
Wax: <verdict>, <reason>. Fallback: <a lower rung that still ships something>
```

Then ask the user which rung to fly, with AskUserQuestion if it is available, or in plain text followed by stopping. If the user already said "just go" or named a rung, skip the question and use that one.

## 6. Fly it

Do the work at the chosen rung, following the axis skill's guidance for carrying it out. If the rung needs access you don't have, close the gaps you can yourself, ask the user for the rest, and deliver the fallback in the meantime.

If the user asked only for a better prompt, output the rewritten prompt for the chosen rung and stop.
