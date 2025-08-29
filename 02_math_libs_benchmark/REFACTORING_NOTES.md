# Math Library Benchmark Refactoring

This document describes the refactored math benchmark code with command-line argument support.

## Changes Made

### 1. Command-Line Interface

The refactored code now supports selective benchmark execution:

```bash
# Run all benchmarks
zig build run -- full

# Run only vector operation benchmarks  
zig build run -- vec

# Show help message
zig build run -- help

# No arguments or invalid arguments show help
zig build run
zig build run -- invalid
```

### 2. Code Organization

#### Benchmark Categories
- Added `BenchmarkCategory` enum for organizing benchmarks
- Currently supports `vec` category with room for future expansion (matrix, quaternion, etc.)

#### Benchmark Metadata
- Created `BenchmarkInfo` struct to hold benchmark metadata
- Contains name, function pointer, and category
- Organized in a central `BENCHMARKS` array

#### Function Organization
- All existing benchmark functions are preserved unchanged
- Grouped into logical categories in the `BENCHMARKS` array:
  - Vector multiplication (element-wise)
  - Vector dot product
  - Vector cross product  
  - Vector length/magnitude
  - Vector varying data scenarios

### 3. New Functions

#### `printHelp(writer)`
- Shows usage instructions and available options
- Displays examples of correct command usage
- Called for invalid arguments or explicit help requests

#### `runBenchmarks(allocator, writer, category)`
- Handles benchmark execution with optional category filtering
- Maintains all existing zbench configuration
- Adds appropriate header based on category selection
- Preserves all original benchmark functionality

### 4. Enhanced Main Function

- Parses command-line arguments using `std.process.argsAlloc()`
- Implements proper error handling for invalid arguments
- Delegates to appropriate functions based on command
- Shows help for missing or invalid arguments
- Exits with error code 1 for invalid commands

### 5. Maintained Features

- All original benchmark functions unchanged
- Same zbench configuration (500k iterations, 5s budget, allocation tracking)
- All vector operations preserved (mul, dot, cross, len, varying data)
- Both zalgebra and zm library comparisons maintained

## Future Expansion

The structure is prepared for easy addition of new benchmark categories:

```zig
const BenchmarkCategory = enum {
    vec,
    matrix,     // Future matrix operations
    quaternion, // Future quaternion operations
    // etc.
};
```

New benchmarks can be easily added to the `BENCHMARKS` array with appropriate categorization.

## Error Handling

- Invalid command-line arguments show error message and help
- Graceful handling of missing arguments
- Non-zero exit codes for error conditions
- Clear error messages with suggestions

This refactoring maintains 100% backward compatibility for the benchmark functionality while adding the requested command-line interface and preparing for future game-dev focused expansions.