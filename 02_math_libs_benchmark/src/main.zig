const std = @import("std");
const zbench = @import("zbench");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// More comprehensive benchmark functions with different vector operations
fn bench_zalgebra_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    // Prevent compiler optimization by using volatile or blackbox
    var result = zalgebra.Vec3.mul(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_vec_mul(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = vec3_zm_a * vec3_zm_b;
    std.mem.doNotOptimizeAway(&result);
}

// Additional vector operations for comprehensive comparison
fn bench_zalgebra_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    var result = zalgebra.Vec3.dot(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_vec_dot(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = zm.vec.dot(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zalgebra_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    var result = zalgebra.Vec3.cross(vec3_za_a, vec3_za_b);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_vec_cross(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    var result = zm.vec.cross(vec3_zm_a, vec3_zm_b);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zalgebra_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_za = zalgebra.Vec3.new(0.2, 0.3, 0.4);

    var result = zalgebra.Vec3.norm(vec3_za);
    std.mem.doNotOptimizeAway(&result);
}

fn bench_zm_vec_len(allocator: std.mem.Allocator) void {
    _ = allocator;
    const vec3_zm = zm.Vec3{ 0.2, 0.3, 0.4 };

    var result = zm.vec.len(vec3_zm);
    std.mem.doNotOptimizeAway(&result);
}

// Benchmark with varying data to prevent optimization
fn bench_zalgebra_varying_data(allocator: std.mem.Allocator) void {
    _ = allocator;
    var i: f32 = 0.1;
    while (i < 1.0) : (i += 0.1) {
        const vec_a = zalgebra.Vec3.new(i, i + 0.1, i + 0.2);
        const vec_b = zalgebra.Vec3.new(i + 0.3, i + 0.4, i + 0.5);
        var result = zalgebra.Vec3.mul(vec_a, vec_b);
        std.mem.doNotOptimizeAway(&result);
    }
}

fn bench_zm_varying_data(allocator: std.mem.Allocator) void {
    _ = allocator;
    var i: f32 = 0.1;
    while (i < 1.0) : (i += 0.1) {
        const vec_a = zm.Vec3{ i, i + 0.1, i + 0.2 };
        const vec_b = zm.Vec3{ i + 0.3, i + 0.4, i + 0.5 };
        var result = vec_a * vec_b;
        std.mem.doNotOptimizeAway(&result);
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Use stdout directly for Zig 0.15
    var stdout = std.fs.File.stdout().writerStreaming(&.{});
    const writer = &stdout.interface;

    // Enhanced configuration with more features
    const config = zbench.Config{
        .max_iterations = 500000,
        .time_budget_ns = 5_000_000_000, // 5 seconds
        .track_allocations = true,
    };

    var bench = zbench.Benchmark.init(allocator, config);
    defer bench.deinit();

    // Group related benchmarks
    try bench.add("zalgebra vec mul", bench_zalgebra_vec_mul, .{});
    try bench.add("zm vec mul", bench_zm_vec_mul, .{});

    try bench.add("zalgebra vec dot", bench_zalgebra_vec_dot, .{});
    try bench.add("zm vec dot", bench_zm_vec_dot, .{});

    try bench.add("zalgebra vec cross", bench_zalgebra_vec_cross, .{});
    try bench.add("zm vec cross", bench_zm_vec_cross, .{});

    try bench.add("zalgebra vec len", bench_zalgebra_vec_len, .{});
    try bench.add("zm vec len", bench_zm_vec_len, .{});

    try bench.add("zalgebra varying data", bench_zalgebra_varying_data, .{});
    try bench.add("zm varying data", bench_zm_varying_data, .{});

    try writer.writeAll("\n");
    try bench.run(writer);
}

