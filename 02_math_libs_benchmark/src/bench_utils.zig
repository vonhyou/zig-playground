const std = @import("std");

// Global sink to prevent dead code elimination
var global_sink: [1024]u8 align(64) = std.mem.zeroes([1024]u8);

/// Prevents compile-time evaluation by performing a volatile load/store
/// This ensures the optimizer cannot precompute values at compile time
pub fn blackBox(comptime T: type, value: T) T {
    // Use volatile operations to prevent constant folding
    var temp = value;
    const ptr: *volatile T = @ptrCast(&global_sink[0]);
    ptr.* = temp;
    temp = ptr.*;
    return temp;
}

/// Consumes a value to ensure computation is not optimized away
/// This creates a visible side effect that the optimizer must preserve
pub fn consume(comptime T: type, value: T) void {
    // Write to a volatile sink to ensure the workload is executed
    const bytes = std.mem.asBytes(&value);
    for (bytes, 0..) |byte, i| {
        const ptr: *volatile u8 = &global_sink[i % @sizeOf(@TypeOf(global_sink))];
        ptr.* = byte;
    }
}

/// Global RNG for runtime data generation
var rng_state: std.Random.DefaultPrng = undefined;
var rng_initialized: bool = false;

/// Initialize RNG with runtime seed to prevent compile-time constant folding
pub fn initRng() void {
    if (!rng_initialized) {
        const seed = @as(u64, @intCast(std.time.milliTimestamp()));
        rng_state = std.Random.DefaultPrng.init(seed);
        rng_initialized = true;
    }
}

/// Get runtime random float in range [min, max)
pub fn randFloat(min: f32, max: f32) f32 {
    initRng();
    const r = rng_state.random().float(f32);
    return blackBox(f32, min + r * (max - min));
}

/// Get runtime random integer in range [min, max]
pub fn randInt(comptime T: type, min: T, max: T) T {
    initRng();
    const r = rng_state.random().intRangeAtMost(T, min, max);
    return blackBox(T, r);
}

/// Fill array with runtime-generated data to prevent constant folding
pub fn fillArrayF32(slice: []f32, base: f32, increment: f32) void {
    initRng();
    for (slice, 0..) |*value, i| {
        const fi = @as(f32, @floatFromInt(i));
        const noise = rng_state.random().float(f32) * 0.001; // Small random noise
        value.* = blackBox(f32, base + fi * increment + noise);
    }
}

/// Compute scalar accumulator from array to prevent DCE
pub fn accumulateF32(slice: []const f32) f32 {
    var sum: f32 = 0.0;
    for (slice) |value| {
        sum += value;
    }
    return blackBox(f32, sum);
}

/// Compute vector component sum for Vec3-like structures
pub fn accumulateVec3Components(comptime T: type, slice: []const T, comptime accessor: fn (T) [3]f32) f32 {
    var sum: f32 = 0.0;
    for (slice) |item| {
        const components = accessor(item);
        sum += components[0] + components[1] + components[2];
    }
    return blackBox(f32, sum);
}

pub fn accumulateVec4Components(comptime T: type, slice: []const T, comptime accessor: fn (T) [4]f32) f32 {
    var sum: f32 = 0.0;
    for (slice) |item| {
        const components = accessor(item);
        sum += components[0] + components[1] + components[2] + components[3];
    }
    return blackBox(f32, sum);
}

/// Compute matrix component sum for Mat4-like structures
pub fn accumulateMat4Components(comptime T: type, slice: []const T, comptime accessor: fn (T) [16]f32) f32 {
    var sum: f32 = 0.0;
    for (slice) |item| {
        const components = accessor(item);
        for (components) |component| {
            sum += component;
        }
    }
    return blackBox(f32, sum);
}

/// Compute quaternion component sum for Quat-like structures
pub fn accumulateQuatComponents(comptime T: type, slice: []const T, comptime accessor: fn (T) [4]f32) f32 {
    var sum: f32 = 0.0;
    for (slice) |item| {
        const components = accessor(item);
        sum += components[0] + components[1] + components[2] + components[3];
    }
    return blackBox(f32, sum);
}

/// Helper to create runtime Vec3-like values with different libraries
pub fn runtimeVec3(comptime Vec3Type: type, base_x: f32, base_y: f32, base_z: f32) Vec3Type {
    const x = randFloat(base_x - 0.1, base_x + 0.1);
    const y = randFloat(base_y - 0.1, base_y + 0.1);
    const z = randFloat(base_z - 0.1, base_z + 0.1);

    // Handle different Vec3 creation methods
    const type_info = @typeInfo(Vec3Type);
    if (type_info == .Struct) {
        // Check for common field patterns
        const fields = type_info.Struct.fields;
        if (fields.len == 3) {
            // Assume xyz order for struct with 3 fields
            return Vec3Type{
                @field(@as(f32, x), fields[0].name),
                @field(@as(f32, y), fields[1].name),
                @field(@as(f32, z), fields[2].name),
            };
        } else if (fields.len == 4) {
            // Assume xyzw order for 4-component vector (w=0 for Vec3)
            return Vec3Type{
                @field(@as(f32, x), fields[0].name),
                @field(@as(f32, y), fields[1].name),
                @field(@as(f32, z), fields[2].name),
                @field(@as(f32, 0.0), fields[3].name),
            };
        }
    } else if (type_info == .Array and type_info.Array.len >= 3) {
        // Array-based vector
        var result: Vec3Type = undefined;
        result[0] = x;
        result[1] = y;
        result[2] = z;
        if (type_info.Array.len == 4) {
            result[3] = 0.0; // w component for homogeneous coordinates
        }
        return result;
    }

    // Fallback - this should be specialized per library
    @compileError("Unsupported Vec3Type: " ++ @typeName(Vec3Type));
}

// Library-specific component extraction helpers
pub fn extractZalgebraVec3(vec: anytype) [3]f32 {
    return [3]f32{ vec.data[0], vec.data[1], vec.data[2] };
}

pub fn extractZmVec3(vec: anytype) [3]f32 {
    return [3]f32{ vec[0], vec[1], vec[2] };
}

pub fn extractZmathVec(vec: anytype) [4]f32 {
    return [4]f32{ vec[0], vec[1], vec[2], vec[3] };
}

pub fn extractZalgebraMat4(mat: anytype) [16]f32 {
    var result: [16]f32 = undefined;
    for (0..4) |i| {
        for (0..4) |j| {
            result[i * 4 + j] = mat.data[i][j];
        }
    }
    return result;
}

pub fn extractZmMat4(mat: anytype) [16]f32 {
    var result: [16]f32 = undefined;
    for (0..4) |i| {
        for (0..4) |j| {
            result[i * 4 + j] = mat.data[i][j];
        }
    }
    return result;
}

pub fn extractZmathMat4(mat: anytype) [16]f32 {
    var result: [16]f32 = undefined;
    for (0..4) |row| {
        for (0..4) |col| {
            result[row * 4 + col] = mat[row][col];
        }
    }
    return result;
}

pub fn extractZalgebraQuat(quat: anytype) [4]f32 {
    return [4]f32{ quat.w, quat.x, quat.y, quat.z };
}

pub fn extractZmQuat(quat: anytype) [4]f32 {
    return [4]f32{ quat.w, quat.x, quat.y, quat.z };
}

pub fn extractZmathQuat(quat: anytype) [4]f32 {
    return [4]f32{ quat[0], quat[1], quat[2], quat[3] };
}
