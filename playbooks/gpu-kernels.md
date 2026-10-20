# GPU kernel playbook: profiling and optimization

Read this when the task is making a GPU kernel faster, or analyzing a profile or thread trace to find out why a kernel is slow. It is written for AMD Instinct GPUs and ROCm (rocprofv3, ATT thread traces, rocprof-compute), where thread-trace analysis is most often asked for. The method carries over to NVIDIA, with Nsight Systems and Nsight Compute in place of the ROCm tools.

Tool flags, counter names and trace formats change between ROCm releases. Check `--help` and the docs installed on the machine rather than trusting the names below.

## 1. Amdahl before anything

Get a system-level trace of the real workload (rocprofv3 kernel or system trace) and find this kernel's share of end-to-end time. A 2× speedup on a kernel that takes 4% of the step saves 2%. Sometimes the best move is altitude: fuse the kernel away, or change the algorithm so it isn't launched at all.

## 2. Speed of light

Compute the bound before measuring how far you are from it:

- the minimum bytes the kernel must move to and from HBM, and the minimum FLOPs;
- arithmetic intensity = FLOPs ÷ bytes, compared with the machine balance (peak matrix-core FLOP/s for this dtype ÷ peak HBM bandwidth);
- bound time = max(FLOPs ÷ peak FLOP/s, bytes ÷ peak bandwidth). Report achieved time as a percentage of that bound.

Use measured peaks (a stream-style bandwidth test, a large GEMM) alongside datasheet peaks; the gap between them is real. This bound is depth's "unreasonable target, stated plainly". It says whether there is headroom at all, and which resource is the limit.

## 3. Instruments, coarse to fine

1. **Timing done right**: warm-up runs, many iterations, median and spread, clocks locked or at least recorded, the GPU otherwise idle, inputs sized like the real workload (larger than the caches unless the real one fits). Without this, every later comparison is noise.
2. **Hardware counters** (rocprofv3 counter collection; rocprof-compute, formerly Omniperf, for roofline and speed-of-light panels): achieved HBM bandwidth, cache hit rates, VALU and MFMA utilization, LDS bank conflicts, occupancy.
3. **ISA**: dump it (`hipcc --save-temps`, or disassemble the code object) and read the resource usage (VGPRs, SGPRs, LDS, scratch) and the hot loop. Are global loads vectorized (`dwordx4`)? Is there scratch, meaning spills? Which MFMA instructions are used? Where are the waits? Compiling with `-Rpass-analysis=kernel-resource-usage` prints register use and occupancy.
4. **ATT thread trace**: per-instruction timing for sampled waves. It shows where waves stall and on what, which counters average away. Use it to find *where* time goes in the hot loop. Use timing and counters for totals, since tracing covers a subset of CUs and perturbs timing slightly.

## 4. From trace to hypotheses to experiments

Read the hot loop in the trace, map the symptoms to competing hypotheses, then design the experiment that tells them apart (strong inference; see `research.md`). Common patterns on CDNA:

| Symptom in trace or counters | Competing hypotheses | Discriminating experiment |
|---|---|---|
| Long stalls on `s_waitcnt vmcnt(...)` after global loads | Latency-bound (too few waves or too little ILP to hide memory latency) vs bandwidth-bound (HBM saturated) | Compare achieved bandwidth with the measured peak. Far below it: raise occupancy (fewer VGPRs, launch bounds), issue more loads before waiting, or prefetch / double-buffer the next tile. Near it: only moving fewer bytes helps (fusion, reuse, lower precision) |
| Stalls on `s_waitcnt lgkmcnt(...)` after `ds_read` | LDS bank conflicts vs LDS latency exposed by scheduling | Bank-conflict counter; pad or swizzle the LDS layout and see whether conflicts and stall cycles drop |
| Gaps between MFMA issues | Dependency chains (too few independent accumulators) vs operands not ready (loads not overlapped) | See what the MFMA waits on in the trace; unroll for more independent accumulators vs interleave loads with MFMAs |
| Long `s_barrier` waits | Load imbalance between waves vs over-synchronization | Per-wave timelines; restructure producer/consumer roles or remove barriers |
| Scratch in the resource usage | Register spills from too much unrolling or too large a tile | Shrink the tile or unroll factor; compare VGPRs and time |
| Uneven wave end times, a long tail | Quantization: workgroups don't divide evenly over the CUs (304 on MI300X) | Change tile size or grid; split-K, stream-K or a persistent kernel |
| Low L2 hit rate on multi-XCD parts | Workgroups that share data land on different XCDs, each with its own L2 | Remap workgroup IDs so neighbors share an XCD; compare hit rates |

These are starting hypotheses, not diagnoses. Each one gets a prediction and an experiment before a code change is kept.

## 5. Experiment discipline

- Change one thing at a time. Keep a table per variant: the change, VGPRs, occupancy, time (median and spread), percentage of speed of light, key counters. That table is the result.
- Check correctness on every variant against a reference implementation, with tolerances suited to the dtype, including edge shapes. A fast wrong kernel is the most common way optimization ships a bug.
- Autotuning picks winners partly on noise. Re-measure the winner on fresh runs before reporting it.
- Measure on the shapes the real workload uses, not one convenient shape.

## 6. Where ideas come from

For AMD-native patterns: Composable Kernel, hipBLASLt, rocWMMA and the Triton AMD backend. For algorithms: the FlashAttention, CUTLASS, split-K and stream-K papers; CPU dense linear algebra (Goto/BLIS-style blocking) for tiling; compiler software pipelining for overlap. An idea from an NVIDIA kernel transfers only after checking where the analogy breaks: wavefront 64 vs warp 32, LDS size and banking, MFMA operand layouts, which async or bulk copy features the target arch (gfx942, gfx950) actually has, and the multi-XCD cache topology.

## What each axis means here

- **altitude**: this kernel → its share of the step (Amdahl) → fuse it or remove it → the model's end-to-end throughput.
- **depth**: wall time → counters and the roofline gap → hypotheses from the ATT trace, tested by experiments → a performance model that predicts other shapes.
- **range**: neighboring fields and other vendors' kernels, each with its transfer check.
- **breadth**: one shape → the workload's shape distribution and dtypes → a tuned config table or autotuner → a performance regression test.
- **horizon**: a checked-in benchmark harness that records its environment (ROCm version, driver, firmware, clocks, GPU) and reruns on new ROCm releases and hardware.
- **wax**: is the benchmark a valid judge (noise, warm caches, unrealistic shapes)? Is the speedup still there after a correctness check and a fresh re-measurement? Is a sweep's GPU-hour cost worth the kernel's share of end-to-end time?
- **preflight**: which GPU and arch (`rocminfo`), the ROCm version, which profilers are installed (rocprofv3 with thread-trace support, rocprof-compute), permission to read counters and collect traces, whether clocks can be locked, whether the GPU is shared.
