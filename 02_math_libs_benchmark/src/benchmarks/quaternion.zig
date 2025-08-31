const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");
const zmath_gd = @import("zmath_gd");

// --- Quaternion Multiplication ---
pub fn bench_quat_mul_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 0, 0);
    const quat_a = zalgebra.Quat.fromAxis(std.math.pi / 4.0, axis_vec);
    const axis_vec2 = zalgebra.Vec3.new(0, 1, 0);
    const quat_b = zalgebra.Quat.fromAxis(std.math.pi / 6.0, axis_vec2);
    var result = zalgebra.Quat.mul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_quat_mul_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_a = [_]f32{ 1, 0, 0 };
    const quat_a = zm.Quaternionf.fromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = [_]f32{ 0, 1, 0 };
    const quat_b = zm.Quaternionf.fromAxisAngle(axis_b, std.math.pi / 6.0);
    var result = zm.Quaternionf.multiply(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_quat_mul_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zmath_gd.f32x4(0.0, 0.0, 0.0, 1.0);
    const quat_b = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0), 0.5);
    var result = zmath_gd.qmul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

// --- Quaternion Normalization ---
pub fn bench_quat_normalize_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 1, 1);
    const quat = zalgebra.Quat.fromAxis(std.math.pi / 4.0, axis_vec);
    var result = zalgebra.Quat.norm(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_quat_normalize_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis = [_]f32{ 1, 1, 1 };
    var quat = zm.Quaternionf.fromAxisAngle(axis, std.math.pi / 4.0);
    zm.Quaternionf.normalize(&quat);
    std.mem.doNotOptimizeAway(&quat);
}

pub fn bench_quat_normalize_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zmath_gd.f32x4(1.0, 2.0, 3.0, 4.0);
    var result = zmath_gd.normalize4(quat);
    std.mem.doNotOptimizeAway(&result);
}

// --- Quaternion Slerp ---
pub fn bench_quat_slerp_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 0, 0);
    const quat_a = zalgebra.Quat.fromAxis(std.math.pi / 4.0, axis_vec);
    const axis_vec2 = zalgebra.Vec3.new(0, 1, 0);
    const quat_b = zalgebra.Quat.fromAxis(std.math.pi / 6.0, axis_vec2);
    var result = zalgebra.Quat.slerp(quat_a, quat_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_quat_slerp_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_a = [_]f32{ 1, 0, 0 };
    const quat_a = zm.Quaternionf.fromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = [_]f32{ 0, 1, 0 };
    const quat_b = zm.Quaternionf.fromAxisAngle(axis_b, std.math.pi / 6.0);
    var result = zm.Quaternionf.slerp(quat_a, quat_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_quat_slerp_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(1.0, 0.0, 0.0, 0.0), std.math.pi / 4.0);
    const quat_b = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0), std.math.pi / 6.0);
    // zmath does not have a direct slerp, this is a placeholder
    var result = zmath_gd.lerp(quat_a, quat_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}
