const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Quaternion multiplication benchmarks
pub fn bench_zalgebra_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(1, 0, 0), std.math.pi / 4.0);
    const quat_b = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(0, 1, 0), std.math.pi / 6.0);
    
    var result = zalgebra.Quat.mul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zm.quat.fromAxisAngle(zm.Vec{ 1, 0, 0, 0 }, std.math.pi / 4.0);
    const quat_b = zm.quat.fromAxisAngle(zm.Vec{ 0, 1, 0, 0 }, std.math.pi / 6.0);
    
    var result = zm.quat.mul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion normalization benchmarks
pub fn bench_zalgebra_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(1, 1, 1), std.math.pi / 4.0);
    
    var result = zalgebra.Quat.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zm.quat.fromAxisAngle(zm.Vec{ 1, 1, 1, 0 }, std.math.pi / 4.0);
    
    var result = zm.quat.normalize(quat);
    std.mem.doNotOptimizeAway(&result);
}

// Spherical linear interpolation (slerp) benchmarks
pub fn bench_zalgebra_quat_slerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(1, 0, 0), std.math.pi / 4.0);
    const quat_b = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(0, 1, 0), std.math.pi / 6.0);
    
    var result = zalgebra.Quat.slerp(quat_a, quat_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_slerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zm.quat.fromAxisAngle(zm.Vec{ 1, 0, 0, 0 }, std.math.pi / 4.0);
    const quat_b = zm.quat.fromAxisAngle(zm.Vec{ 0, 1, 0, 0 }, std.math.pi / 6.0);
    
    var result = zm.quat.slerp(quat_a, quat_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion to matrix conversion benchmarks
pub fn bench_zalgebra_quat_to_mat(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(1, 1, 1), std.math.pi / 4.0);
    
    var result = zalgebra.Mat4.fromQuat(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_to_mat(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zm.quat.fromAxisAngle(zm.Vec{ 1, 1, 1, 0 }, std.math.pi / 4.0);
    
    var result = zm.quatToMat(quat);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion rotation application benchmarks
pub fn bench_zalgebra_quat_rotate_vec(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(0, 1, 0), std.math.pi / 4.0);
    const vec = zalgebra.Vec3.new(1, 0, 0);
    
    var result = zalgebra.Quat.rotateVec(quat, vec);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_rotate_vec(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zm.quat.fromAxisAngle(zm.Vec{ 0, 1, 0, 0 }, std.math.pi / 4.0);
    const vec = zm.Vec{ 1, 0, 0, 0 };
    
    var result = zm.quat.rotateVec(quat, vec);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion conjugate benchmarks
pub fn bench_zalgebra_quat_conjugate(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(1, 1, 1), std.math.pi / 4.0);
    
    var result = zalgebra.Quat.conjugate(quat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_quat_conjugate(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zm.quat.fromAxisAngle(zm.Vec{ 1, 1, 1, 0 }, std.math.pi / 4.0);
    
    var result = zm.quat.conjugate(quat);
    std.mem.doNotOptimizeAway(&result);
}