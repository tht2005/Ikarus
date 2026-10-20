---
name: depth
description: "Push a task toward how the best professional in the field would do it: the rawest source material, named methods and real instruments, a challenged assumption, and a judge other than the model. Then rewrite the prompt to ask for exactly that. 'A deeper version of the task, not a bigger one.' Use when the user invokes /ikarus:depth."
argument-hint: "[task, or leave empty to use the current task]"
disable-model-invocation: true
---

# ikarus: depth

Depth means working the way the top expert in the field would: down to the raw data, with professional instruments and methods, and on until an expert might learn something from the result. The aim is **a deeper version of the task, not a bigger one.** A deeper result is often shorter. If your rewrite only adds sections, it got bigger, not deeper, so start again.

**Task.** The invoking message reads: $ARGUMENTS
If that is empty, use the task the conversation is about.

**Research and kernels.** For research (theoretical intuition, explaining a phenomenon, data analysis, hypotheses), read `../../playbooks/research.md` before answering the questions below. For GPU kernel performance (profiles, ATT thread traces, optimization), read `../../playbooks/gpu-kernels.md`. Both paths are relative to this skill's base directory. They name the raw sources, instruments and judges for those fields, which the examples here don't cover.

## The five questions

Answer these concretely for this task, with named tools, named methods and named files, before rewriting anything. Generic answers like "use the data" or "be rigorous" are the failure mode.

1. **What would a top professional do here that the user didn't ask for?**
2. **What is the rawest source material they would start from?** Event logs rather than the dashboard, source rather than docs, transactions rather than someone's summary of them. Summaries carry the summarizer's assumptions.
3. **Which specific methods and tools would they use?** Name them. For churn: survival analysis (a Cox model, say) and cohort tables in a real database, not "analyze churn" in a markdown table. For performance: a profiler and a flame graph, not "check what's slow". For a GPU kernel: a speed-of-light bound, hardware counters, the ISA and a thread trace, not wall time alone. For a crash: symbolicated dumps, a bisect, sanitizers.
4. **Who or what, other than the user or you, would verify the result?** A test that fails before the change and passes after, a held-out dataset, a benchmark, a reproduction, a backtest, a type checker. For a derivation: a numeric check against direct computation, or small cases enumerated by brute force. Prefer something you can run yourself for fast feedback. Don't be your own only judge: models grade their own work generously, and that is how confident wrong answers ship.
5. **Rewrite the prompt to ask for exactly that.**

## Depth moves

Use the ones that fit:

- **Industry-grade instruments.** Install and use the real tool: a database and a statistical model, not a table in markdown.
- **An unreasonable target, stated plainly.** Ask for 200 ms page loads, not 5 s. The target changes the method: 5 s invites tweaks, while 200 ms forces a rethink of the architecture. Label it a stretch in the ladder so wax can weigh it.
- **Challenge an assumption against the raw data.** Find the belief the task rests on and try to reproduce it: "We believe churn is an onboarding problem. Try to reproduce that from the raw data." Report plainly whether it held.
- **Competing hypotheses, then the crucial experiment.** When the task asks *why* something happens (a loss spike, a slow kernel, an effect in the data), don't settle on the first good story. List at least three hypotheses, including the boring ones (artifact, noise, bug). Write what each predicts that the others don't, then design the cheapest experiment that rules some out, and state the predictions before running it. Evidence that fits one story usually fits two; the experiment is what tells them apart.
- **Produce new knowledge.** Build a model or simulation from the raw data (simulated customers built from event logs, say), look for something nobody knew (the earliest churn signal), and test it on data held back for testing, meaning data the finding was not built from.

## Ladder

```
Depth ladder: <task in one line>

0  As asked: <what it would produce>
1  Real instruments on raw material: <source> with <tools and methods>
   judge: <...>
2  Plus a challenged assumption or competing hypotheses: "<the belief>" or <H1 / H2 / H3>, tested by <data or experiment>
   judge: <...>
3  Plus new knowledge: <model, simulation or finding>, validated on <held-out data>
   judge: <...>

Recommended: rung N, <why>
```

After the ladder, show the rewritten prompt for the recommended rung, the actual text the user could send, in a code block.

If `/ikarus:fly` is running this as part of a flight plan, return the ladder and prompt to it and stop here. Otherwise ask which rung to take, with AskUserQuestion if it is available, or in plain text followed by stopping, unless the user already said to go or named a rung. If the user only wanted the prompt, stop after the rewrite. Before taking any rung above 0, run the checks in `../wax/SKILL.md`; keep that brief unless something fails.

## Doing it

At the chosen rung, get the raw material first and look at it before forming conclusions. Set up the judge before doing the work, so it measures the result rather than rubber-stamping it. Report what the judge said, including where it disagreed with you.

If the judge needs code this session can't run (no shell), say so once and write the check as a script the user can run. Mark the claims it would test as unverified, then finish the rest of the work. Don't spend turns looking for a way to execute it: subagents get the same tools you have, so delegating only adds time.
