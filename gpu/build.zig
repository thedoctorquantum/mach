const std = @import("std");
const gpu_dawn = @import("libs/mach-gpu-dawn/build.zig");
const glfw = @import("libs/mach-glfw/build.zig");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary("gpu", "src/main.zig");
    lib.setBuildMode(mode);
    lib.install();
    gpu_dawn.link(b, lib, .{});

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    const example = b.addExecutable("gpu-hello-triangle", "examples/main.zig");
    example.setTarget(target);
    example.setBuildMode(mode);
    example.install();
    example.linkLibC();
    example.addPackagePath("glfw", "libs/mach-glfw/src/main.zig");
    glfw.link(b, example, .{});
    gpu_dawn.link(b, example, .{});
}