# Assignment 31: Waypoint Pathfinding

You know those tower defense games where enemies walk along a winding road while you try to stop them? This assignment builds that road-walking system from scratch.

Enemies will spawn one by one at the green START dot, march along a curvy S-shaped path, and disappear at the red EXIT dot — unless you click them first!

---

## What you'll learn

How to make a moving character follow a list of checkpoints, one after the other, using direction math.

---

## How it works

### The path is just a list of dots

Imagine drawing a winding road on paper by placing dots and connecting them with lines. That is exactly what the code does:

```lua
path = {
    {x=50,  y=500},   -- dot 1  (START)
    {x=200, y=150},   -- dot 2
    {x=400, y=450},   -- dot 3
    -- ... and so on
}
```

Each dot has an `x` and `y` position on screen. Enemies walk from dot 1, to dot 2, to dot 3, all the way to the last dot (EXIT).

### Each enemy remembers which dot it is heading toward

Every enemy is a little table of data:

```lua
local e = {
    x             = path[1].x,   -- start at dot 1
    y             = path[1].y,
    speed         = 110,          -- pixels per second
    waypointIndex = 1,            -- "I am heading toward dot 1"
}
```

The key piece is `waypointIndex`. It starts at 1. When the enemy reaches dot 1 it changes to 2. When it reaches dot 2 it changes to 3, and so on.

### Moving toward the next dot

Every frame, the enemy needs to take a small step toward its current target dot. Here is the idea in plain English:

1. Find the gap between the enemy and the target: `dx = target.x - e.x`
2. Find the straight-line distance to the target using the Pythagorean theorem: `dist = math.sqrt(dx*dx + dy*dy)`
3. Divide `dx` and `dy` by `dist` to get a "direction" (a pair of numbers each between -1 and 1 that point exactly toward the target)
4. Multiply by `speed * dt` to move the right number of pixels this frame

Think of it like a compass needle. The needle always points toward your destination. You just follow it a tiny bit each frame.

```lua
local dx   = target.x - e.x
local dy   = target.y - e.y
local dist = math.sqrt(dx*dx + dy*dy)
if dist > 0 then
    e.x = e.x + (dx / dist) * e.speed * dt
    e.y = e.y + (dy / dist) * e.speed * dt
end
```

### Knowing when to move to the next dot

The enemy does not need to land exactly on the dot pixel-perfect. When it gets within 20 pixels, that is close enough — we snap it to the next target:

```lua
if dist < WAYPOINT_THRESHOLD then
    e.waypointIndex = e.waypointIndex + 1
end
```

### What happens at the exit

Once `waypointIndex` is higher than the total number of dots, the enemy has walked past the last dot and escaped. Remove it from the list and lose a life.

---

## Your Mission

Open `starter/main.lua`. Find the three `-- TODO` comments inside `love.update`. Fill them in one by one:

1. **TODO 1** — Calculate `dx`, `dy`, and `dist` to the current target waypoint. If `dist > 0`, move the enemy toward it.
2. **TODO 2** — After moving, check if `dist < WAYPOINT_THRESHOLD`. If so, add 1 to `e.waypointIndex`.
3. **TODO 3** — Check if `e.waypointIndex > #path`. If so, remove the enemy and subtract 1 from `lives`.

When all three are done, enemies will march along the path. Left-click any enemy to destroy it before it escapes. You have 5 lives — good luck!

---

## Hints

<details>
<summary>Hint 1 — The direction math feels scary. Here is a step-by-step breakdown.</summary>

Think of `dx` and `dy` as "how far left/right" and "how far up/down" you need to travel. `dist` is the straight-line distance (like a ruler, not following roads).

Dividing by `dist` shrinks both numbers so the pair always has a combined "length" of 1. That is called a unit vector, and it just means "a direction with no size attached." Then you re-scale it by speed and dt to get the right step size for this frame.

```lua
local target = path[e.waypointIndex]
local dx   = target.x - e.x
local dy   = target.y - e.y
local dist = math.sqrt(dx*dx + dy*dy)
if dist > 0 then
    e.x = e.x + (dx / dist) * e.speed * dt
    e.y = e.y + (dy / dist) * e.speed * dt
end
```

The `if dist > 0` check stops a divide-by-zero crash when the enemy is sitting exactly on top of the waypoint.
</details>

<details>
<summary>Hint 2 — How do I know the enemy is "close enough" to the waypoint?</summary>

Use the same `dist` you already calculated in TODO 1. The constant `WAYPOINT_THRESHOLD` is set to 20 pixels at the top of the file. If the enemy is within 20 pixels, it is close enough — bump the index up.

```lua
if dist < WAYPOINT_THRESHOLD then
    e.waypointIndex = e.waypointIndex + 1
end
```

Put this right after the movement code, still inside the loop.
</details>

<details>
<summary>Hint 3 — Removing an enemy while looping through the list safely.</summary>

The loop already counts backward (`for i = #enemies, 1, -1 do`). That is on purpose! When you remove item number 5 from a list, items 6, 7, 8... all slide down by one. Counting backward means you always visit items you have not checked yet — their indices have not changed.

```lua
if e.waypointIndex > #path then
    table.remove(enemies, i)
    lives = lives - 1
end
```

`#path` is the total number of waypoints. Once the index is higher than that, the enemy has passed the last dot.
</details>

---

## Stretch Goals

1. **Speed variation** — when spawning an enemy, give it a slightly random speed: `speed = ENEMY_SPEED + math.random(-20, 20)`. A mixed-speed horde is harder to manage!
2. **Enemy health** — give each enemy `hp = 3`. Each click reduces `hp` by 1. Only remove the enemy when `hp <= 0`. The health bar is already drawn — just change how much damage a click deals.
3. **Spawn waves** — instead of a non-stop timer, define rounds like `wave 1 = 3 enemies`, `wave 2 = 6 enemies`. Show a "Wave incoming!" message between rounds.
