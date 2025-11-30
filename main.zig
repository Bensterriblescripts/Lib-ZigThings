const std = @import("std");
const file = @import("file/file.zig");

pub fn main() !void {

    file.InsertString("file/Resume - Benjamin Nanson.pdf", "stream", "\nmagicalstuff") catch |err| {
        std.debug.print("Error during insertion: {}\n", .{err});
    };
}
