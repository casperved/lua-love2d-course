# Assignment 07: Functions

You've been using functions already — `love.draw`, `love.update`, and `love.load` are all functions! Now you'll learn to **write your own**.

---

## What is a function?

A function is like a **recipe**. You write the recipe once, and you can use it as many times as you want without rewriting it.

```lua
-- Define the recipe (only written once)
function sayHello(name)
    print("Hello, " .. name .. "!")
end

-- Use the recipe as many times as you like
sayHello("Alex")    -- prints: Hello, Alex!
sayHello("Morgan")  -- prints: Hello, Morgan!
sayHello("River")   -- prints: Hello, River!
```

---

## Parameters — the inputs to your recipe

The values inside the parentheses are called **parameters**. They let you pass information into the function so it can behave differently each time:

```lua
function drawCircleAt(x, y, radius, red, green, blue)
    love.graphics.setColor(red, green, blue)
    love.graphics.circle("fill", x, y, radius)
end

-- Now calling it is easy and readable!
drawCircleAt(200, 300, 50, 1, 0, 0)   -- big red circle
drawCircleAt(500, 150, 20, 0, 0, 1)   -- small blue circle
```

Without a function, you'd have to repeat the `setColor` + `circle` lines every single time. Functions keep your code short and clean!

---

## Return values — when a function gives something back

Functions can also **return** a result:

```lua
function add(a, b)
    return a + b
end

local total = add(10, 5)   -- total is 15
```

You won't need `return` for this assignment, but it's good to know about!

---

## Drawing a 5-pointed star

A star shape is a polygon with 10 points — 5 outer (the tips) and 5 inner (the notches). The points alternate between two circles: a big outer radius and a smaller inner radius.

The angle between each point is `math.pi / 5` (36 degrees), and we subtract `math.pi / 2` to start at the top.

Here's the vertex-building loop:

```lua
local verts = {}
for i = 0, 9 do
    local angle  = math.pi * i / 5 - math.pi / 2
    local radius = (i % 2 == 0) and outerR or innerR
    table.insert(verts, x + math.cos(angle) * radius)
    table.insert(verts, y + math.sin(angle) * radius)
end
love.graphics.polygon("fill", verts)
```

Don't worry if the math looks complicated — you can copy it and just focus on calling the function!

---

## Your Mission

1. **Define** a `drawStar(x, y, outerR, innerR, r, g, b)` function using the vertex formula above.
2. **Call** it at least 8 times in `love.draw` with different positions, sizes, and colors to create a beautiful starfield night sky.
3. **Bonus:** Write a `drawShootingStar(x, y)` function that draws a small star with a line trailing behind it.

---

## Hints

<details><summary>Hint 1 — What does the full function skeleton look like?</summary>

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

Put this **before** `love.load` at the top of your file.
</details>

<details><summary>Hint 2 — How do I call it to make a nice starfield?</summary>

```lua
-- A large golden star
drawStar(400, 100, 50, 20, 1.0, 0.9, 0.2)
-- Smaller white stars scattered around
drawStar(100, 80,  20,  8, 1.0, 1.0, 0.9)
drawStar(650, 200, 15,  6, 0.9, 0.9, 1.0)
drawStar(250, 300, 25, 10, 1.0, 0.8, 0.5)
-- Tint some blue or red for variety
drawStar(550, 450, 18,  7, 0.6, 0.8, 1.0)
```

Experiment with the numbers — there's no wrong answer!
</details>

<details><summary>Hint 3 — How do I add a shooting star with a tail?</summary>

```lua
function drawShootingStar(x, y)
    -- Draw the tail as a fading line
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.setLineWidth(2)
    love.graphics.line(x - 60, y - 30, x, y)
    love.graphics.setLineWidth(1)
    -- Draw a small bright star at the tip
    drawStar(x, y, 12, 5, 1, 1, 0.8)
end
```

Call `drawShootingStar(x, y)` in `love.draw` after defining it!
</details>

---

## Stretch Goals

1. **Twinkle effect** — Use `love.timer.getTime()` and `math.sin` to make stars pulse in brightness over time. Pass `math.abs(math.sin(love.timer.getTime() * 2))` as the alpha value!
2. **Random starfield** — In `love.load`, use a loop with `math.random` to build a table of 30 random star positions, then draw them all in `love.draw` using your function.
3. **Constellation lines** — Draw `love.graphics.line` segments connecting several of your stars to trace a simple constellation shape.
