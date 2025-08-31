const std = @import("std");
const libraries = @import("libraries/mod.zig");

// Matrix multiplication benchmarks using adapter pattern
pub fn bench_zalgebra_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getMatOps(.zalgebra, .{});
    
    const a = Ops.identity();
    const b = Ops.translate(1.0, 2.0, 3.0);
    
    var result = Ops.multiply(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getMatOps(.zm, .{});
    
    const a = Ops.identity();
    const b = Ops.translate(1.0, 2.0, 3.0);
    
    var result = Ops.multiply(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getMatOps(.zmath, .{});
    
    const a = Ops.identity();
    const b = Ops.translate(1.0, 2.0, 3.0);
    
    var result = Ops.multiply(a, b);
    std.mem.doNotOptimizeAway(&result);
}