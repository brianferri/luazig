## luazig

Build Lua with a minimal setup, using zig

## Installation

```sh
git submodule add git@github.com:brianferri/luazig.git
```

In your `build.zig.zon`:

```zig
.dependencies = .{
    .luazig = .{
        .path = "luazig",
    },
},
```

And import it on your `build.zig` file:

```zig
const luazig = b.dependency("luazig", .{ .target = target, .optimize = optimize });

const exe = b.addExecutable(.{
    .name = "your_project",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "luazig", .module = luazig.module("luazig") },
        },
    }),
});
b.installArtifact(exe);
```

