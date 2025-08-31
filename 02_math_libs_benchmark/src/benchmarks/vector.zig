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

// --- Batched Vector Operations (SIMD-focused) ---

const BATCH_SIZE = 128;

// Batched Vec3 Dot Product (AoS layout)
pub fn bench_vec3_dot_batched_aos_zalgebra(allocator: std.mem.Allocator) void {
    const vecs_a = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    const vecs_b = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    defer allocator.free(vecs_a);
    defer allocator.free(vecs_b);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_a[i] = zalgebra.Vec3.new(0.1 + fi * 0.001, 0.2 + fi * 0.001, 0.3 + fi * 0.001);
        vecs_b[i] = zalgebra.Vec3.new(0.4 + fi * 0.001, 0.5 + fi * 0.001, 0.6 + fi * 0.001);
    }
    
    var sum: f32 = 0.0;
    for (0..BATCH_SIZE) |i| {
        sum += zalgebra.Vec3.dot(vecs_a[i], vecs_b[i]);
    }
    std.mem.doNotOptimizeAway(&sum);
}

pub fn bench_vec3_dot_batched_aos_zm(allocator: std.mem.Allocator) void {
    const vecs_a = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    const vecs_b = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    defer allocator.free(vecs_a);
    defer allocator.free(vecs_b);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_a[i] = zm.Vec3f{ 0.1 + fi * 0.001, 0.2 + fi * 0.001, 0.3 + fi * 0.001 };
        vecs_b[i] = zm.Vec3f{ 0.4 + fi * 0.001, 0.5 + fi * 0.001, 0.6 + fi * 0.001 };
    }
    
    var sum: f32 = 0.0;
    for (0..BATCH_SIZE) |i| {
        sum += zm.vec.dot(vecs_a[i], vecs_b[i]);
    }
    std.mem.doNotOptimizeAway(&sum);
}

pub fn bench_vec3_dot_batched_aos_zmath(allocator: std.mem.Allocator) void {
    const vecs_a = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    const vecs_b = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    defer allocator.free(vecs_a);
    defer allocator.free(vecs_b);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_a[i] = zmath_gd.f32x4(0.1 + fi * 0.001, 0.2 + fi * 0.001, 0.3 + fi * 0.001, 0.0);
        vecs_b[i] = zmath_gd.f32x4(0.4 + fi * 0.001, 0.5 + fi * 0.001, 0.6 + fi * 0.001, 0.0);
    }
    
    var sum: f32 = 0.0;
    for (0..BATCH_SIZE) |i| {
        const dot_result = zmath_gd.dot3(vecs_a[i], vecs_b[i]);
        sum += dot_result[0];
    }
    std.mem.doNotOptimizeAway(&sum);
}

// Batched Vec3 Dot Product (SoA layout)
pub fn bench_vec3_dot_batched_soa_zalgebra(allocator: std.mem.Allocator) void {
    const x_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const x_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    defer allocator.free(x_a);
    defer allocator.free(y_a);
    defer allocator.free(z_a);
    defer allocator.free(x_b);
    defer allocator.free(y_b);
    defer allocator.free(z_b);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        x_a[i] = 0.1 + fi * 0.001;
        y_a[i] = 0.2 + fi * 0.001;
        z_a[i] = 0.3 + fi * 0.001;
        x_b[i] = 0.4 + fi * 0.001;
        y_b[i] = 0.5 + fi * 0.001;
        z_b[i] = 0.6 + fi * 0.001;
    }
    
    var sum: f32 = 0.0;
    for (0..BATCH_SIZE) |i| {
        sum += x_a[i] * x_b[i] + y_a[i] * y_b[i] + z_a[i] * z_b[i];
    }
    std.mem.doNotOptimizeAway(&sum);
}

pub fn bench_vec3_dot_batched_soa_zm(allocator: std.mem.Allocator) void {
    const x_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const x_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    defer allocator.free(x_a);
    defer allocator.free(y_a);
    defer allocator.free(z_a);
    defer allocator.free(x_b);
    defer allocator.free(y_b);
    defer allocator.free(z_b);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        x_a[i] = 0.1 + fi * 0.001;
        y_a[i] = 0.2 + fi * 0.001;
        z_a[i] = 0.3 + fi * 0.001;
        x_b[i] = 0.4 + fi * 0.001;
        y_b[i] = 0.5 + fi * 0.001;
        z_b[i] = 0.6 + fi * 0.001;
    }
    
    var sum: f32 = 0.0;
    for (0..BATCH_SIZE) |i| {
        sum += x_a[i] * x_b[i] + y_a[i] * y_b[i] + z_a[i] * z_b[i];
    }
    std.mem.doNotOptimizeAway(&sum);
}

pub fn bench_vec3_dot_batched_soa_zmath(allocator: std.mem.Allocator) void {
    const x_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_a = allocator.alloc(f32, BATCH_SIZE) catch return;
    const x_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_b = allocator.alloc(f32, BATCH_SIZE) catch return;
    defer allocator.free(x_a);
    defer allocator.free(y_a);
    defer allocator.free(z_a);
    defer allocator.free(x_b);
    defer allocator.free(y_b);
    defer allocator.free(z_b);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        x_a[i] = 0.1 + fi * 0.001;
        y_a[i] = 0.2 + fi * 0.001;
        z_a[i] = 0.3 + fi * 0.001;
        x_b[i] = 0.4 + fi * 0.001;
        y_b[i] = 0.5 + fi * 0.001;
        z_b[i] = 0.6 + fi * 0.001;
    }
    
    var sum: f32 = 0.0;
    for (0..BATCH_SIZE) |i| {
        sum += x_a[i] * x_b[i] + y_a[i] * y_b[i] + z_a[i] * z_b[i];
    }
    std.mem.doNotOptimizeAway(&sum);
}

// Batched Vec3 Cross Product (AoS layout)
pub fn bench_vec3_cross_batched_aos_zalgebra(allocator: std.mem.Allocator) void {
    const vecs_a = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    const vecs_b = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    const results = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    defer allocator.free(vecs_a);
    defer allocator.free(vecs_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_a[i] = zalgebra.Vec3.new(0.1 + fi * 0.001, 0.2 + fi * 0.001, 0.3 + fi * 0.001);
        vecs_b[i] = zalgebra.Vec3.new(0.4 + fi * 0.001, 0.5 + fi * 0.001, 0.6 + fi * 0.001);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zalgebra.Vec3.cross(vecs_a[i], vecs_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_vec3_cross_batched_aos_zm(allocator: std.mem.Allocator) void {
    const vecs_a = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    const vecs_b = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    const results = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    defer allocator.free(vecs_a);
    defer allocator.free(vecs_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_a[i] = zm.Vec3f{ 0.1 + fi * 0.001, 0.2 + fi * 0.001, 0.3 + fi * 0.001 };
        vecs_b[i] = zm.Vec3f{ 0.4 + fi * 0.001, 0.5 + fi * 0.001, 0.6 + fi * 0.001 };
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zm.vec.cross(vecs_a[i], vecs_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_vec3_cross_batched_aos_zmath(allocator: std.mem.Allocator) void {
    const vecs_a = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    const vecs_b = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    const results = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    defer allocator.free(vecs_a);
    defer allocator.free(vecs_b);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_a[i] = zmath_gd.f32x4(0.1 + fi * 0.001, 0.2 + fi * 0.001, 0.3 + fi * 0.001, 0.0);
        vecs_b[i] = zmath_gd.f32x4(0.4 + fi * 0.001, 0.5 + fi * 0.001, 0.6 + fi * 0.001, 0.0);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zmath_gd.cross3(vecs_a[i], vecs_b[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

// Batched Vec3 Normalize (AoS layout)
pub fn bench_vec3_normalize_batched_aos_zalgebra(allocator: std.mem.Allocator) void {
    const vecs = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    const results = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    defer allocator.free(vecs);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs[i] = zalgebra.Vec3.new(1.0 + fi * 0.001, 2.0 + fi * 0.001, 3.0 + fi * 0.001);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zalgebra.Vec3.norm(vecs[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_vec3_normalize_batched_aos_zm(allocator: std.mem.Allocator) void {
    const vecs = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    const results = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    defer allocator.free(vecs);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs[i] = zm.Vec3f{ 1.0 + fi * 0.001, 2.0 + fi * 0.001, 3.0 + fi * 0.001 };
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zm.vec.normalize(vecs[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

pub fn bench_vec3_normalize_batched_aos_zmath(allocator: std.mem.Allocator) void {
    const vecs = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    const results = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    defer allocator.free(vecs);
    defer allocator.free(results);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs[i] = zmath_gd.f32x4(1.0 + fi * 0.001, 2.0 + fi * 0.001, 3.0 + fi * 0.001, 0.0);
    }
    
    for (0..BATCH_SIZE) |i| {
        results[i] = zmath_gd.normalize3(vecs[i]);
    }
    std.mem.doNotOptimizeAway(&results[0]);
}

// Horizontal Reduction - Sum of Vec3 array
pub fn bench_vec3_sum_reduction_zalgebra(allocator: std.mem.Allocator) void {
    const vecs = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    defer allocator.free(vecs);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs[i] = zalgebra.Vec3.new(fi * 0.001, fi * 0.001, fi * 0.001);
    }
    
    var sum = zalgebra.Vec3.new(0, 0, 0);
    for (0..BATCH_SIZE) |i| {
        sum = zalgebra.Vec3.add(sum, vecs[i]);
    }
    std.mem.doNotOptimizeAway(&sum);
}

pub fn bench_vec3_sum_reduction_zm(allocator: std.mem.Allocator) void {
    const vecs = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    defer allocator.free(vecs);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs[i] = zm.Vec3f{ fi * 0.001, fi * 0.001, fi * 0.001 };
    }
    
    var sum = zm.Vec3f{ 0, 0, 0 };
    for (0..BATCH_SIZE) |i| {
        sum = sum + vecs[i];
    }
    std.mem.doNotOptimizeAway(&sum);
}

pub fn bench_vec3_sum_reduction_zmath(allocator: std.mem.Allocator) void {
    const vecs = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    defer allocator.free(vecs);
    
    // Initialize data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs[i] = zmath_gd.f32x4(fi * 0.001, fi * 0.001, fi * 0.001, 0.0);
    }
    
    var sum = zmath_gd.f32x4(0, 0, 0, 0);
    for (0..BATCH_SIZE) |i| {
        sum = sum + vecs[i];
    }
    std.mem.doNotOptimizeAway(&sum);
}
