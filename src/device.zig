const std = @import("std");
const builtin = @import("builtin");

const c = @cImport({
    @cInclude("metal_wrapper.h");
});

pub const Device = struct {
    handle: c.MTLDeviceRef,

    pub fn get() ?Device {
        if (builtin.os.tag != .macos) {
            return null;
        }

        const handle = c.metal_create_system_default_device();
        if (handle == null) return null;

        return .{ .handle = handle };
    }

    pub fn deinit(self: *Device) void {
        if (self.handle) |_| {
            c.metal_device_release(self.handle);
            self.handle = null;
        }
    }

    pub fn name(self: Device) []const u8 {
        const device_name = c.metal_device_name(self.handle);
        if (device_name == null) return "";
        return std.mem.span(device_name);
    }
};

test "get default device" {
    if (builtin.os.tag != .macos) return error.SkipZigTest;
}
