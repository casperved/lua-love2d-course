# Assignment 09: Smooth Animation with Delta Time

Your programs have been drawing things that stay still. Now let's make them **move** — smoothly, correctly, on any computer!

---

## What is `dt` (delta time)?

Every time `love.update` is called, LÖVE passes in `dt` — the number of **seconds** since the last frame. On a fast computer running at 60 frames per second, `dt` is about `0.0167`. On a slower computer it might be `0.033`.

**Why does this matter?** Imagine you move a ball like this:

```lua
-- BAD: no dt
ball.x = ball.x + 5   -- moves 5 pixels every frame
```

On a 60 FPS machine the ball moves 300 pixels/second. On a 30 FPS machine it only moves 150 pixels/second. The game feels different on every computer!

```lua
-- GOOD: use dt
ball.x = ball.x + 300 * dt   -- always moves 300 pixels per second
```

Multiplying by `dt` makes speed **frame-rate independent**. Always use it when moving things!

---

## Circles with `math.cos` and `math.sin`

`math.cos` and `math.sin` are functions that take an **angle** (in radians) and return a value between -1 and 1. They are perfect for circular motion:

```
x = centerX + math.cos(angle) * radius
y = centerY + math.sin(angle) * radius
```

As `angle` increases from 0 to `2 * math.pi` (one full revolution), the point traces a perfect circle around the center!

To animate this, increase `angle` each frame using `dt`:

```lua
angle = angle + speed * dt
```

A `speed` of `1.0` means one radian per second — roughly one full orbit every 6.3 seconds. Increase it to orbit faster.

---

## Radians — a quick explainer

Angles in Lua are measured in **radians**, not degrees:
- `0` = facing right
- `math.pi / 2` ≈ 1.57 = facing down
- `math.pi` ≈ 3.14 = facing left
- `2 * math.pi` ≈ 6.28 = one full circle back to the start

---

## Your Mission

Build a mini solar system!

- A **sun** sits at the center of the screen.
- A **planet** orbits the sun. Its position uses `math.cos(angle)` and `math.sin(angle)`.
- `angle` grows every frame: `angle = angle + orbitSpeed * dt`
- A **moon** orbits the planet (same idea, but centered on the planet's position).
- Press `R` to reset both angles to 0.

Open `starter/main.lua` and follow the TODO comments!

---

## Hints

<details><summary>Hint 1 — How do I update the planet's angle and position?</summary>

Inside `love.update(dt)`:

```lua
angle   = angle + orbitSpeed * dt
planetX = sunX + math.cos(angle) * orbitRadius
planetY = sunY + math.sin(angle) * orbitRadius
```

`math.cos` gives the horizontal offset, `math.sin` gives the vertical offset. Multiply by `orbitRadius` to control how far away the planet is.
</details>

<details><summary>Hint 2 — How do the moon's calculations work?</summary>

The moon orbits the **planet**, so use `planetX` and `planetY` as the center:

```lua
moonAngle = moonAngle + moonSpeed * dt
moonX     = planetX + math.cos(moonAngle) * moonOrbitRadius
moonY     = planetY + math.sin(moonAngle) * moonOrbitRadius
```

Make sure `planetX` and `planetY` are calculated first (earlier in `love.update`), or the moon will lag one frame behind.
</details>

<details><summary>Hint 3 — How do I draw the planet and moon?</summary>

In `love.draw`, after the sun:

```lua
-- Planet
love.graphics.setColor(0.2, 0.5, 1)
love.graphics.circle("fill", planetX, planetY, planetRadius)

-- Moon
love.graphics.setColor(0.8, 0.8, 0.8)
love.graphics.circle("fill", moonX, moonY, moonRadius)
```

You can also draw a faint orbit ring for the moon:

```lua
love.graphics.setColor(0.25, 0.25, 0.25)
love.graphics.circle("line", planetX, planetY, moonOrbitRadius)
```
</details>

---

## Stretch Goals

1. **Second planet** — Add a second planet with a different orbit radius and speed. Give it its own angle variable!
2. **Trails** — Keep a table of the last 30 positions of the planet and draw small fading circles along the trail. Remove old positions as new ones are added.
3. **Elliptical orbit** — Make the planet's orbit an ellipse instead of a circle by using a different multiplier for X and Y: `planetX = sunX + math.cos(angle) * orbitRadius * 1.5` (wider) and `planetY = sunY + math.sin(angle) * orbitRadius * 0.8` (shorter).
