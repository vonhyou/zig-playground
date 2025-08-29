const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Vector multiplication benchmarks
pub fn bench_zalgebra_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    var result = zalgebra.Vec3.mul(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = vec3_zm_a * vec3_zm_b;
    std.mem.doNotOptimizeAway(&result);
}

// Vector dot product benchmarks
pub fn bench_zalgebra_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    var result = zalgebra.Vec3.dot(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = zm.vec.dot(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector cross product benchmarks
pub fn bench_zalgebra_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    var result = zalgebra.Vec3.cross(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = zm.vec.cross(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector length/magnitude benchmarks
pub fn bench_zalgebra_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zalgebra.Vec3.new(0.2, 0.3, 0.4);

    var result = zalgebra.Vec3.length(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm = zm.Vec3{ 0.2, 0.3, 0.4 };

    var result = zm.vec.len(vec3_zm);
    std.mem.doNotOptimizeAway(&result);
}

// Vector normalization benchmarks  
pub fn bench_zalgebra_vec_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zalgebra.Vec3.new(0.2, 0.3, 0.4);

    var result = zalgebra.Vec3.norm(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm = zm.Vec3{ 0.2, 0.3, 0.4 };

    var result = zm.vec.normalize(vec3_zm);
    std.mem.doNotOptimizeAway(&result);
}

// Vector linear interpolation benchmarks
pub fn bench_zalgebra_vec_lerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);
    
    // Manual lerp implementation: a + (b - a) * t
    const diff = zalgebra.Vec3.sub(vec3_za_b, vec3_za_a);
    const scaled = zalgebra.Vec3.scale(diff, 0.5);
    var result = zalgebra.Vec3.add(vec3_za_a, scaled);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_lerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = zm.vec.lerp(vec3_zm_a, vec3_zm_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

// Vector distance benchmarks
pub fn bench_zalgebra_vec_distance(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    // Manual distance: length(b - a)
    const diff = zalgebra.Vec3.sub(vec3_za_b, vec3_za_a);
    var result = zalgebra.Vec3.length(diff);
    std.mem.doNotOptimizeAway(&result);
}

pub fn bench_zm_vec_distance(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = zm.vec.distance(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

// Benchmark with varying data to prevent optimization
pub fn bench_zalgebra_varying_data(allocator: std.mem.Allocator) void {
    _ = allocator;
    var i: f32 = 0.1;
    while (i < 1.0) : (i += 0.1) {
        const vec_a = zalgebra.Vec3.new(i, i + 0.1, i + 0.2);
        const vec_b = zalgebra.Vec3.new(i + 0.3, i + 0.4, i + 0.5);
        var result = zalgebra.Vec3.mul(vec_a, vec_b);
        std.mem.doNotOptimizeAway(&result);
    }
}

pub fn bench_zm_varying_data(allocator: std.mem.Allocator) void {
    _ = allocator;
    var i: f32 = 0.1;
    while (i < 1.0) : (i += 0.1) {
        const vec_a = zm.Vec3{ i, i + 0.1, i + 0.2 };
        const vec_b = zm.Vec3{ i + 0.3, i + 0.4, i + 0.5 };
        var result = vec_a * vec_b;
        std.mem.doNotOptimizeAway(&result);
    }
}