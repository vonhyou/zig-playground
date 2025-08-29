const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Quaternion multiplication benchmarks
pub fn bench_zalgebra_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 0, 0);
    const quat_a = zalgebra.Quat.fromAxis(std.math.pi / 4.0, axis_vec);
    const axis_vec2 = zalgebra.Vec3.new(0, 1, 0);
    const quat_b = zalgebra.Quat.fromAxis(std.math.pi / 6.0, axis_vec2);

    var result = zalgebra.Quat.mul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_a = [_]f32{ 1, 0, 0 };
    const quat_a = zm.Quaternionf.fromAxisAngle(axis_a, std.math.pi / 4.0);
    const axis_b = [_]f32{ 0, 1, 0 };
    const quat_b = zm.Quaternionf.fromAxisAngle(axis_b, std.math.pi / 6.0);

    var result = zm.Quaternionf.multiply(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion normalization benchmarks
pub fn bench_zalgebra_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis_vec = zalgebra.Vec3.new(1, 1, 1);
    const quat = zalgebra.Quat.fromAxis(std.math.pi / 4.0, axis_vec);

    var result = zalgebra.Quat.norm(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis = [_]f32{ 1, 1, 1 };
    var quat = zm.Quaternionf.fromAxisAngle(axis, std.math.pi / 4.0);

    zm.Quaternionf.normalize(&quat);
    std.mem.doNotOptimizeAway(&quat);
}

