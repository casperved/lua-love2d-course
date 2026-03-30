# Assignment 17: Procedural Generation

## What you'll learn

How to use `math.random()` to let your code build a different world every single time.

---

## How it works

Imagine you had to paint 120 stars on a canvas by hand. You'd have to decide exactly where each one goes. That takes forever — and every painting would look the same.

Now imagine you rolled a pair of dice instead. Roll for X. Roll for Y. Roll for the size. Suddenly every painting is different, and you did almost no work. That's **procedural generation**.

Games like Minecraft, Spelunky, and No Man's Sky use this trick to make worlds that are different every time you play. You write the *rules*, and the computer rolls the dice.

### math.random() — your dice

Without any numbers, it gives you a random decimal between 0 and 1:

```lua
math.random()   -- could be 0.0, 0.37, 0.99 — anything in between
```

With two whole numbers, it picks a random integer in that range (both ends included):

```lua
math.random(1, 6)     -- like a six-sided die: 1, 2, 3, 4, 5, or 6
math.random(0, 800)   -- a random x position anywhere on screen
```

### Making a random number land in a custom range

Want brightness between 0.5 and 1.0 (never fully dark)? Stretch and shift:

```lua
local brightness = math.random() * 0.5 + 0.5
--                 ^^^^^^^^^^^^^^^^  gives 0.0–0.5
--                                  + 0.5 slides it up to 0.5–1.0
```

### Seeding — why you need os.time()

By default Lua's random numbers follow the **same secret list** every run. Your program would be identical every time you opened it. One line fixes that:

```lua
math.randomseed(os.time())  -- use the current clock as the starting point
```

Call it once in `love.load()` and from then on every run is genuinely random.

### The dungeon grid

We store the dungeon as a 2D table of `true`/`false` values:

- `true` means the tile is a **wall**
- `false` means it's a **floor**

We loop over every row and column. Border tiles are *always* walls (so the room stays enclosed). Interior tiles have a 30 % chance of being a wall — that's all it takes to get a dungeon that looks hand-crafted.

---

## Your mission

Press SPACE and watch a brand-new starfield and dungeon appear. Right now SPACE does nothing and no stars or tiles are drawn. Your job is to fill in the five TODOs:

1. **TODO 1** — fill the `stars` table with 120 random stars (position, size, brightness).
2. **TODO 2** — fill the `tiles` grid: borders are always walls, interior tiles are walls 30% of the time.
3. **TODO 3** — draw every star using its stored brightness as the colour.
4. **TODO 4** — draw every tile: walls get a dark purple colour, floors get a very dark colour.
5. **TODO 5** — make SPACE call `generate()` so the world rebuilds.

After TODO 1 and TODO 3 you'll see stars. After TODO 2 and TODO 4 you'll see the dungeon overlay. TODO 5 ties it all together.

---

## Hints

<details><summary>Hint 1 — Creating the stars (TODO 1 & 3)</summary>

Build the table inside a loop. Each star is a small table with four fields:

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

Then in `love.draw`, loop over `stars` and use `s.brightness` for all three colour channels — that gives a white-to-grey star:

```lua
love.graphics.setColor(s.brightness, s.brightness, s.brightness * 0.9 + 0.1)
love.graphics.circle("fill", s.x, s.y, s.radius)
```

</details>

<details><summary>Hint 2 — Building the tile grid (TODO 2)</summary>

You need a table-of-tables. Create each row as its own table, then fill each column:

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

`math.random() < 0.3` is `true` about 30 % of the time — that's your random wall chance. `isBorder or ...` means border tiles are always walls regardless.

</details>

<details><summary>Hint 3 — Drawing the tile grid (TODO 4)</summary>

Loop through every row and column. Multiply the index by `TILE_SIZE` to turn the grid position into a pixel position. Subtract 1 pixel from the size to leave a thin gap between tiles:

```lua
for row = 1, ROWS do
    for col = 1, COLS do
        if tiles[row] and tiles[row][col] then
            love.graphics.setColor(0.38, 0.28, 0.48)   -- wall: dark purple
        else
            love.graphics.setColor(0.09, 0.07, 0.14)   -- floor: very dark
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

1. **Cave smoother** — after building the random grid, loop over every interior tile and count how many of its neighbours are walls. If 5 or more are walls, make it a wall; otherwise make it a floor. Run this pass two or three times and you'll get organic cave shapes (this technique is called "cellular automata").
2. **Random colour themes** — at the start of `generate()` pick random wall and floor colours and store them in variables. Use those variables in your draw loop so each new dungeon has its own look — icy blue, volcanic red, mossy green.
3. **Treasure hunt** — after generating the dungeon, find a random floor tile and mark it as the treasure. Draw a small yellow rectangle there. Move a white dot around with WASD and print "You found it!" when the dot reaches the treasure. Now your procedural room has a goal!
