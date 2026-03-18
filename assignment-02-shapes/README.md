# Assignment 02: Shapes & Colors

Now that you can print text, let's paint a picture! In this assignment you'll use LÖVE2D's drawing functions to create a little scene — a sunny day with a house and a cloud.

---

## The Coordinate System

Before we draw anything, you need to know how LÖVE2D positions things on screen.

Imagine the screen is a grid. The **top-left corner** is position **(0, 0)**. Moving **right** increases the **x** value. Moving **down** increases the **y** value.

```
(0,0) ──────────────── x increases ──► (800, 0)
  │
  │ y increases
  │
  ▼
(0, 600)                              (800, 600)
```

The default screen is **800 pixels wide** and **600 pixels tall**. So:
- The center of the screen is roughly **(400, 300)**
- The bottom-right corner is **(800, 600)**

This might feel backwards if you remember y going *up* from maths class, but you'll get used to it quickly!

---

## New Drawing Functions

### Rectangles
```lua
love.graphics.rectangle("fill", x, y, width, height)
```
- `"fill"` means draw it solid (use `"line"` for just the outline)
- `x, y` is the **top-left corner** of the rectangle
- `width` and `height` are in pixels

### Circles
```lua
love.graphics.circle("fill", x, y, radius)
```
- `x, y` is the **center** of the circle
- `radius` is how big it is (distance from center to edge)

### Lines
```lua
love.graphics.line(x1, y1, x2, y2)
```
- Draws a straight line from point **(x1, y1)** to point **(x2, y2)**

---

## Your Mission

Open `starter/main.lua`. The sky is already drawn for you. Complete the scene by filling in the TODOs to add:

1. **Green ground** — a wide green rectangle across the bottom
2. **Yellow sun** — a filled circle in the top-right area
3. **Brown house** — a rectangle in the middle of the screen
4. **Red roof** — two lines forming a triangle shape over the house
5. **White cloud** — three overlapping circles to make a fluffy cloud

Run it as you go — you don't have to do all TODOs at once!

---

## Hints

<details>
<summary>Hint 1 — Drawing the ground and sun</summary>

For the ground, you want a wide flat rectangle starting at y=400:
```lua
love.graphics.setColor(0.2, 0.7, 0.2)  -- green
love.graphics.rectangle("fill", 0, 400, 800, 200)
```

For the sun, it's a circle. Remember `circle` takes a center point and a radius:
```lua
love.graphics.setColor(1, 1, 0)  -- yellow
love.graphics.circle("fill", 680, 80, 50)
```
</details>

<details>
<summary>Hint 2 — Drawing the house body and roof</summary>

The house body is just a rectangle. Start it around x=250, y=280:
```lua
love.graphics.setColor(0.6, 0.4, 0.2)  -- warm brown
love.graphics.rectangle("fill", 250, 280, 200, 120)
```

For the roof, draw two lines that meet at a peak above the house center. The house goes from x=250 to x=450, so the peak is around x=350:
```lua
love.graphics.setColor(0.8, 0.1, 0.1)  -- red
love.graphics.line(240, 280, 350, 180)  -- left slope
love.graphics.line(350, 180, 460, 280)  -- right slope
```
</details>

<details>
<summary>Hint 3 — Making a fluffy cloud</summary>

A cloud is just several white circles overlapping each other. Draw three circles close together and they'll blend into a cloud shape:
```lua
love.graphics.setColor(1, 1, 1)  -- white
love.graphics.circle("fill", 150, 120, 35)
love.graphics.circle("fill", 190, 105, 35)
love.graphics.circle("fill", 230, 120, 35)
```

Try moving the circles around or changing their sizes to get a shape you like!
</details>

---

## Stretch Goals

Finished the scene? Great work! Try these extras:

1. **Add a door and windows!** Draw small rectangles on the house — a tall thin one for a door and small square ones for windows. Use `love.graphics.rectangle("line", ...)` for window frames.

2. **Add a second cloud!** Copy your cloud code and change the x and y values to put another cloud in a different spot. Make it bigger or smaller by changing the radius.

3. **Add a tree!** A tree can be a brown rectangle (the trunk) with a green circle on top (the leaves). Place it somewhere in the scene that looks natural.
