const std = @import("std");
const zmath_gd = @import("zmath_gd");

// Vector multiplication benchmarks
pub fn bench_zmath_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);

    var result = vec3_za_a * vec3_za_b;
    std.mem.doNotOptimizeAway(&result);
}

// Vector dot product benchmarks
pub fn bench_zmath_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);

    // zmath dot3 returns F32x4 with scalar broadcast, extract lane 0 for scalar parity
    const dot_result = zmath_gd.dot3(vec3_za_a, vec3_za_b);
    var result = dot_result[0];
    std.mem.doNotOptimizeAway(&result);
}

// Vector cross product benchmarks
pub fn bench_zmath_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);

    var result = zmath_gd.cross3(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

// Vector length/magnitude benchmarks
pub fn bench_zmath_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);

    // zmath length3 returns F32x4 with scalar broadcast, extract lane 0 for scalar parity
    const length_result = zmath_gd.length3(vec3_za);
    var result = length_result[0];
    std.mem.doNotOptimizeAway(&result);
}

// Vector normalization benchmarks
pub fn bench_zmath_vec_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);

    var result = zmath_gd.normalize3(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

// Vector linear interpolation benchmarks
pub fn bench_zmath_vec_lerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);

    var result = zmath_gd.lerp(vec3_za_a, vec3_za_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}

// Vector distance benchmarks
pub fn bench_zmath_vec_distance(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zmath_gd.f32x4(0.2, 0.3, 0.4, 0.0);
    const vec3_za_b = zmath_gd.f32x4(0.4, 0.3, 0.2, 0.0);

    // Manual distance: length(b - a), using zmath operations
    const diff = vec3_za_b - vec3_za_a;
    const distance_result = zmath_gd.length3(diff);
    var result = distance_result[0]; // Extract scalar for parity
    std.mem.doNotOptimizeAway(&result);
}

// Benchmark with varying data to prevent optimization
pub fn bench_zmath_varying_data(allocator: std.mem.Allocator) void {
    _ = allocator;
    var i: f32 = 0.1;
    while (i < 1.0) : (i += 0.1) {
        const vec_a = zmath_gd.f32x4(i, i + 0.1, i + 0.2, 0.0);
        const vec_b = zmath_gd.f32x4(i + 0.3, i + 0.4, i + 0.5, 0.0);
        var result = vec_a * vec_b;
        std.mem.doNotOptimizeAway(&result);
    }
}

// Matrix multiplication benchmarks
pub fn bench_zmath_mat_mul(allocator: std.mem.Allocator) void {
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

// Matrix transpose benchmarks
pub fn bench_zmath_mat_transpose(allocator: std.mem.Allocator) void {
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

// Transform matrix benchmarks
pub fn bench_zmath_transform_matrix(allocator: std.mem.Allocator) void {
    _ = allocator;
    const translation = zmath_gd.translationV(zmath_gd.f32x4(1.0, 2.0, 3.0, 0.0));
    const rotation = zmath_gd.rotationY(0.5);
    const scale = zmath_gd.scalingV(zmath_gd.f32x4(2.0, 2.0, 2.0, 0.0));

    var result = zmath_gd.mul(scale, zmath_gd.mul(rotation, translation));
    std.mem.doNotOptimizeAway(&result);
}

// Matrix chain benchmarks
pub fn bench_zmath_matrix_chain(allocator: std.mem.Allocator) void {
    _ = allocator;
    const mat1 = zmath_gd.rotationX(0.1);
    const mat2 = zmath_gd.rotationY(0.2);
    const mat3 = zmath_gd.rotationZ(0.3);
    const mat4 = zmath_gd.translation(1.0, 2.0, 3.0);

    var result = zmath_gd.mul(mat4, zmath_gd.mul(mat3, zmath_gd.mul(mat2, mat1)));
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion multiplication benchmarks
pub fn bench_zmath_quat_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zmath_gd.f32x4(0.0, 0.0, 0.0, 1.0);
    const quat_b = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0), 0.5);

    var result = zmath_gd.qmul(quat_a, quat_b);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion normalization benchmarks
pub fn bench_zmath_quat_normalize(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat = zmath_gd.f32x4(1.0, 2.0, 3.0, 4.0);

    var result = zmath_gd.normalize4(quat);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion from axis angle benchmarks
pub fn bench_zmath_quat_from_axis_angle(allocator: std.mem.Allocator) void {
    _ = allocator;
    const axis = zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0);
    const angle: f32 = 0.5;

    var result = zmath_gd.quatFromAxisAngle(axis, angle);
    std.mem.doNotOptimizeAway(&result);
}

// Quaternion slerp benchmarks
pub fn bench_zmath_quat_slerp(allocator: std.mem.Allocator) void {
    _ = allocator;
    const quat_a = zmath_gd.f32x4(0.0, 0.0, 0.0, 1.0);
    const quat_b = zmath_gd.quatFromAxisAngle(zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0), 1.57);

    var result = zmath_gd.slerp(quat_a, quat_b, 0.5);
    std.mem.doNotOptimizeAway(&result);
}