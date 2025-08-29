// Simple syntax validation test
const std = @import("std");

// Test that our imports work correctly
const config = @import("config.zig");
const vector = @import("benchmarks/vector.zig");  
const matrix = @import("benchmarks/matrix.zig");
const quaternion = @import("benchmarks/quaternion.zig");

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
    
    _ = vec_func;
    _ = mat_func;
    _ = quat_func;
    _ = allocator;
}