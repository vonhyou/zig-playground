const std = @import("std");
const libraries = @import("libraries/mod.zig");

// Vector multiplication benchmarks using adapter pattern
pub fn bench_zalgebra_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.add(a, b); // Using add for component-wise operation
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.add(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.add(a, b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector dot product benchmarks
pub fn bench_zalgebra_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.dot(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.dot(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.dot(a, b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector cross product benchmarks
pub fn bench_zalgebra_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.cross(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.cross(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.cross(a, b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector length benchmarks
pub fn bench_zalgebra_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const v = Ops.vec3(0.2, 0.3, 0.4);
    
    var result = Ops.length(v);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const v = Ops.vec3(0.2, 0.3, 0.4);
    
    var result = Ops.length(v);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const v = Ops.vec3(0.2, 0.3, 0.4);
    
    var result = Ops.length(v);
    std.mem.doNotOptimizeAway(&result);
}

// Vector normalize benchmarks
pub fn bench_zalgebra_vec_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const v = Ops.vec3(0.2, 0.3, 0.4);
    
    var result = Ops.normalize3(v);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const v = Ops.vec3(0.2, 0.3, 0.4);
    
    var result = Ops.normalize3(v);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const v = Ops.vec3(0.2, 0.3, 0.4);
    
    var result = Ops.normalize3(v);
    std.mem.doNotOptimizeAway(&result);
}

// Vector distance benchmarks
pub fn bench_zalgebra_vec_distance(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.distance(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_distance(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.distance(a, b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_distance(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.distance(a, b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector lerp benchmarks
pub fn bench_zalgebra_vec_lerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zalgebra, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.lerp(a, b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_lerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zm, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.lerp(a, b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_vec_lerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const Ops = libraries.getVecOps(.zmath, .{});
    
    const a = Ops.vec3(0.2, 0.3, 0.4);
    const b = Ops.vec3(0.4, 0.3, 0.2);
    
    var result = Ops.lerp(a, b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}