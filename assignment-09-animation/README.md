# Assignment 09: Smooth Animation with Delta Time

Build a mini solar system where a planet orbits the sun and a moon orbits the planet — all moving smoothly on any computer!

---

## What you'll learn

How to use **delta time** (`dt`) and **math.cos / math.sin** to make things move in smooth, perfectly circular orbits.

---

## How it works

### Why does smooth animation need `dt`?

Imagine a toy car that moves one centimeter every time you clap your hands. If you clap fast, the car zooms. If you clap slowly, it crawls. The car's speed depends on how fast *you* clap — not how fast the car is *supposed* to go.

Games have the same problem. LÖVE calls `love.update` once per frame. A fast computer gets 60 frames every second. A slow computer might only get 30. If you move a ball by 5 pixels each frame, it goes twice as fast on the fast computer!

The fix is **delta time**. Every frame, LÖVE hands you a tiny number called `dt` — the number of seconds that passed since the last frame. On a 60 FPS machine, `dt` is about `0.016`. On a 30 FPS machine, `dt` is about `0.033`.

When you multiply your speed by `dt`, slower computers take bigger steps and faster computers take smaller steps. The ball always travels the same distance per second, no matter what:

```lua
-- BAD: speed depends on frame rate
ballX = ballX + 5

-- GOOD: always moves 300 pixels per second
ballX = ballX + 300 * dt
```

### How do you move something in a circle?

You used `math.cos` and `math.sin` in assignment 07B to draw star shapes. Here you'll use them again — but this time to *move* things along a circular path.

Picture the hand of a clock. It always stays the same distance from the center — it just changes *angle* over time.

Two math functions do this job:
- `math.cos(angle)` — how far to move **left or right**
- `math.sin(angle)` — how far to move **up or down**

Both return a number between -1 and 1. Multiply by a radius to control the circle's size:

```lua
x = centerX + math.cos(angle) * radius
y = centerY + math.sin(angle) * radius
```

To keep the object moving, increase `angle` a little every frame using `dt`:

```lua
angle = angle + speed * dt
```

A `speed` of `1.0` means one radian per second. A full circle is about `6.28` radians (that's `2 * math.pi`), so the object completes one orbit every ~6 seconds. Bigger speed = faster orbit.

### What are radians?

Radians are just a different way to measure angles — like Celsius vs Fahrenheit, but for rotation.

| Degrees | Radians |
|---------|---------|
| 0° (pointing right) | `0` |
| 90° (pointing down) | `math.pi / 2` ≈ 1.57 |
| 180° (pointing left) | `math.pi` ≈ 3.14 |
| 360° (full circle) | `2 * math.pi` ≈ 6.28 |

Lua and LÖVE always use radians, so you'll get used to them quickly!

---

## Your mission

The starter already draws the sun and the orbit rings. Your job is to make everything *move*:

- **TODO 1** — Increase the planet's `angle` each frame and calculate its new x/y position.
- **TODO 2** — Do the same for the moon, but orbit around the planet instead of the sun.
- **TODO 3** — Draw the sun, the planet, and the moon.

Planet 2 and the trail are already pre-filled — read that code and you'll see the exact same pattern you need for TODO 1.

When it's all working you'll see a planet circling the sun and a moon circling the planet. Press `R` to reset the angles back to zero.

---

## Hints

<details><summary>Hint 1 — Updating the planet's angle and position</summary>

Inside `love.update(dt)`, add these two steps:

```lua
angle   = angle + orbitSpeed * dt
planetX = sunX + math.cos(angle) * orbitRadius
planetY = sunY + math.sin(angle) * orbitRadius
```

`math.cos` gives the left/right offset and `math.sin` gives the up/down offset. Multiplying by `orbitRadius` stretches the circle to the right size.
</details>

<details><summary>Hint 2 — Making the moon follow the planet</summary>

The moon's math is identical to the planet's — just swap the center point. Use `planetX` / `planetY` instead of `sunX` / `sunY`:

```lua
moonAngle = moonAngle + moonSpeed * dt
moonX     = planetX + math.cos(moonAngle) * moonOrbitRadius
moonY     = planetY + math.sin(moonAngle) * moonOrbitRadius
```

Make sure the planet's position is already calculated before you do this, or the moon will be one frame behind.
</details>

<details><summary>Hint 3 — Drawing the planet and moon</summary>

In `love.draw`, after the sun:

```lua
-- Planet (blue)
love.graphics.setColor(0.2, 0.5, 1.0)
love.graphics.circle("fill", planetX, planetY, planetRadius)

-- Moon (grey)
love.graphics.setColor(0.75, 0.75, 0.75)
love.graphics.circle("fill", moonX, moonY, moonRadius)
```

You can also draw a faint ring to show the moon's orbit path:

```lua
love.graphics.setColor(0.22, 0.22, 0.22)
love.graphics.circle("line", planetX, planetY, moonOrbitRadius)
```
</details>

---

## Stretch Goals

1. **Second planet** — Add a second planet with a bigger orbit radius and a slower speed. Give it its own `angle2` variable so it moves independently.
2. **Trails** — Keep a table of the last 40 positions of the planet. Each frame, add the current position and remove the oldest one if the table gets too long. Draw each saved position as a tiny fading circle — the glow effect in the solution uses `alpha = i / #trail * 0.5`.
3. **Speed variation** — Make orbit speed depend on distance: `angle = angle + (200 / orbitRadius) * dt`. Bodies close to the sun zip around fast; distant ones drift slowly — just like the real solar system!
