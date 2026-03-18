# Assignment 06: Patterns with Loops

Great work making it this far! In this assignment you'll discover one of the most powerful ideas in programming: **loops**. Instead of writing the same code over and over, a loop does the repeating for you.

---

## What is a `for` loop?

A `for` loop runs a block of code a set number of times. Here's the basic shape:

```lua
for i = 1, 10 do
    print(i)   -- prints 1, 2, 3 ... all the way to 10
end
```

- `i` is the **loop variable** — it counts up automatically each time through the loop.
- `1` is where it starts, `10` is where it stops.
- Everything between `do` and `end` is repeated.

You can use `i` in your math! For example, to space things out evenly:

```lua
for i = 1, 5 do
    local x = i * 100   -- 100, 200, 300, 400, 500
    love.graphics.circle("fill", x, 300, 20)
end
```

---

## Nested Loops (a loop inside a loop)

To make a **grid** (rows AND columns), put one loop inside another:

```lua
for row = 1, 3 do
    for col = 1, 4 do
        local x = col * 100
        local y = row * 100
        love.graphics.circle("fill", x, y, 20)
    end
end
```

The **outer** loop goes through each row. For every row, the **inner** loop goes through every column. That gives you 3 × 4 = 12 circles arranged in a perfect grid!

---

## Using the loop variables for color

Since `row` and `col` are just numbers, you can use them to calculate colors too:

```lua
local r = col / COLS   -- goes from a small fraction up to 1.0 as col increases
local g = row / ROWS   -- same idea for rows
love.graphics.setColor(r, g, 0.5)
```

This means each circle in the grid will have a slightly different color — making a beautiful gradient pattern!

---

## Your Mission

**Draw a grid of colorful circles** where each circle's color depends on its position in the grid.

Open `starter/main.lua` and follow the TODO comments step by step:

1. Write a `for` loop for rows
2. Inside it, write a `for` loop for columns
3. Calculate `x` and `y` from `col` and `row`
4. Set a color based on position
5. Draw a filled circle

You should end up with a 8 × 6 grid of circles that form a color gradient across the screen. It'll look like art!

---

## Hints

<details><summary>Hint 1 — How do I start the nested loops?</summary>

```lua
for row = 1, ROWS do
    for col = 1, COLS do
        -- your drawing code goes here
    end  -- closes the inner (col) loop
end      -- closes the outer (row) loop
```

Make sure every `do` has a matching `end`!
</details>

<details><summary>Hint 2 — How do I calculate x and y?</summary>

```lua
local x = col * SPACING - SPACING / 2 + 45
local y = row * SPACING - SPACING / 2 + 30
```

The `- SPACING/2 + 45` part is just a small offset to nicely center the grid on the 800×600 window. You can tweak those numbers and see what happens!
</details>

<details><summary>Hint 3 — How do I make each circle a different color?</summary>

```lua
local r = col / COLS   -- 0.125, 0.25, 0.375 ... 1.0  as col goes 1 → 8
local g = row / ROWS   -- 0.166 ... 1.0  as row goes 1 → 6
local b = 0.5          -- constant blue for a nice look
love.graphics.setColor(r, g, b)
```

Try changing `b` to `1 - (col / COLS)` for an extra twist!
</details>

---

## Stretch Goals

These are optional extras to try once the main task is working:

1. **Size variation** — Make `RADIUS` slightly different for each circle. Try `RADIUS * (col / COLS)` so circles grow across each row.
2. **Checkerboard** — Only draw a circle if `(row + col) % 2 == 0`. What pattern does that make?
3. **Rainbow rings** — Instead of a solid fill, draw a "line" circle (outline only) around each filled circle in a contrasting color.
