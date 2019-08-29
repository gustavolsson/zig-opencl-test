const std = @import("std");

const c = @cImport({
    @cDefine("CL_TARGET_OPENCL_VERSION", "110");
    @cInclude("CL/cl.h");
});

const kernel_source =
    \\__kernel void square_array(__global int* input_array, __global int* output_array) {
    \\    int i = get_global_id(0);
    \\    int value = input_array[i];
    \\    output_array[i] = value * value;
    \\}
;

const CLError = error{
    FailedGetPlatforms,
    FailedGetPlatformInfo,
    FailedGetDevices,
    FailedGetDeviceInfo,
};

fn init_cl() CLError!void {
    var platform_ids: [16]c.cl_platform_id = undefined;
    var platform_id_count: c.cl_uint = undefined;
    if (c.clGetPlatformIDs(16, &platform_ids, &platform_id_count) != c.CL_SUCCESS) {
        return CLError.FailedGetPlatforms;
    }
    std.debug.warn("{} cl platform(s) found:\n", @intCast(u32, platform_id_count));

    for (platform_ids[0..platform_id_count]) |id, i| {
        var name: [1024]u8 = undefined;
        var name_len: usize = undefined;
        if (c.clGetPlatformInfo(id, c.CL_PLATFORM_NAME, name.len, &name, &name_len) != c.CL_SUCCESS) {
            return CLError.FailedGetPlatformInfo;
        }
        std.debug.warn("  platform {}: {}\n", i, name[0..name_len]);
    }
    std.debug.warn("done.\n");
}

pub fn main() anyerror!void {
    // Initialize input array (at compile time)
    var input_array = init: {
        var init_value: [1024]i32 = undefined;
        for (init_value) |*pt, i| {
            pt.* = @intCast(i32, i);
        }
        break :init init_value;
    };
    //for (input_array) |val| {
    //    std.debug.warn("{}\n", val);
    //}

    try init_cl();
}
