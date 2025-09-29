const std = @import("std");
const linkLibLua = @import("build.lua.zig").linkLibLua;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const luabindings = b.addTranslateC(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("bindings/liblua.h"),
    });
    const liblua = luabindings.addModule("liblua");

    const lua = b.addLibrary(.{
        .name = "liblua",
        .linkage = .static,
        .root_module = liblua,
    });
    try linkLibLua(b, lua);

    const exe = b.addExecutable(.{
        .name = "luazig",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "liblua", .module = liblua },
            },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());
}
