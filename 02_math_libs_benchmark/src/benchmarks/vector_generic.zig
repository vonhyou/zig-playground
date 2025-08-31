const std = @import("std");
const libraries = @import("benchmarks/libraries/mod.zig");

// Generic vector distance bench; returns a function pointer for zbench
pub fn bench_vec_distance(comptime lib: libraries.Library, comptime is_simd: bool) fn (std.mem.Allocator) void {
    return struct {
        pub fn run(allocator: std.mem.Allocator) void {
            _ = allocator;
            const Ops = libraries.getVecOps(lib, .{ .simd = is_simd });

            const a = Ops.vec3(0.2, 0.3, 0.4);
            const b = Ops.vec3(0.4, 0.3, 0.2);

            var result: f32 = Ops.distance(a, b);
            std.mem.doNotOptimizeAway(&result);
        }
    }.run;
}