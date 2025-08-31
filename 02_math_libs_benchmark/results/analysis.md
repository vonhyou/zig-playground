# Performance Anomaly Analysis

## Summary

Analysis of baseline benchmark results from Zig 0.15.1 on Ubuntu reveals several significant performance differences between math libraries. This document investigates cross-library anomalies where one library performs ~2x slower than others.

## Key Performance Anomalies

### 1. Vector Cross Product
- **zalgebra**: 546ns (1.99x slower than zm)
- **zm**: 274ns ⭐ fastest  
- **zmath**: 386ns (1.41x slower than zm)

**Root Cause**: zalgebra implements cross product using scalar operations while zm and zmath leverage @Vector or SIMD instructions.

### 2. Vector Normalization  
- **zalgebra**: 460ns (1.74x slower than zm)
- **zm**: 264ns ⭐ fastest
- **zmath**: 293ns (1.11x slower than zm)

**Root Cause**: Normalization requires sqrt operation. zm likely benefits from vectorized sqrt while zalgebra uses scalar math.

### 3. Matrix Chain Operations
- **zalgebra**: 5.78μs (3.47x slower than zmath)
- **zm**: 3.97μs (2.38x slower than zmath)  
- **zmath**: 1.66μs ⭐ fastest

**Root Cause**: zmath uses hand-optimized SIMD matrix multiplication while others rely on scalar operations or less optimized vector ops.

### 4. Quaternion Multiplication
- **zalgebra**: 1.126μs (3.09x slower than zm)
- **zm**: 364ns ⭐ fastest
- **zmath**: 717ns (1.97x slower than zm)

**Root Cause**: zm's quaternion implementation appears most optimized. zmath may be doing additional validation or using different algorithms.

### 5. Quaternion Normalization
- **zalgebra**: 738ns (2.29x slower than zm)
- **zm**: 322ns ⭐ fastest
- **zmath**: 359ns (1.11x slower than zm)

**Root Cause**: Similar to vector normalization - zm benefits from better sqrt optimization.

### 6. Matrix Transpose
- **zalgebra**: 708ns (1.40x slower than zmath)
- **zm**: 825ns (1.63x slower than zmath)
- **zmath**: 506ns ⭐ fastest

**Root Cause**: zmath likely uses SIMD shuffle instructions for transpose while others use scalar element copying.

## Library Performance Characteristics

### zalgebra
- Pure Zig implementation focused on readability
- Consistently slowest for complex operations (cross, normalize, matrix chain)
- Good for simple operations but lacks SIMD optimizations
- No apparent data layout issues - performance gaps due to algorithmic differences

### zm  
- Excellent for quaternions and simple vector operations
- Uses @Vector which enables some compiler optimizations
- Competitive performance across most operations
- Sometimes slower on matrix operations vs zmath

### zmath
- Fastest for matrix operations (especially chains and transpose)
- Hand-optimized SIMD implementations
- Designed specifically for game development workloads
- Occasionally slower than zm on simple operations due to overhead

## Adjustments Made for Fair Comparison

No adjustments were made to the existing benchmark implementations as the performance differences appear to reflect genuine library design choices rather than unfair comparisons:

1. **Data Layout**: All libraries use their native data types and layouts
2. **Batch Sizes**: All operations are single-element for current benchmarks  
3. **Iteration Counts**: Identical across all libraries (500,000 iterations)
4. **Compiler Flags**: No library-specific optimizations applied

## Recommendations for SIMD Benchmarks

Based on this analysis, the new SIMD benchmarks should:

1. **Test Batched Operations**: Compare AoS vs SoA layouts to see if performance gaps change with vectorized workloads
2. **Include Array Operations**: Test operations on arrays of 1000+ elements where SIMD benefits are most apparent  
3. **Measure Memory Patterns**: Add benchmarks for interleave/deinterleave to test memory bandwidth vs computation
4. **Add CPU-Specific Variants**: Compare ReleaseFast vs ReleaseFast -Dcpu=native to see SIMD instruction benefits

The goal is not to "fix" slower libraries, but to understand when and why performance differences occur, and provide realistic workload comparisons for users choosing between libraries.