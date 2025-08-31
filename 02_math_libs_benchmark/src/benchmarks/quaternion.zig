const std = @import("std");
const libraries = @import("libraries/mod.zig");

// Quaternion multiplication benchmarks using adapter pattern
pub fn bench_zalgebra_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const VecOps = libraries.getVecOps(.zalgebra, .{});
    const QuatOps = libraries.getQuatOps(.zalgebra, .{});
    
    const axis_a = VecOps.vec3(1.0, 0.0, 0.0);
    const quat_a = QuatOps.fromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = VecOps.vec3(0.0, 1.0, 0.0);
    const quat_b = QuatOps.fromAxisAngle(axis_b, std.math.pi / 6.0);
    
    var result = QuatOps.multiply(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const VecOps = libraries.getVecOps(.zm, .{});
    const QuatOps = libraries.getQuatOps(.zm, .{});
    
    const axis_a = VecOps.vec3(1.0, 0.0, 0.0);
    const quat_a = QuatOps.fromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = VecOps.vec3(0.0, 1.0, 0.0);
    const quat_b = QuatOps.fromAxisAngle(axis_b, std.math.pi / 6.0);
    
    var result = QuatOps.multiply(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const VecOps = libraries.getVecOps(.zmath, .{});
    const QuatOps = libraries.getQuatOps(.zmath, .{});
    
    const axis_a = VecOps.vec3(1.0, 0.0, 0.0);
    const quat_a = QuatOps.fromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = VecOps.vec3(0.0, 1.0, 0.0);
    const quat_b = QuatOps.fromAxisAngle(axis_b, std.math.pi / 6.0);
    
    var result = QuatOps.multiply(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion normalization benchmarks
pub fn bench_zalgebra_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const VecOps = libraries.getVecOps(.zalgebra, .{});
    const QuatOps = libraries.getQuatOps(.zalgebra, .{});
    
    const axis = VecOps.vec3(1.0, 1.0, 1.0);
    const quat = QuatOps.fromAxisAngle(axis, std.math.pi / 4.0);
    
    var result = QuatOps.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const VecOps = libraries.getVecOps(.zm, .{});
    const QuatOps = libraries.getQuatOps(.zm, .{});
    
    const axis = VecOps.vec3(1.0, 1.0, 1.0);
    const quat = QuatOps.fromAxisAngle(axis, std.math.pi / 4.0);
    
    var result = QuatOps.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const VecOps = libraries.getVecOps(.zmath, .{});
    const QuatOps = libraries.getQuatOps(.zmath, .{});
    
    const axis = VecOps.vec3(1.0, 1.0, 1.0);
    const quat = QuatOps.fromAxisAngle(axis, std.math.pi / 4.0);
    
    var result = QuatOps.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}