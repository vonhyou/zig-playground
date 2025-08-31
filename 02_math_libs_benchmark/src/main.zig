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
    .{ .name = "VecMul:za", .func = vector.bench_vec_mul_zalgebra, .category = .vec },
    .{ .name = "VecMul:zm", .func = vector.bench_vec_mul_zm, .category = .vec },
    .{ .name = "VecMul:zmath", .func = vector.bench_vec_mul_zmath, .category = .vec },
    .{ .name = "VecDot:za", .func = vector.bench_vec_dot_zalgebra, .category = .vec },
    .{ .name = "VecDot:zm", .func = vector.bench_vec_dot_zm, .category = .vec },
    .{ .name = "VecDot:zmath", .func = vector.bench_vec_dot_zmath, .category = .vec },
    .{ .name = "VecCross:za", .func = vector.bench_vec_cross_zalgebra, .category = .vec },
    .{ .name = "VecCross:zm", .func = vector.bench_vec_cross_zm, .category = .vec },
    .{ .name = "VecCross:zmath", .func = vector.bench_vec_cross_zmath, .category = .vec },
    .{ .name = "VecLen:za", .func = vector.bench_vec_len_zalgebra, .category = .vec },
    .{ .name = "VecLen:zm", .func = vector.bench_vec_len_zm, .category = .vec },
    .{ .name = "VecLen:zmath", .func = vector.bench_vec_len_zmath, .category = .vec },
    .{ .name = "VecNorm:za", .func = vector.bench_vec_normalize_zalgebra, .category = .vec },
    .{ .name = "VecNorm:zm", .func = vector.bench_vec_normalize_zm, .category = .vec },
    .{ .name = "VecNorm:zmath", .func = vector.bench_vec_normalize_zmath, .category = .vec },
    .{ .name = "VecLerp:za", .func = vector.bench_vec_lerp_zalgebra, .category = .vec },
    .{ .name = "VecLerp:zm", .func = vector.bench_vec_lerp_zm, .category = .vec },
    .{ .name = "VecLerp:zmath", .func = vector.bench_vec_lerp_zmath, .category = .vec },
    .{ .name = "VecDist:za", .func = vector.bench_vec_distance_zalgebra, .category = .vec },
    .{ .name = "VecDist:zm", .func = vector.bench_vec_distance_zm, .category = .vec },
    .{ .name = "VecDist:zmath", .func = vector.bench_vec_distance_zmath, .category = .vec },

    // --- Batched Vector Operations (SIMD-focused) ---
    .{ .name = "V3DotBatchAoS:za", .func = vector.bench_vec3_dot_batched_aos_zalgebra, .category = .vec },
    .{ .name = "V3DotBatchAoS:zm", .func = vector.bench_vec3_dot_batched_aos_zm, .category = .vec },
    .{ .name = "V3DotBatchAoS:zmath", .func = vector.bench_vec3_dot_batched_aos_zmath, .category = .vec },
    .{ .name = "V3DotBatchSoA:za", .func = vector.bench_vec3_dot_batched_soa_zalgebra, .category = .vec },
    .{ .name = "V3DotBatchSoA:zm", .func = vector.bench_vec3_dot_batched_soa_zm, .category = .vec },
    .{ .name = "V3DotBatchSoA:zmath", .func = vector.bench_vec3_dot_batched_soa_zmath, .category = .vec },
    .{ .name = "V3CrossBatchAoS:za", .func = vector.bench_vec3_cross_batched_aos_zalgebra, .category = .vec },
    .{ .name = "V3CrossBatchAoS:zm", .func = vector.bench_vec3_cross_batched_aos_zm, .category = .vec },
    .{ .name = "V3CrossBatchAoS:zmath", .func = vector.bench_vec3_cross_batched_aos_zmath, .category = .vec },
    .{ .name = "V3NormBatchAoS:za", .func = vector.bench_vec3_normalize_batched_aos_zalgebra, .category = .vec },
    .{ .name = "V3NormBatchAoS:zm", .func = vector.bench_vec3_normalize_batched_aos_zm, .category = .vec },
    .{ .name = "V3NormBatchAoS:zmath", .func = vector.bench_vec3_normalize_batched_aos_zmath, .category = .vec },
    .{ .name = "V3SumReduction:za", .func = vector.bench_vec3_sum_reduction_zalgebra, .category = .vec },
    .{ .name = "V3SumReduction:zm", .func = vector.bench_vec3_sum_reduction_zm, .category = .vec },
    .{ .name = "V3SumReduction:zmath", .func = vector.bench_vec3_sum_reduction_zmath, .category = .vec },

    // --- Enhanced SIMD/SoA Operations (zmath native) ---
    .{ .name = "V3DotSIMDSoA:zmath", .func = vector.bench_vec3_dot_simd_soa_zmath_optimized, .category = .vec },
    .{ .name = "V3NormSIMDSoA:zmath", .func = vector.bench_vec3_normalize_simd_soa_zmath_optimized, .category = .vec },

    // --- Matrix Operations ---
    .{ .name = "MatMul:za", .func = matrix.bench_mat_mul_zalgebra, .category = .matrix },
    .{ .name = "MatMul:zm", .func = matrix.bench_mat_mul_zm, .category = .matrix },
    .{ .name = "MatMul:zmath", .func = matrix.bench_mat_mul_zmath, .category = .matrix },
    .{ .name = "MatTrans:za", .func = matrix.bench_mat_transpose_zalgebra, .category = .matrix },
    .{ .name = "MatTrans:zm", .func = matrix.bench_mat_transpose_zm, .category = .matrix },
    .{ .name = "MatTrans:zmath", .func = matrix.bench_mat_transpose_zmath, .category = .matrix },
    .{ .name = "MatChain:za", .func = matrix.bench_mat_chain_zalgebra, .category = .matrix },
    .{ .name = "MatChain:zm", .func = matrix.bench_mat_chain_zm, .category = .matrix },
    .{ .name = "MatChain:zmath", .func = matrix.bench_mat_chain_zmath, .category = .matrix },

    // --- Batched Matrix Operations (SIMD-focused) ---
    .{ .name = "M4V4BatchAoS:za", .func = matrix.bench_mat4_vec4_batched_aos_zalgebra, .category = .matrix },
    .{ .name = "M4V4BatchAoS:zm", .func = matrix.bench_mat4_vec4_batched_aos_zm, .category = .matrix },
    .{ .name = "M4V4BatchAoS:zmath", .func = matrix.bench_mat4_vec4_batched_aos_zmath, .category = .matrix },
    .{ .name = "M4M4Batch:za", .func = matrix.bench_mat4_mul_batched_zalgebra, .category = .matrix },
    .{ .name = "M4M4Batch:zm", .func = matrix.bench_mat4_mul_batched_zm, .category = .matrix },
    .{ .name = "M4M4Batch:zmath", .func = matrix.bench_mat4_mul_batched_zmath, .category = .matrix },

    // --- Quaternion Operations ---
    .{ .name = "QuatMul:za", .func = quaternion.bench_quat_mul_zalgebra, .category = .quat },
    .{ .name = "QuatMul:zm", .func = quaternion.bench_quat_mul_zm, .category = .quat },
    .{ .name = "QuatMul:zmath", .func = quaternion.bench_quat_mul_zmath, .category = .quat },
    .{ .name = "QuatNorm:za", .func = quaternion.bench_quat_normalize_zalgebra, .category = .quat },
    .{ .name = "QuatNorm:zm", .func = quaternion.bench_quat_normalize_zm, .category = .quat },
    .{ .name = "QuatNorm:zmath", .func = quaternion.bench_quat_normalize_zmath, .category = .quat },
    .{ .name = "QuatSlerp:za", .func = quaternion.bench_quat_slerp_zalgebra, .category = .quat },
    .{ .name = "QuatSlerp:zm", .func = quaternion.bench_quat_slerp_zm, .category = .quat },

    // --- Batched Quaternion Operations (SIMD-focused) ---
    .{ .name = "QuatMulBatch:za", .func = quaternion.bench_quat_mul_batched_zalgebra, .category = .quat },
    .{ .name = "QuatMulBatch:zm", .func = quaternion.bench_quat_mul_batched_zm, .category = .quat },
    .{ .name = "QuatMulBatch:zmath", .func = quaternion.bench_quat_mul_batched_zmath, .category = .quat },
    .{ .name = "QuatNormBatch:za", .func = quaternion.bench_quat_normalize_batched_zalgebra, .category = .quat },
    .{ .name = "QuatNormBatch:zm", .func = quaternion.bench_quat_normalize_batched_zm, .category = .quat },
    .{ .name = "QuatNormBatch:zmath", .func = quaternion.bench_quat_normalize_batched_zmath, .category = .quat },

    .{ .name = "LookAt:za", .func = gamedev.bench_look_at_zalgebra, .category = .gamedev },
    .{ .name = "LookAt:zm", .func = gamedev.bench_look_at_zm, .category = .gamedev },
    .{ .name = "LookAt:zmath", .func = gamedev.bench_look_at_zmath, .category = .gamedev },
    .{ .name = "SIMDVecOps:zmath", .func = gamedev.bench_simd_vec_ops_zmath, .category = .gamedev },
    .{ .name = "SIMDMatChain:zmath", .func = gamedev.bench_simd_mat_chain_zmath, .category = .gamedev },

    // --- Memory Layout Operations (SIMD-focused) ---
    .{ .name = "AoSToSoAV3:za", .func = gamedev.bench_aos_to_soa_vec3_zalgebra, .category = .gamedev },
    .{ .name = "AoSToSoAV3:zm", .func = gamedev.bench_aos_to_soa_vec3_zm, .category = .gamedev },
    .{ .name = "AoSToSoAV3:zmath", .func = gamedev.bench_aos_to_soa_vec3_zmath, .category = .gamedev },
    .{ .name = "SoAToAoSV3:za", .func = gamedev.bench_soa_to_aos_vec3_zalgebra, .category = .gamedev },
    .{ .name = "SoAToAoSV3:zm", .func = gamedev.bench_soa_to_aos_vec3_zm, .category = .gamedev },
    .{ .name = "SoAToAoSV3:zmath", .func = gamedev.bench_soa_to_aos_vec3_zmath, .category = .gamedev },
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
