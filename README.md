# ikarus

Skills for being more ambitious with models, without flying into the sun.

Most prompts aim low. People calibrate to what used to be possible, and a timid prompt gets a timid result. ikarus is a Claude Code plugin that takes a task and shows what a more ambitious version looks like along a few distinct axes. Each axis is a **ladder**: rung 0 is the task as asked, and each rung above it is concrete, has a judge other than the model, and names what it needs. You pick the rung; then it flies.

Altitude, depth and range come from Felix Rieseberg's [How to be more ambitious: a tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/). Breadth, horizon, preflight and wax are additions.

## Skills

| Skill | Axis | The move |
|---|---|---|
| `/ikarus:fly` | all | Scores the task's headroom on every axis, picks the best one or two, builds their ladders, runs wax, asks for a rung |
| `/ikarus:altitude` | ↑ goal | "What do you want to happen next?" Climb to the outcome behind the task, up to the highest rung that's still checkable |
| `/ikarus:depth` | ↓ expertise | Rawest source material, named methods and instruments, a challenged assumption, an outside judge. "Deeper, not bigger" |
| `/ikarus:range` | ↔ fields | Nouns into verbs; who does that verb for a living; a crew plus a red team producing work products, not voices |
| `/ikarus:breadth` | × count | Instance → every member → the mechanism → a guardrail so new members can't appear |
| `/ikarus:horizon` | → time | One-off → repeatable → durable → self-checking; backtest on history, run in shadow |
| `/ikarus:preflight` | access | What the session can actually reach, and the gaps sorted by who can close them |
| `/ikarus:wax` | brake | Mandate, urgency, judge, access, reversibility, cost, fallback, and "too timid?". Returns CLIMB, TRIM, GROUND or HIGHER |

When axes combine, they run in this order: preflight → altitude → depth / range / breadth → horizon → wax. Depth spent on the wrong goal is wasted, so altitude picks the goal first.

Claude can start `fly` (when you explicitly ask to think bigger) and `wax` (when a plan has grown well past what you asked) on its own. The axis skills only run when you invoke them.

## Install

Clone it wherever you keep plugins:

```sh
git clone https://github.com/tht2005/Ikarus.git ikarus
```

Try it for one session by pointing Claude Code at the clone:

```sh
claude --plugin-dir ./ikarus
```

Or install it so it loads in every session. The repo is its own single-plugin marketplace, so you can add it from the clone or straight from GitHub:

```sh
claude plugin marketplace add ./ikarus        # or: claude plugin marketplace add tht2005/Ikarus
claude plugin install ikarus@ikarus
```

## Usage

```
/ikarus:fly I need to make our QBR deck; churn is up 4 points
/ikarus:depth Make a slide explaining why churn went up
/ikarus:wax <a plan you're about to run>
```

Leave the argument empty to apply a skill to the task already under discussion.

## Evals

`evals/` holds one case per skill behaviour, graded by an LLM judge against written criteria, plus a should-not-fire case for `fly` and one for `wax`.

The `wax-*` cases are deliberately hard. A strong model reviewing a plan already catches the obvious problems, so most of these put the deciding fact in the workspace rather than in the prompt: a saved profile that contradicts the plan's guess, a second month of transcripts to compare against, closed deals to backtest on, a `make campaign` that turns out to email customers as the CEO. They pass only if the reviewer looks before judging. `wax-should-climb` is the counterweight: a sound plan that should be cleared to fly, not trimmed by reflex.

Those cases build their workspace with a `scaffold.sh` next to `case.yaml`, so they need `--scaffold`. The rubrics are nuanced enough that a small judge is noisy; use Sonnet.

```sh
claude plugin eval . --scaffold --judge-model sonnet --concurrency 4 --no-publish
claude plugin eval . --scaffold --judge-model sonnet --case 'wax-*' --no-publish   # just the wax suite
```
