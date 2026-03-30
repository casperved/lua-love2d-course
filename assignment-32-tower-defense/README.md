# Assignment 32: Tower Defense

You are going to build a real tower defense game. Enemies march along a winding road. You click to place towers. Towers spot nearby enemies and shoot glowing bullets at them. Enemies take damage and die. Let too many through and it's game over.

Everything you need — the path, the enemy movement, the waves — is already running in the starter file. Your job is to wire up the three most satisfying parts: **aiming**, **chasing**, and **dealing damage**.

---

## What you'll learn

How to place towers that spot the most dangerous enemy nearby, fire homing bullets that steer toward their target every frame, and remove enemies from the game when their health runs out.

---

## How it works

### Distance: "can I reach that?"

Towers can only shoot enemies that are close enough. Think of the tower holding a piece of string with a fixed length — its **range**. If an enemy is inside the circle made by that string, the tower can shoot it.

To measure distance between two points in code, we use a formula called the Pythagorean theorem. You've seen this in earlier assignments:

```lua
local dx = enemy.x - tower.x   -- how far apart left-right
local dy = enemy.y - tower.y   -- how far apart up-down
local d  = math.sqrt(dx*dx + dy*dy)  -- straight-line distance

if d < tower.range then
    -- the enemy is inside the tower's circle!
end
```

### Priority targeting: "shoot the most dangerous one first"

When several enemies are in range, which one should the tower shoot? The most dangerous one is the enemy that has already travelled the furthest — because it's closest to escaping!

Each enemy has a field called `waypointIndex`. It starts at `2` and goes up every time the enemy passes a corner. A higher number means more of the path has been crossed.

So: loop through all nearby enemies, keep track of the biggest `waypointIndex` seen so far, and whoever has the biggest number becomes the target.

```lua
local target      = nil
local bestProgress = -1   -- start lower than any real value

for _, e in ipairs(enemies) do
    -- check if e is alive and in range, then...
    if e.waypointIndex > bestProgress then
        bestProgress = e.waypointIndex
        target = e            -- new leader!
    end
end
-- after the loop, target is the most dangerous enemy in range
```

### Homing bullets: "always turn toward the target"

A homing bullet is like a heat-seeking missile: every single frame it looks at where its target is *right now* and steers toward it.

The trick is **normalising** the direction vector. That just means turning it into a vector that has a length of exactly 1, so you can multiply it by any speed you want.

```lua
local dx  = bullet.target.x - bullet.x   -- direction to target
local dy  = bullet.target.y - bullet.y
local len = math.sqrt(dx*dx + dy*dy)      -- current distance

if len > 0 then
    bullet.vx = (dx / len) * bullet.speed   -- divide by len = normalise
    bullet.vy = (dy / len) * bullet.speed
end

bullet.x = bullet.x + bullet.vx * dt   -- move the bullet
bullet.y = bullet.y + bullet.vy * dt
```

This runs every frame, so the bullet always curves toward wherever the enemy has moved.

### Enemy health and death

Every enemy has `hp` (hit points). When a bullet gets close enough, it deals `damage`. If `hp` drops to zero (or below), the enemy is marked `dead = true` and removed from the game. The bullet is spent too — one bullet, one hit.

```lua
if hitDist < HIT_RADIUS then
    b.target.hp = b.target.hp - b.damage

    if b.target.hp <= 0 then
        b.target.dead = true
        score = score + 1
    end

    b.dead = true   -- bullet is used up
end
```

### The backwards removal trick

When you remove items from a Lua table *while* you are looping through it, the indices shift and you can accidentally skip items or crash. The safe fix is to loop **backwards** from the end to the start:

```lua
for i = #enemies, 1, -1 do
    if enemies[i].dead then
        table.remove(enemies, i)
    end
end
```

Looping backwards means any index you remove is behind you, not in front — so nothing gets skipped.

---

## Your mission

Open `starter/main.lua`. There are three `TODO` blocks. Fill them in one at a time.

**TODO 1 — Tower targeting** (inside `updateTowers`)
Loop through the `enemies` table. For each enemy that is alive and within `tower.range`, check if its `waypointIndex` is higher than `bestProgress`. If yes, make it the new `target`. After the loop, if `target` is not `nil`, the tower fires.

**TODO 2 — Bullet homing** (inside `updateBullets`)
Every frame, calculate the direction from the bullet to `b.target`. Normalise it, multiply by `b.speed`, save as `b.vx` and `b.vy`, then move the bullet with `dt`.

**TODO 3 — Enemy health + death** (still inside `updateBullets`, in the hit-check block)
Subtract `b.damage` from `b.target.hp`. If `hp` drops to zero or below, set `b.target.dead = true` and add 1 to `score`. Then set `b.dead = true` so the bullet disappears.

Run the game before you start — you will see enemies walking but towers doing nothing. After TODO 1 you will see bullets appear. After TODO 2 bullets will start chasing enemies. After TODO 3 enemies will actually die!

---

## Hints

<details>
<summary>Hint 1 — I can't figure out how to pick the "furthest along" enemy</summary>

Start with two local variables before your loop: `local target = nil` and `local bestProgress = -1`.

Inside the loop, first measure the distance from the enemy to the tower (using `dx`, `dy`, `math.sqrt`). If that distance is less than `tower.range`, the enemy is in range.

For enemies in range, check `if e.waypointIndex > bestProgress`. If that is true, update: `bestProgress = e.waypointIndex` and `target = e`.

After the loop, `target` will be the enemy that has travelled the furthest — or `nil` if no enemies were in range at all.

</details>

<details>
<summary>Hint 2 — Bullets appear but they just sit still</summary>

The homing code must run *every frame* inside the bullet update loop — not just once when the bullet is created.

Calculate `dx = b.target.x - b.x` and `dy = b.target.y - b.y`. Then get the length: `local len = math.sqrt(dx*dx + dy*dy)`. Divide both components by `len` to get a direction of length 1. Multiply by `b.speed` and store in `b.vx` and `b.vy`. Finally, move: `b.x = b.x + b.vx * dt`.

Also make sure you are doing this *after* the check for `b.target.dead` — if the target already died, mark the bullet dead and skip the rest.

</details>

<details>
<summary>Hint 3 — Enemies reach the end without dying</summary>

The damage code belongs right after the hit-distance check that is already in the starter. When `hitDist < HIT_RADIUS`, that means the bullet has reached its target.

At that point, subtract damage: `b.target.hp = b.target.hp - b.damage`.

Then check: `if b.target.hp <= 0 then b.target.dead = true; score = score + 1 end`.

Finally mark the bullet spent: `b.dead = true`. The backwards-loop cleanup at the end of `updateBullets` will remove it for you.

</details>

---

## Stretch Goals

1. **Tower upgrades** — right-click an existing tower to upgrade it: increase its range to 180 and cut its cooldown to 0.5. Draw upgraded towers with a golden outline so they are easy to spot.
2. **Enemy variety** — spawn three types at random: a fast fragile runner (hp 1, speed 160), a normal enemy (hp 2, speed 100), and a slow armoured brute (hp 5, speed 60, drawn larger in a darker colour).
3. **Gold economy** — instead of a fixed tower count, give the player 100 gold. Each tower costs 25 gold. Each kill earns 10 gold. Show the current gold in the HUD.
