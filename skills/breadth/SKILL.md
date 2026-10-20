---
name: breadth
description: "Treat a task as one instance of a class: find every member, handle them all, fix the mechanism that produces them, and add a guardrail so new ones can't appear. Altitude asks why; breadth asks how many. Use when the user invokes /ikarus:breadth."
argument-hint: "[task, or leave empty to use the current task]"
disable-model-invocation: true
---

# ikarus: breadth

Most tasks are one member of a class: one bug in a pattern that recurs, one churned customer among the accounts at risk, one doc with a gap that all the docs share. Handling the one by hand used to be the economical choice. With a model, handling the whole class is often barely more work, and worth far more.

Breadth is not altitude. Altitude asks *why* and climbs to a different goal; breadth keeps the goal and asks *how many*.

**Task.** The invoking message reads: $ARGUMENTS
If that is empty, use the task the conversation is about.

## 1. Name the class

What is this task an instance of? Make the definition precise enough to search for. "Bad code" is not a class; "a call to `getUser()` whose result is used without a null check" is.

## 2. Find the members, by actually searching

Grep, query, list. Count them. The count drives the ladder, since 3 members and 300 call for different plans. Check a sample by hand for false members, things that look like the class but aren't, and tighten the definition if you find any. If you can't search (no access to the code or data), say so, and treat the member count as unknown rather than guessing it.

## 3. Ladder

```
Breadth ladder: <task in one line>
Class: <precise definition>   Members found: <n> (<how you searched>)

0  The instance, as asked
1  Every known member: <n> fixes or handlings
2  The mechanism: <the root cause, shared abstraction or generator that produces members>
3  The guardrail: <lint rule, type, CI check, template or alert> so new members can't appear

Recommended: rung N, <why>
```

For example, "fix this null dereference in orders.ts" → the search finds 14 call sites with the same pattern → fix all 14 → make `getUser()` return a type that forces the check → add a lint rule so the pattern can't come back.

If `/ikarus:fly` is running this as part of a flight plan, return the ladder to it and stop here. Otherwise ask which rung to take, with AskUserQuestion if it is available, or in plain text followed by stopping, unless the user already said to go or named a rung. Before taking any rung above 0, run the checks in `../wax/SKILL.md`; keep that brief unless something fails.

## 4. Doing it

Solve one member carefully by hand first and extract the recipe. Then apply it to the rest, fanned out to subagents if there are many and they are independent. Verify every member, not just the sample: a test, a type check, or a re-run of the search that should now come back empty.

Breadth widens the blast radius, so keep the changes reviewable: one commit per member, or a table of what changed where. Changes that reach other people's code or shared systems need the user's go-ahead first.
