# Impact of Library Design on Benchmark Performance

## 1. Executive Summary

Following the correction of the primary bias in the `vec len` benchmark, further investigation into the remaining performance disparities between `zalgebra` and `zm` reveals that these differences are largely attributable to the distinct API design and implementation strategies employed by each library. It is not a flaw in the benchmark setup, but rather an inherent characteristic of how the libraries are constructed.

`zm` consistently outperforms `zalgebra` in operations where `zalgebra` uses more explicit function calls for component access, operation execution, and result construction, while `zm` leverages more direct Zig language features.

## 2. Analysis of `vec cross` Performance

**Benchmark Results:**

| Benchmark   | `zalgebra` (avg) | `zm` (avg) | Difference (`zalgebra` - `zm`) |
| :---------- | :--------------- | :--------- | :----------------------------- |
| `vec cross` | 45ns             | 23ns       | 22ns                           |

`zalgebra` is nearly twice as slow as `zm` in calculating the cross product.

### Implementation Comparison:

**`zalgebra`'s `cross` (from `src/generic_vector.zig`):

```zig
pub fn cross(first_vector: Self, second_vector: Self) Self {
    const x1 = first_vector.x(); // Function call
    const y1 = first_vector.y(); // Function call
    const z1 = first_vector.z(); // Function call
    const x2 = second_vector.x(); // Function call
    const y2 = second_vector.y(); // Function call
    const z2 = second_vector.z(); // Function call

    const result_x = (y1 * z2) - (z1 * y2);
    const result_y = (z1 * x2) - (x1 * z2);
    const result_z = (x1 * y2) - (y1 * x2);

    return Self.new(result_x, result_y, result_z); // Function call
}
```

**`zm`'s `cross` (from `src/vector.zig`):

```zig
pub fn cross(self: anytype, other: @TypeOf(self)) @TypeOf(self) {
    if (dimensions(@TypeOf(self)) != 3) @compileError("cross is only defined for vectors of length 3.");
    return @TypeOf(self){ // Struct literal construction
        self[1] * other[2] - self[2] * other[1], // Direct array access
        self[2] * other[0] - self[0] * other[2],
        self[0] * other[1] - self[1] * other[0],
    };
}
```

**Reason for Difference:**
`zalgebra`'s implementation involves multiple function calls for accessing vector components (`.x()`, `.y()`, `.z()`) and for constructing the result vector (`.new()`). While the Zig compiler is highly capable of inlining, these layers of abstraction can introduce a small, cumulative overhead. `zm`, on the other hand, uses direct array indexing (`self[index]`) and struct literal construction, which are typically more direct and can be more efficiently optimized by the compiler.

## 3. Analysis of `varying data` Performance

**Benchmark Results:**

| Benchmark      | `zalgebra` (avg) | `zm` (avg) | Difference (`zalgebra` - `zm`) |
| :------------- | :--------------- | :--------- | :----------------------------- |
| `varying data` | 104ns            | 53ns       | 51ns                           |

`zalgebra` is approximately twice as slow as `zm` in the `varying data` benchmark.

### Implementation Comparison:

The `varying data` benchmark primarily tests repeated vector multiplication (`mul`).

**`zalgebra`'s `mul` (from `src/generic_vector.zig`):

```zig
pub fn mul(first_vector: Self, second_vector: Self) Self {
    const result = first_vector.data * second_vector.data;
    return .{ .data = result };
}
```

**`zm`'s `mul` (operator `*` for vectors, from `src/vector.zig`):

`zm` leverages Zig's built-in support for element-wise operations on `@Vector` types. When two `@Vector` types are multiplied using the `*` operator (e.g., `vec_a * vec_b`), Zig's compiler directly performs the element-wise multiplication, which is a highly optimized intrinsic operation.

**Reason for Difference:**
Similar to the `cross` function, `zalgebra` wraps the underlying vector multiplication in an explicit `mul` function. While this wrapper is minimal, it's still a function call. `zm` directly uses the `*` operator, which, for `@Vector` types, is handled as a highly optimized built-in operation by the Zig compiler. In a tight loop like the `varying data` benchmark, this difference in approach can lead to significant performance disparities as the overhead accumulates.

## 4. Conclusion

The remaining performance differences between `zalgebra` and `zm` are not indicative of flaws in the benchmark setup (after the `vec len` correction). Instead, they highlight the performance implications of different library design philosophies.

`zalgebra`'s design, which prioritizes a more object-oriented or functional API with explicit function calls for operations and component access, introduces a small, consistent overhead. `zm`'s design, by directly utilizing Zig's low-level `@Vector` type and its intrinsic operator support, often achieves more direct and highly optimized code generation. Both approaches are valid, but `zm`'s design appears to yield better performance in these specific micro-benchmarks due to its closer alignment with Zig's compiler optimizations for built-in types and operations.
