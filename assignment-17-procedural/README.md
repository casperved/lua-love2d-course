# Assignment 17: Procedural Generation

What if your game could build itself? Procedural generation means using *code and randomness* to create content — instead of placing every star, rock, or room tile by hand. Games like Minecraft, Spelunky, and No Man's Sky are almost entirely procedurally generated. Cool, right?

In this assignment you'll generate two things every time you press Space:

1. A **starfield** — hundreds of stars scattered across the sky at random sizes and brightnesses.
2. A **dungeon room** — a grid of wall and floor tiles where walls are randomly placed (with guaranteed borders so the room stays enclosed).

Each press of Space gives you a completely different result. That's the magic of procedural generation!

---

## Random Numbers in Lua

### math.random()

Without arguments, `math.random()` returns a decimal number between **0.0 and 1.0**:

```lua
print(math.random())  -- e.g. 0.37291...
```

With two integer arguments, it returns a whole number in that range (inclusive):

```lua
print(math.random(1, 6))   -- like rolling a six-sided die: 1, 2, 3, 4, 5, or 6
print(math.random(0, 800))  -- random x position across an 800-pixel screen
```

### Scaling decimals to a range

If you want a decimal in a custom range, multiply and add:

```lua
-- Random brightness between 0.5 and 1.0:
local brightness = math.random() * 0.5 + 0.5
--                 ^^ gives 0.0–0.5, then +0.5 shifts to 0.5–1.0
```

### math.randomseed()

By default, `math.random()` produces the **same sequence** every run. Seeding with the current time makes it different each time:

```lua
math.randomseed(os.time())  -- call this once in love.load!
```

---

## What Does "Procedural" Really Mean?

"Procedural" just means *following a procedure* (a set of rules). A procedural generator is a function that follows rules and introduces randomness to create varied results:

- **Rule**: every border tile is always a wall (so the room is enclosed).
- **Randomness**: interior tiles have a 30% chance of being a wall.

Change the 30% to 60% and you get a dense maze. Drop it to 5% and you get an open room. The *rules* stay the same; only the *numbers* change.

---

## Your Mission

1. Fill in **TODO 1**: generate 120 stars with random positions, sizes, and brightnesses.
2. Fill in **TODO 2**: build the tile grid — borders are always walls, interiors have a 30% wall chance.
3. Fill in **TODO 3**: draw each star using its stored brightness as the colour.
4. Fill in **TODO 4**: draw the tile grid (wall tiles are a dark purple, floors are very dark).
5. Fill in **TODO 5**: pressing Space should call `generate()` to rebuild everything.

---

## Hints

<details><summary>Hint 1 — Generating stars (TODO 1)</summary>

The pattern is:

```lua
stars = {}
for i = 1, 120 do
    table.insert(stars, {
        x          = math.random(0, 800),
        y          = math.random(0, 600),
        radius     = math.random(1, 3),
        brightness = math.random() * 0.5 + 0.5
    })
end
```

`math.random() * 0.5 + 0.5` gives a decimal between 0.5 and 1.0 — so stars are never fully dark.

</details>

<details><summary>Hint 2 — Building the grid (TODO 2)</summary>

You need a 2D table: `tiles[row][col]` is `true` for wall, `false` for floor.

```lua
tiles = {}
for row = 1, ROWS do
    tiles[row] = {}
    for col = 1, COLS do
        local isBorder = (row == 1 or row == ROWS or col == 1 or col == COLS)
        tiles[row][col] = isBorder or (math.random() < 0.3)
    end
end
```

`math.random() < 0.3` is true about 30% of the time — that's your wall chance.

</details>

<details><summary>Hint 3 — Drawing the grid (TODO 4)</summary>

Loop through every row and column. Multiply the index by `TILE_SIZE` to get pixel coordinates, and subtract 1 pixel for a thin gap between tiles:

```lua
for row = 1, ROWS do
    for col = 1, COLS do
        if tiles[row] and tiles[row][col] then
            love.graphics.setColor(0.4, 0.3, 0.5)  -- wall colour
        else
            love.graphics.setColor(0.1, 0.08, 0.15) -- floor colour
        end
        love.graphics.rectangle("fill",
            (col - 1) * TILE_SIZE,
            (row - 1) * TILE_SIZE,
            TILE_SIZE - 1,
            TILE_SIZE - 1)
    end
end
```

</details>

---

## Stretch Goals

1. **Cave generation** — after building the random grid, run a "smoothing pass": count a tile's wall neighbours; if 5 or more are walls, make it a wall, otherwise make it a floor. This creates cave-like shapes (look up "cellular automata cave generation"!).
2. **Colour themes** — pick a random colour palette each time `generate()` runs. Multiply your tile colours by `math.random(0.8, 1.2)` for subtle variation.
3. **Animated stars** — give each star a `twinkle` value and wiggle its brightness in `love.update` using `math.sin(love.timer.getTime() * speed + offset)`.
