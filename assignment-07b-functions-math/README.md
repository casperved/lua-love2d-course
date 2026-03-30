# Assignment 07B: Functions with Math

## What you'll learn

How to use `math.cos` and `math.sin` to calculate circular shapes; how one function can call another; and how to loop through a table with `ipairs`.

---

## How it works

### The clock-hand trick: cos and sin

Picture the hand of a clock fixed at the center of the screen. The hand always stays the same length — it just rotates. As it rotates, its tip traces a perfect circle.

Two functions track that tip:

- `math.cos(angle)` — how far the tip is to the **left or right** of center
- `math.sin(angle)` — how far the tip is **up or down** from center

Both return a number between -1 and 1. Multiply by a radius to get real pixel offsets:

```lua
local tipX = centerX + math.cos(angle) * radius
local tipY = centerY + math.sin(angle) * radius
```

Change `angle` and you get a different point on the circle. Loop through many angles and you can calculate every point of any circular shape — including the 10 corners of a star.

### How a star shape works

A 5-pointed star has 10 corners: 5 outer tips and 5 inner notches, alternating. They sit on two rings — a big outer ring and a smaller inner ring — evenly spaced around a circle.

Loop from `i = 0` to `9`. For each step, calculate the angle and pick the matching ring:

```lua
local angle  = math.pi * i / 5 - math.pi / 2   -- evenly spaced, rotated to point up
local radius = (i % 2 == 0) and outerR or innerR  -- alternate big/small
```

`i % 2 == 0` is true when `i` is even (0, 2, 4, …) — those are the outer tips. Odd values of `i` (1, 3, 5, …) give the inner notches.

Collect all 10 vertex positions in a table, then draw them as a polygon.

### Functions calling functions

Nothing stops one function from calling another. In this assignment, `drawShootingStar` will call `drawStar` inside its own body:

```lua
function drawShootingStar(x, y)
    -- draw the tail...
    drawStar(x, y, 14, 6, 1, 1, 0.85)   -- call another function!
end
```

This is how real programs are built — small focused functions snapped together like LEGO bricks.

### ipairs — a friendlier loop for tables

You already know `for i = 1, #t do`. There is a shorter form for looping through every item in a table:

```lua
for i, item in ipairs(t) do
    -- i is the index (1, 2, 3, …)
    -- item is the value at t[i]
end
```

`ipairs` walks the table from index 1 upward and stops at the first missing entry. For a plain list it behaves exactly like `for i = 1, #t do` — just more readable.

---

## Your mission

Build a hand-crafted starfield!

Open `starter/main.lua` and fill in the TODOs:

1. **Write `drawStar`** — use the vertex loop to build the points list, then draw a filled polygon.
2. **Write `drawShootingStar`** — draw a faint line tail, then call `drawStar` at the tip.
3. **In `love.draw`** — loop through the `starfield` table with `ipairs` and call `drawStar` for each entry.
4. **Also in `love.draw`** — call `drawShootingStar` twice for two shooting stars.

---

## Hints

<details><summary>Hint 1 — How does the vertex loop work?</summary>

The key insight: each iteration of the loop produces one vertex (two numbers: an x and a y). You push both into a `verts` table. After the loop, `love.graphics.polygon` reads them all at once.

```lua
local verts = {}
for i = 0, 9 do
    local angle  = math.pi * i / 5 - math.pi / 2
    local radius = (i % 2 == 0) and outerR or innerR
    -- Calculate the x position and insert it into verts
    -- Calculate the y position and insert it into verts
end
love.graphics.setColor(r, g, b)
love.graphics.polygon("fill", verts)
```

`table.insert(verts, value)` appends one number to the end of the list.
</details>

<details><summary>Hint 2 — How do I write drawShootingStar?</summary>

A shooting star is two things at the same spot: a faint line (the tail) and a small star at the tip. The tail goes from a point up-and-left of `(x, y)` back to `(x, y)`.

```lua
function drawShootingStar(x, y)
    love.graphics.setColor(1, 1, 1, 0.35)   -- faint white
    love.graphics.setLineWidth(2)
    love.graphics.line(x - 70, y - 35, x, y)
    love.graphics.setLineWidth(1)
    drawStar(x, y, 14, 6, 1, 1, 0.85)       -- bright tip
end
```

Notice that `drawShootingStar` calls `drawStar` inside it — functions can call other functions!
</details>

<details><summary>Hint 3 — Full drawStar body</summary>

```lua
function drawStar(x, y, outerR, innerR, r, g, b)
    local verts = {}
    for i = 0, 9 do
        local angle  = math.pi * i / 5 - math.pi / 2
        local radius = (i % 2 == 0) and outerR or innerR
        table.insert(verts, x + math.cos(angle) * radius)
        table.insert(verts, y + math.sin(angle) * radius)
    end
    love.graphics.setColor(r, g, b)
    love.graphics.polygon("fill", verts)
end
```

And the ipairs loop in `love.draw`:

```lua
for _, s in ipairs(starfield) do
    drawStar(s[1], s[2], s[3], s[4], s[5], s[6], s[7])
end
```
</details>

---

## Stretch Goals

1. **Twinkle** — Make stars pulse in brightness. Use `math.abs(math.sin(love.timer.getTime() * 2))` as the alpha (fourth color value) when you call `love.graphics.setColor` inside `drawStar`.
2. **Moving comet** — Store a comet position in `love.load` and move it across the screen in `love.update`. When it goes off-screen, reset it to the top-right.
3. **Constellation lines** — Pick four or five stars and connect their centers with `love.graphics.line` to trace a simple shape, like a triangle or a dipper.
