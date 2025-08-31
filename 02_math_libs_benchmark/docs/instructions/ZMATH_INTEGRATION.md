# zmath Integration Methodology

This document describes the integration of `@zig-gamedev/zmath` into the math library benchmark suite and the methodology used to ensure fair comparisons.

## Libraries Compared

### zmath_gd (@zig-gamedev/zmath)
- **SIMD-first design**: Uses F32x4 vectors throughout, optimized for SIMD operations
- **Broadcast scalars**: Many functions like `dot3()` and `length3()` return F32x4 with the scalar result broadcast across all lanes
- **Extensive graphics helpers**: Includes comprehensive matrix operations, quaternions, and camera utilities
- **Right/Left-handed variants**: Provides `lookAtRh/Lh`, `perspectiveFovRh/Lh/Gl` variants for different coordinate systems
- **Row-major matrices**: Uses row vectors stored in SIMD registers
- **API style**: `zmath_gd.dot3(a, b)`, `zmath_gd.cross3(a, b)`, `zmath_gd.normalize3(v)`

### zm_griush (@griush/zm)
- **@Vector-backed**: Uses Zig's `@Vector` types with compiler autovectorization
- **Row-major matrices**: Similar to zmath but with different internal representation  
- **Defaults to f64**: Can be configured for f32, but defaults to higher precision
- **Scalar-style APIs**: Functions in `zm.vec` namespace return scalars where appropriate
- **API style**: `zm.vec.dot(a, b)`, `zm.vec.cross(a, b)`, `zm.vec.normalize(a, b)`

### zalg (@kooparse/zalgebra)
- **Higher-level types**: Exposes `Vec3`, `Mat4`, `Quat` types with methods
- **Column-major matrices**: Different memory layout which can affect cache performance
- **Method-based API**: Uses methods like `Vec3.length()`, `Mat4.mul()`, `Quat.norm()`
- **Manual implementations**: Some operations like distance and lerp need manual implementation
- **API style**: `zalgebra.Vec3.dot(a, b)`, `zalgebra.Vec3.cross(a, b)`, `zalgebra.Vec3.norm(v)`

## Fairness Policy

### Scalar Parity Mode (Default)
The benchmark suite ensures fair comparison by using scalar-equivalent operations across all libraries:

1. **zmath broadcast handling**: When zmath returns F32x4 with broadcast scalars (e.g., `dot3`, `length3`), we extract lane 0: `result[0]`
2. **Vector3 w-lane handling**: For 3D vector operations, zmath uses F32x4 with w ignored or set to 0.0 explicitly
3. **Consistent inputs**: All libraries receive equivalent input values in their native formats
4. **Comparable outputs**: Results are normalized to scalar values where libraries differ in return types

### Optional SIMD Track
An optional `--simd` flag enables zmath-specific SIMD benchmarks that:
- Keep F32x4 math operations end-to-end
- Use patterns like: `r = dot3(a,b) * (splat(0.1) * cross3(a,b) + splat(1.0))`
- Are clearly labeled as "zmath SIMD" in output
- Demonstrate zmath's SIMD-optimized performance characteristics

## API Mapping Examples

### Vector Operations
```zig
// Dot product
zalgebra: zalgebra.Vec3.dot(va, vb) -> f32
zm_griush: zm.vec.dot(va, vb) -> f32  
zmath_gd:  zmath_gd.dot3(va, vb)[0] -> f32  // Extract lane 0

// Cross product  
zalgebra: zalgebra.Vec3.cross(va, vb) -> Vec3
zm_griush: zm.vec.cross(va, vb) -> Vec3
zmath_gd:  zmath_gd.cross3(va, vb) -> F32x4 // w=0 for vector parity

// Length
zalgebra: zalgebra.Vec3.length(v) -> f32
zm_griush: zm.vec.len(v) -> f32
zmath_gd:  zmath_gd.length3(v)[0] -> f32  // Extract lane 0
```

### Matrix Operations
```zig
// Matrix multiplication
zalgebra: zalgebra.Mat4.mul(ma, mb) -> Mat4
zm_griush: zm.mul(ma, mb) -> Mat4
zmath_gd:  zmath_gd.mul(ma, mb) -> Mat

// Transpose
zalgebra: zalgebra.Mat4.transpose(m) -> Mat4  
zm_griush: zm.transpose(m) -> Mat4
zmath_gd:  zmath_gd.transpose(m) -> Mat
```

### Quaternion Operations
```zig
// Quaternion multiplication
zalgebra: zalgebra.Quat.mul(qa, qb) -> Quat
zm_griush: zm.qmul(qa, qb) -> Quat
zmath_gd:  zmath_gd.qmul(qa, qb) -> Quat

// Normalization
zalgebra: zalgebra.Quat.norm(q) -> Quat
zm_griush: zm.normalize(q) -> Quat  
zmath_gd:  zmath_gd.normalize4(q) -> F32x4
```

## Reproducibility

### Environment
- **Zig version**: 0.15.1 (as specified in build.zig.zon)
- **Target triple**: Use `zig build` defaults for your platform
- **Optimize mode**: Follow project defaults (typically ReleaseFast for benchmarks)
- **CPU features**: Automatic detection by Zig toolchain

### Running the Suite
```bash
# All libraries, scalar parity mode
zig build run -- full

# Vector operations only
zig build run -- vec

# Include zmath SIMD benchmarks
zig build run -- full --simd

# Matrix operations with SIMD
zig build run -- matrix --simd
```

### Import Aliases
To avoid naming collisions (both griush/zm and zig-gamedev/zmath commonly use "zm"), this repository uses distinct aliases:
- `zmath_gd` for @zig-gamedev/zmath
- `zm` for @griush/zm (unchanged)  
- `zalgebra` for @kooparse/zalgebra (unchanged)

## Performance Considerations

### Expected Characteristics
- **zmath_gd**: Should excel in SIMD-optimized scenarios, especially with `--simd` flag
- **zm_griush**: Good balance of performance and API usability with compiler autovectorization
- **zalgebra**: May show different performance characteristics due to column-major matrices and method-based API

### Measurement Methodology
- Uses zbench for consistent timing across all libraries
- Multiple iterations to account for variance
- Memory allocation tracking to identify allocation overhead
- Prevents compiler optimization of benchmark code with `std.mem.doNotOptimizeAway`