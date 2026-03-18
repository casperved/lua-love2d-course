# Assignment 08: Tables

So far all your variables have held a single value — a number, or maybe a string. What if you want to keep track of **many things at once**, like a whole garden full of flowers? That's what **tables** are for!

---

## Tables are lists

In Lua, a table is a container that can hold many values:

```lua
myList = {}                  -- create an empty table
table.insert(myList, "apple")
table.insert(myList, "banana")
table.insert(myList, "cherry")

print(#myList)       -- 3  (the # operator gives the length)
print(myList[1])     -- apple   (items are numbered starting at 1)
print(myList[2])     -- banana
```

---

## Tables can hold tables!

Each item in a table can itself be a table — this is how we store objects with multiple properties:

```lua
local flower = {
    x = 250,
    y = 400,
    r = 1.0,
    g = 0.3,
    b = 0.8
}

print(flower.x)   -- 250
print(flower.g)   -- 0.3
```

---

## Looping through a table

Use a `for` loop with `#` to visit every item:

```lua
for i = 1, #myList do
    print(myList[i])
end
```

---

## Adding items when something happens

You can add to a table at any time, not just when the program starts. For example, when the player clicks the mouse:

```lua
function love.mousepressed(x, y, button)
    if button == 1 then   -- left mouse button
        table.insert(myList, {x = x, y = y})
    end
end
```

---

## Your Mission

Build an interactive flower-planting app!

- Every time you **left-click** on the screen, a new flower appears at that spot.
- Each flower has a **random color** (use `math.random()` which returns a value between 0 and 1).
- All flowers are stored in a table and drawn every frame.
- The screen shows how many flowers you have planted.

Open `starter/main.lua` and follow the TODO comments!

---

## Hints

<details><summary>Hint 1 — Where do I create the flowers table?</summary>

At the very top of your file (outside any function), add:

```lua
flowers = {}
```

This creates an empty table that every function in your file can see and use.
</details>

<details><summary>Hint 2 — How do I draw each flower?</summary>

Loop through the table and use each flower's fields:

```lua
for i = 1, #flowers do
    local f = flowers[i]

    -- Green stem going downward from the bloom
    love.graphics.setColor(0.1, 0.6, 0.1)
    love.graphics.setLineWidth(3)
    love.graphics.line(f.x, f.y, f.x, f.y + 40)
    love.graphics.setLineWidth(1)

    -- Colourful bloom
    love.graphics.setColor(f.r, f.g, f.b)
    love.graphics.circle("fill", f.x, f.y, 15)
end
```
</details>

<details><summary>Hint 3 — How do I add a flower on mouse click?</summary>

```lua
function love.mousepressed(x, y, button)
    if button == 1 then
        local newFlower = {
            x = x,
            y = y,
            r = math.random(),   -- random number 0.0 – 1.0
            g = math.random(),
            b = math.random()
        }
        table.insert(flowers, newFlower)
    end
end
```
</details>

---

## Stretch Goals

1. **Right-click to remove** — In `love.mousepressed`, if `button == 2` (right click), loop backwards through flowers and remove the one closest to the click (use the distance formula from assignment 10!).
2. **Growing flowers** — Give each flower a `size` that starts at 0 and grows to 15 in `love.update`. Use `f.size = math.min(f.size + dt * 30, 15)`.
3. **Petals** — Instead of a plain circle, draw 5 small circles arranged around the center of the bloom to make it look like a real flower with petals.
