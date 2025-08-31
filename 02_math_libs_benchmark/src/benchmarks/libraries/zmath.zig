const zmath_gd = @import("zmath_gd");

pub const VecOps = struct {
    pub const Vec3 = @TypeOf(zmath_gd.f32x4(0, 0, 0, 0));

    pub fn vec3(x: f32, y: f32, z: f32) Vec3 { return zmath_gd.f32x4(x, y, z, 0.0); }
    pub fn add(a: Vec3, b: Vec3) Vec3 { return a + b; }
    pub fn sub(a: Vec3, b: Vec3) Vec3 { return a - b; }
    pub fn muls(v: Vec3, s: f32) Vec3 { return v * zmath_gd.f32x4s(s); }
    pub fn normalize3(v: Vec3) Vec3 { return zmath_gd.normalize3(v); }

    pub fn dot(a: Vec3, b: Vec3) f32 { return zmath_gd.dot3(a, b)[0]; } // broadcast -> scalar
    pub fn cross(a: Vec3, b: Vec3) VecOps.Vec3 { return zmath_gd.cross3(a, b); }
    pub fn length(v: Vec3) f32 { return zmath_gd.length3(v)[0]; }
    pub fn lerp(a: Vec3, b: Vec3, t: f32) Vec3 { return zmath_gd.lerp(a, b, t); }
    pub fn distance(a: Vec3, b: Vec3) f32 { return zmath_gd.length3(b - a)[0]; }

    pub fn extract3(v: Vec3) struct { x: f32, y: f32, z: f32 } {
        return .{ .x = v[0], .y = v[1], .z = v[2] };
    }
};

pub const MatOps = struct {
    pub fn identity() zmath_gd.Mat {
        return .{
            zmath_gd.f32x4(1.0, 0.0, 0.0, 0.0),
            zmath_gd.f32x4(0.0, 1.0, 0.0, 0.0),
            zmath_gd.f32x4(0.0, 0.0, 1.0, 0.0),
            zmath_gd.f32x4(0.0, 0.0, 0.0, 1.0),
        };
    }
    pub fn translate(x: f32, y: f32, z: f32) zmath_gd.Mat { return zmath_gd.translation(x, y, z); }
    pub fn multiply(a: zmath_gd.Mat, b: zmath_gd.Mat) zmath_gd.Mat { return zmath_gd.mul(a, b); }
};

pub const QuatOps = struct {
    pub const Quat = zmath_gd.Quat;
    
    pub fn fromAxisAngle(axis: VecOps.Vec3, angle: f32) Quat {
        return zmath_gd.quatFromAxisAngle(axis, angle);
    }
    
    pub fn multiply(a: Quat, b: Quat) Quat {
        return zmath_gd.qmul(a, b);
    }
    
    pub fn normalize(q: Quat) Quat {
        return zmath_gd.qnormalize(q);
    }
};

pub const GeoOps = struct {
    pub const Vec3 = VecOps.Vec3;
    pub const Ray = struct { origin: Vec3, dir: Vec3 };
    pub const Aabb = struct { min: Vec3, max: Vec3 };

    pub fn ray(origin: Vec3, dir: Vec3) Ray { return .{ .origin = origin, .dir = dir }; }
    pub fn aabb(min: Vec3, max: Vec3) Aabb { return .{ .min = min, .max = max }; }

    // Scalarized slab test for parity (not used in this PR)
    pub fn intersectRayAabb(r: Ray, b: Aabb) bool {
        const o = VecOps.extract3(r.origin);
        const d = VecOps.extract3(r.dir);
        const mn = VecOps.extract3(b.min);
        const mx = VecOps.extract3(b.max);

        const inv_dx = 1.0 / d.x;
        const inv_dy = 1.0 / d.y;
        const inv_dz = 1.0 / d.z;

        var tmin = @min((mn.x - o.x) * inv_dx, (mx.x - o.x) * inv_dx);
        var tmax = @max((mn.x - o.x) * inv_dx, (mx.x - o.x) * inv_dx);

        const tymin = @min((mn.y - o.y) * inv_dy, (mx.y - o.y) * inv_dy);
        const tymax = @max((mn.y - o.y) * inv_dy, (mx.y - o.y) * inv_dy);

        if (tmin > tymax or tymin > tmax) return false;
        if (tymin > tmin) tmin = tymin;
        if (tymax < tmax) tmax = tymax;

        const tzmin = @min((mn.z - o.z) * inv_dz, (mx.z - o.z) * inv_dz);
        const tzmax = @max((mn.z - o.z) * inv_dz, (mx.z - o.z) * inv_dz);

        if (tmin > tzmax or tzmin > tmax) return false;
        return true;
    }
};