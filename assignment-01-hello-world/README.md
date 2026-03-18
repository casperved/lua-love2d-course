# Assignment 01: Hello, World!

Welcome to your very first LÖVE2D program! Every programmer's journey starts with printing "Hello, World!" on the screen — it's a tradition. By the end of this assignment, you'll have colorful text appearing wherever you want it.

---

## How LÖVE2D Programs Work

When you run a LÖVE2D program, it automatically looks for three special functions in your `main.lua` file:

### `love.load()`
This runs **once**, right when the program starts. It's the perfect place to set things up — like loading images or setting starting values. Think of it as your game's "morning routine."

### `love.update(dt)`
This runs **every single frame** — about 60 times per second! It's where things *change* over time (movement, physics, game logic). The `dt` parameter stands for "delta time" — we'll use that more in later assignments.

### `love.draw()`
This also runs **every frame**, right after `update`. It's where you tell LÖVE2D what to draw on screen. Everything you see gets drawn here, then erased, then drawn again — super fast, so it looks smooth.

---

## New Concepts

### Strings
A **string** is just a piece of text in your code. You write strings inside quotation marks:
```lua
"Hello, World!"
"My name is Alex"
"I love coding!"
```

### Colors in LÖVE2D
Colors use three numbers: **red**, **green**, and **blue** — each from `0` (none of that color) to `1` (full amount). This is called RGB color.

```lua
love.graphics.setColor(1, 0, 0)    -- Pure red
love.graphics.setColor(0, 1, 0)    -- Pure green
love.graphics.setColor(0, 0, 1)    -- Pure blue
love.graphics.setColor(1, 1, 0)    -- Yellow (red + green)
love.graphics.setColor(1, 1, 1)    -- White (all colors)
love.graphics.setColor(0, 0, 0)    -- Black (no colors)
love.graphics.setColor(0, 0.5, 1)  -- Sky blue
```

Once you call `setColor`, every drawing command after it uses that color — until you call `setColor` again.

### Printing Text
```lua
love.graphics.print("Your text here", x, y)
```
- The first part is your string (the text to display)
- `x` is how far from the **left** edge of the screen (in pixels)
- `y` is how far from the **top** edge of the screen (in pixels)

The default screen is **800 pixels wide** and **600 pixels tall**.

---

## Your Mission

Open `starter/main.lua` and fill in the TODOs to:

1. Display **"Hello, World!"** in **red** at position (100, 100)
2. Display **your name** in **bright blue** at position (100, 150)
3. Display **any message you like** in **a color you pick** at position (100, 200)

Run it and see your words light up the screen!

---

## Hints

<details>
<summary>Hint 1 — Setting a color</summary>

To set the color to red, remember that red is the first of the three numbers, and it goes up to 1:

```lua
love.graphics.setColor(1, 0, 0)
```

The three numbers are (red, green, blue). All between 0 and 1.
</details>

<details>
<summary>Hint 2 — Printing text</summary>

To print text at a specific spot on screen:

```lua
love.graphics.print("Hello, World!", 100, 100)
```

The first argument is your text (in quotes), then the x position, then the y position.
</details>

<details>
<summary>Hint 3 — Putting it together</summary>

Always call `setColor` BEFORE `print`, so the text gets drawn in the right color:

```lua
love.graphics.setColor(1, 0, 0)           -- set color to red
love.graphics.print("Hello, World!", 100, 100)  -- draw in red

love.graphics.setColor(0, 0.5, 1)         -- set color to blue
love.graphics.print("My name is Alex!", 100, 150)  -- draw in blue
```
</details>

---

## Stretch Goals

Done already? Nice work! Here are some optional extras to try:

1. **Make it bigger!** Look up `love.graphics.setNewFont(size)` and call it in `love.load()` to make your text larger. Try a size of `32` or `48`.

2. **Center your text!** The screen is 800 pixels wide. If you print at x=350 or so, your text will look centered. Try to find the x position that makes "Hello, World!" appear right in the middle of the screen. (Bonus: look up `love.graphics.getWidth()` to get the screen width in code!)

3. **Rainbow text!** Print the same message 5 times, each slightly lower on screen and in a different color — red, orange, yellow, green, blue. Make a rainbow!
