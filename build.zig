const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //Import RFC library
    const depe = b.dependency("rfc", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "examples_client",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                //Make RFC library visible in module
                .{ .name = "rfc", .module = depe.module("rfc") },
            },
        }),
    });

    //For linking
    exe.addObjectFile(b.path("src/dll/sapnwrfc.lib"));
    //In order to copy dll's next to exe
    b.installDirectory(.{
        .source_dir = b.path("src/dll"),
        .install_dir = .prefix,
        .install_subdir = "bin",
        .include_extensions = &.{"dll"},
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
