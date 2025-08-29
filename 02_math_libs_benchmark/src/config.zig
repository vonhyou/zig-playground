const zbench = @import("zbench");

pub const BENCHMARK_CONFIG = zbench.Config{
    .max_iterations = 500000,
    .time_budget_ns = 5_000_000_000, // 5 seconds
    .track_allocations = true,
};