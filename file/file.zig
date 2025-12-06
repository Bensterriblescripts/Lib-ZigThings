const std = @import("std");
const ArrayList = std.ArrayList;

pub fn InsertString(filepath: []const u8, findstring: []const u8, insertstring: []const u8) bool {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const workingDir = std.fs.cwd();

    var fileContents = ReadFile("input.txt", workingDir, alloc) catch |err| {
        std.debug.print("Error during reading: {}\n", .{err});
        return;
    };
    defer fileContents.deinit(alloc);

    for (fileContents.items, 0..) |_, fileIndex| {
        if (fileIndex + findstring.len > fileContents.items.len) {
            for (fileContents.items, 0..) |_, i| {
                if (i + findstring.len > fileContents.items.len) break;
                if (std.mem.eql(u8, fileContents.items[i .. i + findstring.len], findstring)) {
                    const pos = i + findstring.len;
                    fileContents.insertSlice(alloc, pos, insertstring) catch |err| {
                        std.debug.print("Error during insertion: {}\n", .{err});
                        break;
                    };
                    std.debug.print("Added text at index {}\n", .{pos});
                }
            }
        }
    }

    workingDir.writeFile(.{
        .sub_path = filepath,
        .data = fileContents.items,
    }) catch |err| {
        std.debug.print("Error during writing: {}\n", .{err});
        return false;
    };

    std.debug.print("Added text to file\n", .{});
    return true;
}
pub fn ReadFile(filepath: []const u8, workingDir: std.fs.Dir, alloc: std.mem.Allocator) !ArrayList(u8) {
    const readContents = workingDir.readFileAlloc(alloc, filepath, 4000000) catch |err| {
        std.debug.print("Error during reading: {}\n", .{err});
        return error.FileNotFound;
    };
    return ArrayList(u8).fromOwnedSlice(readContents);
}
pub fn IterateNewline(fileContents: []const u8) !void {
    var iter = std.mem.splitSequence(u8, fileContents, "\n");
    while (iter.next()) |line| {
        std.debug.print("Line: {s}\n", .{line});
    }
}
