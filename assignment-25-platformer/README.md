# Assignment 25: Platformer Physics

You are about to build the thing at the heart of almost every video game you loved as a kid — a little character that falls, lands, and jumps on platforms. No library does the hard work for you. You will write the physics yourself, from scratch, in about fifteen lines of code.

---

## What you'll learn

How to fake gravity, detect when a character is standing on a platform, and let them jump — the three building blocks of every platformer ever made.

---

## How it works

### Gravity — the invisible hand pulling everything down

Imagine you are holding a ball. The moment you let go, it falls faster and faster. It does not just teleport to the floor — it *accelerates*. Every second it is moving quicker than the second before.

In code, a character has a vertical speed called `vy`. When nothing is happening, `vy` is zero. Gravity's only job is to make `vy` a little bigger every single frame:

```lua
player.vy = player.vy + GRAVITY * dt
player.y  = player.y  + player.vy * dt
```

Two lines. That is real gravity. `dt` is the tiny slice of time since the last frame (usually around 0.016 seconds), so the speed builds up smoothly no matter how fast or slow the computer is.

Think of `vy` like a speedometer for falling. At the start it reads zero. Each frame GRAVITY nudges it a little higher. The player then moves down by however fast the speedometer currently says.

### Platform landing — "did the boxes touch?"

Every object in this game is an invisible rectangle — a **bounding box**. Detecting a collision is just asking: "do these two rectangles overlap right now?"

Picture two books lying on a table. They overlap if:
- Neither book is completely to the left or right of the other (X axis), **and**
- Neither book is completely above or below the other (Y axis).

In code, that looks like this (for the player and one platform `p`):

```lua
local overlapX = player.x < p.x + p.w  and  player.x + player.w > p.x
local overlapY = player.y < p.y + p.h  and  player.y + player.h > p.y
```

If both overlap at the same time, the player is inside the platform. We only want to *land* (not stick to ceilings), so we also check that the player is moving **downward** (`player.vy > 0`). If all three conditions are true, we sit the player neatly on top:

```lua
if overlapX and overlapY and player.vy > 0 then
    player.y        = p.y - player.h   -- sit right on the surface
    player.vy       = 0                -- stop falling
    player.onGround = true             -- remember we are standing
end
```

This technique — checking two axis-aligned rectangles — is called **AABB collision** (Axis-Aligned Bounding Box). The fancy name hides a very simple idea.

### Jumping — a quick shove upward

Remember that `vy` is the speedometer? Jumping is just setting it to a big negative number all at once. (In LÖVE2D, negative Y means *up* on screen.)

```lua
if player.onGround then
    if love.keyboard.isDown("space") then
        player.vy = JUMP_SPEED   -- big negative number = shoot upward
    end
end
```

After that shove, gravity takes over. `vy` starts large and negative (moving up fast), then gets smaller each frame, then reaches zero at the top of the arc, then goes positive again (falling back down). The same two gravity lines from before handle the whole arc automatically.

One important detail: at the very start of each frame we reset `player.onGround = false`. Then the collision loop sets it back to `true` if the player is still touching something. This means the jump check always uses a fresh, up-to-date value — never a stale one from the frame before.

---

## Your mission

Open `starter/main.lua`. Find the three TODO sections and fill them in.

**TODO 1 — Apply gravity**
Add `GRAVITY * dt` to `player.vy`, then add `player.vy * dt` to `player.y`. Two lines.

**TODO 2 — Platform landing check**
Loop over all platforms *and* the floor. For each one, check AABB overlap. If the player overlaps AND is moving downward (`player.vy > 0`), snap the player to the top of the surface, stop vertical movement, and set `player.onGround = true`.

**TODO 3 — Jumping**
If `player.onGround` is `true` and Space or Up is pressed, set `player.vy` to `JUMP_SPEED` and set `player.onGround = false`.

Controls:
- **Left / Right arrow** — move side to side
- **Space or Up arrow** — jump (only when standing on something)

When everything works, your character will land on all five platforms and the floor, arc smoothly through the air, and be blocked from walking off the left or right edge of the screen.

---

## Hints

<details>
<summary>Hint 1 — applying gravity</summary>

Gravity lives inside `love.update(dt)`, near the top, before anything else moves. You need exactly two lines. First, make the downward speed grow. Second, move the player by that speed.

```lua
player.vy = player.vy + GRAVITY * dt
player.y  = player.y  + player.vy * dt
```

Order matters: always update the speed first, then use the new speed to move.

</details>

<details>
<summary>Hint 2 — the overlap check</summary>

Build one combined list of surfaces (platforms plus the floor), then loop over it. Inside the loop, check X overlap, check Y overlap, check that `player.vy > 0`. If all three are true, land the player:

```lua
local allSurfaces = {}
for i = 1, #platforms do allSurfaces[i] = platforms[i] end
allSurfaces[#allSurfaces + 1] = floor

for i = 1, #allSurfaces do
    local p  = allSurfaces[i]
    local ox = player.x < p.x + p.w  and  player.x + player.w > p.x
    local oy = player.y < p.y + p.h  and  player.y + player.h > p.y
    if ox and oy and player.vy > 0 then
        player.y        = p.y - player.h
        player.vy       = 0
        player.onGround = true
    end
end
```

</details>

<details>
<summary>Hint 3 — jumping</summary>

The jump check goes *after* the collision loop, so that `player.onGround` already has its fresh value for this frame. Check that the player is on the ground before allowing a jump — otherwise they could jump in mid-air.

```lua
if player.onGround then
    if love.keyboard.isDown("space") or love.keyboard.isDown("up") then
        player.vy       = JUMP_SPEED   -- defined at the top as -500
        player.onGround = false
    end
end
```

</details>

---

## Stretch Goals

- **Screen wrap** — instead of clamping the player at the edges, let them walk off the right side and reappear on the left (and vice versa).
- **Coyote time** — allow the player to jump for up to 0.1 seconds after walking off a ledge. Store a small timer and only zero it out when they have been in the air longer than that. This one tiny trick makes jumps feel much more forgiving and fair.
- **Moving platforms** — make one or two platforms slide left and right using `math.sin(love.timer.getTime())`. When the player is standing on one, add the platform's movement to the player's X position each frame.
- **Jump squash and stretch** — when the player lands, briefly make them wider and shorter for 0.1 seconds. When they jump, make them taller and thinner. This is the oldest trick in animation and it makes the physics feel alive.
