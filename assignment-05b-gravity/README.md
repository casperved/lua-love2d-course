# Assignment 05b — Gravity!

## What you'll learn

How to simulate gravity by adding a constant acceleration to vertical velocity each frame — and how a single extra line of code completely changes how a program *feels*.

---

## How it works

You already know how bouncing works from assignment 05. A ball moves, hits a wall, and its velocity flips. You did it for all four walls. Great work!

This time we add **one new idea: gravity**.

Think about dropping a rubber ball from your hand. The moment it leaves your fingers it starts falling — slowly at first, then faster and faster. By the time it hits the floor it's moving much quicker than when you let go. That's because gravity is constantly *pushing* it downward, adding a little more speed every second.

In code, we represent that with one line inside `love.update`:

```
ballVY = ballVY + GRAVITY * dt
```

That's it. Every single frame, `ballVY` gets a little bigger. The ball starts with `ballVY = 0` (not moving vertically at all), and by the time it reaches the floor it's traveling at several hundred pixels per second. You can watch the number grow right there on screen — it's very satisfying.

**Why multiply by `dt`?** Because `love.update` is called around 60 times per second, but not *exactly* 60. `dt` is the real time (in seconds) since the last frame. Multiplying by it keeps the ball moving at the same speed no matter how fast or slow the computer is running. You already used this trick in assignment 05 for movement — here it applies to acceleration too.

**What is `BOUNCE_DAMPEN`?** A perfect ball on a perfect floor would bounce forever — each bounce exactly as high as the last. Real rubber balls don't do that: each bounce is a bit shorter because a little energy is lost to heat and sound. `BOUNCE_DAMPEN = 0.85` means each floor bounce keeps 85% of the vertical speed. After a few bounces the ball barely hops at all. Try changing it to `1.0` and watch what happens!

---

## Your mission

Open `starter/main.lua`. The ball will appear near the top of the screen but won't move yet. Fill in the six TODOs in `love.update` to make it fly:

1. **TODO 1** — Apply gravity. Add `GRAVITY * dt` to `ballVY` every frame.
2. **TODO 2** — Move the ball. Add velocity × dt to each position (same as assignment 05).
3. **TODO 3** — Bounce off the left wall. The `if` condition is already written — fill in the 3-line body.
4. **TODO 4** — Bounce off the right wall. Write the whole `if` block.
5. **TODO 5** — Bounce off the top wall. Use `BOUNCE_DAMPEN` so a ceiling hit loses energy.
6. **TODO 6** — Bounce off the bottom wall (the floor). Use `BOUNCE_DAMPEN` here too — this is the main bounce and the reason the ball eventually comes to rest.

When everything works you should see the ball drop, pick up speed, bounce off the floor with a satisfying diminishing arc, and slowly settle. Press **R** to reset and watch it all over again.

---

## Hints

<details><summary>Hint 1 — The gravity line (TODO 1)</summary>

Gravity is just constant acceleration downward. In LÖVE2D, increasing `y` means moving *down* the screen, so we add to `ballVY`:

```lua
ballVY = ballVY + GRAVITY * dt
```

The `* dt` part is critical. Without it the ball would accelerate 60× too fast on a 60 fps machine and instantly fly off screen. With `dt`, the total speed increase per second is always exactly `GRAVITY` pixels/sec, no matter the frame rate.

</details>

<details><summary>Hint 2 — The left-wall bounce (TODO 3, and a reminder for TODOs 4 & 5)</summary>

The pattern for any wall is always three steps: flip the relevant velocity, snap the ball back inside the boundary, and call `newRandomColor()`. For the left wall:

```lua
if ballX - ballRadius < 0 then
    ballVX = -ballVX
    ballX  = ballRadius
    newRandomColor()
end
```

The right wall is the mirror image (check `ballX + ballRadius > SCREEN_W`, snap to `SCREEN_W - ballRadius`, flip `ballVX`). The top wall is the same idea but for `ballVY` and the `y` coordinate.

</details>

<details><summary>Hint 3 — The floor bounce with energy loss (TODO 6)</summary>

For the ceiling (TODO 5) and floor (TODO 6), instead of just flipping with `-ballVY`, multiply by `-BOUNCE_DAMPEN` to bleed off a little energy:

```lua
-- Floor bounce
if ballY + ballRadius > SCREEN_H then
    ballVY = -ballVY * BOUNCE_DAMPEN
    ballY  = SCREEN_H - ballRadius
    newRandomColor()
end
```

`-ballVY * BOUNCE_DAMPEN` does two things at once: the minus sign flips direction (upward), and `* BOUNCE_DAMPEN` shrinks the magnitude to 85% of what it was. Each successive bounce is therefore a little smaller, just like a real ball.

</details>

---

## Stretch Goals

You've already done the hard part in assignment 05 — gravity is just one extra line. If you want to go further:

1. **Crank up gravity.** Change `GRAVITY` from `500` to `1200` and run again. How does it feel different? What about `150`? Notice how the entire character of the simulation changes just by editing one number.

2. **Add a second ball.** Create `ball2X`, `ball2Y`, `ball2VX`, `ball2VY` with different starting values, and give it a slightly different `GRAVITY` constant (say, `350`). Draw and update it alongside the first ball. See how two balls with different gravities feel completely different even with identical starting speeds.

3. **Fading trail.** Before drawing the ball each frame, instead of clearing the screen with a solid colour, draw a semi-transparent dark rectangle over the whole screen:
   ```lua
   love.graphics.setColor(0.05, 0.05, 0.15, 0.3)
   love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
   ```
   Previous frames fade out gradually, leaving a glowing comet tail behind the ball.
