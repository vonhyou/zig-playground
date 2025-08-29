const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Matrix4x4 multiplication benchmarks
pub fn bench_zalgebra_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zalgebra.Mat4.identity();
    const translation_vec = zalgebra.Vec3.new(1, 2, 3);
    const mat_b = zalgebra.Mat4.fromTranslation(translation_vec);
    
    var result = zalgebra.Mat4.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zm.identity();
    const mat_b = zm.translation(1, 2, 3);
    
    var result = zm.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Matrix transpose benchmarks
pub fn bench_zalgebra_mat_transpose(allocator: std.mem.Allocator) void {
    _ = allocator;
    const translation_vec = zalgebra.Vec3.new(1, 2, 3);
    const mat = zalgebra.Mat4.fromTranslation(translation_vec);
    
    var result = zalgebra.Mat4.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_mat_transpose(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zm.translation(1, 2, 3);
    
    var result = zm.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

// Matrix transformation benchmarks  
pub fn bench_zalgebra_transform_matrix(allocator: std.mem.Allocator) void {
    _ = allocator;
    const translation = zalgebra.Vec3.new(1, 2, 3);
    
    var result = zalgebra.Mat4.fromTranslation(translation);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_transform_matrix(allocator: std.mem.Allocator) void {
    _ = allocator;
    
    var result = zm.translation(1, 2, 3);
    std.mem.doNotOptimizeAway(&result);
}

// Simple matrix chain benchmarks
pub fn bench_zalgebra_matrix_chain(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat1 = zalgebra.Mat4.identity();
    const translation_vec = zalgebra.Vec3.new(1, 2, 3);
    const mat2 = zalgebra.Mat4.fromTranslation(translation_vec);
    const mat3 = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(4, 5, 6));
    
    var temp = zalgebra.Mat4.mul(mat1, mat2);
    var result = zalgebra.Mat4.mul(temp, mat3);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_matrix_chain(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat1 = zm.identity();
    const mat2 = zm.translation(1, 2, 3);
    const mat3 = zm.translation(4, 5, 6);
    
    var temp = zm.mul(mat1, mat2);
    var result = zm.mul(temp, mat3);
    std.mem.doNotOptimizeAway(&result);
}