# Assignment 05: Bouncing Ball

## What you'll learn

How to make a ball move on its own and bounce off all four walls by flipping its velocity.

---

## How it works

So far you've moved things by pressing keys. This time the ball moves **by itself** — like a screensaver or a pinball machine. No keys needed!

### Velocity: speed + direction in one number

Imagine you're rolling a toy car. You can roll it left or right. The speed tells you *how fast*, but you also need to know *which way*.

We use **two numbers** to describe the ball's motion:

- `ballVX` — how fast it moves left/right
  - positive number → moving **right**
  - negative number → moving **left**
- `ballVY` — how fast it moves up/down
  - positive number → moving **down** (in LÖVE2D, y=0 is the top of the screen)
  - negative number → moving **up**

Every single frame, we nudge the ball by its velocity:

```lua
ballX = ballX + ballVX * dt
ballY = ballY + ballVY * dt
```

(`dt` is the tiny slice of time since the last frame — it keeps everything smooth no matter how fast the computer is.)

### Bouncing: just flip the sign!

Think about a rubber ball hitting a wall. It comes in from the right, hits the wall, and goes back out to the right. The **direction flips**, but the speed stays the same.

In code, "flip the direction" means **multiply by -1**:

```lua
ballVX = -ballVX    -- 250 becomes -250, or -250 becomes 250
```

That's the whole secret. Bouncing is just one line of math!

### Where is the ball's edge?

The ball is a circle. Its center is at `(ballX, ballY)` and it has a `ballRadius`. So:

| Edge | Position |
|------|----------|
| Left edge | `ballX - ballRadius` |
| Right edge | `ballX + ballRadius` |
| Top edge | `ballY - ballRadius` |
| Bottom edge | `ballY + ballRadius` |

When an edge crosses a wall, it's time to bounce.

### The sneaky "stuck in the wall" bug — and how to fix it

Sometimes the ball moves fast enough that in one frame it goes *past* the wall. If you only flip the velocity, the next frame it's still past the wall, so it flips again... and again... and the ball gets stuck!

The fix is simple: after flipping, **snap the ball back** so its edge is exactly touching the wall:

```lua
if ballX - ballRadius < 0 then
    ballVX = -ballVX        -- flip direction
    ballX = ballRadius      -- push ball back so it just touches the left wall
end
```

---

### keypressed vs isDown — a quick reminder

You may notice `love.keypressed` already in the starter file (it handles the R-to-reset). This is the function LÖVE2D calls **once** the instant a key is pressed — great for one-shot actions like resetting the ball.

That is different from `love.keyboard.isDown` (used in assignment 04), which returns `true` every frame the key is held — great for smooth continuous movement.

Rule of thumb: one-shot action → `keypressed`. Held movement → `isDown`.

---

## Your mission

Open `starter/main.lua`. The movement code is already written for you. Your job is to fill in the **four bounce checks** — one for each wall.

Each check does the same three things:
1. Test whether the ball's edge has crossed the wall
2. Flip the matching velocity
3. Snap the ball back so it touches (but doesn't cross) the wall
4. Call `newRandomColor()` to change the ball's color on bounce

When you're done, the ball should fly around and never leave the screen. Press **R** to reset it to the center.

---

## Hints

<details><summary>Hint 1 — Left wall bounce</summary>

The left wall is at x = 0. The ball's left edge is `ballX - ballRadius`. When that goes below 0, it's time to bounce.

The if-condition is already written in the starter. Inside the block, you need three lines:
- flip `ballVX`
- snap `ballX` so the left edge is exactly at 0 (that means `ballX = ballRadius`)
- call `newRandomColor()`
</details>

<details><summary>Hint 2 — Right wall bounce</summary>

Same idea, but on the other side. The right wall is at `SCREEN_W`. The ball crosses it when its right edge (`ballX + ballRadius`) goes past `SCREEN_W`.

When snapping back, you want the right edge to sit exactly at `SCREEN_W`:

```lua
ballX = SCREEN_W - ballRadius
```

For the top and bottom walls, do the same thing but use `ballVY`, `ballY`, and `SCREEN_H`.
</details>

<details><summary>Hint 3 — All four walls together</summary>

```lua
-- Bounce off LEFT wall
if ballX - ballRadius < 0 then
    ballVX = -ballVX
    ballX = ballRadius
    newRandomColor()
end

-- Bounce off RIGHT wall
if ballX + ballRadius > SCREEN_W then
    ballVX = -ballVX
    ballX = SCREEN_W - ballRadius
    newRandomColor()
end

-- Bounce off TOP wall
if ballY - ballRadius < 0 then
    ballVY = -ballVY
    ballY = ballRadius
    newRandomColor()
end

-- Bounce off BOTTOM wall
if ballY + ballRadius > SCREEN_H then
    ballVY = -ballVY
    ballY = SCREEN_H - ballRadius
    newRandomColor()
end
```
</details>

---

## Stretch Goals

1. **Speed up on every bounce.** Inside each bounce block, after flipping the velocity, multiply it by `1.05`. The ball will get faster each time it hits a wall. How long until it's a blur?

2. **Gravity.** In `love.update`, add a small constant to `ballVY` every frame: `ballVY = ballVY + 200 * dt`. Now the ball falls like a real rubber ball — it will bounce high off the floor and barely tick the ceiling.

3. **Second ball.** Add `ball2X`, `ball2Y`, `ball2VX`, `ball2VY` variables and copy all the movement and bounce logic for a second ball. Give it a different starting speed or color. Can you get them to share the screen without any issues? (We'll learn proper ball-on-ball collision in Assignment 11!)
