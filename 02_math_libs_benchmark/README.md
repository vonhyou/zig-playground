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

### Vector Operations (33 benchmarks)
- **Vec3 multiplication** (component-wise) - zalgebra, zm, zmath
- **Vec3 dot product** - zalgebra, zm, zmath  
- **Vec3 cross product** - zalgebra, zm, zmath
- **Vec3 length/magnitude** - zalgebra, zm, zmath
- **Vec3 normalization** - zalgebra, zm, zmath
- **Vec3 linear interpolation (lerp)** - zalgebra, zm, zmath
- **Vec3 distance** - zalgebra, zm, zmath
- **Vec3 dot product batched (AoS layout)** - zalgebra, zm, zmath
- **Vec3 dot product batched (SoA layout)** - zalgebra, zm, zmath
- **Vec3 cross product batched (AoS layout)** - zalgebra, zm, zmath
- **Vec3 normalization batched (AoS layout)** - zalgebra, zm, zmath
- **Vec3 sum reduction** (horizontal reduction on arrays) - zalgebra, zm, zmath

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
- **SIMD vector operations** (combined dot/cross/scale) - zmath only
- **SIMD matrix chain operations** (rotation/translation/scale chains) - zmath only
- **AoS→SoA Vec3 conversion** (memory layout transformation) - zalgebra, zm, zmath
- **SoA→AoS Vec3 conversion** (memory layout transformation) - zalgebra, zm, zmath

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