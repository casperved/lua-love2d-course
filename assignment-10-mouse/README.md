# Assignment 10: Mouse Input

You already used `love.mousepressed` in assignment 08 to plant flowers. Now let's go deeper — you'll use the **distance formula** to check whether a click landed *on* a specific object, and learn the safe way to **remove items** from a table while looping.

---

## The `love.mousepressed` callback

LÖVE calls this function automatically whenever a mouse button is pressed:

```lua
function love.mousepressed(x, y, button)
    -- x, y  = where on screen the click happened
    -- button = 1 (left), 2 (right), 3 (middle)
    if button == 1 then
        print("Left click at", x, y)
    end
end
```

---

## The Distance Formula

To check if a click landed inside a circle, calculate the distance between the click and the circle's center:

```
distance = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
```

If `distance < circle.radius`, the click is inside the circle!

```lua
local dx = clickX - circle.x
local dy = clickY - circle.y
local distance = math.sqrt(dx*dx + dy*dy)

if distance < circle.radius then
    print("Hit!")
end
```

---

## Removing items from a table — the safe way

If you remove an item from a table while looping **forward** (`for i = 1, #t`), the indices shift and you can accidentally skip items or crash. The safe fix is to loop **backwards**:

```lua
for i = #myList, 1, -1 do
    if shouldRemove(myList[i]) then
        table.remove(myList, i)   -- safe! only affects indices >= i
    end
end
```

The third number in the `for` statement (`-1`) is the **step** — it counts down instead of up.

---

## Your Mission

Balloons float upward across the screen. Your job:

1. **Detect clicks on balloons** using the distance formula.
2. **Remove** a popped balloon from the table (loop backwards!).
3. **Track the score** — every pop adds 1 point.

The spawning, movement, and drawing code is already written for you. Your task is the click-detection logic inside `love.mousepressed`.

Open `starter/main.lua` and follow the TODO comments!

---

## Hints

<details><summary>Hint 1 — How do I loop backwards through the balloons?</summary>

```lua
for i = #balloons, 1, -1 do
    local b = balloons[i]
    -- check if the click hit balloon b
end
```

The `for` loop counts from `#balloons` down to `1`, stepping by `-1` each time. This is essential when you might call `table.remove` inside the loop.
</details>

<details><summary>Hint 2 — How do I calculate distance and check for a hit?</summary>

```lua
local dx       = x - b.x
local dy       = y - b.y
local distance = math.sqrt(dx * dx + dy * dy)

if distance < b.radius then
    -- The click landed inside this balloon!
end
```

`x` and `y` here are the parameters passed into `love.mousepressed` — they're the pixel coordinates of the click.
</details>

<details><summary>Hint 3 — How do I remove the balloon and update the score?</summary>

Inside the `if distance < b.radius then` block:

```lua
table.remove(balloons, i)
score = score + 1
break   -- stop checking other balloons — only pop one per click
```

`break` exits the loop immediately so a single click can't pop multiple overlapping balloons.
</details>

---

## Stretch Goals

1. **Pop animation** — Instead of instantly removing a balloon, set a `popping = true` flag and a `popTimer` on it. In `love.update`, grow its radius and fade its alpha over 0.3 seconds, then remove it.
2. **Combo multiplier** — Keep a `combo` counter that increases when you pop multiple balloons within 1 second of each other, and resets after a pause. Multiply the score by the combo!
3. **Missed clicks penalty** — If a click doesn't hit any balloon, subtract 1 from the score (minimum 0). Display a "Miss!" message near the click for half a second.
