const std = @import("std");
const zalgebra = @import("zalgebra");
const zm = @import("zm");
const zmath_gd = @import("zmath_gd");
const bench_utils = @import("../bench_utils.zig");

// --- SIMD Vector Operations ---
pub fn bench_simd_vec_ops_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const x_a = bench_utils.randFloat(0.1, 0.3);
    const y_a = bench_utils.randFloat(0.2, 0.4);
    const z_a = bench_utils.randFloat(0.3, 0.5);
    const x_b = bench_utils.randFloat(0.3, 0.5);
    const y_b = bench_utils.randFloat(0.2, 0.4);
    const z_b = bench_utils.randFloat(0.1, 0.3);

    const vec_a = zmath_gd.f32x4(x_a, y_a, z_a, 0.0);
    const vec_b = zmath_gd.f32x4(x_b, y_b, z_b, 0.0);
    const dot_result = zmath_gd.dot3(vec_a, vec_b);
    const cross_result = zmath_gd.cross3(vec_a, vec_b);
    const scale_val = bench_utils.randFloat(0.05, 0.15);
    const offset_val = bench_utils.randFloat(0.8, 1.2);
    const scale = zmath_gd.f32x4s(scale_val);
    const offset = zmath_gd.f32x4s(offset_val);
    const result = dot_result * (scale * cross_result + offset);
    bench_utils.consume(zmath_gd.Vec, result);
}

// --- SIMD Matrix Chain ---
pub fn bench_simd_mat_chain_zmath(allocator: std.mem.Allocator) void {
    _ = allocator;
    const angle_x = bench_utils.randFloat(0.05, 0.15);
    const angle_y = bench_utils.randFloat(0.15, 0.25);
    const angle_z = bench_utils.randFloat(0.25, 0.35);
    const trans_x = bench_utils.randFloat(0.8, 1.2);
    const trans_y = bench_utils.randFloat(1.8, 2.2);
    const trans_z = bench_utils.randFloat(2.8, 3.2);
    const scale_val = bench_utils.randFloat(1.8, 2.2);

    const rot_x = zmath_gd.rotationX(angle_x);
    const rot_y = zmath_gd.rotationY(angle_y);
    const rot_z = zmath_gd.rotationZ(angle_z);
    const trans = zmath_gd.translation(trans_x, trans_y, trans_z);
    const scale = zmath_gd.scaling(scale_val, scale_val, scale_val);
    const temp1 = zmath_gd.mul(rot_x, trans);
    const temp2 = zmath_gd.mul(rot_y, temp1);
    const temp3 = zmath_gd.mul(rot_z, temp2);
    const result = zmath_gd.mul(scale, temp3);
    bench_utils.consume(zmath_gd.Mat, result);
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

// --- Memory Layout Operations (SIMD-focused) ---

const BATCH_SIZE = 256;

// AoS to SoA conversion (interleave/deinterleave)
pub fn bench_aos_to_soa_vec3_zalgebra(allocator: std.mem.Allocator) void {
    const vecs_aos = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    const x_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    defer allocator.free(vecs_aos);
    defer allocator.free(x_soa);
    defer allocator.free(y_soa);
    defer allocator.free(z_soa);

    // Initialize AoS data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_aos[i] = zalgebra.Vec3.new(fi * 0.001, fi * 0.002, fi * 0.003);
    }

    // Convert AoS to SoA
    for (0..BATCH_SIZE) |i| {
        x_soa[i] = vecs_aos[i].data[0];
        y_soa[i] = vecs_aos[i].data[1];
        z_soa[i] = vecs_aos[i].data[2];
    }
    std.mem.doNotOptimizeAway(&x_soa[0]);
    std.mem.doNotOptimizeAway(&y_soa[0]);
    std.mem.doNotOptimizeAway(&z_soa[0]);
}

pub fn bench_aos_to_soa_vec3_zm(allocator: std.mem.Allocator) void {
    const vecs_aos = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    const x_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    defer allocator.free(vecs_aos);
    defer allocator.free(x_soa);
    defer allocator.free(y_soa);
    defer allocator.free(z_soa);

    // Initialize AoS data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_aos[i] = zm.Vec3f{ fi * 0.001, fi * 0.002, fi * 0.003 };
    }

    // Convert AoS to SoA
    for (0..BATCH_SIZE) |i| {
        x_soa[i] = vecs_aos[i][0];
        y_soa[i] = vecs_aos[i][1];
        z_soa[i] = vecs_aos[i][2];
    }
    std.mem.doNotOptimizeAway(&x_soa[0]);
    std.mem.doNotOptimizeAway(&y_soa[0]);
    std.mem.doNotOptimizeAway(&z_soa[0]);
}

pub fn bench_aos_to_soa_vec3_zmath(allocator: std.mem.Allocator) void {
    const vecs_aos = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    const x_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    defer allocator.free(vecs_aos);
    defer allocator.free(x_soa);
    defer allocator.free(y_soa);
    defer allocator.free(z_soa);

    // Initialize AoS data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        vecs_aos[i] = zmath_gd.f32x4(fi * 0.001, fi * 0.002, fi * 0.003, 0.0);
    }

    // Convert AoS to SoA
    for (0..BATCH_SIZE) |i| {
        x_soa[i] = vecs_aos[i][0];
        y_soa[i] = vecs_aos[i][1];
        z_soa[i] = vecs_aos[i][2];
    }
    std.mem.doNotOptimizeAway(&x_soa[0]);
    std.mem.doNotOptimizeAway(&y_soa[0]);
    std.mem.doNotOptimizeAway(&z_soa[0]);
}

// SoA to AoS conversion
pub fn bench_soa_to_aos_vec3_zalgebra(allocator: std.mem.Allocator) void {
    const x_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const vecs_aos = allocator.alloc(zalgebra.Vec3, BATCH_SIZE) catch return;
    defer allocator.free(x_soa);
    defer allocator.free(y_soa);
    defer allocator.free(z_soa);
    defer allocator.free(vecs_aos);

    // Initialize SoA data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        x_soa[i] = fi * 0.001;
        y_soa[i] = fi * 0.002;
        z_soa[i] = fi * 0.003;
    }

    // Convert SoA to AoS
    for (0..BATCH_SIZE) |i| {
        vecs_aos[i] = zalgebra.Vec3.new(x_soa[i], y_soa[i], z_soa[i]);
    }
    std.mem.doNotOptimizeAway(&vecs_aos[0]);
}

pub fn bench_soa_to_aos_vec3_zm(allocator: std.mem.Allocator) void {
    const x_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const vecs_aos = allocator.alloc(zm.Vec3f, BATCH_SIZE) catch return;
    defer allocator.free(x_soa);
    defer allocator.free(y_soa);
    defer allocator.free(z_soa);
    defer allocator.free(vecs_aos);

    // Initialize SoA data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        x_soa[i] = fi * 0.001;
        y_soa[i] = fi * 0.002;
        z_soa[i] = fi * 0.003;
    }

    // Convert SoA to AoS
    for (0..BATCH_SIZE) |i| {
        vecs_aos[i] = zm.Vec3f{ x_soa[i], y_soa[i], z_soa[i] };
    }
    std.mem.doNotOptimizeAway(&vecs_aos[0]);
}

pub fn bench_soa_to_aos_vec3_zmath(allocator: std.mem.Allocator) void {
    const x_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const y_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const z_soa = allocator.alloc(f32, BATCH_SIZE) catch return;
    const vecs_aos = allocator.alloc(zmath_gd.Vec, BATCH_SIZE) catch return;
    defer allocator.free(x_soa);
    defer allocator.free(y_soa);
    defer allocator.free(z_soa);
    defer allocator.free(vecs_aos);

    // Initialize SoA data
    for (0..BATCH_SIZE) |i| {
        const fi = @as(f32, @floatFromInt(i));
        x_soa[i] = fi * 0.001;
        y_soa[i] = fi * 0.002;
        z_soa[i] = fi * 0.003;
    }

    // Convert SoA to AoS
    for (0..BATCH_SIZE) |i| {
        vecs_aos[i] = zmath_gd.f32x4(x_soa[i], y_soa[i], z_soa[i], 0.0);
    }
    std.mem.doNotOptimizeAway(&vecs_aos[0]);
}
