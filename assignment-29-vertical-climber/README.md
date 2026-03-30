# Assignment 29: Vertical Climber

You've made platforms that scroll sideways. Now let's flip it upside-down. The world goes *up*, the camera only ever follows you higher, and if you fall off the bottom — game over. Grab glowing orbs for a speed boost, and your best score is saved so you can beat it next time.

---

## What you'll learn

- A **one-way camera** that only scrolls upward (it never comes back down)
- **Procedural platforms** — the level is built fresh every time you play
- **Spark particles** that burst out when you grab a power-up
- **Saving your high score** to a file so it survives closing the game

---

## How it works

### The world is upside-down

In LÖVE2D, `y = 0` is the **top** of the screen and bigger `y` values go **down**. This game uses that fact: you start at the very bottom of a tall world (`y = 9000`) and you climb toward `y = 0`.

Think of it like a swimming pool. You start at the deep end (bottom) and swim toward the surface (top). Your height is just how far up you've gone:

```lua
heightReached = WORLD_H - (player.y + player.h)
```

The bigger `heightReached` is, the higher you've climbed.

### The one-way camera

The camera has a target (`camYTarget`). Think of the camera like a crane operator following a climber — it only moves the crane *up*, never back down.

We check: "Is the player getting close to the top edge of my screen view?" If yes, move the target upward to keep the player in the upper part of the view. The camera then smoothly slides toward that target each frame:

```lua
-- Only scroll up — never down
if player.y < camYTarget + SCREEN_H * 0.4 then
    camYTarget = player.y - SCREEN_H * 0.4
end
-- Don't go past the world edges
camYTarget = math.max(0, math.min(camYTarget, WORLD_H - SCREEN_H))
-- Smoothly slide the camera toward the target (lerp)
camY = camY + (camYTarget - camY) * 8 * dt
```

Then when drawing, we shift everything in the world by `-camY` so only the right slice is visible:

```lua
love.graphics.push()
love.graphics.translate(0, -camY)  -- slide the world up on screen
-- draw platforms, player, power-ups here...
love.graphics.pop()
-- draw the HUD *after* pop() — it stays glued to the screen
```

### Platform landing

This is AABB collision from assignment 25, but now there are 70 platforms. The idea is the same: the player can only land from above, not pass through from below.

Five things must all be true at the same time:
1. The player is **falling** (moving downward, so `vy > 0`)
2. The player's right side is past the platform's left side
3. The player's left side is before the platform's right side
4. The player's **feet** (`y + h`) have reached the platform top
5. The player's **head** (`y`) is still above the platform (so we don't snap when tunnelling through)

When all five are true, sit the player on top of the platform and stop the downward movement.

### Death

If your feet drop more than 20 pixels below the camera's bottom edge, you fell off and it's game over:

```lua
if player.y + player.h > camY + SCREEN_H + 20 then
    -- game over!
end
```

### Spark burst

When the player touches a glowing orb, we fire 16 sparks out in all directions — like a tiny firework. Picture a clock face: we place one spark pointing at each "hour" around the full circle. Each spark has its own speed and a short lifetime. Every frame we move them, and when their `life` runs out we remove them:

```lua
for k = 1, 16 do
    local angle = (k / 16) * math.pi * 2   -- evenly spaced around a full circle
    local spd   = math.random(80, 200)
    sparks[#sparks + 1] = {
        x = pu.x,  y = pu.y,
        vx = math.cos(angle) * spd,
        vy = math.sin(angle) * spd,
        life    = math.random(20, 50) / 100,
        maxLife = 0.5,
    }
end
```

### Saving the high score

LÖVE2D gives you a safe folder to read and write files. We save the best height as plain text and load it back when the game starts:

```lua
function saveScore(h)
    love.filesystem.write("best_height.txt", tostring(h))
end

function loadScore()
    if love.filesystem.getInfo("best_height.txt") then
        return tonumber(love.filesystem.read("best_height.txt")) or 0
    end
    return 0
end
```

---

## Your mission

Open `starter/main.lua`. The player, gravity, movement, platform generation, power-up spawning, and all the drawing are already done. Run it — you'll see the player standing on the starting platform, but they fall through everything and the camera never moves. Your job is to fill in three TODOs:

1. **TODO 1 — Camera:** Move `camYTarget` upward when the player is near the top of the view, clamp it to the world edges, then lerp `camY` toward it.
2. **TODO 2 — Platform landing:** Loop through every platform. When the player is falling and their feet just touch a platform's top surface (all five conditions!), snap them on top, set `vy = 0`, and set `onGround = true`.
3. **TODO 3 — Sparks + save:** When a power-up is collected, spawn 16 spark particles in a circle. Also call `saveScore(bestHeight)` when the player beats their record.

---

## Hints

<details>
<summary>Hint 1 — Camera (TODO 1)</summary>

The target should only ever get smaller (move up in world coordinates). Check if the player is near the top 40% of the screen, then pull the target upward. Clamp so you can't scroll past the world edges. Finally, lerp `camY` toward the target so it glides smoothly:

```lua
if player.y < camYTarget + SCREEN_H * 0.4 then
    camYTarget = player.y - SCREEN_H * 0.4
end
camYTarget = math.max(0, math.min(camYTarget, WORLD_H - SCREEN_H))
camY = camY + (camYTarget - camY) * 8 * dt
```
</details>

<details>
<summary>Hint 2 — Platform landing (TODO 2)</summary>

Loop over `platforms` with `for _, plat in ipairs(platforms) do`. Inside, check all five conditions in one `if` statement. When they're all true, snap the player on top:

```lua
for _, plat in ipairs(platforms) do
    if player.vy > 0
       and player.x + player.w > plat.x
       and player.x < plat.x + plat.w
       and player.y + player.h >= plat.y
       and player.y < plat.y
    then
        player.y        = plat.y - player.h
        player.vy       = 0
        player.onGround = true
    end
end
```
</details>

<details>
<summary>Hint 3 — Sparks + save (TODO 3)</summary>

The spark loop goes right after `pu.collected = true` inside the power-up collection block. Use `math.cos` and `math.sin` with evenly spaced angles to send sparks in all directions:

```lua
for k = 1, 16 do
    local angle = (k / 16) * math.pi * 2
    local spd   = math.random(80, 200)
    sparks[#sparks + 1] = {
        x = pu.x, y = pu.y,
        vx = math.cos(angle) * spd,
        vy = math.sin(angle) * spd,
        life    = math.random(20, 50) / 100,
        maxLife = 0.5,
    }
end
```

For the save, find the death-check block where `bestHeight` is updated and add `saveScore(bestHeight)` right after. Also uncomment the real `love.filesystem` lines inside `saveScore` and `loadScore`.
</details>

---

## Stretch Goals

1. **Rising floor!** Gradually speed up the minimum camera scroll rate every 1 000 px climbed — the higher you go, the faster the floor chases you.
2. **Double jump!** Let the player jump once more while in the air. Track a `jumpsLeft` counter, reset it to `2` when landing, and subtract `1` each jump.
3. **Crumbling platforms!** Start a short countdown when the player lands on a platform. When the timer expires, remove it from the list — you can't rest for long!
