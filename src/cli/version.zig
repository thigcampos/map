const std = @import("std");

pub fn printVersion() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("0.0.1", .{});
}
