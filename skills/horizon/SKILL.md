---
name: horizon
description: "Extend a task along time, from a one-off answer to something repeatable, durable and self-checking: checked in, scheduled or triggered, loud when it breaks, backtested against history, and run in shadow before it replaces anything. Use when the user invokes /ikarus:horizon."
argument-hint: "[task, or leave empty to use the current task]"
disable-model-invocation: true
---

# ikarus: horizon

Horizon is the time axis. A one-off answer starts going stale the day it is delivered. The same work rebuilt as something that regenerates from source, runs on its own, and says when it is wrong keeps paying. Horizon also points backward: the strongest evidence that something will work next quarter is showing that it would have worked last quarter.

**Task.** The invoking message reads: $ARGUMENTS
If that is empty, use the task the conversation is about.

## When it fits

Ask: will this need doing again? How often, and what changes between runs? If it is truly one-off, like a migration that runs once or a decision already made, say so in one line and stop. Horizon has nothing to add there.

## Ladder

```
Horizon ladder: <task in one line>

0  One-off: the answer, as asked
1  Repeatable: a checked-in script, query, notebook or skill that regenerates it from source
2  Durable: scheduled or triggered (CI, cron, a scheduled agent, a hook), loud when it fails, with an owner
3  Self-checking: compares its outputs with what actually happened and flags drift; backtested on history and run in shadow before it replaces the old process

Recommended: rung N, <why>
```

If `/ikarus:fly` is running this as part of a flight plan, return the ladder to it and stop here. Otherwise ask which rung to take, with AskUserQuestion if it is available, or in plain text followed by stopping, unless the user already said to go or named a rung. Before taking any rung above 0, run the checks in `../wax/SKILL.md`; keep that brief unless something fails.

## Backtest and shadow

These two are horizon's judges, the thing other than you that says it works.

- **Backtest**: run it on the past (git history, last quarter's data, old incidents) and show what it would have caught, and when. Felix Rieseberg's replacement for the quarterly review had to show, from the company's own history, that it would have caught issues sooner.
- **Shadow**: run it alongside the current process for a while before replacing anything. Where the two disagree is the most useful output of that period.

## Durability checklist

Before calling anything rung 2 or above, check that:

- it lives in version control, not in a chat transcript;
- it has no hard-coded local paths or secrets, and credentials come from the environment or a connector;
- running it twice is safe;
- failure is loud: it alerts or fails visibly instead of quietly producing stale output;
- someone owns it, and the README says how to turn it off.

Scheduling jobs, wiring CI, or anything else that runs unattended is outward-facing, so confirm with the user before turning it on.
