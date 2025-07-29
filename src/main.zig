const std = @import("std");
const builtin = @import("builtin");

const printVersion = @import("cli/version.zig").printVersion;
const sync = @import("cli/sync.zig").sync;
const printHelp = @import("cli/help.zig").printHelp;

const Command = enum {
    //version
    @"-v",
    @"--version",
    //help
    @"-h",
    @"--help",
    //commands
    sync,
};

pub const gpa = std.heap.smp_allocator;

pub fn main() !void {
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    var cmd: Command = .@"--help";
    if (args.len >= 2) {
        if (std.meta.stringToEnum(Command, args[1])) |parsed_cmd| {
            cmd = parsed_cmd;
        }
    }

    switch (cmd) {
        .@"--version", .@"-v" => try printVersion(),
        .@"-h", .@"--help" => printHelp(),
        .sync => try sync(),
    }
}
