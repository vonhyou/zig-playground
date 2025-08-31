const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");
const zmath_gd = @import("zmath_gd");
const bench_utils = @import("../bench_utils.zig");

// --- Matrix Multiplication ---
pub fn bench_mat_mul_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const trans_x = bench_utils.randFloat(0.8, 1.2);
    const trans_y = bench_utils.randFloat(1.8, 2.2);
    const trans_z = bench_utils.randFloat(2.8, 3.2);
    
    const mat_a = zalgebra.Mat4.identity();
    const translation_vec = zalgebra.Vec3.new(trans_x, trans_y, trans_z);
    const mat_b = zalgebra.Mat4.fromTranslate(translation_vec);
    var result = zalgebra.Mat4.mul(mat_a, mat_b);
    bench_utils.consume(zalgebra.Mat4, result);
}

pub fn bench_mat_mul_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const trans_x = bench_utils.randFloat(0.8, 1.2);
    const trans_y = bench_utils.randFloat(1.8, 2.2);
    const trans_z = bench_utils.randFloat(2.8, 3.2);
    
    const mat_a = zm.Mat4f.identity();
    const mat_b = zm.Mat4f.translation(trans_x, trans_y, trans_z);
    var result = zm.Mat4f.multiply(mat_a, mat_b);
    bench_utils.consume(zm.Mat4f, result);
}

pub fn bench_mat_mul_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const trans_x = bench_utils.randFloat(0.8, 1.2);
    const trans_y = bench_utils.randFloat(1.8, 2.2);
    const trans_z = bench_utils.randFloat(2.8, 3.2);
    
    const mat_a = zmath_gd.identity();
    const mat_b = zmath_gd.translation(trans_x, trans_y, trans_z);
    var result = zmath_gd.mul(mat_a, mat_b);
    bench_utils.consume(zmath_gd.Mat, result);
}

// --- Matrix Transpose ---
pub fn bench_mat_transpose_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const translation_vec = zalgebra.Vec3.new(1, 2, 3);
    const mat = zalgebra.Mat4.fromTranslate(translation_vec);
    var result = zalgebra.Mat4.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_mat_transpose_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zm.Mat4f.translation(1, 2, 3);
    var result = zm.Mat4f.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_mat_transpose_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zmath_gd.Mat{
        zmath_gd.f32x4(1.0, 2.0, 3.0, 4.0),
        zmath_gd.f32x4(5.0, 6.0, 7.0, 8.0),
        zmath_gd.f32x4(9.0, 10.0, 11.0, 12.0),
        zmath_gd.f32x4(13.0, 14.0, 15.0, 16.0),
    };
    var result = zmath_gd.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

// --- Matrix Chain Multiplication ---
pub fn bench_mat_chain_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat1 = zalgebra.Mat4.identity();
    const translation_vec = zalgebra.Vec3.new(1, 2, 3);
    const mat2 = zalgebra.Mat4.fromTranslate(translation_vec);
    const mat3 = zalgebra.Mat4.fromTranslate(zalgebra.Vec3.new(4, 5, 6));
    var result = zalgebra.Mat4.mul(zalgebra.Mat4.mul(mat1, mat2), mat3);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_mat_chain_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat1 = zm.Mat4f.identity();
    const mat2 = zm.Mat4f.translation(1, 2, 3);
    const mat3 = zm.Mat4f.translation(4, 5, 6);
    var result = zm.Mat4f.multiply(zm.Mat4f.multiply(mat1, mat2), mat3);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_mat_chain_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat1 = zmath_gd.rotationX(0.1);
    const mat2 = zmath_gd.rotationY(0.2);
    const mat3 = zmath_gd.rotationZ(0.3);
    const mat4 = zmath_gd.translation(1.0, 2.0, 3.0);
    var result = zmath_gd.mul(mat4, zmath_gd.mul(mat3, zmath_gd.mul(mat2, mat1)));
    std.mem.doNotOptimizeAway(&result);
}

// --- Batched Matrix Operations (SIMD-focused) ---

const BATCH_SIZE = 64; // Smaller batch for matrix ops due to memory usage

// Batched Mat4×Vec4 Transform (AoS layout)
pub fn bench_mat4_vec4_batched_aos_zalgebra(allocator: std.mem.Allocator) void {
    const mats = allocator.alloc(zalgebra.Mat4, BATCH_SIZE) catch return;
    const vecs = allocator.alloc(zalgebra.Vec4, BATCH_SIZE) catch return;
    const results = allocator.alloc(zalgebra.Vec4, BATCH_SIZE) catch return;
    defer allocator.free(mats);
    defer allocator.free(vecs);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        mats[i] = zalgebra.Mat4.fromTranslate(zalgebra.Vec3.new(fi * 0.01, fi * 0.01, fi * 0.01));
        vecs[i] = zalgebra.Vec4.new(1.0 + fi * 0.001, 2.0 + fi * 0.001, 3.0 + fi * 0.001, 1.0);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zalgebra.Mat4.mulByVec4(mats[i], vecs[i]);
    }
    
    // Consume all results to prevent DCE (Vec4 treated as 4-component vector)
    var accumulator: f32 = 0.0;
    for (results) |result| {
        accumulator += result.data[0] + result.data[1] + result.data[2] + result.data[3];
    }
    bench_utils.consume(f32, accumulator);
}

pub fn bench_mat4_vec4_batched_aos_zm(allocator: std.mem.Allocator) void {
    const mats = allocator.alloc(zm.Mat4f, BATCH_SIZE) catch return;
    const vecs = allocator.alloc(zm.Vec4f, BATCH_SIZE) catch return;
    const results = allocator.alloc(zm.Vec4f, BATCH_SIZE) catch return;
    defer allocator.free(mats);
    defer allocator.free(vecs);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        mats[i] = zm.Mat4f.translation(fi * 0.01, fi * 0.01, fi * 0.01);
        vecs[i] = zm.Vec4f{ 1.0 + fi * 0.001, 2.0 + fi * 0.001, 3.0 + fi * 0.001, 1.0 };
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = mats[i].multiplyVec4(vecs[i]);
    }
    
    // Consume all results to prevent DCE (Vec4 treated as 4-component vector)
    var accumulator: f32 = 0.0;
    for (results) |result| {
        accumulator += result[0] + result[1] + result[2] + result[3];
    }
    bench_utils.consume(f32, accumulator);
}

pub fn bench_mat4_vec4_batched_aos_zmath(allocator: std.mem.Allocator) void {
    const mats = allocator.alloc(zmath_gd.Mat, BATCH_SIZE) catch return;
    const vecs = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    const results = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    defer allocator.free(mats);
    defer allocator.free(vecs);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        mats[i] = zmath_gd.translation(fi * 0.01, fi * 0.01, fi * 0.01);
        vecs[i] = zmath_gd.f32x4(1.0 + fi * 0.001, 2.0 + fi * 0.001, 3.0 + fi * 0.001, 1.0);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zmath_gd.mul(vecs[i], mats[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

// Batched Mat4×Mat4 Multiplication
pub fn bench_mat4_mul_batched_zalgebra(allocator: std.mem.Allocator) void {
    const mats_a = allocator.alloc(zalgebra.Mat4, BATCH_SIZE) catch return;
    const mats_b = allocator.alloc(zalgebra.Mat4, BATCH_SIZE) catch return;
    const results = allocator.alloc(zalgebra.Mat4, BATCH_SIZE) catch return;
    defer allocator.free(mats_a);
    defer allocator.free(mats_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        mats_a[i] = zalgebra.Mat4.fromTranslate(zalgebra.Vec3.new(fi * 0.01, 0, 0));
        mats_b[i] = zalgebra.Mat4.fromTranslate(zalgebra.Vec3.new(0, fi * 0.01, 0));
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zalgebra.Mat4.mul(mats_a[i], mats_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_mat4_mul_batched_zm(allocator: std.mem.Allocator) void {
    const mats_a = allocator.alloc(zm.Mat4f, BATCH_SIZE) catch return;
    const mats_b = allocator.alloc(zm.Mat4f, BATCH_SIZE) catch return;
    const results = allocator.alloc(zm.Mat4f, BATCH_SIZE) catch return;
    defer allocator.free(mats_a);
    defer allocator.free(mats_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        mats_a[i] = zm.Mat4f.translation(fi * 0.01, 0, 0);
        mats_b[i] = zm.Mat4f.translation(0, fi * 0.01, 0);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zm.Mat4f.multiply(mats_a[i], mats_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_mat4_mul_batched_zmath(allocator: std.mem.Allocator) void {
    const mats_a = allocator.alloc(zmath_gd.Mat, BATCH_SIZE) catch return;
    const mats_b = allocator.alloc(zmath_gd.Mat, BATCH_SIZE) catch return;
    const results = allocator.alloc(zmath_gd.Mat, BATCH_SIZE) catch return;
    defer allocator.free(mats_a);
    defer allocator.free(mats_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        mats_a[i] = zmath_gd.translation(fi * 0.01, 0, 0);
        mats_b[i] = zmath_gd.translation(0, fi * 0.01, 0);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zmath_gd.mul(mats_a[i], mats_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}
