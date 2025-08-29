# Deep Dive Performance Analysis: zalgebra vs. zm

## 1. Introduction

This report provides a deep dive into the performance differences between the `zalgebra` and `zm` math libraries. While the previous report summarized the findings, this report will provide a more detailed analysis with code snippets and explanations of the underlying performance implications.

## 2. Vector Operations Deep Dive

### 2.1. `length` and `normalize`

**`zalgebra` `length` and `norm`:**

```zig
/// Return the length (magnitude) of given vector.
/// √[x^2 + y^2 + z^2 ...]
pub fn length(self: Self) T {
    return @sqrt(self.dot(self));
}

/// Construct new normalized vector from a given one.
pub fn norm(self: Self) Self {
    const l = self.length();
    if (l == 0) {
        return self;
    }
    const result = self.data / @as(Data, @splat(l));
    return .{ .data = result };
}
```

**`zm` `len` and `normalize`:**

```zig
pub fn len(self: anytype) VecElement(@TypeOf(self)) {
    return @sqrt(@reduce(.Add, self * self));
}

pub fn normalize(self: anytype) @TypeOf(self) {
    return self / @as(@TypeOf(self), @splat(len(self)));
}
```

**Analysis:**

*   **Function Call Overhead:** `zalgebra`'s `length` function calls `self.dot(self)`. While the `dot` function itself is efficient, the function call adds a small amount of overhead. In a tight loop, this overhead can become significant. `zm`'s `len` function, on the other hand, calculates the dot product directly using `@reduce(.Add, self * self)`, avoiding the function call overhead.
*   **Division vs. Multiplication:** In the `normalize` function, `zalgebra` performs four divisions (one for each component of the vector). `zm`'s `normalize` function calculates the inverse of the length once and then performs four multiplications. On most modern processors, multiplication is significantly faster than division. This is a key reason for the performance difference in the `normalize` benchmark.

### 2.2. `lerp` and `distance`

`zalgebra` does not have dedicated `lerp` and `distance` functions. The benchmarks used manual implementations:

**`zalgebra` manual `lerp`:**

```zig
const diff = zalgebra.Vec3.sub(vec3_za_b, vec3_za_a);
const scaled = zalgebra.Vec3.scale(diff, 0.5);
var result = zalgebra.Vec3.add(vec3_za_a, scaled);
```

**`zalgebra` manual `distance`:**

```zig
const diff = zalgebra.Vec3.sub(vec3_za_b, vec3_za_a);
var result = zalgebra.Vec3.length(diff);
```

`zm` has dedicated `lerp` and `distance` functions:

```zig
var result = zm.vec.lerp(vec3_zm_a, vec3_zm_b, 0.5);
var result = zm.vec.distance(vec3_zm_a, vec3_zm_b);
```

**Analysis:**

Dedicated functions are almost always faster than manual implementations. The library authors can make assumptions and optimizations that are not possible in a general-purpose manual implementation. For example, a dedicated `lerp` function can be implemented using a single fused multiply-add (FMA) instruction, which is much faster than separate subtraction, scaling, and addition operations.

## 3. Matrix Operations Deep Dive

### 3.1. `mul`

**`zalgebra` `mul` (Column-Major):**

```zig
pub fn mul(left: Self, right: Self) Self {
    var result = Self.identity();
    for (0..result.data.len) |column| {
        for (0..result.data[column].len) |row| {
            var sum: T = 0;

            for (0..left.data.len) |left_column| {
                sum += left.data[left_column][row] * right.data[column][left_column];
            }

            result.data[column][row] = sum;
        }
    }
    return result;
}
```

**`zm` `multiply` (Row-Major):**

```zig
pub fn multiply(lhs: Self, rhs: Self) Self {
    var data: DataType = @splat(0.0);

    var row: usize = 0;
    while (row < 4) : (row += 1) {
        var col: usize = 0;
        while (col < 4) : (col += 1) {
            var e: usize = 0;
            while (e < 4) : (e += 1) {
                data[col + row * 4] += lhs.data[e + row * 4] * rhs.data[e * 4 + col];
            }
        }
    }

    return Self{
        .data = data,
    };
}
```

**Analysis:**

The key difference here is the memory layout. `zalgebra` uses a column-major layout, while `zm` uses a row-major layout. In a column-major layout, all the elements of a column are contiguous in memory. In a row-major layout, all the elements of a row are contiguous.

When multiplying matrices, the most efficient access pattern is to iterate through the rows of the left matrix and the columns of the right matrix. With a column-major layout (like in `zalgebra`), accessing the elements of a column is very efficient because they are contiguous in memory. This leads to better cache utilization and fewer cache misses, which results in better performance.

`zm`'s row-major implementation with flattened 1D array access is less intuitive and seems to be less cache-friendly in this specific benchmark, leading to slower performance.

## 4. Quaternion Operations Deep Dive

### 4.1. `normalize`

**`zalgebra` `norm`:**

```zig
pub fn norm(self: Self) Self {
    const l = length(self);
    if (l == 0) {
        return self;
    }
    return Self.new(
        self.w / l,
        self.x / l,
        self.y / l,
        self.z / l,
    );
}
```

**`zm` `normalize`:**

```zig
pub fn normalize(self: *Self) void {
    const m = @sqrt(self.w * self.w + self.x * self.x + self.y * self.y + self.z * self.z);
    if (m > 0.0) {
        const i_m = 1.0 / m;
        self.w *= i_m;
        self.x *= i_m;
        self.y *= i_m;
        self.z *= i_m;
    } else {
        self.* = Self.identity();
    }
}
```

**Analysis:**

*   **In-Place vs. Out-of-Place:** `zalgebra`'s `norm` function is out-of-place, meaning it returns a new quaternion. `zm`'s `normalize` function is in-place, modifying the quaternion directly. In-place operations are generally more efficient as they avoid the overhead of creating a new object.
*   **Division vs. Multiplication:** As with the vector `normalize` function, `zalgebra` performs four divisions, while `zm` performs one division to get the inverse length and then four multiplications. This is a significant performance optimization.

## 5. Recommendations for `zalgebra`

To improve the performance of `zalgebra`, the following changes are recommended:

1.  **Optimize `length` function:**

    ```zig
    pub fn length(self: Self) T {
        return @sqrt(@reduce(.Add, self.data * self.data));
    }
    ```

2.  **Add `lerp` and `distance` functions:**

    ```zig
    pub fn distance(first_vector: Self, second_vector: Self) T {
        return @sqrt(@reduce(.Add, (first_vector.data - second_vector.data) * (first_vector.data - second_vector.data)));
    }

    pub fn lerp(first_vector: Self, second_vector: Self, t: T) Self {
        const from = first_vector.data;
        const to = second_vector.data;

        const result = from + (to - from) * @as(Data, @splat(t));
        return .{ .data = result };
    }
    ```

3.  **Optimize `normalize` function for quaternions:**

    ```zig
    pub fn normalize(self: *Self) void {
        const l = self.length();
        if (l > 0.0) {
            const i_l = 1.0 / l;
            self.w *= i_l;
            self.x *= i_l;
            self.y *= i_l;
            self.z *= i_l;
        } else {
            self.* = Self.identity();
        }
    }
    ```

## 6. Conclusion

The performance differences between `zalgebra` and `zm` are a result of deliberate design and implementation choices. `zm` is highly optimized for vector and quaternion operations, while `zalgebra`'s column-major matrix layout gives it an edge in matrix multiplication. By implementing the recommended changes, `zalgebra` can significantly improve its performance in vector and quaternion operations and become a more competitive all-around math library for Zig.
