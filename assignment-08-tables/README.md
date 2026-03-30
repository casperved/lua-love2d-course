# Assignment 08: Tables — A Garden Full of Flowers

## What you'll learn

How to store and use **many things at once** using a table — Lua's all-purpose list.

---

## How it works

### Variables can only hold one thing

So far your variables have looked like this:

```lua
ballX = 100
ballY = 200
```

Each variable holds **one number**. That's fine for one ball. But what if you want a garden with 50 flowers? You don't want 50 variables!

### A table is like a shopping bag

Imagine a shopping bag. You can put **as many items as you like** inside it. In Lua that bag is called a **table**:

```lua
bag = {}                      -- empty bag
table.insert(bag, "apple")    -- toss an apple in
table.insert(bag, "banana")   -- toss a banana in
table.insert(bag, "cherry")   -- toss a cherry in

print(#bag)     -- 3   (#bag means "how many things are in bag?")
print(bag[1])   -- apple   (item 1, 2, 3 ... Lua starts counting at 1)
```

### Two ways to access a table field

You can use a **number index** (`t[1]`, `t[2]`, …) or a **named field** (`t.x`, `t.name`, …). Both are valid — they just use different kinds of keys.

```lua
-- Numbered index — like items in a list
local color = {1.0, 0.5, 0.2}
print(color[1])   -- 1.0   (the red channel)

-- Named field — like a labelled box
local flower = {x = 300, y = 450, r = 1.0}
print(flower.x)   -- 300
print(flower.r)   -- 1.0
```

Inside this assignment you'll use named fields because they make your code easier to read: `f.x` is clearer than `f[1]`.

### Each item can have its own properties

Instead of just storing a word, you can store a **mini-table** (think of it as a labelled box) inside the bag:

```lua
local flower = {
    x = 300,      -- where on screen
    y = 450,
    r = 1.0,      -- red amount  (0 to 1)
    g = 0.2,      -- green amount
    b = 0.8,      -- blue amount
}

print(flower.x)   -- 300
print(flower.r)   -- 1.0
```

### Visiting every item with a loop

To do something with every item in a table, use a `for` loop and the `#` operator:

```lua
for i = 1, #flowers do
    local f = flowers[i]   -- grab flower number i
    -- now use f.x, f.y, f.r, etc.
end
```

### Adding a new item when the player clicks

```lua
function love.mousepressed(x, y, button)
    if button == 1 then   -- left click
        local newFlower = { x = x, y = y }
        table.insert(flowers, newFlower)
    end
end
```

Every click creates a new mini-table and drops it into the bag. The loop in `love.draw` picks it up automatically next frame — you don't have to change anything else!

---

## Your mission

Plant a garden! When you run the finished program:

- The screen shows a blue sky and a green grassy field.
- Every **left-click** plants a flower at that spot.
- Each flower has a **random color**, a stem, petals, and a bright center dot.
- Flowers **grow from tiny to full size** — they start at size 0 and bloom over time.
- A counter in the top-left shows how many flowers you've planted.

Open `starter/main.lua` and fill in the TODOs:

**TODO 1** — Write `spawnFlower(x, y)`. Create a table with all the fields a flower needs and insert it into `flowers`.

**TODO 2** — In `love.update`, grow each flower a little bit every frame until it reaches its `maxSize`.

**TODO 3** — In `love.draw`, loop through every flower and draw it (stem, petals, bloom, center dot).

---

## Hints

<details><summary>Hint 1 — What fields should a new flower have?</summary>

Give the flower table all the properties it needs:

```lua
function spawnFlower(x, y)
    local newFlower = {
        x       = x,
        y       = y,
        r       = math.random(),          -- random number between 0.0 and 1.0
        g       = math.random(),
        b       = math.random(),
        size    = 0,                      -- starts tiny
        maxSize = math.random(12, 22),    -- grows to a random final size
    }
    table.insert(flowers, newFlower)
end
```

`math.random()` with no arguments gives a random decimal between 0 and 1 — perfect for a color channel.
</details>

<details><summary>Hint 2 — How do I make a flower grow in love.update?</summary>

Loop through every flower and nudge its `size` upward each frame. Use `math.min` so it never goes past `maxSize`:

```lua
for i = 1, #flowers do
    local f = flowers[i]
    if f.size < f.maxSize then
        f.size = math.min(f.size + dt * 40, f.maxSize)
    end
end
```

`dt` is the time since the last frame (a tiny number like 0.016). Multiplying by 40 makes the flower bloom in about half a second.
</details>

<details><summary>Hint 3 — How do I draw the stem, petals, bloom, and center dot?</summary>

Inside your drawing loop, use each flower's fields:

```lua
for i = 1, #flowers do
    local f = flowers[i]

    -- Stem: a thick line going downward from the bloom
    love.graphics.setColor(0.1, 0.55, 0.1)
    love.graphics.setLineWidth(3)
    love.graphics.line(f.x, f.y, f.x, f.y + 45)
    love.graphics.setLineWidth(1)

    -- Petals: 5 small circles arranged in a ring around the center
    love.graphics.setColor(f.r * 0.8, f.g * 0.8, f.b * 0.8)
    for p = 0, 4 do
        local angle  = (p / 5) * math.pi * 2
        local petalX = f.x + math.cos(angle) * f.size * 0.8
        local petalY = f.y + math.sin(angle) * f.size * 0.8
        love.graphics.circle("fill", petalX, petalY, f.size * 0.6)
    end

    -- Central bloom circle
    love.graphics.setColor(f.r, f.g, f.b)
    love.graphics.circle("fill", f.x, f.y, f.size)

    -- Bright yellow center dot
    love.graphics.setColor(1, 1, 0.6)
    love.graphics.circle("fill", f.x, f.y, f.size * 0.3)
end
```
</details>

---

## Stretch Goals

1. **Right-click to remove** — In `love.mousepressed`, if `button == 2` (right-click), remove the last flower with `table.remove(flowers)`. Watch the counter go down!
2. **Flower limit** — Cap the garden at 20 flowers. Before inserting a new one, check `if #flowers >= 20 then table.remove(flowers, 1) end`. The oldest flower quietly makes room for the newest.
3. **Leaves** — Draw two small ovals branching off the stem to give each flower a leaf on each side.
