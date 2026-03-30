# Assignment 23: Object-Oriented Programming

## What you'll learn

How to build a **class** in Lua — a reusable blueprint that lets you create as many independent objects as you want, each with its own data but sharing the same behavior.

---

## How it works

### The problem first

Imagine you're making a game with eight bouncing balls. You could write eight sets of variables:

```lua
ball1X = 100  ball1Y = 200  ball1VX = 80  ball1VY = -50
ball2X = 300  ball2Y = 150  ball2VX = -60  ball2VY = 90
-- ... six more ...
```

And then eight copies of the bounce logic:

```lua
ball1X = ball1X + ball1VX * dt
ball2X = ball2X + ball2VX * dt
-- ... six more ...
```

That's painful. And what if you want 50 balls? It breaks completely.

There's a much better way: **object-oriented programming**, or OOP for short.

---

### The cookie-cutter analogy

Think of a **cookie cutter**. You have one cutter, but you can stamp out as many cookies as you want. Each cookie is separate — you can decorate them differently — but they all came from the same shape.

In OOP:
- The **class** is the cookie cutter (the blueprint)
- Each **instance** is one cookie (one actual ball in the game)

---

### How Lua does it: tables

Lua doesn't have a built-in `class` keyword. But it has **tables**, and tables can do everything a class needs.

Here is the big idea:

1. Make a table called `Ball`. This table will hold all the **methods** (the functions every ball knows how to do).
2. When you want a new ball, create a fresh **empty table** for its data (x, y, color…).
3. Tell Lua: "when you look up something on this data table and don't find it, go check `Ball` instead."

Step 3 is the magic. It's done with something called a **metatable**.

---

### Metatables: the "backup lookup" trick

A **metatable** is a special table you attach to another table. It lets you customise what Lua does when something goes wrong — like when it can't find a key.

The specific rule we care about is called `__index`. It says:

> "If a key is missing from this table, look it up here instead."

Here is the two-line setup that makes a Lua class work:

```lua
Ball = {}          -- all methods live here
Ball.__index = Ball  -- if a key is missing on an instance, look in Ball
```

That second line says: "Ball is its own backup." When Lua looks up `update` on a ball instance and doesn't find it, it checks `Ball` — where it does find it.

---

### The constructor: Ball.new

A **constructor** is just a function that creates and returns a new instance. By convention we call it `.new`:

```lua
function Ball.new(x, y, vx, vy, radius, r, g, b)
    local self = setmetatable({}, Ball)
    --           ^^^^^^^^^^^^^^^^^^^
    --   Create an empty table AND attach Ball as its metatable.
    --   Now any missing key will be looked up in Ball.

    self.x      = x       -- this ball's position
    self.y      = y
    self.vx     = vx      -- this ball's velocity
    self.vy     = vy
    self.radius = radius
    self.r      = r       -- this ball's color (red, 0–1)
    self.g      = g
    self.b      = b
    return self
end
```

Every time you call `Ball.new(...)` you get back a brand-new table with its own data, connected to the `Ball` class.

---

### Colon syntax: the hidden "self"

When you define a method with a **colon**:

```lua
function Ball:update(dt)
    self.x = self.x + self.vx * dt
end
```

Lua automatically adds a hidden first parameter called `self`. It's exactly the same as writing:

```lua
function Ball.update(self, dt)   -- identical; colon is just shorthand
    self.x = self.x + self.vx * dt
end
```

And when you **call** the method with a colon:

```lua
myBall:update(dt)   -- Lua secretly passes myBall as self
```

That's it. `self` is always "the table you called the method on." Each ball passes itself, so each ball updates its own position.

---

### Putting it together

```lua
balls = {}   -- an array of every Ball instance

-- Create a ball:
balls[1] = Ball.new(100, 200, 80, -50, 15, 1, 0.3, 0.5)

-- Update all balls in the game loop:
for i = 1, #balls do
    balls[i]:update(dt)   -- each ball updates itself
end

-- Draw all balls:
for i = 1, #balls do
    balls[i]:draw()       -- each ball draws itself
end
```

One `Ball` class. Unlimited cookies.

---

## Your Mission

Open `starter/main.lua`. The game loop, the background, the HUD, and the `spawnBall` helper are all already there. Your job is to fill in three TODOs inside the `Ball` class so the balls actually move, bounce, and appear on screen.

**TODO 1 — Connect instances to the class**

Inside `Ball.new`, replace the placeholder `local self = {}` line with the real `setmetatable` call. Also make sure `Ball.__index = Ball` is set above `Ball.new`.

**TODO 2 — Write `Ball:update(dt)`**

Move the ball using its velocity, then bounce it off all four walls. When a ball hits a wall, flip the matching velocity (`self.vx = -self.vx` for left/right walls) and snap the ball back inside so it doesn't get stuck.

**TODO 3 — Write `Ball:draw()`**

Set the drawing color using `self.r`, `self.g`, `self.b`, then draw a filled circle at `self.x`, `self.y` with radius `self.radius`. Add a white outline if you like the look.

Once all three TODOs are done, you should see colorful balls bouncing around a dark background. Click anywhere to spawn more!

---

## Hints

<details>
<summary>Hint 1 — Setting up the class (TODO 1)</summary>

Put `Ball.__index = Ball` right after `Ball = {}`, before the constructor. Then inside `Ball.new`, use `setmetatable` to create the instance:

```lua
Ball = {}
Ball.__index = Ball   -- missing keys fall through to Ball

function Ball.new(x, y, vx, vy, radius, r, g, b)
    local self = setmetatable({}, Ball)
    -- {} is a blank table; Ball is the metatable
    -- Because Ball.__index = Ball, method lookups find :update and :draw
    self.x      = x
    self.y      = y
    self.vx     = vx
    self.vy     = vy
    self.radius = radius
    self.r      = r
    self.g      = g
    self.b      = b
    return self
end
```
</details>

<details>
<summary>Hint 2 — Moving and bouncing (TODO 2)</summary>

This is the same bounce logic from Assignment 05 — just written as a method, using `self.` in front of every variable name:

```lua
function Ball:update(dt)
    -- Move
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Bounce off left wall
    if self.x - self.radius < 0 then
        self.vx = -self.vx
        self.x  = self.radius
    end
    -- Bounce off right wall
    if self.x + self.radius > SCREEN_W then
        self.vx = -self.vx
        self.x  = SCREEN_W - self.radius
    end
    -- Bounce off top wall
    if self.y - self.radius < 0 then
        self.vy = -self.vy
        self.y  = self.radius
    end
    -- Bounce off bottom wall
    if self.y + self.radius > SCREEN_H then
        self.vy = -self.vy
        self.y  = SCREEN_H - self.radius
    end
end
```
</details>

<details>
<summary>Hint 3 — Drawing the ball (TODO 3)</summary>

Use the ball's own color fields to set the color, then draw the circle:

```lua
function Ball:draw()
    -- Use this ball's own color
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", self.x, self.y, self.radius)

    -- A faint white outline makes it easier to see
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.circle("line", self.x, self.y, self.radius)
end
```
</details>

---

## Stretch Goals

1. **Gravity!** Add a `self.gravity = 400` field in `Ball.new`. In `Ball:update`, add `self.vy = self.vy + self.gravity * dt` each frame. The balls will arc and bounce like rubber balls.

2. **Ball-to-ball collisions!** In `love.update`, check every pair of balls. If the distance between their centers is less than the sum of their radii, swap their `vx` and `vy`. Distance formula: `math.sqrt((ax-bx)^2 + (ay-by)^2)`.

3. **Shrinking balls!** Each time a ball bounces, reduce `self.radius` by 1. When `self.radius` drops below 3, remove it from the `balls` table. Watch them wink out of existence.
