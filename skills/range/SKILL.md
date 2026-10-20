---
name: range
description: "Look at a task through other fields: turn the deliverable's noun into the verb it serves, find who does that verb for a living, and assemble a crew of specialists plus a red team, each producing their field's work product rather than imitating its voice. Fans out to subagents when the crew is big enough. Use when the user invokes /ikarus:range."
argument-hint: "[task, or leave empty to use the current task]"
disable-model-invocation: true
---

# ikarus: range

Range means borrowing perspectives, tools and techniques from many fields, more than used to be economical now that one person can run a crew of agents. Felix Rieseberg had made video games, yet never thought of a 3D environment for his homepage until a colleague used Blender to design interiors. He says this is where "the most magic" happens.

**Task.** The invoking message reads: $ARGUMENTS
If that is empty, use the task the conversation is about.

## 1. Nouns into verbs

Rewrite the deliverable as the job it does. (The technique comes from Tom Kelley and Jonathan Littman's *The Art of Innovation*.) A noun locks you into one field's way of making that thing; a verb reveals every field that does the same job.

- "a deck" → getting busy people to believe a story about cause and effect in 30 minutes
- "a README" → getting a stranger from zero to a first success before they lose interest
- "fix this crash" → keeping a system from failing in the field
- "an onboarding email" → changing what someone does in their first week

## 2. Who does that verb for a living?

List 5–8 fields that do it, with at least two far from the obvious one. For each, name one concrete technique or tool it would bring that the obvious field wouldn't. For "believe a story about cause and effect": a journalist (lede and nut graf, so the point lands in the first paragraph), a trial lawyer (exhibits and burden of proof), an epidemiologist (confounders and dose-response), a documentary editor (structure built around one character's change).

**Transfer check.** In research and technical work, a borrowed idea is a hypothesis, not a result. For each one, write the mapping (what in their field corresponds to what in yours) and the point where the analogy breaks. A FlashAttention trick from an NVIDIA kernel, ported to AMD, breaks at wavefront 64 vs warp 32, LDS size and banking, and MFMA operand layouts. A physics analogy for a learning dynamic breaks wherever the conserved quantity has no counterpart. The break point often holds the interesting question, and it is where the port fails if nobody looked. For research or GPU kernel tasks, `../../playbooks/research.md` and `../../playbooks/gpu-kernels.md` list the usual neighboring fields and pitfalls.

## 3. Assemble the crew

Pick the 3–5 roles that add the most, plus a **red team**: people whose job is to find the hole, such as a short seller, a forensic accountant, a penetration tester, opposing counsel or a hostile peer reviewer. In research, the red team's work products are a referee report, an attempt to replicate the result from the raw material, and a counterexample search. For a QBR about a churn problem, Felix's crew is an analyst, a journalist and an editor (plus a motion and audio designer if it will be presented), with a short seller and a forensic accountant as the red team.

**Work products, not voices.** Ask each role to do what that role does, not to write the way it talks. Role-play makes transcripts stranger without improving results. Not "You are a cynical short seller..." but "Research a short position on Acme: find the three numbers in this data that most undermine the bull case, and size the downside." Each role's spec names its deliverable: a short thesis, a reconciliation of revenue to cash, an edit memo, a storyboard, an attack tree.

## 4. Ladder

```
Range ladder: <task in one line>
Verb: <the job the deliverable does>
Fields that do this verb:
  <field>: <the technique or tool it brings>
  ... (5–8 lines; mark the far ones)

0  As asked: the usual way
1  One borrowed technique: <field>: <technique>
2  A crew: <role> → <work product>, one line each, then a synthesis
3  Plus a red team: <role> → <the hole it hunts for>; plus a change of medium if a field suggests one (<e.g. deck → interactive model>)

Recommended: rung N, <why>
```

Always show the field list, even when you pick the crew from only some of it. The far fields are the point of range: they are what the user would not have thought of alone, and seeing them is how the user steers the crew.

If `/ikarus:fly` is running this as part of a flight plan, return the ladder to it and stop here. Otherwise ask which rung to take, with AskUserQuestion if it is available, or in plain text followed by stopping, unless the user already said to go or named a rung. Before taking any rung above 0, run the checks in `../wax/SKILL.md`; keep that brief unless something fails.

## 5. Run the crew

If the crew has three or more roles and subagents are available, fan out: one subagent per role, each given the raw material and its deliverable spec, each returning its artifact. Otherwise run the roles as separate passes. Fan-out costs tokens, so scale the crew to the stakes.

Then synthesize. Look first at where the work products disagree, because disagreement is where the insight is. Treat red-team findings as inputs: for each hole, either fix it or say plainly why it is accepted.
