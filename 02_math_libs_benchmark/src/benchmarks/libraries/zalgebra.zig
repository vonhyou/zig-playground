const zalgebra = @import("zalgebra");

// Adapter for Vec/Mat/Geo to normalize APIs across libraries
pub const VecOps = struct {
    pub const Vec3 = zalgebra.Vec3;

    pub fn vec3(x: f32, y: f32, z: f32) Vec3 { return Vec3.new(x, y, z); }
    pub fn add(a: Vec3, b: Vec3) Vec3 { return zalgebra.Vec3.add(a, b); }
    pub fn sub(a: Vec3, b: Vec3) Vec3 { return zalgebra.Vec3.sub(a, b); }
    pub fn muls(v: Vec3, s: f32) Vec3 { return zalgebra.Vec3.mul(v, Vec3.new(s, s, s)); }
    pub fn normalize3(v: Vec3) Vec3 { return zalgebra.Vec3.normalize(v); }

    pub fn dot(a: Vec3, b: Vec3) f32 { return zalgebra.Vec3.dot(a, b); }
    pub fn cross(a: Vec3, b: Vec3) Vec3 { return zalgebra.Vec3.cross(a, b); }
    pub fn length(v: Vec3) f32 { return zalgebra.Vec3.length(v); }
    pub fn lerp(a: Vec3, b: Vec3, t: f32) Vec3 { return zalgebra.Vec3.lerp(a, b, t); }
    pub fn distance(a: Vec3, b: Vec3) f32 {
        const diff = zalgebra.Vec3.sub(b, a);
        return zalgebra.Vec3.length(diff);
    }

    pub fn extract3(v: Vec3) struct { x: f32, y: f32, z: f32 } {
        return .{ .x = v.x, .y = v.y, .z = v.z };
    }
};

pub const MatOps = struct {
    pub fn identity() zalgebra.Mat4 { return zalgebra.Mat4.identity(); }
    pub fn translate(x: f32, y: f32, z: f32) zalgebra.Mat4 {
        return zalgebra.Mat4.fromTranslate(zalgebra.Vec3.new(x, y, z));
    }
    pub fn multiply(a: zalgebra.Mat4, b: zalgebra.Mat4) zalgebra.Mat4 {
        return zalgebra.Mat4.mul(a, b);
    }
};

pub const QuatOps = struct {
    pub const Quat = zalgebra.Quat;
    
    pub fn fromAxisAngle(axis: VecOps.Vec3, angle: f32) Quat {
        return zalgebra.Quat.fromAxis(angle, axis);
    }
    
    pub fn multiply(a: Quat, b: Quat) Quat {
        return zalgebra.Quat.mul(a, b);
    }
    
    pub fn normalize(q: Quat) Quat {
        return zalgebra.Quat.norm(q);
    }
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