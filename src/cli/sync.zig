const std = @import("std");
const toml = @import("toml");

const Config = @import("../config/dot_toml.zig").Config;
const parseDotToml = @import("../config/parse_toml.zig").parseDotToml;

pub fn sync() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var parser = toml.Parser(Config).init(allocator);
    defer parser.deinit();

    const config = try parseDotToml(allocator);

    const home_dir = try std.process.getEnvVarOwned(allocator, "HOME");
    defer allocator.free(home_dir);

    const pwd = try std.process.getEnvVarOwned(allocator, "PWD");
    defer allocator.free(pwd);

    for (config.dotfiles.files) |file| {
        const mounted_dotfile_source = try std.fmt.allocPrint(
            allocator,
            "{s}/{s}/{s}",
            .{ pwd, config.dot.source_path, file.source },
        );
        defer allocator.free(mounted_dotfile_source);

        const output_path = try std.mem.replaceOwned(u8, allocator, file.destination, "~", home_dir);
        defer allocator.free(output_path);

        std.posix.symlink(mounted_dotfile_source, output_path) catch |err| {
            switch (err) {
                error.PathAlreadyExists => {
                    std.debug.print("No changes, already synced: {s}.\n", .{file.source});
                    continue;
                },
                else => return err,
            }
        };
        std.debug.print("Successfully synced {s}.\n", .{file.source});
    }
}
