const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");
const zmath_gd = @import("zmath_gd");

// --- Matrix Multiplication ---
pub fn bench_mat_mul_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zalgebra.Mat4.identity();
    const translation_vec = zalgebra.Vec3.new(1, 2, 3);
    const mat_b = zalgebra.Mat4.fromTranslate(translation_vec);
    var result = zalgebra.Mat4.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_mat_mul_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zm.Mat4f.identity();
    const mat_b = zm.Mat4f.translation(1, 2, 3);
    var result = zm.Mat4f.multiply(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_mat_mul_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zmath_gd.Mat{
        zmath_gd.f32x4(1.0, 2.0, 3.0, 4.0),
        zmath_gd.f32x4(5.0, 6.0, 7.0, 8.0),
        zmath_gd.f32x4(9.0, 10.0, 11.0, 12.0),
        zmath_gd.f32x4(13.0, 14.0, 15.0, 16.0),
    };
    const mat_b = zmath_gd.Mat{
        zmath_gd.f32x4(17.0, 18.0, 19.0, 20.0),
        zmath_gd.f32x4(21.0, 22.0, 23.0, 24.0),
        zmath_gd.f32x4(25.0, 26.0, 27.0, 28.0),
        zmath_gd.f32x4(29.0, 30.0, 31.0, 32.0),
    };
    var result = zmath_gd.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
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
