# Assignment 03B: Tables as Color Palettes

## What you'll learn

How to group related values into a **table** and access them by position number — then use a table of tables to swap color palettes with a single keypress.

---

## How it works

### A table is a shelf with numbered slots

In assignment 03A you stored a color as three separate variables: `ballR`, `ballG`, `ballB`. That works, but it gets messy when you have many colors.

A **table** lets you keep related values together in one box. You make a table with curly braces `{ }`:

```lua
myColor = {1, 0.5, 0}   -- a shelf with three slots
```

The slots are numbered starting from **1**. Grab a value with square brackets:

```lua
myColor[1]   -- slot 1 → 1    (red)
myColor[2]   -- slot 2 → 0.5  (green)
myColor[3]   -- slot 3 → 0    (blue)  →  orange!
```

Think of it like a row of numbered cups. Cup 1 holds red, cup 2 holds green, cup 3 holds blue.

---

### A table of tables — a shelf of shelves

You can put tables inside tables. That is how we store a whole **palette** — a set of colors:

```lua
palette = {
    {1, 0.2, 0.2},   -- color 1: soft red
    {1, 0.8, 0.2},   -- color 2: golden yellow
    {0.2, 0.6, 1},   -- color 3: sky blue
}
```

`palette` is a shelf. `palette[1]` is the first color (itself a shelf with three cups). `palette[1][2]` is the green amount of the first color.

To use a color from the palette:

```lua
local c = palette[1]              -- grab color 1
love.graphics.setColor(c[1], c[2], c[3])  -- set red, green, blue
```

---

### Cycling through options with modulo

The `%` operator (modulo) gives the **remainder** after division. It is perfect for wrapping a counter around:

```lua
currentPalette = currentPalette % #palettes + 1
```

- `#palettes` is the number of palettes (3 in our case).
- When `currentPalette` reaches 3, `3 % 3 = 0`, then `0 + 1 = 1`. Back to the start!

So the counter goes: 1 → 2 → 3 → 1 → 2 → 3 → ...

---

## Your mission

Open `starter/main.lua`. Palette 1 is already filled in. Your job:

1. **TODO 1** — Add palette 2: pick three colors you like, one per ball.
2. **TODO 2** — Add palette 3: pick three more colors (try something totally different!).
3. **TODO 3** — Inside `love.keypressed`, make Space cycle to the next palette. It should go 1 → 2 → 3 → 1 → ...

Run it with `love starter/` and press Space to watch the colors change!

---

## Hints

<details><summary>Hint 1 — How do I add a palette?</summary>

A palette is a table of three color tables. Copy the structure of palette 1 and change the numbers. Each color is `{red, green, blue}` with values between 0 and 1.

```lua
{ {0.2, 1, 0.5}, {0.1, 0.8, 0.8}, {0.5, 0.2, 1} }
```

Put a comma after each palette inside the outer `palettes` table.
</details>

<details><summary>Hint 2 — How do I make Space cycle the palette?</summary>

Inside `love.keypressed`, you already have `if key == "space" then`. In the body, update `currentPalette` so it goes 1 → 2 → 3 → 1.

The modulo trick: `currentPalette % #palettes` gives you 0 when you reach the end. Adding 1 brings it back to 1.
</details>

<details><summary>Hint 3 — Full keypressed answer</summary>

```lua
function love.keypressed(key)
    if key == "space" then
        currentPalette = currentPalette % #palettes + 1
    end
end
```

`#palettes` automatically counts however many palettes you have, so this still works if you add a 4th palette later.
</details>

---

## Stretch Goals

1. **Add a 4th palette.** Themes to try: fire (`{1,0.2,0}`, `{1,0.5,0}`, `{1,0.8,0}`), pastel, or neon.

2. **Show the palette name.** Give each palette a name field: `{name="Warm", colors={{...},{...},{...}}}` and print `palette.name` on screen.

3. **Smooth color transition.** Instead of snapping instantly, slowly blend each ball's displayed color toward the target color using `dt`. That is a trickier challenge — but very satisfying when it works!
