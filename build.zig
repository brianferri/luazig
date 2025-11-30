const std = @import("std");
const linkLibLua = @import("build.lua.zig").linkLibLua;

pub fn build(b: *std.Build) !void {
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

    const lib = b.addLibrary(.{
        .name = "luazig",
        .linkage = .dynamic,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .root_source_file = b.path("src/root.zig"),
            .imports = &.{
                .{ .name = "lua", .module = liblua },
            },
        }),
    });
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "luazig",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "liblua", .module = lib.root_module },
            },
        }),
    });
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    const asm_step = b.step("asm", "Emit assembly file");
    const awf = b.addWriteFiles();
    awf.step.dependOn(b.getInstallStep());
    // Path is relative to the cache dir in which it *would've* been placed in
    const asm_file_name = try std.fmt.allocPrint(b.allocator, "../../../zig-out/asm/lua.s", .{});
    _ = awf.addCopyFile(exe.getEmittedAsm(), asm_file_name);
    asm_step.dependOn(&awf.step);
}
