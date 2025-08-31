const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");
const zmath_gd = @import("zmath_gd");

// --- SIMD Vector Operations ---
pub fn bench_simd_vec_ops_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    const dot_result = zmath_gd.dot3(vec_a, vec_b);
    const cross_result = zmath_gd.cross3(vec_a, vec_b);
    const scale = zmath_gd.f32x4s(0.1);
    const offset = zmath_gd.f32x4s(1.0);
    var result = dot_result * (scale * cross_result + offset);
    std.mem.doNotOptimizeAway(&result);
}

// --- SIMD Matrix Chain ---
pub fn bench_simd_mat_chain_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const rot_x = zmath_gd.rotationX(0.1);
    const rot_y = zmath_gd.rotationY(0.2);
    const rot_z = zmath_gd.rotationZ(0.3);
    const trans = zmath_gd.translation(1.0, 2.0, 3.0);
    const scale = zmath_gd.scaling(2.0, 2.0, 2.0);
    const temp1 = zmath_gd.mul(rot_x, trans);
    const temp2 = zmath_gd.mul(rot_y, temp1);
    const temp3 = zmath_gd.mul(rot_z, temp2);
    var result = zmath_gd.mul(scale, temp3);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_look_at_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const eye = zalgebra.Vec3.new(1, 2, 3);
    _ = eye;
    const target = zalgebra.Vec3.new(0, 0, 0);
    _ = target;
    const up = zalgebra.Vec3.new(0, 1, 0);
    _ = up;
    // TODO: zalgebra does not have a direct lookAt equivalent.
    // This is a placeholder for a custom implementation.
    var result = zalgebra.Mat4.identity(); // Placeholder
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_look_at_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const eye = zm.Vec3f{ 1, 2, 3 };
    const target = zm.Vec3f{ 0, 0, 0 };
    const up = zm.Vec3f{ 0, 1, 0 };
    var result = zm.Mat4f.lookAt(eye, target, up);
    std.mem.doNotOptimizeAway(&result);
}

// --- Look At ---
pub fn bench_look_at_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const eye = zmath_gd.f32x4(1.0, 2.0, 3.0, 0.0);
    const target = zmath_gd.f32x4(0.0, 0.0, 0.0, 0.0);
    const up = zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0);
    var result = zmath_gd.lookAtRh(eye, target, up);
    std.mem.doNotOptimizeAway(&result);
}
