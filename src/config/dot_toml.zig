const std = @import("std");
const DotfilesHashMap = struct {
    source: []const u8,
    destination: []const u8,
};

const Dotfiles = struct {
    files: []DotfilesHashMap,
};

const Dot = struct {
    source_path: []const u8,
};

// Represents the whole dot.toml config file
pub const Config = struct {
    dot: Dot,
    dotfiles: Dotfiles,
};
