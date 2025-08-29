# Math Library Benchmark Analysis

## 1. Executive Summary

An analysis of the math library benchmark in `src/main.zig` revealed significant bias, leading to flawed conclusions about the relative performance of the `zalgebra` and `zm` libraries. While `zm` consistently outperforms `zalgebra` in all tests, the magnitude of the difference is artificially inflated by an incorrect benchmark implementation.

The primary issue is that the `vec len` benchmark does not compare the same operation between the two libraries. It unfairly pits `zalgebra`'s vector **normalization** function against `zm`'s vector **length** function. Normalization is a more computationally expensive operation, which skews the results.

Secondary biases related to library API design (function calls vs. operators) also contribute to minor performance differences.

## 2. Flawed `vec len` Benchmark

The most significant issue lies in the benchmark named `bench_..._vec_len`.

### Benchmark Results

| Benchmark          | `zalgebra` (avg) | `zm` (avg) | Winner |
| ------------------ | ---------------- | ---------- | ------ |
| `vec len`          | 45ns             | 23ns       | `zm`   |

`zm` appears to be nearly twice as fast. However, an investigation into the source code of both libraries reveals why this result is misleading.

### `zalgebra` Implementation

The `zalgebra` benchmark calls `zalgebra.Vec3.norm()`:

```zig
// Benchmark code in src/main.zig
var result = zalgebra.Vec3.norm(vec3_za);
```

The implementation of `norm()` in `zalgebra`'s `generic_vector.zig` is as follows:

```zig
// zalgebra source
pub fn norm(self: Self) Self {
    const l = self.length(); // Involves a square root
    if (l == 0) {
        return self;
    }
    // Performs a vector-scalar division
    const result = self.data / @as(Data, @splat(l));
    return .{ .data = result };
}

pub fn length(self: Self) T {
    return @sqrt(self.dot(self));
}
```

The benchmark is executing a `sqrt` operation followed by a vector division.

### `zm` Implementation

The `zm` benchmark calls `zm.vec.len()`:

```zig
// Benchmark code in src/main.zig
var result = zm.vec.len(vec3_zm);
```

The implementation of `len()` in `zm`'s `vector.zig` is:

```zig
// zm source
pub fn len(self: anytype) VecElement(@TypeOf(self)) {
    return @sqrt(@reduce(.Add, self * self));
}
```

This function *only* performs a `sqrt` operation.

### Conclusion on Flaw

The benchmark incorrectly compares `zalgebra`'s vector normalization (`norm`) with `zm`'s vector length (`len`). The former is a more complex operation, which fully explains the dramatic performance gap. The benchmark author likely confused the function name `norm` (common for normalization) with a length calculation (also sometimes called the "norm" of a vector).

**To correct this, the `zalgebra` benchmark should call `zalgebra.Vec3.length()` instead of `zalgebra.Vec3.norm()`.**

## 3. Secondary Bias: API Design

A more subtle bias exists in the API design of the two libraries.

-   **`zalgebra`**: Tends to use static function calls for initialization and operations (e.g., `Vec3.new(...)`, `Vec3.mul(...)`).
-   **`zm`**: Tends to use struct literals and overloaded operators (e.g., `Vec3{...}`, `a * b`).

While the Zig compiler is highly effective at inlining and optimizing, the function call overhead in `zalgebra`, however small, can be measured in a tight benchmark loop. This likely accounts for the minor performance advantage `zm` holds in the other, more comparable benchmarks (`mul`, `dot`, `cross`).

## 4. Recommendation

The benchmark suite requires correction to be considered a fair comparison. The most critical change is to modify the `bench_zalgebra_vec_len` function to call the correct `length` function.
