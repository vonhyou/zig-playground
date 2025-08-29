const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Quaternion multiplication benchmarks
pub fn bench_zalgebra_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 0, 0);
    const quat_a = zalgebra.Quat.fromAxis(axis_vec, std.math.pi / 4.0);
    const axis_vec2 = zalgebra.Vec3.new(0, 1, 0);
    const quat_b = zalgebra.Quat.fromAxis(axis_vec2, std.math.pi / 6.0);
    
    var result = zalgebra.Quat.mul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_a = [_]f32{ 1, 0, 0, 0 };
    const quat_a = zm.quatFromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = [_]f32{ 0, 1, 0, 0 };
    const quat_b = zm.quatFromAxisAngle(axis_b, std.math.pi / 6.0);
    
    var result = zm.qmul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion normalization benchmarks
pub fn bench_zalgebra_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 1, 1);
    const quat = zalgebra.Quat.fromAxis(axis_vec, std.math.pi / 4.0);
    
    var result = zalgebra.Quat.norm(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis = [_]f32{ 1, 1, 1, 0 };
    const quat = zm.quatFromAxisAngle(axis, std.math.pi / 4.0);
    
    var result = zm.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}

// Basic quaternion operations
pub fn bench_zalgebra_quat_basic(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(0, 1, 0);
    const quat = zalgebra.Quat.fromAxis(axis_vec, std.math.pi / 4.0);
    
    var result = zalgebra.Quat.norm(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_basic(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis = [_]f32{ 0, 1, 0, 0 };
    const quat = zm.quatFromAxisAngle(axis, std.math.pi / 4.0);
    
    var result = zm.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}