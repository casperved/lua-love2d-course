# Assignment 01: Hello, World!

Welcome to your very first program! Every coder on the planet starts here. By the end of this assignment you'll have colorful text lighting up the screen — written by you.

---

## What you'll learn

How to print text in different colors using LÖVE2D's three core functions.

---

## How it works

### LÖVE2D runs three functions for you, automatically

Think of LÖVE2D like a movie projector. It runs your code on a loop, drawing frame after frame — about 60 times every second — so things can move and change smoothly.

You give it three functions and it knows exactly when to call each one:

**`love.load()`** — runs once, right at the start.
Use this to get things ready. Like packing your bag before a trip — you do it once, not every single step of the walk.

**`love.update(dt)`** — runs every frame, before drawing.
This is where things *change* — moving characters, timers counting down, etc. We won't need it yet, but LÖVE2D expects it to exist.

**`love.draw()`** — runs every frame, to paint the screen.
Everything you can see gets drawn here. LÖVE2D clears the screen and calls this function again and again — so fast it looks smooth.

---

### Colors are three numbers

Screens mix red, green, and blue light to make every color. LÖVE2D uses the same idea. You give it three numbers — one for red, one for green, one for blue — each between `0` (none) and `1` (full blast).

```lua
love.graphics.setColor(1, 0, 0)    -- red:1  green:0  blue:0  → pure red
love.graphics.setColor(0, 0, 1)    -- red:0  green:0  blue:1  → pure blue
love.graphics.setColor(1, 1, 0)    -- red:1  green:1  blue:0  → yellow
love.graphics.setColor(1, 1, 1)    -- all full → white
love.graphics.setColor(0, 0.5, 1)  -- half green, full blue  → sky blue
```

Once you call `setColor`, every drawing command after it uses that color — until you call `setColor` again with something different.

---

### Printing text

```lua
love.graphics.print("Hello, World!", 100, 100)
```

- The text goes inside quotes.
- The second number is `x` — how many pixels from the **left** edge.
- The third number is `y` — how many pixels from the **top** edge.

The default window is **800 pixels wide** and **600 pixels tall**. Position `(0, 0)` is the top-left corner.

---

## Your mission

Open `starter/main.lua` and fill in the three TODOs inside `love.draw()`:

1. Set the color to **red**, then print **"Hello, World!"** at position `(100, 100)`.
2. Set the color to **sky blue** `(0, 0.5, 1)`, then print **your name** at position `(100, 150)`.
3. Pick **any color you like**, then print **any message you like** at position `(100, 200)`.

Run it with `love starter/` and see your words appear!

---

## Hints

<details><summary>Hint 1 — How do I set a color?</summary>

Call `love.graphics.setColor` with three numbers: red, green, blue — each between 0 and 1.

Pure red looks like this:

```lua
love.graphics.setColor(1, 0, 0)
```

Full red, no green, no blue. Try tweaking the numbers to see what colors you get!
</details>

<details><summary>Hint 2 — How do I print text?</summary>

```lua
love.graphics.print("Hello, World!", 100, 100)
```

First comes the text in quotes, then the x position (from the left), then the y position (from the top).
</details>

<details><summary>Hint 3 — Why isn't my text the right color?</summary>

`setColor` must come **before** `print`. The color is like picking up a marker — you choose the color first, then you write.

```lua
love.graphics.setColor(1, 0, 0)                    -- pick up the red marker
love.graphics.print("Hello, World!", 100, 100)     -- write in red

love.graphics.setColor(0, 0.5, 1)                  -- swap to sky blue
love.graphics.print("My name is Alex!", 100, 150)  -- write in sky blue
```
</details>

---

## Stretch Goals

Finished already? Great work! Try one of these:

1. **Bigger text.** Call `love.graphics.setNewFont(48)` inside `love.load()` and rerun. How big can you go before it falls off screen?

2. **Rainbow stack.** Print the same word five times, each line a little lower (`y = 100, 150, 200, 250, 300`) and each in a different color. Red → orange `(1, 0.5, 0)` → yellow → green → blue.

3. **Center it.** The screen is 800 pixels wide. Experiment with the x position until "Hello, World!" looks roughly centered. (Bonus: look up `love.graphics.getWidth()` to get the screen width in code instead of guessing.)
