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

    const result = parser.parseFile("dot.toml") catch |err| return err;
    defer result.deinit();

    const config = result.value;
    const home_dir = try std.process.getEnvVarOwned(allocator, "HOME");
    defer allocator.free(home_dir);

    for (config.dotfiles.files) |file| {
        const mounted_dotfile_source = std.fmt.bufPrint(
            dotfile_path_buffer,
            "./{s}/{s}",
            .{ config.dot.dotpath, file.source },
        ) catch |err| {
            return err;
        };
        const output_buffer = try allocator.alloc(u8, file.destination.len + home_dir.len - 1);
        defer allocator.free(output_buffer);

        _ = std.mem.replace(u8, file.destination, "~", home_dir, output_buffer);

        std.posix.symlink(mounted_dotfile_source, output_buffer) catch |err| {
            switch (err) {
                error.PathAlreadyExists => std.debug.print("Yay, it is already created\n", .{}),
                else => return err,
            }
        };
    }
}
