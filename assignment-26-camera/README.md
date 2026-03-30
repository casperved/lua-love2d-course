# Assignment 26: Camera & Scrolling World

## What you'll learn

How to make the game world bigger than the screen — and how to move a "camera" so it always follows the player.

---

## How it works

So far, every object in your game has been drawn exactly where it lives on screen. The level fit neatly inside the window. Easy!

But what if the level is **three times wider than the screen**? You can't shrink everything. Instead, you need a **camera**.

### Think of it like a phone camera filming a parade

Imagine a parade marching down a long street. Your phone screen only shows a small slice of the street at a time. As the float moves right, you pan the phone right so the float stays in the middle. The street doesn't move — your view of it moves.

In a game it works the same way. The world is big and stays put. What changes is *which part of the world you are looking at*.

### camX — the camera's position

`camX` is a single number: **how many pixels from the left edge of the world the camera is sitting**. When `camX = 0`, you are looking at the very start of the level. When `camX = 800`, you have slid the view 800 pixels to the right.

To keep the player in the centre of the screen, you aim the camera at the player:

```lua
camX = player.x + player.w / 2 - SCREEN_W / 2
```

That says: "put the centre of the player at the centre of the screen."

### Clamping — don't look past the edges

If the player walks near the left wall, the formula above would try to show space *before* the level starts. That looks horrible. So you clamp `camX` so it never goes below `0` or above `LEVEL_W - SCREEN_W`:

```lua
camX = math.max(0, math.min(camX, LEVEL_W - SCREEN_W))
```

Think of it like a fence on both sides. The camera can slide freely in the middle, but the fence stops it at the edges.

### push / translate / pop — shifting the whole world

To actually move the picture, you use three LÖVE calls:

```lua
love.graphics.push()              -- "remember where we are"
love.graphics.translate(-camX, 0) -- slide everything left by camX pixels
-- ... draw the world here ...
love.graphics.pop()               -- "go back to normal"
```

`translate(-camX, 0)` shifts every draw call to the left by `camX` pixels. So an object at world position `x = 800` will appear at screen position `800 - camX`. When `camX = 800`, that object is at screen x = 0 (the left edge). When `camX = 0`, it is at screen x = 800 (the right edge). The world scrolls!

### The HUD must go AFTER pop

Your score, lives counter, and any other on-screen labels should **not** scroll with the world. Draw them after `love.graphics.pop()`. At that point the coordinates are back to normal screen positions, so `print("Score: 3", 10, 10)` always appears in the top-left corner of the window no matter where the player is.

---

## Your mission

Open `starter/main.lua`. There are **three TODO sections** to fill in:

1. **TODO 1 — Calculate camX** (inside `love.update`): Centre the camera on the player and clamp it to the level.
2. **TODO 2 — Apply the camera transform** (inside `love.draw`): Wrap the world-drawing code in `push` / `translate` / `pop`.
3. **TODO 3 — Draw the HUD after pop** (at the end of `love.draw`): Print the score so it stays fixed on screen.

Controls:
- **Left / Right arrow** — move
- **Space or Up arrow** — jump

When everything works, you can walk across all 2400 pixels of level, collect every coin, and the camera will follow you smoothly — stopping cleanly at both edges.

---

## Hints

<details><summary>Hint 1 — how do I calculate camX?</summary>

You want the player to sit in the middle of the screen. The middle of the player (in world coordinates) is `player.x + player.w / 2`. Subtract half the screen width to find where the camera's left edge should be:

```lua
camX = player.x + player.w / 2 - SCREEN_W / 2
camX = math.max(0, math.min(camX, LEVEL_W - SCREEN_W))
```

The second line is the clamp. `math.max(0, ...)` stops it going below zero. `math.min(..., LEVEL_W - SCREEN_W)` stops it going too far right.

</details>

<details><summary>Hint 2 — where exactly do push, translate, and pop go?</summary>

In `love.draw`, call `push` and `translate` *before* you draw any part of the world. Call `pop` *after* the last world object:

```lua
love.graphics.push()
love.graphics.translate(-camX, 0)

-- draw floor, platforms, coins, player here

love.graphics.pop()
```

Note the minus sign on `camX`. You are sliding the drawing canvas to the *left*, so that world objects appear in the right place on screen.

</details>

<details><summary>Hint 3 — my score text is scrolling off screen, what's wrong?</summary>

The HUD must be drawn **after** `love.graphics.pop()`. If you draw text before `pop`, it gets shifted by the camera translation just like everything else, and it will wander off screen as the player moves.

```lua
love.graphics.pop()   -- camera off — back to screen coords

love.graphics.setColor(1, 1, 1)
love.graphics.print("Score: " .. score .. " / " .. totalCoins, 12, 10)
```

</details>

---

## Stretch Goals

- **Smooth camera lag** — instead of snapping instantly to the player, ease toward the target: `camXSmooth = camXSmooth + (camX - camXSmooth) * 6 * dt`. Use `camXSmooth` in `translate` for a buttery feel.
- **Parallax background** — draw a wide background strip at *half* the camera speed so it scrolls slower than the ground. This gives a sense of depth for free.
- **Mini-map** — draw a tiny bar at the bottom of the screen. A small dot shows where the player is along the level. Use `player.x / LEVEL_W` to find the fraction.
- **Camera shake on hard landing** — when the player lands with a high downward speed, add a small random offset to the camera for 0.2 seconds to make the impact feel punchy.
