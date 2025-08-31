const std = @import("std");
const libraries = @import("libraries/mod.zig");

// Generic matrix multiply bench; returns a function pointer for zbench
pub fn bench_mat_mul(comptime lib: libraries.Library, comptime is_simd: bool) fn (std.mem.Allocator) void {
    return struct {
        pub fn run(allocator: std.mem.Allocator) void {
            _ = allocator;
            const Ops = libraries.getMatOps(lib, .{ .simd = is_simd });

            const a = Ops.identity();
            const b = Ops.translate(1.0, 2.0, 3.0);

            var r = Ops.multiply(a, b);
            std.mem.doNotOptimizeAway(&r);
        }
    }.run;
}