# Math Benchmark Phase 2 - Complete Game-Dev Math Operations

This project benchmarks math libraries (zalgebra vs zm) for game development operations across three categories: **vectors**, **matrices**, and **quaternions**.

## 🚀 Quick Start

```bash
# Run all benchmarks (36+ operations)
zig build run -- full

# Run only vector operations (16 operations)
zig build run -- vec  

# Run only matrix operations (8 operations) 
zig build run -- matrix

# Run only quaternion operations (6 operations)
zig build run -- quat

# Show help
zig build run -- help
```

## 📂 Clean Modular Structure

```
src/
├── main.zig           # CLI handling + main function only
├── config.zig         # Benchmark configuration constants
└── benchmarks/
    ├── vector.zig     # Vector operations (16 benchmarks)
    ├── matrix.zig     # Matrix operations (8 benchmarks) 
    └── quaternion.zig # Quaternion operations (6 benchmarks)
```

## 🎮 Game-Dev Focused Operations

### Vector Operations (16 benchmarks)
- **Core Operations**: multiplication, dot product, cross product, length
- **Game-Dev Essentials**: normalization, linear interpolation (lerp), distance
- **Performance Testing**: varying data scenarios

### Matrix Operations (8 benchmarks)  
- **Matrix4x4 Operations**: multiplication, transpose
- **Transform Matrices**: translation, transformation chains
- **Rendering Pipeline**: matrix multiplication chains

### Quaternion Operations (6 benchmarks)
- **Rotation Math**: quaternion multiplication, normalization
- **Basic Operations**: axis-angle creation, normalization

## ⚡ Performance Focus

These operations target critical game development use cases:
- **Real-time rendering** (matrix transformations)
- **Smooth animations** (interpolations)
- **Physics calculations** (vector operations) 
- **Camera controls** (quaternion rotations)

## 🔧 Technical Details

- **Zig 0.15.1 Compatible**
- **Libraries**: zalgebra vs zm comparison
- **Configuration**: 500k iterations, 5-second budget, allocation tracking
- **Optimization Prevention**: Uses `std.mem.doNotOptimizeAway()`

## 📊 Expected Output

Each benchmark shows:
- Operations per second
- Average execution time
- Memory allocation tracking
- Comparative performance between libraries

Perfect for identifying the best math library for your Zig game development needs!