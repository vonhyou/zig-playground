const std = @import("std");
const zbench = @import("zbench");

const config = @import("config.zig");
const vector = @import("benchmarks/vector.zig");
const matrix = @import("benchmarks/matrix.zig");
const quaternion = @import("benchmarks/quaternion.zig");

const BenchmarkCategory = enum {
    vec,
    matrix,
    quat,
};

const BenchmarkInfo = struct {
    name: []const u8,
    func: *const fn (std.mem.Allocator) void,
    category: BenchmarkCategory,
};

const BENCHMARKS = [_]BenchmarkInfo{
    // Vector operations
    .{ .name = "zalgebra vec mul", .func = vector.bench_zalgebra_vec_mul, .category = .vec },
    .{ .name = "zm vec mul", .func = vector.bench_zm_vec_mul, .category = .vec },
    .{ .name = "zalgebra vec dot", .func = vector.bench_zalgebra_vec_dot, .category = .vec },
    .{ .name = "zm vec dot", .func = vector.bench_zm_vec_dot, .category = .vec },
    .{ .name = "zalgebra vec cross", .func = vector.bench_zalgebra_vec_cross, .category = .vec },
    .{ .name = "zm vec cross", .func = vector.bench_zm_vec_cross, .category = .vec },
    .{ .name = "zalgebra vec len", .func = vector.bench_zalgebra_vec_len, .category = .vec },
    .{ .name = "zm vec len", .func = vector.bench_zm_vec_len, .category = .vec },
    .{ .name = "zalgebra vec normalize", .func = vector.bench_zalgebra_vec_normalize, .category = .vec },
    .{ .name = "zm vec normalize", .func = vector.bench_zm_vec_normalize, .category = .vec },
    .{ .name = "zalgebra vec lerp", .func = vector.bench_zalgebra_vec_lerp, .category = .vec },
    .{ .name = "zm vec lerp", .func = vector.bench_zm_vec_lerp, .category = .vec },
    .{ .name = "zalgebra vec distance", .func = vector.bench_zalgebra_vec_distance, .category = .vec },
    .{ .name = "zm vec distance", .func = vector.bench_zm_vec_distance, .category = .vec },
    .{ .name = "zalgebra varying data", .func = vector.bench_zalgebra_varying_data, .category = .vec },
    .{ .name = "zm varying data", .func = vector.bench_zm_varying_data, .category = .vec },

    // Matrix operations
    .{ .name = "zalgebra mat mul", .func = matrix.bench_zalgebra_mat_mul, .category = .matrix },
    .{ .name = "zm mat mul", .func = matrix.bench_zm_mat_mul, .category = .matrix },
    .{ .name = "zalgebra mat transpose", .func = matrix.bench_zalgebra_mat_transpose, .category = .matrix },
    .{ .name = "zm mat transpose", .func = matrix.bench_zm_mat_transpose, .category = .matrix },
    .{ .name = "zalgebra transform matrix", .func = matrix.bench_zalgebra_transform_matrix, .category = .matrix },
    .{ .name = "zm transform matrix", .func = matrix.bench_zm_transform_matrix, .category = .matrix },
    .{ .name = "zalgebra matrix chain", .func = matrix.bench_zalgebra_matrix_chain, .category = .matrix },
    .{ .name = "zm matrix chain", .func = matrix.bench_zm_matrix_chain, .category = .matrix },

    // Quaternion operations
    .{ .name = "zalgebra quat mul", .func = quaternion.bench_zalgebra_quat_mul, .category = .quat },
    .{ .name = "zm quat mul", .func = quaternion.bench_zm_quat_mul, .category = .quat },
    .{ .name = "zalgebra quat normalize", .func = quaternion.bench_zalgebra_quat_normalize, .category = .quat },
    .{ .name = "zm quat normalize", .func = quaternion.bench_zm_quat_normalize, .category = .quat },
    .{ .name = "zalgebra quat basic", .func = quaternion.bench_zalgebra_quat_basic, .category = .quat },
    .{ .name = "zm quat basic", .func = quaternion.bench_zm_quat_basic, .category = .quat },
};

fn printHelp(writer: anytype) !void {
    try writer.writeAll("Math Library Benchmark Tool\n");
    try writer.writeAll("============================\n\n");
    try writer.writeAll("Usage: zig build run -- [OPTION]\n\n");
    try writer.writeAll("Available options:\n");
    try writer.writeAll("  full    Run all benchmarks\n");
    try writer.writeAll("  vec     Run only vector operations benchmarks\n");
    try writer.writeAll("  matrix  Run only matrix operations benchmarks\n");
    try writer.writeAll("  quat    Run only quaternion operations benchmarks\n");
    try writer.writeAll("  help    Show this help message\n\n");
    try writer.writeAll("If no option is provided, this help message will be displayed.\n\n");
    try writer.writeAll("Examples:\n");
    try writer.writeAll("  zig build run -- full\n");
    try writer.writeAll("  zig build run -- vec\n");
    try writer.writeAll("  zig build run -- matrix\n");
    try writer.writeAll("  zig build run -- quat\n");
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
            .vec => try writer.writeAll("\n=== Vector Operations Benchmarks ===\n"),
            .matrix => try writer.writeAll("\n=== Matrix Operations Benchmarks ===\n"),
            .quat => try writer.writeAll("\n=== Quaternion Operations Benchmarks ===\n"),
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

    if (args.len < 2) {
        try printHelp(writer);
        return;
    }

    const command = args[1];

    if (std.mem.eql(u8, command, "full")) {
        try runBenchmarks(allocator, writer, null);
    } else if (std.mem.eql(u8, command, "vec")) {
        try runBenchmarks(allocator, writer, .vec);
    } else if (std.mem.eql(u8, command, "matrix")) {
        try runBenchmarks(allocator, writer, .matrix);
    } else if (std.mem.eql(u8, command, "quat")) {
        try runBenchmarks(allocator, writer, .quat);
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

