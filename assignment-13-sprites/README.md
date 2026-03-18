# Assignment 13: Sprites & Images 🚀

You've been drawing rectangles and circles. Now let's level up and draw *real* artwork! In most games you'd load a `.png` file as a sprite. In this assignment we'll learn all the concepts — and since we can't include image files in the course, we'll create our sprite by drawing shapes onto a **Canvas**, which works exactly like a real image once it's made.

---

## Loading a Real Image (the normal way)

When you have an image file, you do this:

```lua
function love.load()
    myImage = love.graphics.newImage("spaceship.png")
end

function love.draw()
    love.graphics.draw(myImage, x, y)
end
```

That's it! The image file must be in the same folder as `main.lua`.

---

## The `love.graphics.draw` Arguments

```lua
love.graphics.draw(image, x, y, rotation, scaleX, scaleY, originX, originY)
```

| Argument | What it does |
|---|---|
| `image` | The image (or canvas) to draw |
| `x, y` | Position on screen |
| `rotation` | Rotation in **radians** (0 = no rotation, `math.pi` = 180°) |
| `scaleX, scaleY` | Size multiplier (1 = normal, 2 = double, 0.5 = half) |
| `originX, originY` | The "pivot point" — the point on the image that sits at (x, y) |

---

## Origin Offset — Rotating Around the Centre

By default, `originX` and `originY` are 0, so the image is drawn with its **top-left corner** at (x, y). That's fine for placing, but if you rotate it, it spins around the top-left corner — usually not what you want!

To rotate around the **centre** of the image:

```lua
local ox = imageWidth  / 2
local oy = imageHeight / 2
love.graphics.draw(image, x, y, rotation, 1, 1, ox, oy)
```

Now (x, y) is the centre of the image, and rotation spins it around that point.

---

## What is a Canvas?

A `Canvas` is a texture you can draw *onto*:

```lua
myCanvas = love.graphics.newCanvas(width, height)

love.graphics.setCanvas(myCanvas)   -- redirect drawing to the canvas
    -- ... draw shapes here ...
love.graphics.setCanvas()           -- go back to drawing on the screen
```

After that, `myCanvas` behaves exactly like an image loaded from a file. You can pass it to `love.graphics.draw()` with rotation, scale, and origin!

---

## Your Mission

- A spaceship (made from shapes drawn onto a Canvas) flies around the screen.
- Move it with **WASD**.
- The ship **rotates** to face the direction it's moving.
- As a bonus, add a thruster flame when pressing W (moving up)!

---

## TODOs in the Starter File

1. **TODO 1** — Call `love.graphics.draw()` with the canvas, ship position, angle, scale 1/1, and centred origin.
2. **TODO 2** — Draw an orange flame triangle below the ship when W is held down.

---

## Hints

<details><summary>Hint 1 — Drawing the canvas as a sprite</summary>

```lua
love.graphics.setColor(1, 1, 1)   -- white tint = draw at full colour
love.graphics.draw(
    shipCanvas,    -- the canvas to draw
    ship.x,        -- screen X position
    ship.y,        -- screen Y position
    ship.angle,    -- rotation in radians
    1, 1,          -- scaleX, scaleY
    shipW / 2,     -- originX (centre of the canvas)
    shipH / 2      -- originY (centre of the canvas)
)
```

Delete the placeholder rectangle once you've added this!
</details>

<details><summary>Hint 2 — Thruster flame</summary>

A thruster flame is a small triangle drawn below the ship's centre. Because the ship rotates, you need to draw this *before* you draw the ship — or just check which key is held:

```lua
if love.keyboard.isDown("w") then
    love.graphics.setColor(1, 0.5, 0.1, 0.9)
    -- Position the flame below the ship centre
    local fx = ship.x
    local fy = ship.y + shipH * 0.5 + 5
    love.graphics.polygon("fill", fx - 10, fy, fx + 10, fy, fx, fy + 20)
end
```
</details>

<details><summary>Hint 3 — Angles for each direction</summary>

LÖVE uses radians. Here's a cheat sheet:

```
Up    → -math.pi / 2   (or -1.5708)
Down  →  math.pi / 2
Left  →  math.pi       (or 3.1416)
Right →  0
```

The ship canvas is drawn pointing **up** by default (the nose is at the top), so the angle values above line up with the movement directions perfectly!
</details>

---

## Stretch Goals

1. **Diagonal movement** — Allow pressing two keys at once (e.g. W+D) to move diagonally. Calculate the angle with `math.atan2`.
2. **Wrap around the screen** — When the ship flies off one edge, it reappears on the opposite side.
3. **Exhaust particles** — Spawn small fading circles behind the ship whenever it's moving, to create a particle trail.
