# Assignment 03: Variables & Math

So far you've typed numbers directly into your drawing calls. But what happens if you want to move your ball to a different spot? You'd have to change the number in five different places! There's a much smarter way: **variables**.

---

## What Is a Variable?

Think of a variable as a **labeled box** that holds a value. You give the box a name, put something inside it, and then use that name whenever you need the value.

```lua
ballX = 400     -- A box labeled "ballX" holding the number 400
ballY = 300     -- A box labeled "ballY" holding the number 300
```

Now instead of writing `400` and `300` everywhere, you write `ballX` and `ballY`. When you want to move the ball, you just change the number in one box — and everything that uses that variable updates automatically!

Variable names in Lua:
- Can contain letters, numbers, and underscores `_`
- Cannot start with a number
- Are case-sensitive (`ballX` and `ballx` are different!)
- Should be descriptive — `ballRadius` is clearer than `r`

---

## Basic Math

You can do math with variables just like a calculator:

```lua
x = 100 + 50      -- x is now 150
y = 300 - 75      -- y is now 225
size = 20 * 3     -- size is now 60
half = 100 / 2    -- half is now 50
```

You can also mix variables and numbers together:
```lua
ballX = ballX + 10    -- move the ball 10 pixels to the right
```

---

## Tables: Storing Multiple Values Together

Sometimes you want to group related values. In Lua, a **table** lets you do this:

```lua
ballColor = {1, 0.5, 0}    -- an orange color, stored as one unit
```

To access the values inside, use square brackets and a number:
```lua
ballColor[1]    -- gets the first value:  1   (red)
ballColor[2]    -- gets the second value: 0.5 (green)
ballColor[3]    -- gets the third value:  0   (blue)
```

---

## Where Should Variables Live?

Global variables (like `ballX = 400`) can go at the top of the file, outside any function. That way every function can see and use them.

`love.load()` is also a great place to set starting values — it runs once at the beginning, so it's perfect for setup.

---

## Your Mission

Open `starter/main.lua` and fill in the TODOs to:

1. Define variables for the ball's **position** (`ballX`, `ballY`), **size** (`ballRadius`), and **color** (`ballColor`)
2. Draw the ball using those variables
3. Display a text label showing the ball's x and y position on screen

Then try **changing the variable values** and re-running — watch how the ball jumps to a different position without you having to change anything in the drawing code!

---

## Hints

<details>
<summary>Hint 1 — Creating variables</summary>

Variables in Lua are created just by assigning a value to a name. Put these near the top of your file, before any functions:

```lua
ballX = 400
ballY = 300
ballRadius = 40
```

For the color table, use curly braces:
```lua
ballColor = {1, 0.5, 0}    -- orange!
```
</details>

<details>
<summary>Hint 2 — Drawing with variables</summary>

Once you have variables, use them in your drawing calls exactly like you'd use numbers:

```lua
love.graphics.setColor(ballColor[1], ballColor[2], ballColor[3])
love.graphics.circle("fill", ballX, ballY, ballRadius)
```

Notice how we access each part of the color table with `[1]`, `[2]`, `[3]`.
</details>

<details>
<summary>Hint 3 — Displaying the position as text</summary>

To show the ball's coordinates as text, use `..` to join (concatenate) strings and numbers together:

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.print("x = " .. ballX .. "  y = " .. ballY, 10, 10)
```

The `..` operator glues pieces of text together into one string. So if `ballX` is 400, this prints `"x = 400  y = 300"`.
</details>

---

## Stretch Goals

1. **Calculated positions!** Instead of setting `ballX` and `ballY` directly, calculate them: set `ballX = 800 / 2` (center of screen) and `ballY = 600 / 2`. Run it — does the ball appear in the center? Now try `love.graphics.getWidth() / 2` instead of `800 / 2`.

2. **Second ball!** Create a second set of variables (`ball2X`, `ball2Y`, `ball2Radius`, `ball2Color`) and draw a second ball in a different spot with a different color.

3. **Math art!** Set `ballX = ballRadius * 3`. Change `ballRadius` to different values and see how both the size and position change at once. That's the power of using variables!
