# Assignment 22: Multiple Files

## What you'll learn

How to split your Lua code across several files so that big projects stay tidy and easy to read.

---

## How it works

### Imagine a recipe binder

You are baking a big cake. You could write every recipe on one giant piece of paper — but it gets messy fast. Instead you put each recipe on its own card: one card for the batter, one for the frosting, one for the filling. When you need the frosting recipe you just grab that card.

Lua does the same thing with `require`.

```lua
-- main.lua
Player = require("player")   -- "grab the player card"
```

When Lua sees `require("player")` it opens `player.lua`, runs it, and hands back whatever that file returned. You store the result in a variable (`Player`) and use it anywhere in your program.

### What does a module file look like?

Every module follows the same three-step recipe:

1. **Create a table** to hold everything.
2. **Put your functions** inside it.
3. **Return the table** at the end.

```lua
-- greet.lua
local M = {}            -- step 1: the "card"

function M.hello(name)  -- step 2: add a function
    return "Hi, " .. name .. "!"
end

return M                -- step 3: hand the card back
```

```lua
-- main.lua
Greet = require("greet")
print(Greet.hello("world"))   -- prints: Hi, world!
```

That is the whole pattern. `local M = {}` is just a conventional short name — you will see it everywhere in Lua code.

### Where does LÖVE look for the files?

LÖVE looks in the **same folder** as `main.lua`. So if your project folder has:

```
starter/
  main.lua
  player.lua
  asteroids.lua
  utils.lua
```

then `require("player")` will find `player.lua` automatically. No paths needed.

### Why split into multiple files?

| One big file | Split into modules |
|--------------|--------------------|
| Hard to scroll through | Each file has one job |
| Easy to break something unrelated | Changes stay in the right file |
| Hard to reuse code | Any module can `require` another |

In this project `utils.lua` holds small helper functions that **both** `player.lua` and `asteroids.lua` use. No copy-pasting needed — they just `require("utils")`.

---

## Your mission

Open the `starter/` folder. The game runs and you can move the ship around — but the player can never die, because the two key functions are missing.

Your two tasks are in **`utils.lua`** and **`asteroids.lua`**:

**TODO 1 — `utils.lua`: write the `distance` function.**

Right now it always returns `999`. Replace that with the real formula for the straight-line distance between two points:

```
distance = sqrt( (x2 - x1)² + (y2 - y1)² )
```

**TODO 2 — `asteroids.lua`: write the `checkCollision` function.**

Right now it always returns `false`. Replace that with a loop that goes through every asteroid in `Asteroids.list`. If the distance from the player centre to an asteroid centre is smaller than the sum of their radii, they are touching — return `true`. If nothing hits, return `false`.

Look for the two `-- TODO` comments — that is exactly where your changes go.

---

## Hints

<details><summary>Hint 1 — distance formula in utils.lua</summary>

Find the difference in x and the difference in y, then use Pythagoras:

```lua
function M.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
```
</details>

<details><summary>Hint 2 — collision loop in asteroids.lua</summary>

Go through every asteroid. Each one has an `.x`, `.y`, and `.r` (radius). The player has position `px, py` and radius `pr`. Two circles overlap when the distance between their centres is less than their radii added together:

```lua
function Asteroids.checkCollision(px, py, pr)
    for _, a in ipairs(Asteroids.list) do
        if utils.distance(px, py, a.x, a.y) < pr + a.r then
            return true
        end
    end
    return false
end
```
</details>

<details><summary>Hint 3 — nothing seems to happen after adding the code?</summary>

Double-check two things:

1. In `utils.lua`, make sure you **deleted** (or replaced) the `return 999` line. If it is still there, the real calculation never runs.
2. In `asteroids.lua`, make sure you **deleted** (or replaced) the `return false` stub at the top of `checkCollision`. A `return` that runs early means the loop below it never executes.
</details>

---

## Stretch Goals

- Add a `utils.clamp(value, min, max)` helper that keeps a number inside a range. Then use it in `player.lua` to stop the ship from flying off the screen edges.
- Create a `hud.lua` module with a `HUD.draw(score, lives)` function and `require` it in `main.lua`. Moving the HUD drawing code there is good practice with the module pattern.
- Add a **difficulty ramp**: every 10 seconds, increase `ASTEROID_SPEED_MIN` and `ASTEROID_SPEED_MAX` by 20 so the rocks fall faster the longer you survive.
