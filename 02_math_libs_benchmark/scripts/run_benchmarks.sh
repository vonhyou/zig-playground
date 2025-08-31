#!/bin/bash

# Local benchmark runner script for 02_math_libs_benchmark
# Runs the full benchmark suite and saves results to results/latest.csv

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCHMARK_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="$BENCHMARK_DIR/results"

cd "$BENCHMARK_DIR"

echo "Running math library benchmarks..."
echo "Benchmark directory: $BENCHMARK_DIR"
echo "Results directory: $RESULTS_DIR"
echo

# Ensure results directory exists
mkdir -p "$RESULTS_DIR"

# Run benchmarks with ReleaseFast optimization
echo "Building and running benchmarks (this may take a few minutes)..."
OUTPUT_FILE="$RESULTS_DIR/latest.txt"
CSV_FILE="$RESULTS_DIR/latest.csv"

# Run the benchmark and capture output
zig build run -Doptimize=ReleaseFast -- all > "$OUTPUT_FILE" 2>&1

echo "Benchmark run completed. Output saved to: $OUTPUT_FILE"

# Note: For now, we keep the text output. A future enhancement could parse
# this into CSV format automatically, but that's beyond the current scope
# since the focus is on SIMD benchmark additions, not output parsing.

echo "To view results:"
echo "  cat $OUTPUT_FILE"
echo
echo "To run specific categories:"
echo "  zig build run -Doptimize=ReleaseFast -- vec      # Vector operations"
echo "  zig build run -Doptimize=ReleaseFast -- matrix   # Matrix operations"
echo "  zig build run -Doptimize=ReleaseFast -- quat     # Quaternion operations"
echo "  zig build run -Doptimize=ReleaseFast -- gamedev  # GameDev operations"
echo
echo "To run with native CPU optimizations:"
echo "  zig build run -Doptimize=ReleaseFast -Dcpu=native -- all"