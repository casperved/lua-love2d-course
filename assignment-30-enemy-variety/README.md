# Assignment 30: Enemy Variety

Right now your game has enemies — but they all move the same way. Boring! Real games have enemies with different personalities. In this assignment you'll build **three enemy types** that each move in their own unique way, all living together in one list. Your job is to write the movement brain for each one.

## What you'll learn

- Storing different kinds of things in one table, and acting differently based on a `type` field
- How to make something "home in" on a target using a direction vector
- How to make something bounce off walls
- How to make something patrol back and forth between two points
- Using the right collision shape for each enemy (circles and rectangles)

## How it works

Think of the `enemies` table like a **bag of monsters**. Each monster is a little Lua table (like a card with stats written on it). Every card has a `type` field that says what kind of monster it is.

```lua
-- A red circle that chases you
{ type = "chaser",   x=100, y=100, r=14, speed=150, colour={1, 0.2, 0.2} }

-- A blue circle that bounces around like a pinball
{ type = "bouncer",  x=400, y=200, r=12, vx=130, vy=-90, colour={0.2, 0.4, 1} }

-- A yellow square that paces left and right like a guard
{ type = "patroller", x=200, y=400, w=20, h=20,
  x1=100, x2=500, speed=120, dir=1, colour={1, 0.9, 0.1} }
```

Once per frame, you loop through the bag and check the `type` field. Then you move each enemy the right way:

**Chaser** — like a heat-seeking missile. Every frame, figure out which direction the player is, then move that way. The trick is **normalizing** the direction vector (making it length 1) so the chaser always moves at the same speed no matter how far away it is.

**Bouncer** — like a pinball. It has a stored velocity (`vx`, `vy`). Every frame you just add that velocity to its position. When it hits a wall, you flip the right velocity component so it bounces back.

**Patroller** — like a guard pacing a hallway. It has a `dir` value that is either `1` (moving right) or `-1` (moving left). When it reaches the end of its patrol path, it flips `dir` and goes back.

Here is what the update loop looks like with all three branches:

```lua
for _, e in ipairs(enemies) do

    if e.type == "chaser" then
        local dx   = player.x - e.x     -- how far right is the player?
        local dy   = player.y - e.y     -- how far down is the player?
        local dist = math.sqrt(dx*dx + dy*dy)  -- straight-line distance
        if dist > 0 then
            e.x = e.x + (dx / dist) * e.speed * dt
            e.y = e.y + (dy / dist) * e.speed * dt
        end

    elseif e.type == "bouncer" then
        e.x = e.x + e.vx * dt
        e.y = e.y + e.vy * dt
        if e.x - e.r < 0        then e.x = e.r;            e.vx =  math.abs(e.vx) end
        if e.x + e.r > SCREEN_W then e.x = SCREEN_W - e.r; e.vx = -math.abs(e.vx) end
        if e.y - e.r < 0        then e.y = e.r;            e.vy =  math.abs(e.vy) end
        if e.y + e.r > SCREEN_H then e.y = SCREEN_H - e.r; e.vy = -math.abs(e.vy) end

    elseif e.type == "patroller" then
        e.x = e.x + e.dir * e.speed * dt
        if e.x >= e.x2 then e.x = e.x2; e.dir = -1 end
        if e.x <= e.x1 then e.x = e.x1; e.dir =  1 end
    end

end
```

Collision is already handled for you. Circles (chaser and bouncer) use a **circle-vs-circle** distance check. The patroller is a square, so it uses a **circle-vs-rectangle** check instead.

When the player is hit, they become briefly invincible and the screen edge flashes red — those parts are already written too.

## Your Mission

1. Open `starter/main.lua`. The game loads and enemies appear on screen, but they all stand completely still.
2. Find the three `-- TODO` blocks inside `love.update`.
3. Fill in the movement code for each enemy type. Each TODO shows you exactly what to uncomment.
4. Run the game (`love .` from inside the `starter/` folder).
5. Verify that chasers hunt you down, bouncers ping around like pinballs, and patrollers pace their beat.
6. Check that getting touched costs a life and makes you flash.

## Hints

<details>
<summary>Hint 1 — Chaser: how do I aim it at the player?</summary>

You need a direction from the enemy to the player. Subtract the enemy's position from the player's position:

```lua
local dx = player.x - e.x
local dy = player.y - e.y
```

Now `(dx, dy)` points toward the player, but it might be a really long vector. You want to shrink it down to length 1 (a "unit vector") so the speed stays constant. Divide both parts by the distance:

```lua
local dist = math.sqrt(dx*dx + dy*dy)
if dist > 0 then
    e.x = e.x + (dx / dist) * e.speed * dt
    e.y = e.y + (dy / dist) * e.speed * dt
end
```

The `if dist > 0` guard stops a crash if the enemy is sitting exactly on the player.
</details>

<details>
<summary>Hint 2 — Bouncer: how do I make it bounce off the walls?</summary>

First, move it using its stored velocity each frame:

```lua
e.x = e.x + e.vx * dt
e.y = e.y + e.vy * dt
```

Then check all four walls. If the bouncer crosses a wall, snap it back inside and flip the velocity for that axis. Using `math.abs` is safer than just negating — it prevents the bouncer from getting stuck in a corner:

```lua
if e.x - e.r < 0        then e.x = e.r;            e.vx =  math.abs(e.vx) end
if e.x + e.r > SCREEN_W then e.x = SCREEN_W - e.r; e.vx = -math.abs(e.vx) end
if e.y - e.r < 0        then e.y = e.r;            e.vy =  math.abs(e.vy) end
if e.y + e.r > SCREEN_H then e.y = SCREEN_H - e.r; e.vy = -math.abs(e.vy) end
```
</details>

<details>
<summary>Hint 3 — Patroller: how do I make it turn around?</summary>

Move it horizontally by multiplying `e.dir` by speed and delta time. Since `e.dir` is `1` or `-1`, this naturally makes it go right or left:

```lua
e.x = e.x + e.dir * e.speed * dt
```

Then check the two patrol endpoints. When it reaches one end, snap it there and flip the direction:

```lua
if e.x >= e.x2 then e.x = e.x2; e.dir = -1 end
if e.x <= e.x1 then e.x = e.x1; e.dir =  1 end
```

That's it — no angles, no distance math. Just one number that flips between `1` and `-1`.
</details>

## Stretch Goals

1. **Speed up the chasers** — make each chaser 10 % faster for every other chaser already on screen, so a swarm becomes increasingly dangerous as time goes on.
2. **Bouncer collisions** — make bouncers bounce off each other, not just the walls. Two bouncers collide when their distance is less than the sum of their radii; swap their velocities.
3. **Shockwave attack** — press Space to send a shockwave ring expanding outward from the player. Any patroller it touches when it reaches full size is destroyed.
