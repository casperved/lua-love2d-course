# Assignment 02: Shapes & Colors

Let's draw a picture! You'll use simple shapes — rectangles, circles, and lines — to build a sunny day scene with a house and clouds.

---

## What you'll learn

How to draw rectangles, circles, and lines on screen, and how to pick colors.

---

## How it works

### The screen is like a piece of graph paper

The top-left corner of the window is position **(0, 0)**.

- Moving **right** makes the **x number bigger**.
- Moving **down** makes the **y number bigger**.

Think of it like this: the origin is pinned to the top-left, and everything else hangs below and to the right of it.

```
(0,0) ──── x grows this way ────► (800, 0)
  │
  │  y grows this way
  │
  ▼
(0, 600)                         (800, 600)
```

The window is **800 pixels wide** and **600 pixels tall**.

---

### Colors use three numbers

Before drawing any shape, you tell LÖVE2D what color to use:

```lua
love.graphics.setColor(red, green, blue)
```

Each number goes from **0** (none of that color) to **1** (full blast). Think of mixing paint:

| Color  | Call |
|--------|------|
| Red    | `setColor(1, 0, 0)` |
| Green  | `setColor(0, 1, 0)` |
| Blue   | `setColor(0, 0, 1)` |
| Yellow | `setColor(1, 1, 0)` |
| White  | `setColor(1, 1, 1)` |

Once you set a color, **every shape you draw after that uses that color** — until you set a new one.

---

### Three drawing tools

**Rectangle** — great for walls, floors, doors, windows.
```lua
love.graphics.rectangle("fill", x, y, width, height)
```
`x, y` is the **top-left corner** of the rectangle.

**Circle** — great for the sun, clouds, wheels.
```lua
love.graphics.circle("fill", x, y, radius)
```
`x, y` is the **center** of the circle. `radius` is how big it is.

**Line** — great for rooftops, fences, wires.
```lua
love.graphics.line(x1, y1, x2, y2)
```
Draws a straight line from point `(x1, y1)` to point `(x2, y2)`.

Use `"fill"` to draw a solid shape. Use `"line"` instead to draw just the outline.

---

### Drawing order matters

LÖVE2D draws things like a painter: each new shape goes **on top** of everything drawn before it. If you draw the ground after the house, the ground will cover the house!

The golden rule: **draw backgrounds and big shapes first, details on top last.** In our scene that means: sky first, then ground, then house, then windows and door.

---

## Your mission

Open `starter/main.lua`. The sky is already painted for you — a big blue rectangle covering the whole window.

Your job is to fill in the TODOs to complete the scene:

1. **Ground** — a wide green rectangle at the bottom of the screen
2. **Sun** — a yellow circle near the top-right corner
3. **House body** — a warm brown rectangle sitting on the ground
4. **Roof** — two red lines meeting at a peak above the house
5. **Door** — a small dark rectangle on the front of the house
6. **Windows** — two small light-blue rectangles on the house
7. **Cloud** — three white circles overlapping to make a fluffy shape
8. **Second cloud** — same idea, smaller, somewhere else in the sky

Run the program as you go — you can see each piece appear!

---

## Hints

<details><summary>Hint 1 — Ground and sun</summary>

The ground should be a flat rectangle covering the bottom 200 pixels of the screen. The screen is 600 tall, so start it at y = 400:

```lua
love.graphics.setColor(0.2, 0.7, 0.2)
love.graphics.rectangle("fill", 0, 400, 800, 200)
```

The sun is a circle. Its center goes near the top-right. Try x=680, y=80, with a radius of 50:

```lua
love.graphics.setColor(1, 1, 0)
love.graphics.circle("fill", 680, 80, 50)
```
</details>

<details><summary>Hint 2 — House, roof, door, and windows</summary>

The house body is a brown rectangle. Place it a bit above the ground line (y=280) so it looks like it's sitting on the grass:

```lua
love.graphics.setColor(0.6, 0.4, 0.2)
love.graphics.rectangle("fill", 250, 280, 200, 120)
```

The roof is two lines that meet at a pointy peak. The house runs from x=250 to x=450, so the peak is at x=350:

```lua
love.graphics.setColor(0.8, 0.1, 0.1)
love.graphics.line(240, 280, 350, 180)  -- left slope
love.graphics.line(350, 180, 460, 280)  -- right slope
```

The door is a tall thin dark rectangle at the base of the house:

```lua
love.graphics.setColor(0.35, 0.2, 0.08)
love.graphics.rectangle("fill", 330, 340, 40, 60)
```

The windows are two small light-blue squares, one on each side of the door:

```lua
love.graphics.setColor(0.6, 0.85, 1)
love.graphics.rectangle("fill", 265, 300, 45, 40)  -- left window
love.graphics.rectangle("fill", 390, 300, 45, 40)  -- right window
```
</details>

<details><summary>Hint 3 — Fluffy clouds</summary>

A cloud is just a few white circles drawn close together so they overlap:

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.circle("fill", 150, 120, 35)
love.graphics.circle("fill", 190, 105, 35)
love.graphics.circle("fill", 230, 120, 35)
```

For the second cloud, copy those three lines and move them to a different spot in the sky. Make the radius smaller to make the cloud look further away:

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.circle("fill", 500, 90, 25)
love.graphics.circle("fill", 530, 78, 25)
love.graphics.circle("fill", 560, 90, 25)
```
</details>

---

## Stretch Goals

Done with the scene? Nice work! Here are some extras to try:

1. **Add a tree.** A tree is just a brown rectangle (the trunk) with a green circle on top (the leaves). Put it somewhere in the yard.

2. **Change the colors.** Make it a sunset by swapping the sky to orange (`0.95, 0.5, 0.1`) and the sun to deep red. What else would you change to make it feel like dusk?

3. **Add a path or fence.** A path could be a light-gray rectangle leading up to the door. A fence could be several thin rectangles in a row across the yard.
