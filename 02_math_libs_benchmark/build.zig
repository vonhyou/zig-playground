const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mod = b.addModule("_02_math_libs_benchmark", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    const exe = b.addExecutable(.{
        .name = "_02_math_libs_benchmark",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "_02_math_libs_benchmark", .module = mod },
            },
        }),
    });

    const opts = .{ .target = target, .optimize = optimize };

    const zalgebra = b.dependency("zalgebra", opts);
    exe.root_module.addImport("zalgebra", zalgebra.module("zalgebra"));

    const zbench = b.dependency("zbench", opts);
    exe.root_module.addImport("zbench", zbench.module("zbench"));

    const zm = b.dependency("zm", opts);
    exe.root_module.addImport("zm", zm.module("zm"));

    const zmath = b.dependency("zmath", opts);
    exe.root_module.addImport("zmath_gd", zmath.module("root"));

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
