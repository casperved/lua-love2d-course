# Assignment 13: Sprites & Images

In this assignment you'll learn how to draw a picture once, save it, and then stamp it anywhere on screen — rotated, scaled, and centred perfectly.

---

## What you'll learn

How to use `love.graphics.draw()` to display an image (or a canvas) at any position, with any rotation, using a centre pivot point.

---

## How it works

### Images in real games

In most games you'd have a file called `spaceship.png` sitting in your project folder. Loading and drawing it looks like this:

```lua
function love.load()
    myImage = love.graphics.newImage("spaceship.png")
end

function love.draw()
    love.graphics.draw(myImage, x, y)
end
```

Short and sweet! But we don't have a PNG file here, so we'll make our own image using a **Canvas**.

### What is a Canvas?

Think of a Canvas like a blank piece of paper you can draw on.

You grab the paper, draw your spaceship on it with shapes, then put the paper down. Now you have a finished drawing you can pick up and stamp anywhere on screen — just like a rubber stamp.

```lua
myCanvas = love.graphics.newCanvas(60, 80)   -- make a blank 60x80 sheet

love.graphics.setCanvas(myCanvas)   -- "pick up the pen" — draw onto the canvas
    love.graphics.circle("fill", 30, 20, 10)  -- draw a circle on it
love.graphics.setCanvas()           -- "put down the pen" — back to drawing on screen
```

After that, `myCanvas` works exactly like a loaded image file.

### The draw command — all its arguments

```lua
love.graphics.draw(image, x, y, rotation, scaleX, scaleY, originX, originY)
```

| Argument | What it does |
|---|---|
| `image` | The image or canvas to stamp |
| `x, y` | Where on screen to stamp it |
| `rotation` | How much to rotate it, in **radians** (0 = no rotation) |
| `scaleX, scaleY` | How big to make it (1 = normal, 2 = double size) |
| `originX, originY` | The "pin point" — which part of the image sits at (x, y) |

### The pivot point — why it matters

Imagine you're pinning a picture to a noticeboard. If you pin it by its **top-left corner**, spinning it rotates around that corner — looks weird for a spaceship!

If you pin it through its **centre**, it spins in place — much better.

To pin through the centre, set `originX = imageWidth / 2` and `originY = imageHeight / 2`:

```lua
love.graphics.draw(myCanvas, x, y, rotation, 1, 1, canvasWidth/2, canvasHeight/2)
```

Now `(x, y)` is the centre of the image, and it rotates around that point.

### Radians — a quick cheat sheet

LÖVE measures angles in **radians**, not degrees. Here's all you need:

```
Pointing up    → -math.pi / 2
Pointing down  →  math.pi / 2
Pointing left  →  math.pi
Pointing right →  0
```

---

## Your mission

You'll fly a canvas-drawn spaceship around a starfield with WASD. The ship rotates to face the direction it's moving, and a thruster flame appears when pressing W.

**TODOs to fill in:**

1. **TODO 1** — Call `love.graphics.draw()` to stamp the canvas on screen at the ship's position, with rotation and a centred pivot point. Remove the placeholder rectangle once this works.
2. **TODO 2** — Set `ship.moving = true` inside the movement blocks so the thruster knows when to fire.
3. **TODO 3** — Draw the thruster flame (a triangle behind the ship) when W is held and the ship is moving.

---

## Hints

<details><summary>Hint 1 — How to draw the canvas as a sprite</summary>

Replace the placeholder rectangle with this:

```lua
love.graphics.setColor(1, 1, 1)   -- white = draw at full colour, no tint
love.graphics.draw(
    shipCanvas,          -- the canvas to stamp
    ship.x, ship.y,      -- centre position on screen
    ship.angle + math.pi/2,  -- rotation (the canvas nose points up; offset by 90° to align)
    1, 1,                -- scaleX, scaleY (normal size)
    shipW / 2,           -- originX: halfway across the canvas
    shipH / 2            -- originY: halfway down the canvas
)
```

The `+ math.pi/2` offset is needed because the canvas was drawn with the nose pointing straight up (angle 0 in canvas space), but LÖVE's angle 0 means "pointing right". Adding 90° lines them up.
</details>

<details><summary>Hint 2 — Tracking whether the ship is moving</summary>

At the top of `love.update`, reset the flag:

```lua
ship.moving = false
```

Then inside each `if love.keyboard.isDown(...)` block, add:

```lua
ship.moving = true
```

That way `ship.moving` is only true during the frame a key is held.
</details>

<details><summary>Hint 3 — Drawing the thruster flame</summary>

The flame is a triangle drawn just behind the ship's centre. Because the ship only shows a flame when moving upward (W key), you can position it at a fixed offset below the ship centre:

```lua
if ship.moving and love.keyboard.isDown("w") then
    local fx = ship.x
    local fy = ship.y + shipH / 2 + 8   -- just below the ship centre

    -- Outer flame (orange)
    love.graphics.setColor(1, 0.45, 0.05, 0.85)
    love.graphics.polygon("fill", fx - 9, fy,  fx + 9, fy,  fx, fy + 22)

    -- Inner flame (yellow)
    love.graphics.setColor(1, 0.9, 0.2, 0.9)
    love.graphics.polygon("fill", fx - 5, fy,  fx + 5, fy,  fx, fy + 13)
end
```

Draw the flame **before** you draw the ship, so it appears behind it.
</details>

---

## Stretch Goals

1. **Screen wrap** — When the ship flies off one edge, make it reappear on the opposite side. (The solution already does this — try to work out how before peeking!)
2. **Diagonal movement** — Allow pressing two keys at once (e.g. W + D) to move diagonally. Calculate the angle with `math.atan2`.
3. **Particle trail** — Spawn small fading dots behind the ship whenever it moves, to create an exhaust effect.
