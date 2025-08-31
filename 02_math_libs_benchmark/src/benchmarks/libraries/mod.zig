const std = @import("std");

pub const Library = enum { zalgebra, zm, zmath };

pub const MatOpsCfg = struct { simd: bool = false };
pub const VecOpsCfg = struct { simd: bool = false };
pub const QuatOpsCfg = struct { simd: bool = false };
pub const GeoOpsCfg = struct { simd: bool = false };

// Matrix ops dispatch
pub fn getMatOps(comptime lib: Library, comptime cfg: MatOpsCfg) type {
    _ = cfg; // reserved for future SIMD switching
    return switch (lib) {
        .zalgebra => @import("zalgebra.zig").MatOps,
        .zm => @import("zm.zig").MatOps,
        .zmath => @import("zmath.zig").MatOps,
    };
}

// Vector ops dispatch
pub fn getVecOps(comptime lib: Library, comptime cfg: VecOpsCfg) type {
    _ = cfg; // reserved for future SIMD switching
    return switch (lib) {
        .zalgebra => @import("zalgebra.zig").VecOps,
        .zm => @import("zm.zig").VecOps,
        .zmath => @import("zmath.zig").VecOps,
    };
}

// Quaternion ops dispatch
pub fn getQuatOps(comptime lib: Library, comptime cfg: QuatOpsCfg) type {
    _ = cfg; // reserved for future SIMD switching
    return switch (lib) {
        .zalgebra => @import("zalgebra.zig").QuatOps,
        .zm => @import("zm.zig").QuatOps,
        .zmath => @import("zmath.zig").QuatOps,
    };
}

// Geometry ops dispatch (for future use)
pub fn getGeomOps(comptime lib: Library, comptime cfg: GeoOpsCfg) type {
    _ = cfg;
    return switch (lib) {
        .zalgebra => @import("zalgebra.zig").GeoOps,
        .zm => @import("zm.zig").GeoOps,
        .zmath => @import("zmath.zig").GeoOps,
    };
}

// Unified context (future expansion)
pub const Cfg = struct { simd: bool = false };
pub fn getCtx(comptime lib: Library, comptime cfg: Cfg) type {
    return struct {
        pub const Vec = getVecOps(lib, .{ .simd = cfg.simd });
        pub const Mat = getMatOps(lib, .{ .simd = cfg.simd });
        pub const Quat = getQuatOps(lib, .{ .simd = cfg.simd });
        pub const Geo = getGeomOps(lib, .{ .simd = cfg.simd });
    };
}