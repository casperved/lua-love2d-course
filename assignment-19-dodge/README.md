# Assignment 19: Mini Project — Dodge!

You've learned a lot of pieces. Now you're putting them all together into a real game — one where red enemies swarm in from every direction and your only job is to *not get touched*.

---

## What you'll learn

How to make enemies that **chase the player** using a direction vector, and how to detect **circle-circle collisions** to trigger game over.

---

## How it works

### The game in plain English

You are a green circle. Red circles appear at the edges of the screen and rush straight toward you. You dodge them with the arrow keys or WASD. The longer you survive, the faster they spawn. When one touches you, it's game over.

### Moving toward a target (direction vectors)

Imagine you're standing in a field and you want to walk toward a tree. You look at the tree, take one step in that direction, look again, take one step — over and over. That's exactly what each enemy does every frame.

Here's how to calculate that "one step toward the player":

1. Find the gap: how far is the enemy from the player in x? In y?
   ```lua
   local dx = player.x - e.x
   local dy = player.y - e.y
   ```

2. Find the total distance (like measuring a diagonal line on graph paper):
   ```lua
   local len = math.sqrt(dx * dx + dy * dy)
   ```

3. **Shrink dx and dy so their combined size is exactly 1.** This is called *normalising*. It means a slow enemy and a fast enemy both walk in the *same direction* — the speed variable controls how fast, not the distance.
   ```lua
   -- dx/len and dy/len now form a direction of length 1
   e.x = e.x + (dx / len) * e.speed * dt
   e.y = e.y + (dy / len) * e.speed * dt
   ```

Why does normalising matter? Without it, an enemy that's far away would take huge steps, and one that's close would barely move. Normalising makes the step size consistent regardless of distance.

### Circle collision

Two circles bump into each other when the distance between their centres is less than their radii added together.

Think of it like two balloons. If the distance between their centres is smaller than the sum of how "puffed out" they each are, they're overlapping.

```lua
local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
if dist < player.size + e.size then
    -- they're touching!
end
```

### Spawning from a random edge

Pick one of four sides at random, then place the enemy just off-screen on that side — so it slides into view like it's running in from outside the arena.

---

## Your mission

About 70% of the game is already written. You need to fill in **three TODOs**:

| TODO | What to do |
|------|-----------|
| **TODO 1** | Complete `spawnEnemy()` so enemies appear at a random screen edge |
| **TODO 2** | Inside the enemy loop, move each enemy toward the player |
| **TODO 3** | Inside the same loop, check if an enemy touches the player |

When all three are done:
- Enemies spawn from all four edges and rush at you.
- The moment one touches you, the game ends and shows your survival time.
- Press **R** to try again and beat your best time.

---

## Hints

<details><summary>Hint 1 — Spawning from a random edge (TODO 1)</summary>

Pick a random side number (1 to 4). Then set `ex` and `ey` depending on which side you picked. The `-15` / `+15` offset places the enemy just outside the visible screen so it looks like it runs in:

```lua
local side = math.random(1, 4)
local ex, ey
if side == 1 then
    -- top edge: random x, above the screen
    ex = math.random(0, SCREEN_W)
    ey = -15
elseif side == 2 then
    -- bottom edge: random x, below the screen
    ex = math.random(0, SCREEN_W)
    ey = SCREEN_H + 15
elseif side == 3 then
    -- left edge: off to the left, random y
    ex = -15
    ey = math.random(0, SCREEN_H)
else
    -- right edge: off to the right, random y
    ex = SCREEN_W + 15
    ey = math.random(0, SCREEN_H)
end
table.insert(enemies, { x = ex, y = ey, size = 12, speed = math.random(80, 180) })
```

</details>

<details><summary>Hint 2 — Making enemies chase the player (TODO 2)</summary>

Inside the `for` loop where it says `-- TODO 2`, put this. It calculates the direction from the enemy to the player, normalises it to length 1, then moves the enemy along that direction:

```lua
local dx  = player.x - e.x
local dy  = player.y - e.y
local len = math.sqrt(dx * dx + dy * dy)
if len > 0 then
    e.x = e.x + (dx / len) * e.speed * dt
    e.y = e.y + (dy / len) * e.speed * dt
end
```

Run the game after this step — the red dots should start chasing you!

</details>

<details><summary>Hint 3 — Detecting a hit (TODO 3)</summary>

Right after the movement code from Hint 2, still inside the same `for` loop, add the collision check:

```lua
local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
if dist < player.size + e.size then
    bestTime  = math.max(bestTime, survivalTime)
    gameState = "gameover"
    return
end
```

The `return` stops the update immediately so no other enemy triggers a second game over on the same frame.

</details>

---

## Stretch Goals

1. **Speed boost** — Hold Shift to sprint at 1.8× speed for up to 2 seconds. Track a `boostEnergy` value that drains while you sprint and slowly refills when you don't. Draw a small bar on the HUD to show how much boost is left.
2. **Enemy trails** — Store each enemy's last 5 positions in a small table and draw fading, smaller circles at those past positions. Fast enemies will look especially menacing with a smear behind them.
3. **Survival milestones** — At 10 s, 30 s, and 60 s, flash a message on screen ("Still alive! 30 seconds!") and briefly make the background pulse green. Store the milestones in an array and remove each one after it fires so it only triggers once.
