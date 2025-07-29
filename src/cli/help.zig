const std = @import("std");

pub fn printHelp() noreturn {
    std.debug.print(
        \\Usage: dot [COMMAND] [OPTIONS]
        \\
        \\Commands:
        \\ (no command)    Print this message and exits.
        \\ sync            Reads dot.toml and create symbolic links.
        \\
        \\Options:
        \\ --help, -h      Print this message and exits.
        \\ --version, -v   Print dot version.
        \\
    , .{});

    std.process.exit(1);
}
