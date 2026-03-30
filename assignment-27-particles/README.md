# Assignment 27: Particle Systems

## What you'll learn

How to use LÖVE2D's built-in particle system to make fire, smoke, and click-triggered spark bursts.

---

## How it works

### What is a particle system?

Imagine a garden hose. You aim it, turn it on, and water sprays out. Each water droplet is a **particle**. You control the hose — direction, pressure, spread — and the hose handles all the droplets for you.

A **particle system** works the same way. You create one emitter (the "hose"), set a few knobs, and LÖVE2D handles spawning, moving, and removing hundreds of tiny dots automatically. You never touch the individual dots.

### The base image

Every particle needs something to draw. We make a tiny 4x4 white square using a **Canvas** (think of it as a mini whiteboard you can draw on in code):

```lua
local canvas = love.graphics.newCanvas(4, 4)
love.graphics.setCanvas(canvas)          -- start drawing onto the canvas
love.graphics.setColor(1, 1, 1)
love.graphics.rectangle("fill", 0, 0, 4, 4)
love.graphics.setCanvas()               -- stop drawing onto the canvas
particleImg = canvas                     -- save it for later
```

All three particle systems in this assignment share that same tiny white square. The colour comes from settings on the system itself, not the image.

### Creating and tuning a particle system

```lua
firePS = love.graphics.newParticleSystem(particleImg, 200)
-- 200 = max particles alive at once (like the size of the tank)
```

Then you twist the knobs:

| Knob | What it does | Real-world analogy |
|------|-------------|-------------------|
| `setParticleLifetime(min, max)` | How many seconds each dot lives | Ice cubes that melt at different speeds |
| `setEmissionRate(n)` | New dots born per second | Bubbles rising from a fish tank |
| `setSpeed(min, max)` | How fast each dot moves (pixels/sec) | Light toss vs. hard throw |
| `setDirection(angle)` | Which way they fly (in radians) | `-math.pi/2` = straight up |
| `setSpread(angle)` | How wide the spray cone is | Narrow nozzle vs. wide shower head |
| `setSizes(start, end)` | Scale at birth vs. death | Soap bubble growing as it floats up |
| `setColors(r,g,b,a, r,g,b,a, ...)` | Colour + opacity at each life stage | Candle flame: orange → red → dark |

After tuning, call `:start()` to switch it on, then update and draw it every frame:

```lua
function love.update(dt)
    firePS:update(dt)   -- moves all the dots forward in time
end

function love.draw()
    love.graphics.setColor(1, 1, 1)          -- keep this white!
    love.graphics.draw(firePS, FIRE_X, FIRE_Y)
end
```

> **Why keep setColor white?** The particle system colours each dot itself. If you set a tint first, it multiplies — your orange fire turns brown. Always reset to white before drawing a particle system.

### One-shot bursts with `:emit()`

Smoke and fire run continuously. But sparks should only fly when you click. The trick: set `emissionRate` to `0` so the system stays quiet, then call `:emit(n)` to instantly shoot `n` particles:

```lua
sparkPS:setEmissionRate(0)    -- silent until we say so

function love.mousepressed(x, y, button)
    if button == 1 then
        sparkPS:moveTo(x, y)  -- move the "hose" to the click spot
        sparkPS:emit(20)      -- fire 20 sparks right now
    end
end
```

---

## Your mission

Open `starter/main.lua`. You will fill in **three TODOs**:

1. **TODO 1** — Give the fire its look: set its speed, direction, spread, sizes, and colours so it looks like a flickering orange flame going upward.
2. **TODO 2** — Give the smoke its look: slower, bigger particles that start dark grey and fade away as they drift up.
3. **TODO 3** — In `love.mousepressed`, move `sparkPS` to the click position and call `:emit(20)` to shoot sparks.

Run it with `love .` from inside the `starter/` folder. When all three TODOs are filled in, you should see a night-sky campfire scene where clicking anywhere sends sparks flying.

---

## Hints

<details>
<summary>Hint 1 — What values should fire use?</summary>

Fire shoots upward fast and shrinks as it rises. Try these values:

```lua
firePS:setSpeed(40, 120)
firePS:setDirection(-math.pi / 2)   -- straight up
firePS:setSpread(0.6)               -- slight wobble
firePS:setSizes(1.5, 0.2)          -- starts big, shrinks to almost nothing
```

For colours, go orange at birth, deep red in the middle, and near-invisible dark at death:

```lua
firePS:setColors(
    1,   0.6, 0,   1,     -- born:  vivid orange, fully visible
    1,   0.2, 0,   0.5,   -- mid:   deep red, half faded
    0.1, 0.1, 0.1, 0      -- dies:  near-black, invisible
)
```

</details>

<details>
<summary>Hint 2 — What values should smoke use?</summary>

Smoke is slower and grows bigger as it drifts upward. The size order is reversed compared to fire:

```lua
smokePS:setSpeed(15, 40)            -- much slower than fire
smokePS:setDirection(-math.pi / 2)
smokePS:setSpread(0.4)
smokePS:setSizes(0.5, 2.0)         -- starts small, grows as it floats up
```

For colours, start dark (near the fire) and fade to white-transparent:

```lua
smokePS:setColors(
    0.3, 0.3, 0.3, 0.6,   -- dark grey, semi-transparent at birth
    0.8, 0.8, 0.8, 0.2,   -- light grey, nearly gone
    1,   1,   1,   0       -- white, fully invisible at death
)
```

</details>

<details>
<summary>Hint 3 — How do I trigger sparks on click?</summary>

Inside `love.mousepressed`, you need two lines. First, move the spark emitter to where you clicked. Then fire a burst:

```lua
sparkPS:moveTo(x, y)
sparkPS:emit(20)
```

`moveTo` is like picking up the hose and pointing it at a new spot. `emit(20)` is the squeeze of the trigger.

</details>

---

## Stretch Goals

- **Wind** — Add a horizontal push to the smoke with `smokePS:setLinearAcceleration(-8, -10, 8, -5)`. Watch the smoke lean like it's caught in a breeze.
- **Rain** — Make a new particle system that fires blue-white streaks straight down at high speed. Use `setSpread(0.05)` for a tight stream and `setLinearAcceleration(0, 300, 0, 400)` to accelerate them downward.
- **Wandering fire** — In `love.update`, call `firePS:moveTo(love.mouse.getX(), FIRE_Y)` every frame so the campfire follows your mouse left and right.
