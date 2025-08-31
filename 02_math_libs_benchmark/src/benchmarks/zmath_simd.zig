const std = @import("std");
const zmath_gd = @import("zmath_gd");

// SIMD-optimized benchmarks for zmath (used with --simd flag)
// These benchmarks demonstrate zmath's SIMD performance without scalar conversion

pub fn bench_zmath_simd_vec_ops(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    
    // Complex SIMD operation: r = dot3(a,b) * (splat(0.1) * cross3(a,b) + splat(1.0))
    const dot_result = zmath_gd.dot3(vec_a, vec_b);  // F32x4 broadcast
    const cross_result = zmath_gd.cross3(vec_a, vec_b);  // F32x4 vector
    const scale = zmath_gd.f32x4s(0.1);  // F32x4 splat
    const offset = zmath_gd.f32x4s(1.0);  // F32x4 splat
    
    var result = dot_result * (scale * cross_result + offset);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zmath_simd_mat_chain(allocator: std.mem.Allocator) void {
    _ = allocator;
    // Complex matrix chain staying in SIMD throughout
    const rot_x = zmath_gd.rotationX(0.1);
    const rot_y = zmath_gd.rotationY(0.2);
    const rot_z = zmath_gd.rotationZ(0.3);
    const trans = zmath_gd.translation(1.0, 2.0, 3.0);
    const scale = zmath_gd.scaling(2.0, 2.0, 2.0);
    
    // Chain: Scale * Rot_Z * Rot_Y * Rot_X * Translation
    const temp1 = zmath_gd.mul(rot_x, trans);
    const temp2 = zmath_gd.mul(rot_y, temp1);
    const temp3 = zmath_gd.mul(rot_z, temp2);
    var result = zmath_gd.mul(scale, temp3);
    
    std.mem.doNotOptimizeAway(&result);
}