# Assignment 03A: Variables

## What you'll learn

How to store values in **variables** so you can change one number and have your whole program update automatically.

---

## How it works

### Variables are labeled boxes

Imagine you have a cardboard box. You write "ballX" on the side, and put the number `400` inside.

```lua
ballX = 400
```

Now whenever your program needs to know where the ball is, it looks inside the box called `ballX` and finds `400`.

The magic part: if you change what's in the box, **everything that uses the box updates too**. You don't have to hunt through your code changing `400` in five different places. You just change it once, at the top.

```lua
ballX = 200   -- move the box to the left — the ball moves too!
```

### Math with variables

You can do math with variables just like a calculator:

```lua
ballX = 400 + 100    -- ballX is now 500
ballX = ballX + 10   -- add 10 to whatever is already in the box
```

### Where to put your variables

Put them at the very top of the file, before any functions. That way every function in your program can see and use them.

---

### Colors are just three variables

A color is made of three amounts: red, green, and blue — each between `0` and `1`. Instead of typing the numbers directly into the drawing call, store them in variables:

```lua
ballR = 1     -- full red
ballG = 0.5   -- half green
ballB = 0     -- no blue  →  orange!
```

Then use those variables when you draw:

```lua
love.graphics.setColor(ballR, ballG, ballB)
```

Change one variable and the color of everything drawn with it changes too.

> **Coming up next:** In assignment 03B you'll learn a neater way to group related values like colors together into a single thing called a **table**.

---

## Your mission

Open `starter/main.lua`. Six variables are declared at the top but all start at `0`.

There are **3 TODOs**:

1. **TODO 1** — Give `ballX`, `ballY`, `ballRadius`, `ballR`, `ballG`, and `ballB` sensible starting values so the ball appears on screen in a color of your choice.
2. **TODO 2** — Draw the ball using those variables.
3. **TODO 3** — Print the ball's position as text in the top-left corner.

When you're done, try tweaking the values at the top and re-running. Watch the ball jump without touching the drawing code!

---

## Hints

<details><summary>Hint 1 — Setting variable values</summary>

Right now all variables are `0`, which hides the ball in the corner and makes it invisible. Try these as a starting point:

```lua
ballX      = 400   -- center of the 800-wide screen
ballY      = 300   -- center of the 600-tall screen
ballRadius = 40

ballR = 1      -- red amount
ballG = 0.5    -- green amount
ballB = 0      -- blue amount  →  orange
```

Feel free to pick any color you like!
</details>

<details><summary>Hint 2 — Drawing the ball with variables</summary>

Once your variables have values, plug them straight into the drawing calls:

```lua
love.graphics.setColor(ballR, ballG, ballB)
love.graphics.circle("fill", ballX, ballY, ballRadius)
```
</details>

<details><summary>Hint 3 — Printing the position as text</summary>

The `..` operator glues pieces of text together. If `ballX` is `400`, then `"x = " .. ballX` becomes `"x = 400"`.

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.print("Ball position:  x = " .. ballX .. "  y = " .. ballY, 10, 10)
```

Put this at the end of `love.draw()` so the text appears on top of everything else.
</details>

---

## Stretch Goals

1. **Center the ball using math.** Instead of typing `400` and `300`, write `ballX = 800 / 2` and `ballY = 600 / 2`. The ball lands in the exact center. Now try `love.graphics.getWidth() / 2` — same result, but LÖVE figures out the screen size for you!

2. **Add a second ball.** Create a new set of variables (`ball2X`, `ball2Y`, `ball2Radius`, `ball2R`, `ball2G`, `ball2B`) and draw a second circle somewhere else on screen in a different color.

3. **Link variables together.** Set `ballX = ballRadius * 5`. Now change `ballRadius` to a bigger or smaller number and re-run. Notice how the ball moves *and* resizes at the same time — that's the power of variables pointing to other variables!
