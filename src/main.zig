const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const screen_width: i32 = 800;
    const screen_height: i32 = 450;

    rl.SetConfigFlags(rl.FLAG_WINDOW_HIGHDPI);
    rl.InitWindow(screen_width, screen_height, "raylib: zig playground");
    defer rl.CloseWindow();

    var ball_pos: rl.Vector2 = .{
        .x = @as(f32, @floatFromInt(screen_width)) / 2.0,
        .y = @as(f32, @floatFromInt(screen_height)) / 2.0,
    };

    rl.SetTargetFPS(60);

    const speed: f32 = 2.0;
    while (!rl.WindowShouldClose()) {
        if (rl.IsKeyDown(rl.KEY_RIGHT)) ball_pos.x += speed;
        if (rl.IsKeyDown(rl.KEY_LEFT)) ball_pos.x -= speed;
        if (rl.IsKeyDown(rl.KEY_UP)) ball_pos.y -= speed;
        if (rl.IsKeyDown(rl.KEY_DOWN)) ball_pos.y += speed;

        rl.BeginDrawing();
        rl.ClearBackground(rl.GRAY);
        rl.DrawCircleV(ball_pos, 50, rl.BLUE);
        rl.DrawText("Move the ball w/ arrow keys :p", 10, 10, 20, rl.YELLOW);
        rl.EndDrawing();

        std.debug.print("\rBall position: ({d}, {d})", .{ ball_pos.x, ball_pos.y });
    }
}
