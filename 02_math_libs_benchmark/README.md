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
zig build run -Doptimize=ReleaseFast -Dcpu=native
```

## Supported libraries

- **zalgebra** (kooparse/zalgebra) - Pure Zig linear algebra library
- **zm** (griush/zm) - Zig math library with @Vector optimization
- **zmath** (zig-gamedev/zmath) - SIMD-first math library for game development

## Current benchmark cases

### Vector Operations (18 benchmarks)
- **Vec3 multiplication** (component-wise) - zalgebra, zm, zmath
- **Vec3 dot product** - zalgebra, zm, zmath  
- **Vec3 cross product** - zalgebra, zm, zmath
- **Vec3 length/magnitude** - zalgebra, zm, zmath
- **Vec3 normalization** - zalgebra, zm, zmath
- **Vec3 linear interpolation (lerp)** - zalgebra, zm, zmath
- **Vec3 distance** - zalgebra, zm, zmath

### Matrix Operations (9 benchmarks)
- **Mat4×Mat4 multiplication** - zalgebra, zm, zmath
- **Mat4 transpose** - zalgebra, zm, zmath
- **Mat4 chain multiplication** (multiple matrix multiplications) - zalgebra, zm, zmath

### Quaternion Operations (8 benchmarks)
- **Quaternion multiplication** - zalgebra, zm, zmath
- **Quaternion normalization** - zalgebra, zm, zmath
- **Quaternion slerp** (spherical linear interpolation) - zalgebra, zm

### GameDev Operations (5 benchmarks)
- **Look At matrix generation** - zalgebra (placeholder), zm, zmath
- **SIMD vector operations** (combined dot/cross/scale) - zmath only
- **SIMD matrix chain operations** (rotation/translation/scale chains) - zmath only

## Proposed SIMD benches to add next

- Batched vector ops (SoA/AoS): vec3/vec4 dot, vec3 cross, normalize/length, horizontal reductions on large arrays
- Matrix ops: mat4×vec4 batched transforms, mat4×mat4, 4×4 transpose via shuffles, affine inverse vs full inverse
- Quaternions: multiply, normalize, slerp, quat→mat conversion (batched)
- Geometry: transform AABBs, frustum culling (plane-dot-vec), ray-box/triangle intersections (vectorized)
- Memory/layout: aligned vs unaligned loads/stores (if observable), AoS↔SoA interleave/deinterleave throughput
- Variants: compare ReleaseFast with -Dcpu=native and baseline targets; try lane-width variants if the library/target enables it

## Methodology

The benchmark methodology includes:
- Warmup runs with initial results discarded
- Multiple sample measurements for statistical accuracy
- Kernel-only timing (excluding setup/teardown overhead)
- Single sample validation to ensure correctness
- Optimized build flags (ReleaseFast, optional -Dcpu=native)
- Memory allocation tracking via zbench framework