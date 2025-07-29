const std = @import("std");
const toml = @import("toml");

const DotfilesHashMap = struct {
    source: []const u8,
    destination: []const u8,
};

const Dotfiles = struct {
    files: []DotfilesHashMap,
};

const Dot = struct {
    dotpath: []const u8,
};

// Represents the whole dot.toml config file
const Config = struct {
    dot: Dot,
    dotfiles: Dotfiles,
};

pub fn sync() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var parser = toml.Parser(Config).init(allocator);
    defer parser.deinit();

    const result = parser.parseFile("dot.toml") catch {
        std.debug.print("Could not find dot.toml.\n", .{});
        return;
    };
    defer result.deinit();

    const config = result.value;
    const home_dir = try std.process.getEnvVarOwned(allocator, "HOME");
    defer allocator.free(home_dir);

    const pwd = try std.process.getEnvVarOwned(allocator, "PWD");
    defer allocator.free(pwd);

    for (config.dotfiles.files) |file| {
        const mounted_dotfile_source = try std.fmt.allocPrint(
            allocator,
            "{s}/{s}/{s}",
            .{ pwd, config.dot.dotpath, file.source },
        );
        defer allocator.free(mounted_dotfile_source);

        const output_path = try std.mem.replaceOwned(u8, allocator, file.destination, "~", home_dir);
        defer allocator.free(output_path);

        std.posix.symlink(mounted_dotfile_source, output_path) catch |err| {
            switch (err) {
                error.PathAlreadyExists => std.debug.print("Yay, it is already created\n", .{}),
                else => return err,
            }
        };
    }
}
