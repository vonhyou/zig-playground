const std = @import("std");
const zbench = @import("zbench");

const config = @import("config.zig");
const vector = @import("benchmarks/vector.zig");
const matrix = @import("benchmarks/matrix.zig");
const quaternion = @import("benchmarks/quaternion.zig");
const zmath_simd = @import("benchmarks/zmath_simd.zig");

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
    .{ .name = "zmath vec mul", .func = vector.bench_zmath_vec_mul, .category = .vec },
    .{ .name = "zalgebra vec dot", .func = vector.bench_zalgebra_vec_dot, .category = .vec },
    .{ .name = "zm vec dot", .func = vector.bench_zm_vec_dot, .category = .vec },
    .{ .name = "zmath vec dot", .func = vector.bench_zmath_vec_dot, .category = .vec },
    .{ .name = "zalgebra vec cross", .func = vector.bench_zalgebra_vec_cross, .category = .vec },
    .{ .name = "zm vec cross", .func = vector.bench_zm_vec_cross, .category = .vec },
    .{ .name = "zmath vec cross", .func = vector.bench_zmath_vec_cross, .category = .vec },
    .{ .name = "zalgebra vec len", .func = vector.bench_zalgebra_vec_len, .category = .vec },
    .{ .name = "zm vec len", .func = vector.bench_zm_vec_len, .category = .vec },
    .{ .name = "zmath vec len", .func = vector.bench_zmath_vec_len, .category = .vec },
    .{ .name = "zalgebra vec normalize", .func = vector.bench_zalgebra_vec_normalize, .category = .vec },
    .{ .name = "zm vec normalize", .func = vector.bench_zm_vec_normalize, .category = .vec },
    .{ .name = "zmath vec normalize", .func = vector.bench_zmath_vec_normalize, .category = .vec },
    .{ .name = "zalgebra vec lerp", .func = vector.bench_zalgebra_vec_lerp, .category = .vec },
    .{ .name = "zm vec lerp", .func = vector.bench_zm_vec_lerp, .category = .vec },
    .{ .name = "zmath vec lerp", .func = vector.bench_zmath_vec_lerp, .category = .vec },
    .{ .name = "zalgebra vec distance", .func = vector.bench_zalgebra_vec_distance, .category = .vec },
    .{ .name = "zm vec distance", .func = vector.bench_zm_vec_distance, .category = .vec },
    .{ .name = "zmath vec distance", .func = vector.bench_zmath_vec_distance, .category = .vec },

    // Matrix operations
    .{ .name = "zalgebra mat mul", .func = matrix.bench_zalgebra_mat_mul, .category = .matrix },
    .{ .name = "zm mat mul", .func = matrix.bench_zm_mat_mul, .category = .matrix },
    .{ .name = "zmath mat mul", .func = matrix.bench_zmath_mat_mul, .category = .matrix },

    // Quaternion operations
    .{ .name = "zalgebra quat mul", .func = quaternion.bench_zalgebra_quat_mul, .category = .quat },
    .{ .name = "zm quat mul", .func = quaternion.bench_zm_quat_mul, .category = .quat },
    .{ .name = "zmath quat mul", .func = quaternion.bench_zmath_quat_mul, .category = .quat },
    .{ .name = "zalgebra quat normalize", .func = quaternion.bench_zalgebra_quat_normalize, .category = .quat },
    .{ .name = "zm quat normalize", .func = quaternion.bench_zm_quat_normalize, .category = .quat },
    .{ .name = "zmath quat normalize", .func = quaternion.bench_zmath_quat_normalize, .category = .quat },
};

// Optional SIMD benchmarks for zmath (--simd flag)
// These use end-to-end F32x4 operations to demonstrate zmath's SIMD-optimized performance
const SIMD_BENCHMARKS = [_]BenchmarkInfo{
    .{ .name = "zmath SIMD vec ops", .func = zmath_simd.bench_zmath_simd_vec_ops, .category = .vec },
    .{ .name = "zmath SIMD mat chain", .func = zmath_simd.bench_zmath_simd_mat_chain, .category = .matrix },
};

fn printHelp(writer: anytype) !void {
    try writer.writeAll("Math Library Benchmark Tool\n");
    try writer.writeAll("============================\n\n");
    try writer.writeAll("Usage: zig build run -- [OPTION] [FLAGS]\n\n");
    try writer.writeAll("Available options:\n");
    try writer.writeAll("  full    Run scalar parity benchmarks (default) or SIMD benchmarks with --simd\n");
    try writer.writeAll("  vec     Run scalar parity vector benchmarks or SIMD vector benchmarks with --simd\n");
    try writer.writeAll("  matrix  Run scalar parity matrix benchmarks or SIMD matrix benchmarks with --simd\n");
    try writer.writeAll("  quat    Run scalar parity quaternion benchmarks or SIMD quaternion benchmarks with --simd\n");
    try writer.writeAll("  help    Show this help message\n\n");
    try writer.writeAll("Available flags:\n");
    try writer.writeAll("  --simd  Run SIMD benchmarks only (replaces scalar benchmarks)\n");
    try writer.writeAll("  --mem   Show memory allocation statistics (optional)\n\n");
    try writer.writeAll("Benchmark modes:\n");
    try writer.writeAll("  Default mode: Runs scalar parity benchmarks across all libraries using f32 types.\n");
    try writer.writeAll("  SIMD mode:    Runs zmath SIMD-optimized benchmarks only (end-to-end F32x4).\n\n");
    try writer.writeAll("If no option is provided, this help message will be displayed.\n\n");
    try writer.writeAll("Examples:\n");
    try writer.writeAll("  zig build run -- full         # Scalar parity benchmarks\n");
    try writer.writeAll("  zig build run -- full --simd  # SIMD benchmarks only\n");
    try writer.writeAll("  zig build run -- vec          # Scalar vector benchmarks\n");
    try writer.writeAll("  zig build run -- matrix --simd # SIMD matrix benchmarks\n");
    try writer.writeAll("  zig build run -- full --mem   # Show memory stats\n");
}

fn runBenchmarks(allocator: std.mem.Allocator, writer: anytype, category: ?BenchmarkCategory, simd_mode: bool, show_mem: bool) !void {
    var bench = zbench.Benchmark.init(allocator, config.BENCHMARK_CONFIG);
    defer bench.deinit();

    if (simd_mode) {
        // SIMD mode: register ONLY SIMD benchmarks
        for (SIMD_BENCHMARKS) |benchmark_info| {
            if (category == null or benchmark_info.category == category.?) {
                try bench.add(benchmark_info.name, benchmark_info.func, .{});
            }
        }
    } else {
        // Scalar parity mode: register all scalar benchmarks
        for (BENCHMARKS) |benchmark_info| {
            if (category == null or benchmark_info.category == category.?) {
                try bench.add(benchmark_info.name, benchmark_info.func, .{});
            }
        }
    }

    if (category) |cat| {
        switch (cat) {
            .vec => {
                if (simd_mode) {
                    try writer.writeAll("\n=== Vector Operations SIMD Benchmarks ===\n");
                } else {
                    try writer.writeAll("\n=== Vector Operations Scalar Parity Benchmarks ===\n");
                }
            },
            .matrix => {
                if (simd_mode) {
                    try writer.writeAll("\n=== Matrix Operations SIMD Benchmarks ===\n");
                } else {
                    try writer.writeAll("\n=== Matrix Operations Scalar Parity Benchmarks ===\n");
                }
            },
            .quat => {
                if (simd_mode) {
                    try writer.writeAll("\n=== Quaternion Operations SIMD Benchmarks ===\n");
                } else {
                    try writer.writeAll("\n=== Quaternion Operations Scalar Parity Benchmarks ===\n");
                }
            },
        }
    } else {
        if (simd_mode) {
            try writer.writeAll("\n=== SIMD Benchmarks ===\n");
        } else {
            try writer.writeAll("\n=== Scalar Parity Benchmarks ===\n");
        }
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
    var simd_mode = false;
    var show_mem = false;

    // Check for flags
    for (args) |arg| {
        if (std.mem.eql(u8, arg, "--simd")) {
            simd_mode = true;
        } else if (std.mem.eql(u8, arg, "--mem")) {
            show_mem = true;
        }
    }

    if (std.mem.eql(u8, command, "full")) {
        try runBenchmarks(allocator, writer, null, simd_mode, show_mem);
    } else if (std.mem.eql(u8, command, "vec")) {
        try runBenchmarks(allocator, writer, .vec, simd_mode, show_mem);
    } else if (std.mem.eql(u8, command, "matrix")) {
        try runBenchmarks(allocator, writer, .matrix, simd_mode, show_mem);
    } else if (std.mem.eql(u8, command, "quat")) {
        try runBenchmarks(allocator, writer, .quat, simd_mode, show_mem);
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

