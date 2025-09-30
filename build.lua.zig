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
    // core -- used by all
    "lzio.c",
    "lctype.c",
    "lopcodes.c",
    "lmem.c",
    "lundump.c",
    "ldump.c",
    "lstate.c",
    "lgc.c",
    "llex.c",
    "lcode.c",
    "lparser.c",
    "ldebug.c",
    "lfunc.c",
    "lobject.c",
    "ltm.c",
    "lstring.c",
    "ltable.c",
    "ldo.c",
    "lvm.c",
    "lapi.c",
    // auxiliary library -- used by all
    "lauxlib.c",
    // standard library  -- not used by luac
    "lbaselib.c",
    "lcorolib.c",
    "ldblib.c",
    "liolib.c",
    "lmathlib.c",
    "loadlib.c",
    "loslib.c",
    "lstrlib.c",
    "ltablib.c",
    "lutf8lib.c",
    "linit.c",
    // lua
    "lua.c",
};
