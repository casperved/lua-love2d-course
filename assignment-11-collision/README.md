# Assignment 11: Collision Detection 🟩💥🟪

Great work making it to Assignment 11! You now know how to move things around the screen. But how does a game know when two things *touch* each other? That's what collision detection is all about — and today you'll build it yourself!

---

## What is AABB Collision?

**AABB** stands for **Axis-Aligned Bounding Box**. That's a fancy way of saying: "a rectangle that isn't rotated." Most game objects (players, enemies, walls) can be wrapped in a rectangle, and we check whether those rectangles overlap.

Two rectangles overlap if they overlap on **both** the X axis **and** the Y axis at the same time.

Imagine sliding two boxes on a table:
- If they overlap left-to-right **and** overlap top-to-bottom at the same time, they're touching.
- If there's any gap on either axis, they're not touching.

---

## The AABB Formula

Here's the collision check in code:

```lua
function checkCollision(a, b)
    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end
```

Where `a` and `b` are tables with fields `x`, `y`, `w` (width), and `h` (height).

Let's break it down:
| Condition | What it checks |
|---|---|
| `a.x < b.x + b.w` | A's left edge is to the left of B's right edge |
| `a.x + a.w > b.x` | A's right edge is to the right of B's left edge |
| `a.y < b.y + b.h` | A's top edge is above B's bottom edge |
| `a.y + a.h > b.y` | A's bottom edge is below B's top edge |

All four must be true at the same time for a collision!

---

## Your Mission

- Move a **green player rectangle** around the screen using arrow keys.
- There are several **purple obstacle rectangles** placed around the screen.
- When the player overlaps any obstacle, the player turns **red**.
- When it's not touching anything, it stays **green**.

---

## TODOs in the Starter File

1. **TODO 1** — Write the real `checkCollision(a, b)` function using the AABB formula.
2. **TODO 2** — Loop through all obstacles and set `isColliding = true` if any collision is found.
3. **TODO 3** — Draw the player red when colliding, green when safe.

---

## Hints

<details><summary>Hint 1 — The collision formula</summary>

Copy this into your `checkCollision` function:

```lua
return a.x < b.x + b.w and
       a.x + a.w > b.x and
       a.y < b.y + b.h and
       a.y + a.h > b.y
```

Each line checks one edge. All four must pass for a collision!
</details>

<details><summary>Hint 2 — Looping through obstacles</summary>

```lua
isColliding = false
for i = 1, #obstacles do
    if checkCollision(player, obstacles[i]) then
        isColliding = true
    end
end
```

We reset to `false` every frame, then set it `true` the moment we find any overlap.
</details>

<details><summary>Hint 3 — Drawing the player in the right colour</summary>

```lua
if isColliding then
    love.graphics.setColor(1, 0.2, 0.2)   -- red
else
    love.graphics.setColor(0.2, 1, 0.4)   -- green
end
love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
```
</details>

---

## Stretch Goals

1. **Solid walls** — Instead of just changing colour, *stop* the player from moving into an obstacle (push it back out when a collision happens).
2. **More obstacles** — Add 5 or more obstacles in interesting patterns to make a maze.
3. **Collision counter** — Display how many obstacles the player is currently overlapping at once (could be more than one!).
