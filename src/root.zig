pub const c = @import("lua");

const std = @import("std");

/// As a proof of concept of Lua<->Zig function calling we export a function
/// that gets called loaded from the `.so` in `test.lua`
export fn add(L: ?*c.lua_State) callconv(.c) c_int {
    const a = c.luaL_checkinteger(L, 1);
    const b = c.luaL_checkinteger(L, 2);

    c.lua_pushinteger(L, a + b);
    return 1;
}

/// As a proof of concept of Lua<->Zig function calling we export a function
/// that gets called loaded from the `.so` in `test.lua`
export fn zig_print(L: ?*c.lua_State) callconv(.c) c_int {
    const nargs = c.lua_gettop(L);
    var i: c_int = 1;
    while (i <= nargs) : (i += 1) {
        const str = c.lua_tolstring(L, i, null);
        if (str != null) {
            std.debug.print("{s}", .{str});
        } else {
            if (c.lua_isnil(L, i)) {
                std.debug.print("nil", .{});
            } else if (c.lua_isboolean(L, i)) {
                const b = c.lua_toboolean(L, i);
                std.debug.print("{}", .{b != 0});
            } else if (c.lua_isnumber(L, i) != 0) {
                const n = c.lua_tonumberx(L, i, null);
                std.debug.print("{d}", .{n});
            } else {
                const t = c.luaL_typename(L, i);
                std.debug.print("<{s}>", .{t});
            }
        }
    }
    std.debug.print("\n", .{});
    return 0;
}
