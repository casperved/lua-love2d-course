# Assignment 10: Mouse Input

Pop balloons by clicking on them! You'll learn how to detect mouse clicks, measure the distance between two points, and safely remove items from a table while you're looping through it.

---

## What you'll learn

How to use the mouse click position to hit-test circular objects using the **distance formula**, and how to safely **remove items from a table** while looping.

---

## How it works

### Listening for clicks

You've seen `love.mousepressed` before — you used it in assignment 08 to plant flowers. Here you'll use it again, but this time you'll write the whole thing yourself.

Every time the player clicks the mouse, LÖVE calls a special function for you:

```lua
function love.mousepressed(x, y, button)
    -- x, y   = the pixel position of the click on screen
    -- button = which button: 1 = left, 2 = right, 3 = middle
end
```

Think of it like a doorbell. You don't have to keep checking — LÖVE rings the doorbell for you the moment the player clicks.

---

### Did the click land ON the balloon?

A balloon is a circle. Imagine drawing a line from the centre of the balloon to where the player clicked. If that line is **shorter than the balloon's radius**, the click is inside the balloon.

```
[click]----distance----[centre]
```

If `distance < radius` → hit!
If `distance >= radius` → miss.

We calculate the distance with the **distance formula**. Picture a right-angle triangle:

- One side goes left/right between the two points (`dx`)
- The other side goes up/down (`dy`)
- The distance is the hypotenuse (the long diagonal side)

```lua
local dx       = clickX - balloon.x    -- how far apart, left/right
local dy       = clickY - balloon.y    -- how far apart, up/down
local distance = math.sqrt(dx*dx + dy*dy)  -- the actual distance
```

`math.sqrt(n)` gives the square root of `n`. LÖVE and Lua include it as a standard tool — you don't need to add anything to use it.

This is just the Pythagoras theorem from maths class, written in Lua.

---

### Removing items from a table — the right way

Imagine you have a row of five chairs and you want to remove chair number 2. As soon as you pull it out, chairs 3, 4, and 5 slide along to fill the gap. If you were already looking at chair 3, it has now become chair 2 — and you accidentally skip it!

The fix: start from the **last** chair and work backwards. Removing a chair from the end never shifts the chairs you haven't visited yet.

```lua
-- BACKWARDS — safe to remove items inside the loop
for i = #balloons, 1, -1 do
    if shouldPop(balloons[i]) then
        table.remove(balloons, i)
    end
end
```

The `-1` at the end of the `for` line is the **step** — it tells the loop to count down instead of up.

### Stopping early with break

Once you've found a balloon that was clicked and popped it, there's no reason to keep checking the others. `break` exits the loop immediately — useful when you've found what you were looking for and don't need to keep checking.

```lua
table.remove(balloons, i)
break   -- stop the loop right here
```

---

## Your mission

Colourful balloons float up the screen. Click them to pop them!

The balloons, the drawing code, and the spawning timer are already written. Your job is to fill in `love.mousepressed` so clicks actually do something.

Open `starter/main.lua` and complete the three TODOs:

1. **TODO 1** — Loop through `balloons` backwards (from `#balloons` down to `1`). The first two lines of the loop are given — fill in the body.
2. **TODO 2** — Calculate the distance from the click `(x, y)` to each balloon's centre.
3. **TODO 3** — If the click is inside the balloon, remove it, add 10 to the score, and `break` out of the loop.

---

## Hints

<details><summary>Hint 1 — How do I loop backwards through the balloons?</summary>

A backwards `for` loop looks like this:

```lua
for i = #balloons, 1, -1 do
    local b = balloons[i]
    -- b is the current balloon
end
```

The three numbers after `for i =` mean: **start** at `#balloons`, **stop** at `1`, **step** by `-1` each time.

This is the safe pattern any time you might call `table.remove` inside the loop.
</details>

<details><summary>Hint 2 — How do I calculate the distance and check for a hit?</summary>

Use `dx` and `dy` (the horizontal and vertical gaps between the click and the balloon centre), then apply Pythagoras:

```lua
local dx       = x - b.x
local dy       = y - b.y
local distance = math.sqrt(dx * dx + dy * dy)

if distance < b.radius then
    -- The click landed inside this balloon!
end
```

`x` and `y` are the parameters that `love.mousepressed` already gives you — the pixel position of the click.
</details>

<details><summary>Hint 3 — How do I pop the balloon and update the score?</summary>

Inside the `if distance < b.radius then` block, spawn the particle burst, remove the balloon from the table, add points, and stop checking:

```lua
spawnParticles(b.x, b.y, b.r, b.g, b.b)
table.remove(balloons, i)
score = score + 10
break   -- exit the loop — one click can only pop one balloon
```

`break` jumps out of the loop immediately, so even if two balloons overlap the same spot only one gets popped per click.
</details>

---

## Stretch Goals

1. **Pop particles** — When a balloon is popped, spawn a burst of tiny coloured dots that fly outward and fade out over half a second. (Take a peek at the solution for a working example!)
2. **Missed-click penalty** — If a click doesn't hit any balloon, subtract 1 from the score (minimum 0) and flash a "Miss!" message near the cursor for 0.5 seconds.
3. **Point value by size** — Smaller balloons are harder to click. Award more points for smaller ones: `score = score + math.floor(50 / b.radius)`.
