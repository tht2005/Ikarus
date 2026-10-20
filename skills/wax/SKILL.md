---
name: wax
description: "Check an ambitious or expanded plan before carrying it out, so ambition doesn't melt the wings: mandate, urgency, a real judge, access, reversibility, cost, a fallback, and whether the plan is actually too timid. Returns CLIMB, TRIM, GROUND or HIGHER with a reason. Use when the user invokes /ikarus:wax; when they ask you to sanity-check, gut-check, pressure-test or poke holes in a plan before saying go; after any ikarus skill recommends a rung above 'as asked'; and whenever your own plan has grown well beyond what the user asked for (new infrastructure, many subagents, outward-facing actions)."
argument-hint: "[plan to check, or leave empty for the current plan]"
---

# ikarus: wax

Icarus's wings worked; the wax failed. Daedalus told him to fly the middle course: too low and the sea soaks the feathers, too high and the sun melts the wax. Too low is the timid default prompt that wastes what the model can do. Too high is a plan that can't be checked, can't be reached, or wasn't asked for. Wax checks a plan against both before it flies.

**Plan.** The invoking message reads: $ARGUMENTS
If that is empty, check the plan or rung currently on the table.

## Look first

Before judging, open what the plan refers to: the test it wants to fix, the config a command will run, the data it plans to sample, plus a quick listing of the workspace. Plans are written from memory, and the files often say something the plan doesn't: a profile that points somewhere else, a second month of data, a campaign that emails customers. A verdict on the plan as written is only as good as the plan's author's memory.

## The checks

Go through them quickly. Most plans pass most checks, and the report only needs to dwell on the ones that fail.

1. **Mandate.** Did the user ask for this scope? A higher rung is a proposal, not permission. If they haven't picked it, ask.
2. **Urgency.** Is the user in the middle of an incident or up against a deadline? Then do the as-asked version now and offer the climb afterward. A crash-free-apps loop is no help while production is down.
3. **Judge.** Is there something other than the model that can tell whether this rung worked, such as a test, held-out data, a backtest, or a person who will review it? If not, the rung is above the ceiling: drop a rung or add a judge. In research and benchmarking, also check that the judge is valid. A benchmark with no warm-up, a noisy shared GPU, warm caches or unrepresentative shapes measures the wrong thing. A derivation the model "checked" by rereading it hasn't been checked. A winner picked from many variants or hypotheses is partly picked on noise, so it needs a fresh re-measurement or held-out confirmation before it counts.
4. **Access.** Can the plan reach the data, tools and environments it needs? A plan built on access it doesn't have produces confident fiction. If unsure, read and run `../preflight/SKILL.md`.
5. **Reversibility.** Does it touch shared or outward-facing things: production, other people's code, messages to people, money, anything scheduled to run unattended? Those steps need explicit approval whatever rung was picked.
6. **Cost.** Roughly what time, tokens, money or GPU-hours will it take, compared with what the outcome is worth? Eight subagents to fix a typo is the sun, and so is a week of kernel tuning on 3% of the step.
7. **Fallback.** Is there a lower rung that still ships something useful if this one fails? Every plan needs one. When the fallback is cheap, deliver it first: ship the fix, then build the loop.
8. **Too low?** Check the other side too. If the session has the access, the task has the headroom, and the plan is still the timid default, say so: stopping at 40% of a kernel's speed-of-light bound with clear stalls in the trace, or testing one favored hypothesis when three are live. Under-reaching is a failure, not a safe choice.

## Verdict

```
Wax: CLIMB | TRIM to rung N | GROUND | HIGHER
Why: <one or two sentences naming the check that decided it>
Do now: <the immediate next step, e.g. "roll back the deploy" under GROUND>
Fallback: <the lower rung that still ships if the chosen plan fails; omit under GROUND, where "do now" already is the floor>
Needs approval: <any outward-facing or irreversible steps>
```

Keep "do now" and "fallback" separate. "Do now" is what happens first. "Fallback" is the safety net if the plan doesn't work out. Put the urgent action under "fallback" and it reads as optional.

- **CLIMB**: go as planned.
- **TRIM**: go, but at a lower rung, and name it.
- **GROUND**: do the task as asked; now isn't the time to climb. Say when the climb is worth revisiting (after the incident, after the deadline), so grounding delays the ambition without dropping it.
- **HIGHER**: the plan is too timid for the access and headroom available. Name the axis with the most room; `../fly/SKILL.md` can help pick it.
