const std = @import("std");

const c = @cImport({
    @cDefine("CL_TARGET_OPENCL_VERSION", "110");
    @cInclude("CL/cl.h");
});

pub fn main() anyerror!void {
    var platform_id: c.cl_platform_id = undefined;
    var ret_num_platforms: c.cl_uint = undefined;
    var ret_val = c.clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
    std.debug.warn("num cl platforms: {}\n", @intCast(u32, ret_num_platforms));
    std.debug.warn("done.\n");
}
