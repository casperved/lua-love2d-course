# Assignment 05: Bouncing Ball

In the last assignment you moved things with keyboard input. Now let's make something move **on its own** — a ball that flies around and bounces off every wall like a pinball. This is the foundation of almost every physics-based game ever made.

---

## Velocity: Speed With Direction

So far we've used `playerSpeed` as a simple number — just how fast something moves. But speed alone doesn't tell the whole story. Which *direction* is it moving?

**Velocity** combines both speed and direction into one value. We store it as two variables:
- `vx` — velocity in the **x direction** (positive = moving right, negative = moving left)
- `vy` — velocity in the **y direction** (positive = moving down, negative = moving up)

Every frame, we add the velocity to the position:
```lua
ballX = ballX + ballVX * dt
ballY = ballY + ballVY * dt
```

If `ballVX` is `250`, the ball moves right at 250 pixels per second. If `ballVX` is `-250`, it moves left at 250 pixels per second.

---

## Bouncing: Flipping the Velocity

When the ball hits a wall, we want it to bounce. What does bouncing actually mean physically? The ball **reverses direction**.

If the ball is moving right (`ballVX = 250`) and hits the right wall, we flip `ballVX` so it moves left instead:

```lua
ballVX = ballVX * -1    -- 250 becomes -250
```

Or more neatly written:
```lua
ballVX = -ballVX
```

That's literally all bouncing is! Multiply the velocity by -1.

---

## Detecting Wall Collisions

The ball is a circle with a **center** at `(ballX, ballY)` and a **radius**. So:
- The **left edge** of the ball is at `ballX - ballRadius`
- The **right edge** is at `ballX + ballRadius`
- The **top edge** is at `ballY - ballRadius`
- The **bottom edge** is at `ballY + ballRadius`

The screen goes from `0` to `SCREEN_W` horizontally and `0` to `SCREEN_H` vertically.

So the four wall conditions are:
```lua
ballX - ballRadius < 0          -- hit left wall
ballX + ballRadius > SCREEN_W   -- hit right wall
ballY - ballRadius < 0          -- hit top wall
ballY + ballRadius > SCREEN_H   -- hit bottom wall
```

When one of these is true, flip the matching velocity!

---

## Preventing Sticking

There's a sneaky bug: if the ball moves fast enough, it might go slightly *past* the wall in one frame, flip its velocity, but then next frame it's still past the wall — so it flips again, and gets stuck vibrating!

The fix: after flipping, **push the ball back** to exactly touch the wall:
```lua
if ballX - ballRadius < 0 then
    ballVX = -ballVX
    ballX = ballRadius    -- snap ball back so it's touching, not past, the wall
end
```

---

## Your Mission

Open `starter/main.lua`. The ball movement is already written. Fill in the TODOs to add bounce conditions for all **four walls** — left, right, top, and bottom.

Press `R` to reset the ball to the center (that code is already there for you).

---

## Hints

<details>
<summary>Hint 1 — Left and right wall bounces</summary>

```lua
-- Left wall: ball's left edge goes past x=0
if ballX - ballRadius < 0 then
    ballVX = -ballVX
    ballX = ballRadius
end

-- Right wall: ball's right edge goes past SCREEN_W
if ballX + ballRadius > SCREEN_W then
    ballVX = -ballVX
    ballX = SCREEN_W - ballRadius
end
```
</details>

<details>
<summary>Hint 2 — Top and bottom wall bounces</summary>

Same idea, but for y this time:

```lua
-- Top wall: ball's top edge goes past y=0
if ballY - ballRadius < 0 then
    ballVY = -ballVY
    ballY = ballRadius
end

-- Bottom wall: ball's bottom edge goes past SCREEN_H
if ballY + ballRadius > SCREEN_H then
    ballVY = -ballVY
    ballY = SCREEN_H - ballRadius
end
```
</details>

<details>
<summary>Hint 3 — Putting all four together</summary>

All four bounce checks go inside `love.update(dt)`, after the lines that move the ball. Order doesn't matter much — they're all independent checks:

```lua
function love.update(dt)
    -- Move
    ballX = ballX + ballVX * dt
    ballY = ballY + ballVY * dt

    -- Bounce left
    if ballX - ballRadius < 0 then
        ballVX = -ballVX
        ballX = ballRadius
    end
    -- Bounce right
    if ballX + ballRadius > SCREEN_W then
        ballVX = -ballVX
        ballX = SCREEN_W - ballRadius
    end
    -- Bounce top
    if ballY - ballRadius < 0 then
        ballVY = -ballVY
        ballY = ballRadius
    end
    -- Bounce bottom
    if ballY + ballRadius > SCREEN_H then
        ballVY = -ballVY
        ballY = SCREEN_H - ballRadius
    end
end
```
</details>

---

## Stretch Goals

1. **Speed it up over time!** Every time the ball bounces, multiply `ballVX` and `ballVY` by `1.05` to make it slightly faster. Watch it go!

2. **Color change on bounce!** Create a function `randomColor()` that sets `love.graphics.setColor` to a random color using `math.random()`. Call it every time the ball bounces off a wall.

3. **Multiple balls!** Create `ball2X`, `ball2Y`, `ball2VX`, `ball2VY`, `ball2Radius` variables and duplicate all the movement and bounce logic for a second ball. Can you get them to collide? (We'll learn proper collision in Assignment 11!)
