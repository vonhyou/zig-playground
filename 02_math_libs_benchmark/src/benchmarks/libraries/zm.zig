const zm = @import("zm");

pub const VecOps = struct {
    pub const Vec3 = zm.Vec3f;

    pub fn vec3(x: f32, y: f32, z: f32) Vec3 { return .{ x, y, z }; }
    pub fn add(a: Vec3, b: Vec3) Vec3 { return zm.vec.add(a, b); }
    pub fn sub(a: Vec3, b: Vec3) Vec3 { return zm.vec.sub(a, b); }
    pub fn muls(v: Vec3, s: f32) Vec3 { return zm.vec.scale(v, s); }
    pub fn normalize3(v: Vec3) Vec3 { return zm.vec.normalize(v); }

    pub fn dot(a: Vec3, b: Vec3) f32 { return zm.vec.dot(a, b); }
    pub fn cross(a: Vec3, b: Vec3) Vec3 { return zm.vec.cross(a, b); }
    pub fn length(v: Vec3) f32 { return zm.vec.length(v); }
    pub fn distance(a: Vec3, b: Vec3) f32 { return zm.vec.distance(a, b); }

    pub fn extract3(v: Vec3) struct { x: f32, y: f32, z: f32 } {
        return .{ .x = v[0], .y = v[1], .z = v[2] };
    }
};

pub const MatOps = struct {
    pub fn identity() zm.Mat4f { return zm.Mat4f.identity(); }
    pub fn translate(x: f32, y: f32, z: f32) zm.Mat4f { return zm.Mat4f.translation(x, y, z); }
    pub fn multiply(a: zm.Mat4f, b: zm.Mat4f) zm.Mat4f { return zm.Mat4f.multiply(a, b); }
};

pub const GeoOps = struct {
    pub const Vec3 = VecOps.Vec3;
    pub const Ray = struct { origin: Vec3, dir: Vec3 };
    pub const Aabb = struct { min: Vec3, max: Vec3 };

    pub fn ray(origin: Vec3, dir: Vec3) Ray { return .{ .origin = origin, .dir = dir }; }
    pub fn aabb(min: Vec3, max: Vec3) Aabb { return .{ .min = min, .max = max }; }

    // Scalarized slab test (not used in this PR)
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