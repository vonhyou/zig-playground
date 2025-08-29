# Future Expansion Example - Matrix Operations

This document shows how the refactored structure makes it easy to add new benchmark categories like matrix operations.

## Adding Matrix Benchmarks

### 1. Extend the Category Enum

```zig
const BenchmarkCategory = enum {
    vec,
    matrix, // Add new category
};
```

### 2. Add Matrix Benchmark Functions

```zig
// Matrix multiplication benchmarks
fn bench_zalgebra_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zalgebra.Mat4.identity();
    const mat_b = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    var result = zalgebra.Mat4.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zm.Mat4.identity();
    const mat_b = zm.Mat4.translation(1, 2, 3);
    var result = zm.Mat4.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Matrix transpose benchmarks
fn bench_zalgebra_mat_transpose(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    var result = zalgebra.Mat4.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_mat_transpose(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zm.Mat4.translation(1, 2, 3);
    var result = zm.Mat4.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

// Matrix inverse benchmarks
fn bench_zalgebra_mat_inverse(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    var result = zalgebra.Mat4.inverse(mat);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_mat_inverse(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zm.Mat4.translation(1, 2, 3);
    var result = zm.Mat4.inverse(mat);
    std.mem.doNotOptimizeAway(&result);
}
```

### 3. Update the BENCHMARKS Array

```zig
const BENCHMARKS = [_]BenchmarkInfo{
    // Vector operations (existing)
    .{ .name = "zalgebra vec mul", .func = bench_zalgebra_vec_mul, .category = .vec },
    .{ .name = "zm vec mul", .func = bench_zm_vec_mul, .category = .vec },
    // ... (all existing vector benchmarks)
    
    // Matrix operations (new)
    .{ .name = "zalgebra mat mul", .func = bench_zalgebra_mat_mul, .category = .matrix },
    .{ .name = "zm mat mul", .func = bench_zm_mat_mul, .category = .matrix },
    .{ .name = "zalgebra mat transpose", .func = bench_zalgebra_mat_transpose, .category = .matrix },
    .{ .name = "zm mat transpose", .func = bench_zm_mat_transpose, .category = .matrix },
    .{ .name = "zalgebra mat inverse", .func = bench_zalgebra_mat_inverse, .category = .matrix },
    .{ .name = "zm mat inverse", .func = bench_zm_mat_inverse, .category = .matrix },
};
```

### 4. Update the Switch Statement

```zig
fn runBenchmarks(allocator: std.mem.Allocator, writer: anytype, category: ?BenchmarkCategory) !void {
    // ... existing code ...
    
    // Print category header
    if (category) |cat| {
        switch (cat) {
            .vec => try writer.writeAll("\n=== Vector Operations Benchmarks ===\n"),
            .matrix => try writer.writeAll("\n=== Matrix Operations Benchmarks ===\n"), // Add this line
        }
    } else {
        try writer.writeAll("\n=== All Benchmarks ===\n");
    }
    
    // ... rest remains the same ...
}
```

### 5. Update Help Message

```zig
fn printHelp(writer: anytype) !void {
    try writer.writeAll("Math Library Benchmark Tool\n");
    try writer.writeAll("============================\n\n");
    try writer.writeAll("Usage: zig build run -- [OPTION]\n\n");
    try writer.writeAll("Available options:\n");
    try writer.writeAll("  full      Run all benchmarks\n");
    try writer.writeAll("  vec       Run only vector operations benchmarks\n");
    try writer.writeAll("  matrix    Run only matrix operations benchmarks\n"); // Add this line
    try writer.writeAll("  help      Show this help message\n\n");
    try writer.writeAll("If no option is provided, this help message will be displayed.\n\n");
    try writer.writeAll("Examples:\n");
    try writer.writeAll("  zig build run -- full\n");
    try writer.writeAll("  zig build run -- vec\n");
    try writer.writeAll("  zig build run -- matrix\n"); // Add this line
}
```

### 6. Update Main Function

```zig
pub fn main() !void {
    // ... existing setup code ...
    
    // Handle commands
    if (std.mem.eql(u8, command, "full")) {
        try runBenchmarks(allocator, writer, null);
    } else if (std.mem.eql(u8, command, "vec")) {
        try runBenchmarks(allocator, writer, .vec);
    } else if (std.mem.eql(u8, command, "matrix")) { // Add this block
        try runBenchmarks(allocator, writer, .matrix);
    } else if (std.mem.eql(u8, command, "help")) {
        try printHelp(writer);
    } else {
        try writer.writeAll("Error: Invalid option '");
        try writer.writeAll(command);
        try writer.writeAll("'\n\n");
        try printHelp(writer);
        std.process.exit(1);
    }
}
```

## New Command-Line Options

After adding matrix operations, the benchmark would support:

```bash
# Run all benchmarks (vectors + matrices)
zig build run -- full

# Run only vector benchmarks  
zig build run -- vec

# Run only matrix benchmarks
zig build run -- matrix

# Show help
zig build run -- help
zig build run
```

## Benefits of This Approach

1. **Minimal Changes**: Only need to add functions and update the BENCHMARKS array
2. **Consistent Interface**: Same command-line pattern for all categories
3. **Easy Testing**: Can benchmark each category independently
4. **Scalable**: Can add quaternion, transform, physics, etc. categories the same way
5. **Maintainable**: All metadata in one central location

## Future Categories

The same pattern can be used for:
- `quaternion` - Quaternion operations for rotations
- `transform` - Transform matrices and operations  
- `physics` - Physics-related math operations
- `interpolation` - Lerp, slerp, bezier curves
- `collision` - Collision detection math
- `lighting` - Lighting calculation benchmarks

Each category would follow the same pattern: add enum value, add benchmark functions, update BENCHMARKS array, update help and main function.