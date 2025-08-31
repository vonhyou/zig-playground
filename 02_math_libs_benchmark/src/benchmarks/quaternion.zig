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

// Note: A slerp benchmark for zmath is intentionally omitted.
// zmath does not provide a native slerp function, and using lerp
// would result in an inaccurate and misleading performance comparison.

// --- Batched Quaternion Operations (SIMD-focused) ---

const BATCH_SIZE = 128;

// Batched Quaternion Multiplication
pub fn bench_quat_mul_batched_zalgebra(allocator: std.mem.Allocator) void {
    const quats_a = allocator.alloc(zalgebra.Quat, BATCH_SIZE) catch return;
    const quats_b = allocator.alloc(zalgebra.Quat, BATCH_SIZE) catch return;
    const results = allocator.alloc(zalgebra.Quat, BATCH_SIZE) catch return;
    defer allocator.free(quats_a);
    defer allocator.free(quats_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        const axis1 = zalgebra.Vec3.new(1, 0, 0);
        const axis2 = zalgebra.Vec3.new(0, 1, 0);
        quats_a[i] = zalgebra.Quat.fromAxis(0.1 + fi * 0.001, axis1);
        quats_b[i] = zalgebra.Quat.fromAxis(0.2 + fi * 0.001, axis2);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zalgebra.Quat.mul(quats_a[i], quats_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_quat_mul_batched_zm(allocator: std.mem.Allocator) void {
    const quats_a = allocator.alloc(zm.Quaternionf, BATCH_SIZE) catch return;
    const quats_b = allocator.alloc(zm.Quaternionf, BATCH_SIZE) catch return;
    const results = allocator.alloc(zm.Quaternionf, BATCH_SIZE) catch return;
    defer allocator.free(quats_a);
    defer allocator.free(quats_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        const axis1 = [_]f32{ 1, 0, 0 };
        const axis2 = [_]f32{ 0, 1, 0 };
        quats_a[i] = zm.Quaternionf.fromAxisAngle(axis1, 0.1 + fi * 0.001);
        quats_b[i] = zm.Quaternionf.fromAxisAngle(axis2, 0.2 + fi * 0.001);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zm.Quaternionf.multiply(quats_a[i], quats_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_quat_mul_batched_zmath(allocator: std.mem.Allocator) void {
    const quats_a = allocator.alloc(zmath_gd.Quat, BATCH_SIZE) catch return;
    const quats_b = allocator.alloc(zmath_gd.Quat, BATCH_SIZE) catch return;
    const results = allocator.alloc(zmath_gd.Quat, BATCH_SIZE) catch return;
    defer allocator.free(quats_a);
    defer allocator.free(quats_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        quats_a[i] = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(1, 0, 0, 0), 0.1 + fi * 0.001);
        quats_b[i] = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(0, 1, 0, 0), 0.2 + fi * 0.001);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zmath_gd.qmul(quats_a[i], quats_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

// Batched Quaternion Normalization
pub fn bench_quat_normalize_batched_zalgebra(allocator: std.mem.Allocator) void {
    const quats = allocator.alloc(zalgebra.Quat, BATCH_SIZE) catch return;
    const results = allocator.alloc(zalgebra.Quat, BATCH_SIZE) catch return;
    defer allocator.free(quats);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        const axis = zalgebra.Vec3.new(1, 1, 1);
        quats[i] = zalgebra.Quat.fromAxis(0.1 + fi * 0.001, axis);
        // Make it slightly non-normalized
        quats[i].w *= 1.1;
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zalgebra.Quat.norm(quats[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_quat_normalize_batched_zm(allocator: std.mem.Allocator) void {
    const quats = allocator.alloc(zm.Quaternionf, BATCH_SIZE) catch return;
    defer allocator.free(quats);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        const axis = [_]f32{ 1, 1, 1 };
        quats[i] = zm.Quaternionf.fromAxisAngle(axis, 0.1 + fi * 0.001);
        // Make it slightly non-normalized
        quats[i].w *= 1.1;
    }
    
    for (0..BATCH_SIZE) |i| {
        zm.Quaternionf.normalize(&quats[i]);
    }
    std.mem.doNotOptimizeAway(&quats[0]);
}

pub fn bench_quat_normalize_batched_zmath(allocator: std.mem.Allocator) void {
    const quats = allocator.alloc(zmath_gd.Quat, BATCH_SIZE) catch return;
    const results = allocator.alloc(zmath_gd.Quat, BATCH_SIZE) catch return;
    defer allocator.free(quats);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        quats[i] = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(1, 1, 1, 0), 0.1 + fi * 0.001);
        // Make it slightly non-normalized
        quats[i] = quats[i] * zmath_gd.f32x4s(1.1);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zmath_gd.normalize4(quats[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}
