const std = @import("std");
const toml = @import("toml");

const Config = @import("../config/dot_toml.zig").Config;

pub fn parseDotToml(allocator: std.mem.Allocator) !Config {
    var parser = toml.Parser(Config).init(allocator);
    defer parser.deinit();

    const result = parser.parseFile("dot.toml") catch |err| {
        std.debug.print("Could not find dot.toml.\n", .{});
        return err;
    };

    return result.value;
}
