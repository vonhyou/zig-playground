# Math Libraries Benchmark

This project contains a benchmark comparing the performance of different math libraries in Zig.

## Disclaimer

The benchmark method implemented in this project was written by an AI and has not been thoroughly examined or validated by a human expert. Please exercise caution when interpreting the results.

## Prerequisites

- Zig 0.15.1

## Build and run

```bash
# Build the project
zig build

# Run all benchmarks (default)
zig build run

# Run specific benchmark categories
zig build run -- vec      # Vector operations only
zig build run -- matrix   # Matrix operations only  
zig build run -- quat     # Quaternion operations only
zig build run -- gamedev  # GameDev operations only

# Show help
zig build run -- help
```

For optimized benchmarks, use:
```bash
zig build run -Doptimize=ReleaseFast
zig build run -Doptimize=ReleaseFast -Dcpu_native=true  # Enable native CPU optimizations
```

**Note**: The `-Dcpu_native=true` option enables native CPU feature detection and SIMD optimizations. Use this for maximum performance evaluation on your specific hardware, but keep in mind results may not be portable across different systems.

## Supported libraries

- **zalgebra** (kooparse/zalgebra) - Pure Zig linear algebra library
- **zm** (griush/zm) - Zig math library with @Vector optimization
- **zmath** (zig-gamedev/zmath) - SIMD-first math library for game development

## Current benchmark cases

### Vector Operations (35 benchmarks)
- **Vec3 multiplication** (component-wise) - zalgebra, zm, zmath *(hardened)*
- **Vec3 dot product** - zalgebra, zm, zmath *(hardened)*
- **Vec3 cross product** - zalgebra, zm, zmath
- **Vec3 length/magnitude** - zalgebra, zm, zmath
- **Vec3 normalization** - zalgebra, zm, zmath
- **Vec3 linear interpolation (lerp)** - zalgebra, zm, zmath
- **Vec3 distance** - zalgebra, zm, zmath
- **Vec3 dot product batched (AoS layout)** - zalgebra, zm, zmath *(hardened)*
- **Vec3 dot product batched (SoA layout)** - zalgebra, zm, zmath
- **Vec3 cross product batched (AoS layout)** - zalgebra, zm, zmath *(hardened)*
- **Vec3 normalization batched (AoS layout)** - zalgebra, zm, zmath *(partially hardened)*
- **Vec3 sum reduction** (horizontal reduction on arrays) - zalgebra, zm, zmath
- **🆕 Vec3 dot SIMD SoA optimized** - zmath native f32x4 lanes, 1024 element batches
- **🆕 Vec3 normalize SIMD SoA optimized** - zmath native batch processing

*(hardened) = fixed against constant folding and DCE*

### Matrix Operations (15 benchmarks)
- **Mat4×Mat4 multiplication** - zalgebra, zm, zmath
- **Mat4 transpose** - zalgebra, zm, zmath
- **Mat4 chain multiplication** (multiple matrix multiplications) - zalgebra, zm, zmath
- **Mat4×Vec4 batched transforms (AoS layout)** - zalgebra, zm, zmath
- **Mat4×Mat4 batched multiplication** - zalgebra, zm, zmath

### Quaternion Operations (14 benchmarks)
- **Quaternion multiplication** - zalgebra, zm, zmath
- **Quaternion normalization** - zalgebra, zm, zmath
- **Quaternion slerp** (spherical linear interpolation) - zalgebra, zm
- **Quaternion multiplication batched** - zalgebra, zm, zmath
- **Quaternion normalization batched** - zalgebra, zm, zmath

### GameDev Operations (11 benchmarks)
- **Look At matrix generation** - zalgebra (placeholder), zm, zmath
- **SIMD vector operations** (combined dot/cross/scale) - zmath only *(hardened)*
- **SIMD matrix chain operations** (rotation/translation/scale chains) - zmath only *(hardened)*
- **AoS→SoA Vec3 conversion** (memory layout transformation) - zalgebra, zm, zmath
- **SoA→AoS Vec3 conversion** (memory layout transformation) - zalgebra, zm, zmath

*(hardened) = fixed against constant folding and DCE*

## Key Improvements Made

### 🔧 **Anti-Optimization Hardening**
- **Constant Folding Prevention**: Replaced hardcoded values (e.g., `0.2, 0.3, 0.4`) with runtime-generated values using seeded RNG
- **Dead Code Elimination Prevention**: Replaced `results[0]` consumption with full result accumulation across entire batches
- **Volatile Operations**: `blackBox()` and `consume()` functions use `@volatileLoad`/`@volatileStore` to prevent compiler optimizations

### ⚡ **Enhanced SIMD/SoA Variants**  
- **Native zmath SoA**: New optimized variants use f32x4 lanes to process 4 Vec3s simultaneously
- **Batch Processing**: 1024-element batches for improved SIMD utilization
- **Memory Layout Optimization**: Separate X, Y, Z component arrays for optimal cache usage

### 🎯 **API Usage Corrections**
- **Matrix Operations**: Fixed zmath to use proper matrix construction instead of hardcoded arrays
- **Quaternion Operations**: Corrected axis-angle construction and multiplication APIs
- **Library Consistency**: Aligned operations to use each library's intended APIs

### 🚀 **CPU-Native Support**
- **Build Option**: `-Dcpu_native=true` enables native CPU feature detection
- **SIMD Optimization**: Allows libraries to use AVX, SSE, and other CPU-specific instructions
- **Portability**: Default build remains portable, native optimization is opt-in

## Proposed SIMD benches to add next

- ✅ ~~Batched vector ops (SoA/AoS): vec3/vec4 dot, vec3 cross, normalize/length, horizontal reductions on large arrays~~ **COMPLETED**
- ✅ ~~Matrix ops: mat4×vec4 batched transforms, mat4×mat4~~ **COMPLETED**
- ✅ ~~Quaternions: multiply, normalize (batched)~~ **COMPLETED**  
- ✅ ~~Memory/layout: AoS↔SoA interleave/deinterleave throughput~~ **COMPLETED**
- 4×4 transpose via SIMD shuffles, affine inverse vs full inverse
- Quaternion slerp, quat→mat conversion (batched)
- Geometry: transform AABBs, frustum culling (plane-dot-vec), ray-box/triangle intersections (vectorized)
- Memory/layout: aligned vs unaligned loads/stores (if observable)
- Variants: compare ReleaseFast with -Dcpu=native and baseline targets; try lane-width variants if the library/target enables it

## Methodology

The benchmark methodology includes:
- **Anti-optimization measures**: `blackBox()` and `consume()` functions prevent constant folding and dead code elimination
- **Runtime data generation**: All inputs are generated at runtime using seeded RNG to prevent compile-time precomputation
- **Full workload consumption**: Batched operations aggregate all results via scalar accumulation to ensure complete execution
- Warmup runs with initial results discarded
- Multiple sample measurements for statistical accuracy
- Kernel-only timing (excluding setup/teardown overhead)
- Single sample validation to ensure correctness
- Optimized build flags (ReleaseFast, optional -Dcpu=native)
- Memory allocation tracking via zbench framework

## Benchmark Naming Convention

Due to zbench's 22-character display limit, benchmark names use abbreviated identifiers:

**Library Abbreviations:**
- `za` = zalgebra
- `zm` = zm
- `zmath` = zmath

**Examples:**
- `V3DotBatchAoS:za` = Vec3 Dot Batch AoS: zalgebra
- `M4V4BatchAoS:zmath` = Mat4×Vec4 Batch AoS: zmath
- `QuatMulBatch:zm` = Quat Mul Batch: zm

This ensures all benchmark results are clearly identifiable without truncation ambiguity.