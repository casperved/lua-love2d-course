# Assignment 07: Functions

## What you'll learn

How to write a reusable function with parameters — so you can stamp the same drawing on screen multiple times, each with different colors and sizes.

---

## How it works

### A function is like a recipe

Imagine you write a recipe for chocolate chip cookies. You write it down once. Then any time you want cookies, you just say "make the cookie recipe" — you don't rewrite it from scratch.

Functions work exactly the same way. You **define** the recipe once, then **call** it whenever you need it.

```lua
-- Define the recipe (written once, at the top of your file)
function sayHello(name)
    print("Hello, " .. name .. "!")
end

-- Call it as many times as you like
sayHello("Alex")    -- prints: Hello, Alex!
sayHello("Morgan")  -- prints: Hello, Morgan!
sayHello("River")   -- prints: Hello, River!
```

Without functions, you'd have to paste the same code over and over. With functions, you write it once and reuse it forever.

### Parameters are blanks in a form

The words inside the parentheses are called **parameters**. They are like blanks in a form — each time you call the function you fill in the blanks with different values.

```lua
function drawCircleAt(x, y, radius, red, green, blue)
    love.graphics.setColor(red, green, blue)
    love.graphics.circle("fill", x, y, radius)
end

drawCircleAt(200, 300, 50, 1, 0, 0)   -- big red circle
drawCircleAt(500, 150, 20, 0, 0, 1)   -- small blue circle
```

Same recipe, different results — because the inputs are different.

### Define once, call many times

Once `drawCircleAt` exists, you never think about the details again. You just call it. This is the whole point: **hide the details inside the function, use a short name on the outside.**

In this assignment you'll write two functions — `drawHouse` and `drawTree` — and call them several times to build a complete scene.

---

## Your mission

Build a sunny landscape! When the program runs you should see:

- A blue sky and a green field.
- Three houses in a row, each a different color.
- Two or three trees placed between and beside the houses.

Open `starter/main.lua` and fill in the TODOs:

1. **Write `drawHouse`** — fill in the body so it draws a wall, a roof, a door, and a window using the `x`, `y`, `size`, `r`, `g`, `b` parameters.
2. **Write `drawTree`** — fill in the body so it draws a trunk (rectangle) and a triangular canopy (polygon).
3. **In `love.draw`** — call `drawHouse` and `drawTree` several times with different positions and sizes to build the scene.

---

## Hints

<details><summary>Hint 1 — How do I define a function with parameters?</summary>

Write the keyword `function`, then the name, then the parameter names inside parentheses. Everything between `function` and `end` is the body:

```lua
function drawHouse(x, y, size, r, g, b)
    -- drawing code using x, y, size, r, g, b goes here
end
```

Inside the body, `x`, `y`, `size`, `r`, `g`, `b` are just ordinary local variables — use them the same way you'd use any variable.
</details>

<details><summary>Hint 2 — How do I use x, y, and size in draw calls?</summary>

Scale every measurement off `size` so the house looks right at any size. For example:

```lua
-- Wall: a rectangle whose width and height are based on size
love.graphics.rectangle("fill", x, y, size, size * 0.8)

-- Roof: a triangle (polygon) sitting above the wall
love.graphics.polygon("fill",
    x - size * 0.1, y,
    x + size * 0.5, y - size * 0.5,
    x + size * 1.1, y)
```

The same idea works for the door and window — pick offsets and sizes that are fractions of `size`.
</details>

<details><summary>Hint 3 — Full drawHouse body</summary>

```lua
function drawHouse(x, y, size, r, g, b)
    -- Wall
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", x, y, size, size * 0.8)
    -- Roof
    love.graphics.setColor(r * 0.6, g * 0.6, b * 0.6)
    love.graphics.polygon("fill",
        x - size * 0.1, y,
        x + size * 0.5, y - size * 0.5,
        x + size * 1.1, y)
    -- Door
    love.graphics.setColor(0.3, 0.2, 0.1)
    love.graphics.rectangle("fill", x + size * 0.35, y + size * 0.4, size * 0.3, size * 0.4)
    -- Window
    love.graphics.setColor(0.7, 0.9, 1)
    love.graphics.rectangle("fill", x + size * 0.1, y + size * 0.15, size * 0.25, size * 0.25)
end
```
</details>

---

## Stretch Goals

1. **Chimney** — Add a small rectangle above the roof on one side. Scale its position and size off `size` so it looks right on every house.
2. **Clouds** — Write a `drawCloud(x, y)` function that draws three overlapping circles in white. Call it a few times across the top of the sky.
3. **Sun** — Draw a yellow circle in the upper corner with a few short lines radiating outward like rays.
