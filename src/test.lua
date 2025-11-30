local cwd = io.popen("pwd"):read() .. '/'
local so = cwd .. "../zig-out/lib/libluazig.so"
print("Loading: " .. so)

local add = package.loadlib(so, "add")
local zig_print = package.loadlib(so, "zig_print")
zig_print("SUM: ", add(21, 13))
