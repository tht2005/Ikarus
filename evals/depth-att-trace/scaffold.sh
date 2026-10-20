#!/usr/bin/env bash
set -euo pipefail
mkdir -p kernels profile
cat > README.md <<'IKARUS_EOF'
# rmsnorm_fused

Fused RMSNorm (bf16 in and out, fp32 accumulation), run before every attention and MLP block.

- Target: MI300X (gfx942), ROCm 6.4
- Benchmark shape: tokens = 16384, hidden = 8192, bf16; weight is 8192 bf16
- Current: 410 us median over 200 iterations (clocks not locked)
- Measured stream bandwidth on this node: 4.2 TB/s

profile/ holds the decoded ATT hotspot summary, counters from the same run, and the compiler's resource-usage remarks.
IKARUS_EOF
cat > kernels/rmsnorm_fused.hip <<'IKARUS_EOF'
#include <hip/hip_runtime.h>
#include <hip/hip_bf16.h>

// One 256-thread workgroup per row.
__global__ void rmsnorm_fused(const __hip_bfloat16* __restrict__ x,
                              const __hip_bfloat16* __restrict__ w,
                              __hip_bfloat16* __restrict__ y,
                              int hidden, float eps) {
  const __hip_bfloat16* row = x + (size_t)blockIdx.x * hidden;
  __hip_bfloat16* out = y + (size_t)blockIdx.x * hidden;
  __shared__ float partial[256];

  float sumsq = 0.f;
  for (int i = threadIdx.x; i < hidden; i += blockDim.x) {
    float v = __bfloat162float(row[i]);
    sumsq += v * v;
  }
  partial[threadIdx.x] = sumsq;
  __syncthreads();
  for (int s = blockDim.x / 2; s > 0; s >>= 1) {
    if (threadIdx.x < s) partial[threadIdx.x] += partial[threadIdx.x + s];
    __syncthreads();
  }
  float inv = rsqrtf(partial[0] / hidden + eps);

  for (int i = threadIdx.x; i < hidden; i += blockDim.x) {
    float v = __bfloat162float(row[i]);
    out[i] = __float2bfloat16(v * inv * __bfloat162float(w[i]));
  }
}
IKARUS_EOF
cat > profile/att_hotspots.csv <<'IKARUS_EOF'
# ROCprof ATT instruction summary (decoded thread trace), kernel rmsnorm_fused, gfx942
# 64 waves sampled on SE0; cycles and stall_cycles summed over the sampled waves
pc,instruction,hitcount,cycles,stall_cycles
0x0000,"s_load_dwordx4 s[4:7], s[0:1], 0x0",64,1856,1504
0x0008,s_waitcnt lgkmcnt(0),64,2112,2048
0x0020,"v_lshlrev_b32 v1, 1, v0",64,256,0
0x0040,"global_load_ushort v2, v[0:1], off",2048,18432,4096
0x0048,s_waitcnt vmcnt(0),2048,1611776,1597440
0x004c,"v_lshlrev_b32 v2, 16, v2",2048,8192,0
0x0050,"v_fmac_f32 v3, v2, v2",2048,8192,0
0x0054,"v_add_co_u32 v0, vcc, v0, 0x200",2048,8192,0
0x0060,s_cbranch_vccnz 0x0040,2048,12288,2048
0x0080,"ds_write_b32 v4, v3",64,512,128
0x0088,s_barrier,576,215040,208896
0x0090,"ds_read_b32 v5, v4 offset:512",512,4096,1024
0x0098,s_waitcnt lgkmcnt(0),512,36864,34816
0x00a0,"v_add_f32 v3, v3, v5",512,2048,0
0x00f0,"v_rsq_f32 v8, v8",64,512,128
0x0100,"global_load_ushort v6, v[0:1], off",2048,18432,4096
0x0104,"global_load_ushort v7, v[10:11], off",2048,18432,4096
0x0108,s_waitcnt vmcnt(0),2048,1290240,1277952
0x010c,"v_lshlrev_b32 v6, 16, v6",2048,8192,0
0x0110,"v_mul_f32 v6, v6, v8",2048,8192,0
0x0118,"v_mul_f32 v6, v6, v7",2048,8192,0
0x0120,"v_lshrrev_b32 v6, 16, v6",2048,8192,0
0x0128,"global_store_short v[12:13], v6, off",2048,24576,8192
0x0130,s_cbranch_vccnz 0x0100,2048,12288,2048
0x0140,s_endpgm,64,256,0
IKARUS_EOF
cat > profile/counters.csv <<'IKARUS_EOF'
metric,value,unit
duration_median,410,us
duration_p90,428,us
iterations,200,
hbm_read,271,MB
hbm_write,268,MB
achieved_hbm_bandwidth,1.31,TB/s
l2_hit_rate,49,%
mean_occupancy,7.6,waves/SIMD
valu_utilization,6,%
lds_bank_conflict_cycles,0.2,% of LDS cycles
IKARUS_EOF
cat > profile/resource_usage.txt <<'IKARUS_EOF'
remark: kernels/rmsnorm_fused.hip:5:0: Function Name: _Z13rmsnorm_fusedPK14__hip_bfloat16S1_PS_if
remark: kernels/rmsnorm_fused.hip:5:0:     SGPRs: 22
remark: kernels/rmsnorm_fused.hip:5:0:     VGPRs: 14
remark: kernels/rmsnorm_fused.hip:5:0:     AGPRs: 0
remark: kernels/rmsnorm_fused.hip:5:0:     ScratchSize [bytes/lane]: 0
remark: kernels/rmsnorm_fused.hip:5:0:     Occupancy [waves/SIMD]: 8
remark: kernels/rmsnorm_fused.hip:5:0:     LDS Size [bytes/block]: 1024
IKARUS_EOF
