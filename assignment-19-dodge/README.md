# Assignment 19: Mini Project — Dodge!

Welcome to your second mini project! This one's a top-down survival game where the enemies never stop coming. Your only job is to *not get touched*. Simple to understand, surprisingly hard to master — the best kind of game.

---

## What You're Building

- Your player is a green circle in the middle of the screen.
- Move in all 4 directions with **Arrow Keys** or **WASD**.
- Red enemies spawn continuously from random edges of the screen.
- Each enemy steers directly toward you.
- Survive as long as possible — your best time is saved for the session.
- As time passes, enemies spawn faster.

About 70% of the game is already written. Three pieces of core logic are left for you.

---

## The Three TODOs

| # | What to do |
|---|-----------|
| TODO 1 | Spawn an enemy at a random edge of the screen |
| TODO 2 | Move each enemy toward the player using a direction vector |
| TODO 3 | Check if an enemy touches the player (circle collision) |

---

## Vectors: Moving Toward a Target

This assignment introduces a useful idea: the **direction vector**.

If you want something to move toward a point, you:
1. Find the difference: `dx = targetX - myX`, `dy = targetY - myY`
2. Find the length: `len = math.sqrt(dx*dx + dy*dy)`
3. **Normalise** it (make it length 1): `dx = dx / len`, `dy = dy / len`
4. Multiply by speed: `myX = myX + dx * speed * dt`

Step 3 is the key. Without normalising, diagonal movement would be faster than straight movement. After normalising, the direction is always exactly length 1 regardless of how far away the target is.

```lua
local dx  = player.x - e.x
local dy  = player.y - e.y
local len = math.sqrt(dx * dx + dy * dy)
if len > 0 then
    e.x = e.x + (dx / len) * e.speed * dt
    e.y = e.y + (dy / len) * e.speed * dt
end
```

---

## Circle Collision

Two circles overlap when the distance between their centres is less than the sum of their radii:

```lua
local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
if dist < player.size + e.size then
    -- collision!
end
```

`^2` is Lua's power operator (same as `math.pow(x, 2)`).

---

## Hints

<details><summary>Hint 1 — Spawning from random edges (TODO 1)</summary>

Pick a random side (1 = top, 2 = bottom, 3 = left, 4 = right), then set `ex` and `ey` based on that side. Use `-15` or `SCREEN_W + 15` so the enemy starts just out of view:

```lua
local side = math.random(1, 4)
local ex, ey
if side == 1 then
    ex = math.random(SCREEN_W)
    ey = -15
elseif side == 2 then
    ex = math.random(SCREEN_W)
    ey = SCREEN_H + 15
elseif side == 3 then
    ex = -15
    ey = math.random(SCREEN_H)
else
    ex = SCREEN_W + 15
    ey = math.random(SCREEN_H)
end
table.insert(enemies, { x = ex, y = ey, size = 12, speed = math.random(80, 180) })
```

</details>

<details><summary>Hint 2 — Steering toward the player (TODO 2)</summary>

Put this code inside the enemy loop, replacing the TODO 2 comment:

```lua
local dx  = player.x - e.x
local dy  = player.y - e.y
local len = math.sqrt(dx * dx + dy * dy)
if len > 0 then
    e.x = e.x + (dx / len) * e.speed * dt
    e.y = e.y + (dy / len) * e.speed * dt
end
```

After you do this, run the game — the red dots should start chasing you!

</details>

<details><summary>Hint 3 — Circle collision (TODO 3)</summary>

Still inside the enemy loop, after the movement code:

```lua
local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
if dist < player.size + e.size then
    bestTime  = math.max(bestTime, survivalTime)
    gameState = "gameover"
end
```

You don't need to break the loop — once `gameState` becomes `"gameover"` the update function returns at the top next frame, so it won't double-trigger.

</details>

---

## Stretch Goals

1. **Speed boost** — Hold Shift to sprint at 1.8x speed, but only for 2 seconds before you need to rest. Track a `boostCooldown` timer.
2. **Enemy variety** — Every 20 seconds, spawn a "fast" enemy (red-orange, smaller, speed 250-350) alongside the regular ones.
3. **Safe zone** — Draw a small white circle at the centre. If the player stands inside it for 3 full seconds without moving, all enemies on screen disappear (a "panic button"). Reset the timer if the player moves.
