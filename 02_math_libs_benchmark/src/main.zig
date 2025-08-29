const std = @import("std");
const zbench = @import("zbench");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

// Benchmark categories for selective execution
const BenchmarkCategory = enum {
    vec,
    // Future categories can be added here (e.g., matrix, quaternion, etc.)
};

// Benchmark function metadata
const BenchmarkInfo = struct {
    name: []const u8,
    func: *const fn (std.mem.Allocator) void,
    category: BenchmarkCategory,
};

// Vector operations benchmark functions
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

    var result = zalgebra.Vec3.length(vec3_za);
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

// All available benchmarks organized by category
const BENCHMARKS = [_]BenchmarkInfo{
    // Vector multiplication benchmarks
    .{ .name = "zalgebra vec mul", .func = bench_zalgebra_vec_mul, .category = .vec },
    .{ .name = "zm vec mul", .func = bench_zm_vec_mul, .category = .vec },
    
    // Vector dot product benchmarks  
    .{ .name = "zalgebra vec dot", .func = bench_zalgebra_vec_dot, .category = .vec },
    .{ .name = "zm vec dot", .func = bench_zm_vec_dot, .category = .vec },
    
    // Vector cross product benchmarks
    .{ .name = "zalgebra vec cross", .func = bench_zalgebra_vec_cross, .category = .vec },
    .{ .name = "zm vec cross", .func = bench_zm_vec_cross, .category = .vec },
    
    // Vector length/magnitude benchmarks
    .{ .name = "zalgebra vec len", .func = bench_zalgebra_vec_len, .category = .vec },
    .{ .name = "zm vec len", .func = bench_zm_vec_len, .category = .vec },
    
    // Vector varying data benchmarks
    .{ .name = "zalgebra varying data", .func = bench_zalgebra_varying_data, .category = .vec },
    .{ .name = "zm varying data", .func = bench_zm_varying_data, .category = .vec },
};

fn printHelp(writer: anytype) !void {
    try writer.writeAll("Math Library Benchmark Tool\n");
    try writer.writeAll("============================\n\n");
    try writer.writeAll("Usage: zig build run -- [OPTION]\n\n");
    try writer.writeAll("Available options:\n");
    try writer.writeAll("  full    Run all benchmarks\n");
    try writer.writeAll("  vec     Run only vector operations benchmarks\n");
    try writer.writeAll("  help    Show this help message\n\n");
    try writer.writeAll("If no option is provided, this help message will be displayed.\n\n");
    try writer.writeAll("Examples:\n");
    try writer.writeAll("  zig build run -- full\n");
    try writer.writeAll("  zig build run -- vec\n");
}

fn runBenchmarks(allocator: std.mem.Allocator, writer: anytype, category: ?BenchmarkCategory) !void {
    // Enhanced configuration with more features
    const config = zbench.Config{
        .max_iterations = 500000,
        .time_budget_ns = 5_000_000_000, // 5 seconds
        .track_allocations = true,
    };

    var bench = zbench.Benchmark.init(allocator, config);
    defer bench.deinit();

    // Add benchmarks based on category filter
    for (BENCHMARKS) |benchmark_info| {
        if (category == null or benchmark_info.category == category.?) {
            try bench.add(benchmark_info.name, benchmark_info.func, .{});
        }
    }

    // Print category header
    if (category) |cat| {
        switch (cat) {
            .vec => try writer.writeAll("\n=== Vector Operations Benchmarks ===\n"),
        }
    } else {
        try writer.writeAll("\n=== All Benchmarks ===\n");
    }

    try writer.writeAll("\n");
    try bench.run(writer);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Use stdout directly for Zig 0.15
    var stdout = std.fs.File.stdout().writerStreaming(&.{});
    const writer = &stdout.interface;

    // Parse command line arguments
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Skip program name, check for command
    if (args.len < 2) {
        try printHelp(writer);
        return;
    }

    const command = args[1];

    // Handle commands
    if (std.mem.eql(u8, command, "full")) {
        try runBenchmarks(allocator, writer, null);
    } else if (std.mem.eql(u8, command, "vec")) {
        try runBenchmarks(allocator, writer, .vec);
    } else if (std.mem.eql(u8, command, "help")) {
        try printHelp(writer);
    } else {
        try writer.writeAll("Error: Invalid option '");
        try writer.writeAll(command);
        try writer.writeAll("'\n\n");
        try printHelp(writer);
        std.process.exit(1);
    }
}

