// Simple syntax validation test
const std = @import("std");

// Test that our imports work correctly
const config = @import("config.zig");
const vector = @import("benchmarks/vector.zig");  
const matrix = @import("benchmarks/matrix.zig");
const quaternion = @import("benchmarks/quaternion.zig");
const zmath_simd = @import("benchmarks/zmath_simd.zig");

test "config validation" {
    // Just check that config compiles and has expected values
    const cfg = config.BENCHMARK_CONFIG;
    try std.testing.expect(cfg.max_iterations == 500000);
    try std.testing.expect(cfg.time_budget_ns == 5_000_000_000);
    try std.testing.expect(cfg.track_allocations == true);
}

test "module imports work" {
    // Test that function pointers can be accessed (validates function existence)
    const allocator = std.testing.allocator;
    
    // These should compile if the functions exist with correct signatures
    const vec_func: *const fn (std.mem.Allocator) void = vector.bench_zalgebra_vec_mul;
    const mat_func: *const fn (std.mem.Allocator) void = matrix.bench_zalgebra_mat_mul;  
    const quat_func: *const fn (std.mem.Allocator) void = quaternion.bench_zalgebra_quat_mul;
    const zmath_simd_func: *const fn (std.mem.Allocator) void = zmath_simd.bench_zmath_simd_vec_ops;
    
    _ = vec_func;
    _ = mat_func;
    _ = quat_func;
    _ = zmath_simd_func;
    _ = allocator;
}

// Basic parity tests for zmath scalar equivalence
test "zmath vector parity tests" {
    const zmath_gd = @import("zmath_gd");
    const epsilon: f32 = 0.0001;

    // Test dot3 parity (zmath returns F32x4, take lane 0)
    const va = zmath_gd.f32x4(1.0, 2.0, 3.0, 0.0);
    const vb = zmath_gd.f32x4(4.0, 5.0, 6.0, 0.0);
    const dot_result = zmath_gd.dot3(va, vb);
    const expected_dot: f32 = 1.0*4.0 + 2.0*5.0 + 3.0*6.0; // = 32.0
    try std.testing.expectApproxEqAbs(expected_dot, dot_result[0], epsilon);

    // Test length3 parity  
    const vc = zmath_gd.f32x4(3.0, 4.0, 0.0, 0.0);
    const length_result = zmath_gd.length3(vc);
    const expected_length: f32 = 5.0; // sqrt(3*3 + 4*4) = 5
    try std.testing.expectApproxEqAbs(expected_length, length_result[0], epsilon);

    // Test cross3 result has w=0 for vector parity
    const vd = zmath_gd.f32x4(1.0, 0.0, 0.0, 0.0);
    const ve = zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0);
    const cross_result = zmath_gd.cross3(vd, ve);
    // Cross of (1,0,0) x (0,1,0) should be (0,0,1,0)
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), cross_result[0], epsilon);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), cross_result[1], epsilon);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), cross_result[2], epsilon);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), cross_result[3], epsilon);
}