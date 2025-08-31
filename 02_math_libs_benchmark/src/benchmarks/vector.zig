const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");
const zmath_gd = @import("zmath_gd");

// --- Vector Multiplication ---
pub fn bench_vec_mul_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);
    var result = zalgebra.Vec3.mul(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_mul_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3f{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3f{ 0.4, 0.3, 0.2 };
    var result = vec3_zm_a * vec3_zm_b;
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_mul_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    var result = vec3_za_a * vec3_za_b;
    std.mem.doNotOptimizeAway(&result);
}

// --- Vector Dot Product ---
pub fn bench_vec_dot_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);
    var result = zalgebra.Vec3.dot(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_dot_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3f{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3f{ 0.4, 0.3, 0.2 };
    var result = zm.vec.dot(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_dot_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    const dot_result = zmath_gd.dot3(vec3_za_a, vec3_za_b);
    var result = dot_result[0];
    std.mem.doNotOptimizeAway(&result);
}

// --- Vector Cross Product ---
pub fn bench_vec_cross_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);
    var result = zalgebra.Vec3.cross(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_cross_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3f{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3f{ 0.4, 0.3, 0.2 };
    var result = zm.vec.cross(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_cross_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    var result = zmath_gd.cross3(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

// --- Vector Length ---
pub fn bench_vec_len_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    var result = zalgebra.Vec3.length(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_len_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm = zm.Vec3f{ 0.2, 0.3, 0.4 };
    var result = zm.vec.len(vec3_zm);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_len_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const length_result = zmath_gd.length3(vec3_za);
    var result = length_result[0];
    std.mem.doNotOptimizeAway(&result);
}

// --- Vector Normalization ---
pub fn bench_vec_normalize_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    var result = zalgebra.Vec3.norm(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_normalize_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm = zm.Vec3f{ 0.2, 0.3, 0.4 };
    var result = zm.vec.normalize(vec3_zm);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_normalize_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    var result = zmath_gd.normalize3(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

// --- Vector Linear Interpolation ---
pub fn bench_vec_lerp_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);
    const diff = zalgebra.Vec3.sub(vec3_za_b, vec3_za_a);
    const scaled = zalgebra.Vec3.scale(diff, 0.5);
    var result = zalgebra.Vec3.add(vec3_za_a, scaled);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_lerp_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3f{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3f{ 0.4, 0.3, 0.2 };
    var result = zm.vec.lerp(vec3_zm_a, vec3_zm_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_lerp_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    var result = zmath_gd.lerp(vec3_za_a, vec3_za_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

// --- Vector Distance ---
pub fn bench_vec_distance_zalgebra(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);
    const diff = zalgebra.Vec3.sub(vec3_za_b, vec3_za_a);
    var result = zalgebra.Vec3.length(diff);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_distance_zm(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3f{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3f{ 0.4, 0.3, 0.2 };
    var result = zm.vec.distance(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_vec_distance_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);
    const diff = vec3_za_b - vec3_za_a;
    const distance_result = zmath_gd.length3(diff);
    var result = distance_result[0];
    std.mem.doNotOptimizeAway(&result);
}
