# Benchmark Results

This directory contains benchmark results and analysis artifacts for reference.

**Important**: These results are illustrative examples from development runs, not canonical benchmarks. Performance varies significantly based on hardware, system load, compiler optimizations, and other factors.

## Files

- `baseline.csv` - Initial baseline performance measurements
- `analysis.md` - Investigation of performance anomalies and cross-library differences
- `latest.csv` - Most recent benchmark run (if using local runner script)

## Running Benchmarks

```bash
# Run full benchmark suite
zig build run -- all

# Run with optimizations
zig build run -Doptimize=ReleaseFast -- all

# Run with native CPU optimizations
zig build run -Doptimize=ReleaseFast -Dcpu=native -- all
```