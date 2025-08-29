const std = @import("std");
const zbench = @import("zbench");
const zalgebra = @import("zalgebra");
const zm = @import("zm");

fn bench_zalgebra_vec_mul(_: std.mem.Allocator) void {
    const vec3_za_a = zalgebra.Vec3.new(0.2, 0.3, 0.4);
    const vec3_za_b = zalgebra.Vec3.new(0.4, 0.3, 0.2);

    _ = zalgebra.Vec3.mul(vec3_za_a, vec3_za_b);
}

fn bench_zm_vec_mul(_: std.mem.Allocator) void {
    const vec3_zm_a = zm.Vec3{ 0.2, 0.3, 0.4 };
    const vec3_zm_b = zm.Vec3{ 0.4, 0.3, 0.2 };

    _ = vec3_zm_a * vec3_zm_b;
}

pub fn main() !void {
    var stdout = std.fs.File.stdout().writerStreaming(&.{});
    const writer = &stdout.interface;

    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("zalgebra vec mul", bench_zalgebra_vec_mul, .{});
    try bench.add("zm vec mul", bench_zm_vec_mul, .{});
    try writer.writeAll("\n");
    try bench.run(writer);
}
