---
name: preflight
description: "Inventory what this session can actually reach (data, tools, environments, verifiers, connectors) and name the access gaps that block a more ambitious version of a task, sorted by who can close them. Use when the user invokes /ikarus:preflight, or when another ikarus skill needs to know whether a rung is reachable."
argument-hint: "[task or plan to check access for, or leave empty for the current one]"
disable-model-invocation: true
---

# ikarus: preflight

Ambition is capped by access. The ambitious version of a quarterly review needs the raw event data, not the dashboard. Felix Rieseberg's crash-free-apps loop only worked once crash reports were easy to fetch, app versions mapped to git commits, and Claude had machines on three operating systems to reproduce and verify fixes. Closing those gaps was the real work; after that, the human could leave the loop.

This skill finds the gaps before you climb, so the plan rests on what's reachable rather than on what sounds good.

**Target.** The invoking message reads: $ARGUMENTS
If that is empty, use the task or plan the conversation is about.

## 1. What does the target need?

List what the most ambitious reasonable version of the target would need, in five buckets:

- **Data**: the rawest source. Event logs rather than the dashboard, source code rather than the docs, the database rather than an export.
- **Tools**: the instruments a professional would use, such as a statistics package, a profiler, a database or a renderer.
- **Environments**: places to run and reproduce, such as a test suite, a staging copy, or a machine on the right OS.
- **Verifiers**: something other than you or the user that can say whether it worked: tests, a held-out dataset, a benchmark, a backtest, a reproduction.
- **Reach**: connectors and permissions, such as the issue tracker, analytics, docs or chat.

## 2. What can you actually reach?

Check rather than assume; a few quick commands beat a guess. List what's in the working directory, look for data files and for config that names data sources, check that key tools are installed, look at which connectors and MCP tools this session has, and test whether you can install packages. Keep it to a few minutes. This is a preflight, not an audit.

For GPU kernel work, also check:
- the GPU and its arch;
- the ROCm or CUDA version;
- whether the profilers are installed, including thread-trace support;
- permission to read counters and collect traces;
- whether clocks can be locked;
- whether anyone else is using the GPU.

The section on preflight in `../../playbooks/gpu-kernels.md` lists the commands. For theoretical or analytical research, check for a computer algebra system, a proof assistant if one is warranted, compute for simulations, and access to the primary papers.

## 3. Sort the gaps

For each need that isn't met, mark who can close it:

- **(a) You can close it now**: install a package, write a fetch script, generate a fixture, build a reproduction.
- **(b) The user can close it in minutes**: connect a connector, export a file, grant a permission, say where the data lives. For credentials, ask them to use an environment variable or a connector rather than pasting secrets into the chat.
- **(c) Structural**: it needs infrastructure or other people. Note it, and don't plan around it.

## 4. Report

```
Preflight: <target in one line>

Need                          Have?   Closes by
raw event logs (events.db)    yes     -
churn labels                  no      (b) export from billing
survival analysis library     no      (a) pip install lifelines
a held-out quarter of data    yes     -

Reachable now:            <the highest rung or version possible today>
Reachable after (b) gaps: <what becomes possible; often the real unlock>
```

Offer to close the (a) gaps right away. They usually take minutes, and they raise the ceiling for everything after.
