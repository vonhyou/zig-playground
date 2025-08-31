const std = @import("std");
const zbench = @import("zbench");

const config = @import("config.zig");
const vector = @import("benchmarks/vector.zig");
const matrix = @import("benchmarks/matrix.zig");
const quaternion = @import("benchmarks/quaternion.zig");
const gamedev = @import("benchmarks/gamedev.zig");

const BenchmarkCategory = enum {
    vec,
    matrix,
    quat,
    gamedev,
};

const BenchmarkInfo = struct {
    name: []const u8,
    func: *const fn (std.mem.Allocator) void,
    category: BenchmarkCategory,
};

const BENCHMARKS = [_]BenchmarkInfo{
    // --- Vector Operations ---
    .{ .name = "Vector Mul: zalgebra", .func = vector.bench_vec_mul_zalgebra, .category = .vec },
    .{ .name = "Vector Mul: zm", .func = vector.bench_vec_mul_zm, .category = .vec },
    .{ .name = "Vector Mul: zmath", .func = vector.bench_vec_mul_zmath, .category = .vec },
    .{ .name = "Vector Dot: zalgebra", .func = vector.bench_vec_dot_zalgebra, .category = .vec },
    .{ .name = "Vector Dot: zm", .func = vector.bench_vec_dot_zm, .category = .vec },
    .{ .name = "Vector Dot: zmath", .func = vector.bench_vec_dot_zmath, .category = .vec },
    .{ .name = "Vector Cross: zalgebra", .func = vector.bench_vec_cross_zalgebra, .category = .vec },
    .{ .name = "Vector Cross: zm", .func = vector.bench_vec_cross_zm, .category = .vec },
    .{ .name = "Vector Cross: zmath", .func = vector.bench_vec_cross_zmath, .category = .vec },
    .{ .name = "Vec Length: zalgebra", .func = vector.bench_vec_len_zalgebra, .category = .vec },
    .{ .name = "Vec Length: zm", .func = vector.bench_vec_len_zm, .category = .vec },
    .{ .name = "Vec Length: zmath", .func = vector.bench_vec_len_zmath, .category = .vec },
    .{ .name = "Vec Norm: zalgebra", .func = vector.bench_vec_normalize_zalgebra, .category = .vec },
    .{ .name = "Vec Norm: zm", .func = vector.bench_vec_normalize_zm, .category = .vec },
    .{ .name = "Vec Norm: zmath", .func = vector.bench_vec_normalize_zmath, .category = .vec },
    .{ .name = "Vec Lerp: zalgebra", .func = vector.bench_vec_lerp_zalgebra, .category = .vec },
    .{ .name = "Vec Lerp: zm", .func = vector.bench_vec_lerp_zm, .category = .vec },
    .{ .name = "Vec Lerp: zmath", .func = vector.bench_vec_lerp_zmath, .category = .vec },
    .{ .name = "Vec Dist: zalgebra", .func = vector.bench_vec_distance_zalgebra, .category = .vec },
    .{ .name = "Vec Dist: zm", .func = vector.bench_vec_distance_zm, .category = .vec },
    .{ .name = "Vec Dist: zmath", .func = vector.bench_vec_distance_zmath, .category = .vec },

    // --- Batched Vector Operations (SIMD-focused) ---
    .{ .name = "Vec3 Dot Batch AoS: zalgebra", .func = vector.bench_vec3_dot_batched_aos_zalgebra, .category = .vec },
    .{ .name = "Vec3 Dot Batch AoS: zm", .func = vector.bench_vec3_dot_batched_aos_zm, .category = .vec },
    .{ .name = "Vec3 Dot Batch AoS: zmath", .func = vector.bench_vec3_dot_batched_aos_zmath, .category = .vec },
    .{ .name = "Vec3 Dot Batch SoA: zalgebra", .func = vector.bench_vec3_dot_batched_soa_zalgebra, .category = .vec },
    .{ .name = "Vec3 Dot Batch SoA: zm", .func = vector.bench_vec3_dot_batched_soa_zm, .category = .vec },
    .{ .name = "Vec3 Dot Batch SoA: zmath", .func = vector.bench_vec3_dot_batched_soa_zmath, .category = .vec },
    .{ .name = "Vec3 Cross Batch AoS: zalgebra", .func = vector.bench_vec3_cross_batched_aos_zalgebra, .category = .vec },
    .{ .name = "Vec3 Cross Batch AoS: zm", .func = vector.bench_vec3_cross_batched_aos_zm, .category = .vec },
    .{ .name = "Vec3 Cross Batch AoS: zmath", .func = vector.bench_vec3_cross_batched_aos_zmath, .category = .vec },
    .{ .name = "Vec3 Norm Batch AoS: zalgebra", .func = vector.bench_vec3_normalize_batched_aos_zalgebra, .category = .vec },
    .{ .name = "Vec3 Norm Batch AoS: zm", .func = vector.bench_vec3_normalize_batched_aos_zm, .category = .vec },
    .{ .name = "Vec3 Norm Batch AoS: zmath", .func = vector.bench_vec3_normalize_batched_aos_zmath, .category = .vec },
    .{ .name = "Vec3 Sum Reduction: zalgebra", .func = vector.bench_vec3_sum_reduction_zalgebra, .category = .vec },
    .{ .name = "Vec3 Sum Reduction: zm", .func = vector.bench_vec3_sum_reduction_zm, .category = .vec },
    .{ .name = "Vec3 Sum Reduction: zmath", .func = vector.bench_vec3_sum_reduction_zmath, .category = .vec },
    
    // --- Enhanced SIMD/SoA Operations (zmath native) ---
    .{ .name = "Vec3 Dot SIMD SoA Optimized: zmath", .func = vector.bench_vec3_dot_simd_soa_zmath_optimized, .category = .vec },
    .{ .name = "Vec3 Norm SIMD SoA Optimized: zmath", .func = vector.bench_vec3_normalize_simd_soa_zmath_optimized, .category = .vec },

    // --- Matrix Operations ---
    .{ .name = "Mat Mul: zalgebra", .func = matrix.bench_mat_mul_zalgebra, .category = .matrix },
    .{ .name = "Mat Mul: zm", .func = matrix.bench_mat_mul_zm, .category = .matrix },
    .{ .name = "Mat Mul: zmath", .func = matrix.bench_mat_mul_zmath, .category = .matrix },
    .{ .name = "Mat Trans: zalgebra", .func = matrix.bench_mat_transpose_zalgebra, .category = .matrix },
    .{ .name = "Mat Trans: zm", .func = matrix.bench_mat_transpose_zm, .category = .matrix },
    .{ .name = "Mat Trans: zmath", .func = matrix.bench_mat_transpose_zmath, .category = .matrix },
    .{ .name = "Mat Chain: zalgebra", .func = matrix.bench_mat_chain_zalgebra, .category = .matrix },
    .{ .name = "Mat Chain: zm", .func = matrix.bench_mat_chain_zm, .category = .matrix },
    .{ .name = "Mat Chain: zmath", .func = matrix.bench_mat_chain_zmath, .category = .matrix },

    // --- Batched Matrix Operations (SIMD-focused) ---
    .{ .name = "Mat4×Vec4 Batch AoS: zalgebra", .func = matrix.bench_mat4_vec4_batched_aos_zalgebra, .category = .matrix },
    .{ .name = "Mat4×Vec4 Batch AoS: zm", .func = matrix.bench_mat4_vec4_batched_aos_zm, .category = .matrix },
    .{ .name = "Mat4×Vec4 Batch AoS: zmath", .func = matrix.bench_mat4_vec4_batched_aos_zmath, .category = .matrix },
    .{ .name = "Mat4×Mat4 Batch: zalgebra", .func = matrix.bench_mat4_mul_batched_zalgebra, .category = .matrix },
    .{ .name = "Mat4×Mat4 Batch: zm", .func = matrix.bench_mat4_mul_batched_zm, .category = .matrix },
    .{ .name = "Mat4×Mat4 Batch: zmath", .func = matrix.bench_mat4_mul_batched_zmath, .category = .matrix },

    // --- Quaternion Operations ---
    .{ .name = "Quat Mul: zalgebra", .func = quaternion.bench_quat_mul_zalgebra, .category = .quat },
    .{ .name = "Quat Mul: zm", .func = quaternion.bench_quat_mul_zm, .category = .quat },
    .{ .name = "Quat Mul: zmath", .func = quaternion.bench_quat_mul_zmath, .category = .quat },
    .{ .name = "Quat Norm: zalgebra", .func = quaternion.bench_quat_normalize_zalgebra, .category = .quat },
    .{ .name = "Quat Norm: zm", .func = quaternion.bench_quat_normalize_zm, .category = .quat },
    .{ .name = "Quat Norm: zmath", .func = quaternion.bench_quat_normalize_zmath, .category = .quat },
    .{ .name = "Quat Slerp: zalgebra", .func = quaternion.bench_quat_slerp_zalgebra, .category = .quat },
    .{ .name = "Quat Slerp: zm", .func = quaternion.bench_quat_slerp_zm, .category = .quat },

    // --- Batched Quaternion Operations (SIMD-focused) ---
    .{ .name = "Quat Mul Batch: zalgebra", .func = quaternion.bench_quat_mul_batched_zalgebra, .category = .quat },
    .{ .name = "Quat Mul Batch: zm", .func = quaternion.bench_quat_mul_batched_zm, .category = .quat },
    .{ .name = "Quat Mul Batch: zmath", .func = quaternion.bench_quat_mul_batched_zmath, .category = .quat },
    .{ .name = "Quat Norm Batch: zalgebra", .func = quaternion.bench_quat_normalize_batched_zalgebra, .category = .quat },
    .{ .name = "Quat Norm Batch: zm", .func = quaternion.bench_quat_normalize_batched_zm, .category = .quat },
    .{ .name = "Quat Norm Batch: zmath", .func = quaternion.bench_quat_normalize_batched_zmath, .category = .quat },

    .{ .name = "Look At: zalgebra", .func = gamedev.bench_look_at_zalgebra, .category = .gamedev },
    .{ .name = "Look At: zm", .func = gamedev.bench_look_at_zm, .category = .gamedev },
    .{ .name = "Look At: zmath", .func = gamedev.bench_look_at_zmath, .category = .gamedev },
    .{ .name = "SIMD Vec Ops: zmath", .func = gamedev.bench_simd_vec_ops_zmath, .category = .gamedev },
    .{ .name = "SIMD Mat Chain: zmath", .func = gamedev.bench_simd_mat_chain_zmath, .category = .gamedev },

    // --- Memory Layout Operations (SIMD-focused) ---
    .{ .name = "AoS→SoA Vec3: zalgebra", .func = gamedev.bench_aos_to_soa_vec3_zalgebra, .category = .gamedev },
    .{ .name = "AoS→SoA Vec3: zm", .func = gamedev.bench_aos_to_soa_vec3_zm, .category = .gamedev },
    .{ .name = "AoS→SoA Vec3: zmath", .func = gamedev.bench_aos_to_soa_vec3_zmath, .category = .gamedev },
    .{ .name = "SoA→AoS Vec3: zalgebra", .func = gamedev.bench_soa_to_aos_vec3_zalgebra, .category = .gamedev },
    .{ .name = "SoA→AoS Vec3: zm", .func = gamedev.bench_soa_to_aos_vec3_zm, .category = .gamedev },
    .{ .name = "SoA→AoS Vec3: zmath", .func = gamedev.bench_soa_to_aos_vec3_zmath, .category = .gamedev },
};

fn printHelp(writer: anytype) !void {
    try writer.writeAll("Math Library Benchmark Tool\n");
    try writer.writeAll("============================\n\n");
    try writer.writeAll("Usage: zig build run -- [OPTION]\n\n");
    try writer.writeAll("Available options:\n");
    try writer.writeAll("  all      Run all benchmarks (default)\n");
    try writer.writeAll("  vec      Run vector benchmarks\n");
    try writer.writeAll("  matrix   Run matrix benchmarks\n");
    try writer.writeAll("  quat     Run quaternion benchmarks\n");
    try writer.writeAll("  gamedev  Run gamedev-specific benchmarks\n");
    try writer.writeAll("  help     Show this help message\n\n");
}

fn runBenchmarks(allocator: std.mem.Allocator, writer: anytype, category: ?BenchmarkCategory) !void {
    var bench = zbench.Benchmark.init(allocator, config.BENCHMARK_CONFIG);
    defer bench.deinit();

    for (BENCHMARKS) |benchmark_info| {
        if (category == null or benchmark_info.category == category.?) {
            try bench.add(benchmark_info.name, benchmark_info.func, .{});
        }
    }

    if (category) |cat| {
        switch (cat) {
            .vec => try writer.writeAll("\n=== Vector Operations ===\n"),
            .matrix => try writer.writeAll("\n=== Matrix Operations ===\n"),
            .quat => try writer.writeAll("\n=== Quaternion Operations ===\n"),
            .gamedev => try writer.writeAll("\n=== GameDev Operations ===\n"),
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

    var stdout = std.fs.File.stdout().writerStreaming(&.{});
    const writer = &stdout.interface;

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2 or std.mem.eql(u8, args[1], "help")) {
        try printHelp(writer);
        return;
    }

    const command = args[1];

    if (std.mem.eql(u8, command, "all")) {
        try runBenchmarks(allocator, writer, null);
    } else if (std.mem.eql(u8, command, "vec")) {
        try runBenchmarks(allocator, writer, .vec);
    } else if (std.mem.eql(u8, command, "matrix")) {
        try runBenchmarks(allocator, writer, .matrix);
    } else if (std.mem.eql(u8, command, "quat")) {
        try runBenchmarks(allocator, writer, .quat);
    } else if (std.mem.eql(u8, command, "gamedev")) {
        try runBenchmarks(allocator, writer, .gamedev);
    } else {
        try writer.print("Error: Invalid option '{s}'\n\n", .{command});
        try printHelp(writer);
        std.process.exit(1);
    }
}
