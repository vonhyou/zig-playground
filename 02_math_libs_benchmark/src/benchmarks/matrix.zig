const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Matrix4x4 multiplication benchmarks
pub fn bench_zalgebra_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zalgebra.Mat4.identity();
    const mat_b = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    
    var result = zalgebra.Mat4.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_mat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat_a = zm.Mat.identity();
    const mat_b = zm.Mat.translation(1, 2, 3);
    
    var result = zm.mul(mat_a, mat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Matrix inverse benchmarks
pub fn bench_zalgebra_mat_inverse(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    
    var result = zalgebra.Mat4.inverse(mat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_mat_inverse(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zm.Mat.translation(1, 2, 3);
    
    var result = zm.inverse(mat);
    std.mem.doNotOptimizeAway(&result);
}

// Matrix transpose benchmarks
pub fn bench_zalgebra_mat_transpose(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    
    var result = zalgebra.Mat4.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_mat_transpose(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat = zm.Mat.translation(1, 2, 3);
    
    var result = zm.transpose(mat);
    std.mem.doNotOptimizeAway(&result);
}

// Transform matrix creation benchmarks
pub fn bench_zalgebra_transform_matrix(allocator: std.mem.Allocator) void {
    _ = allocator;
    const translation = zalgebra.Vec3.new(1, 2, 3);
    const rotation = zalgebra.Quat.fromAxis(zalgebra.Vec3.new(0, 1, 0), std.math.pi / 4.0);
    const scale = zalgebra.Vec3.new(2, 2, 2);
    
    var result = zalgebra.Mat4.fromTransformComponents(translation, rotation, scale);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_transform_matrix(allocator: std.mem.Allocator) void {
    _ = allocator;
    const translation = zm.Vec{ 1, 2, 3, 0 };
    const rotation = zm.quat.fromAxisAngle(zm.Vec{ 0, 1, 0, 0 }, std.math.pi / 4.0);
    const scale = zm.Vec{ 2, 2, 2, 0 };
    
    var result = zm.scaling(scale[0], scale[1], scale[2]);
    result = zm.mul(result, zm.quatToMat(rotation));
    result = zm.mul(result, zm.translation(translation[0], translation[1], translation[2]));
    std.mem.doNotOptimizeAway(&result);
}

// World-View-Projection matrix chain benchmarks
pub fn bench_zalgebra_mvp_chain(allocator: std.mem.Allocator) void {
    _ = allocator;
    const model = zalgebra.Mat4.fromTranslation(zalgebra.Vec3.new(1, 2, 3));
    const view = zalgebra.Mat4.lookAt(zalgebra.Vec3.new(0, 0, 5), zalgebra.Vec3.new(0, 0, 0), zalgebra.Vec3.new(0, 1, 0));
    const projection = zalgebra.Mat4.perspective(std.math.pi / 4.0, 16.0 / 9.0, 0.1, 100.0);
    
    var mvp = zalgebra.Mat4.mul(projection, view);
    mvp = zalgebra.Mat4.mul(mvp, model);
    std.mem.doNotOptimizeAway(&mvp);
}

pub fn bench_zm_mvp_chain(allocator: std.mem.Allocator) void {
    _ = allocator;
    const model = zm.translation(1, 2, 3);
    const view = zm.lookAt(zm.Vec{ 0, 0, 5, 1 }, zm.Vec{ 0, 0, 0, 1 }, zm.Vec{ 0, 1, 0, 0 });
    const projection = zm.perspectiveFovLh(std.math.pi / 4.0, 16.0 / 9.0, 0.1, 100.0);
    
    var mvp = zm.mul(projection, view);
    mvp = zm.mul(mvp, model);
    std.mem.doNotOptimizeAway(&mvp);
}