const std = @import("std");

pub fn linkLibLua(
    b: *std.Build,
    lib: *std.Build.Step.Compile,
) !void {
    const target = lib.root_module.resolved_target.?;
    const optimize = lib.root_module.optimize.?;

    const lua = b.dependency("lua", .{});

    const liblua = b.addLibrary(.{
        .name = "lua",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    liblua.link_gc_sections = true;
    liblua.link_data_sections = true;
    liblua.link_function_sections = true;

    liblua.root_module.addIncludePath(lua.path("."));

    liblua.root_module.addCSourceFiles(.{
        .files = lua_sources,
        .root = lua.path(""),
        .flags = &.{
            "-lm",
        },
    });

    lib.root_module.linkLibrary(liblua);
}

const lua_sources = &.{
    "lauxlib.c",
    "liolib.c",
    "lopcodes.c",
    "lstate.c",
    "lobject.c",
    "lmathlib.c",
    "loadlib.c",
    "lvm.c",
    "lfunc.c",
    "lstrlib.c",
    "lua.c",
    "linit.c",
    "lstring.c",
    "lundump.c",
    "lctype.c",
    "ltable.c",
    "ldump.c",
    "loslib.c",
    "lgc.c",
    "lzio.c",
    "ldblib.c",
    "lutf8lib.c",
    "lmem.c",
    "lcorolib.c",
    "lcode.c",
    "ltablib.c",
    "lapi.c",
    "lbaselib.c",
    "ldebug.c",
    "onelua.c",
    "lparser.c",
    "llex.c",
    "ltm.c",
    "ltests.c",
    "ldo.c",
};
