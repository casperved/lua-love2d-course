# Assignment 06: Patterns with Loops

You've been drawing shapes one at a time. What if you want 48 circles? In this assignment you'll learn how to make the computer repeat itself — so you can draw a whole grid of colorful circles with just a few lines of code.

---

## What you'll learn

How to use `for` loops (including a loop inside a loop) to draw a grid of shapes without copy-pasting the same code over and over.

---

## How it works

### A loop is like a stack of pancakes

Imagine you're making pancakes and you want to make 6 of them. You don't write a new recipe for each one — you follow the same recipe 6 times.

A `for` loop does exactly that. It runs the same block of code a set number of times:

```lua
for i = 1, 6 do
    -- make one pancake
end
```

`i` is a counter that goes up automatically: 1, 2, 3, 4, 5, 6. You can use `i` in your math to change something each time:

```lua
for i = 1, 5 do
    local x = i * 100   -- 100, 200, 300, 400, 500
    love.graphics.circle("fill", x, 300, 20)
end
```

That draws 5 circles in a row — one line of `circle` code, five circles on screen!

### Local variables inside loops

Notice the `local` keyword in front of `x` above. `local x = ...` creates a variable that only exists inside the loop body — it disappears each time the loop repeats and is created fresh on the next pass. Inside loops (and functions), always use `local` for temporary values. This keeps your code tidy and avoids accidentally mixing up values between passes.

### A loop inside a loop makes a grid

One loop gives you a row. Put that loop inside *another* loop, and you get rows AND columns — a full grid.

Think of it like a chocolate box. The outer loop says "go to the next row of chocolates." The inner loop says "go through every chocolate in this row." Together they visit every single chocolate.

```lua
for row = 1, 3 do       -- outer loop: 3 rows
    for col = 1, 4 do   -- inner loop: 4 columns in each row
        local x = col * 100
        local y = row * 100
        love.graphics.circle("fill", x, y, 20)
    end
end
```

This draws 3 × 4 = 12 circles arranged in a perfect grid. The computer does all the positioning for you!

### Using position numbers as colors

`row` and `col` are just numbers, so you can use them to calculate a color too:

```lua
local r = col / COLS   -- starts small, reaches 1.0 at the last column
local g = row / ROWS   -- starts small, reaches 1.0 at the last row
love.graphics.setColor(r, g, 0.5)
```

Each circle ends up a slightly different color depending on where it sits in the grid. The whole thing looks like a color gradient — like art!

---

## Your mission

Draw a grid of colorful circles. Each circle's color should depend on its position in the grid.

Open `starter/main.lua` and fill in the TODOs one at a time:

1. Write a `for` loop that counts through the rows.
2. Inside it, write another `for` loop that counts through the columns.
3. Calculate `x` and `y` from `col` and `row` using `SPACING` — use `local` variables.
4. Calculate a color from `col` and `row`.
5. Set the color and draw a filled circle.

When it's working you'll see an 8 × 6 grid of 48 circles that fade through red, green, and blue — it looks great!

---

## Hints

<details><summary>Hint 1 — How do I write the nested loops?</summary>

Start with the outer loop for rows, then put the inner loop for columns inside it:

```lua
for row = 1, ROWS do
    for col = 1, COLS do
        -- drawing code goes here
    end   -- closes the col loop
end       -- closes the row loop
```

Every `do` needs a matching `end`. Two loops = two `end`s.
</details>

<details><summary>Hint 2 — How do I find the x and y position for each circle?</summary>

Multiply `col` and `row` by `SPACING` and add a small offset to nudge the grid toward the center of the window:

```lua
local x = col * SPACING - SPACING / 2 + 45
local y = row * SPACING - SPACING / 2 + 30
```

Try changing those offset numbers and see what happens!
</details>

<details><summary>Hint 3 — How do I make each circle a different color?</summary>

Divide `col` by `COLS` to get a number between 0 and 1, and do the same for `row`. Then set the color and draw the circle:

```lua
local r = col / COLS   -- 0.125, 0.25 ... 1.0 as col goes 1 → 8
local g = row / ROWS   -- 0.166 ... 1.0 as row goes 1 → 6
local b = 0.5
love.graphics.setColor(r, g, b)
love.graphics.circle("fill", x, y, RADIUS)
```
</details>

---

## Stretch Goals

Finished early? Try one of these:

1. **Size variation** — Make each circle a slightly different size. Try `RADIUS * (col / COLS)` so circles grow from left to right across each row.
2. **Checkerboard gaps** — Only draw a circle when `(row + col) % 2 == 0`. What pattern does that make?
3. **Animated ripple** — Add `love.timer.getTime()` to the color calculation so the grid pulses and shifts colors over time. Try `math.abs(math.sin((row + col) * 0.4 + love.timer.getTime() * 2))` as your red value.
