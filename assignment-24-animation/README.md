# Assignment 24: Spritesheet Animation

Make a stick figure walk across the screen using **spritesheet animation** — the same trick every 2D game uses to bring characters to life.

---

## What you'll learn

How to draw animation frames onto a Canvas, slice them into pieces with Quads, and flip through them fast enough to look like real movement.

---

## How it works

### Cartoons work the same way

A cartoon is just a stack of drawings shown one after another, very fast. Each drawing is slightly different from the last. Your brain fills in the gaps and sees smooth motion.

Games do the exact same thing. Instead of a stack of paper drawings, they use a **spritesheet** — one wide image with all the frames sitting side by side in a row.

```
┌──────────────────────────────────────────┐
│  frame 1  │  frame 2  │  frame 3  │  frame 4  │
│ legs wide │legs close │ legs wide │legs close │
└──────────────────────────────────────────┘
```

The game shows one frame at a time and switches every fraction of a second. At 8 frames per second your eye sees a smooth walk.

---

### Step 1 — Drawing to a Canvas

A `Canvas` is like a blank piece of paper you can draw on *before* the game starts. Once you're done drawing on it, you can use it like any other image.

```lua
-- Make a blank canvas (256 pixels wide, 64 pixels tall)
local sheet = love.graphics.newCanvas(256, 64)

-- Aim your drawing tools at the canvas instead of the screen
love.graphics.setCanvas(sheet)

    love.graphics.circle("fill", 32, 32, 20)   -- this goes onto the canvas

-- Aim drawing tools back at the screen
love.graphics.setCanvas()
```

In this assignment the `buildSpritesheet()` function does this for you — it draws all four walking poses onto one canvas.

---

### Step 2 — Quads: cut out one frame at a time

A **Quad** is like a cardboard window you hold up to the spritesheet. Move the window and you reveal a different frame.

```lua
-- "I want the region starting at x=0, y=0, that is 64×64 pixels,
--  inside an image that is 256×64 pixels total."
local q = love.graphics.newQuad(0, 0, 64, 64, 256, 64)
```

You make one Quad per frame, then store them all in a table:

```lua
quads[1]  -- shows frame 1 (x starts at 0)
quads[2]  -- shows frame 2 (x starts at 64)
quads[3]  -- shows frame 3 (x starts at 128)
quads[4]  -- shows frame 4 (x starts at 192)
```

---

### Step 3 — The animation timer

You need two variables working together:

- `animTimer` — a stopwatch that counts up every frame
- `currentFrame` — which frame is showing right now (1, 2, 3, or 4)

Every update, add `dt` to the stopwatch. When it hits `FRAME_DURATION` (0.12 seconds), flip to the next frame and reset the stopwatch:

```lua
animTimer = animTimer + dt
if animTimer >= FRAME_DURATION then
    animTimer    = animTimer - FRAME_DURATION   -- keep the leftover time
    currentFrame = (currentFrame % NUM_FRAMES) + 1   -- 1→2→3→4→1→2→...
end
```

Subtracting `FRAME_DURATION` instead of setting to zero is important. If the timer overshot by a tiny bit, keeping that leftover means the animation stays perfectly timed.

---

### Step 4 — Flipping the sprite

You only need right-facing frames. To face left, mirror the sprite by passing `sx = -1` to `love.graphics.draw`.

There's a catch: scaling by -1 flips around the draw position, which moves the image off to the left. Shift it back right by one frame width and it lands exactly where you want it.

```lua
-- Facing right (normal)
love.graphics.draw(spritesheet, quads[currentFrame], charX, charY)

-- Facing left (mirror)
love.graphics.draw(spritesheet, quads[currentFrame],
                   charX + FRAME_W, charY,
                   0,   -- rotation
                   -1,  -- sx: flip!
                   1)   -- sy: normal
```

---

## Your mission

Open `starter/main.lua`. The spritesheet is already drawn for you. Fill in three TODOs to bring the character to life:

1. **TODO 1** — Build the `quads` table. Make 4 quads, one per frame. Frame `i` (counting from 0) starts at `x = i * FRAME_W` on the canvas.

2. **TODO 2** — In `love.update`, make the animation timer tick. While walking, add `dt` to `animTimer`. When it reaches `FRAME_DURATION`, subtract `FRAME_DURATION` and advance `currentFrame`. When standing still, reset to frame 1.

3. **TODO 3** — In `love.draw`, draw the character using `love.graphics.draw` with the spritesheet and the current quad. When `facingLeft` is true, flip the sprite with `sx = -1` (and shift `x` right by `FRAME_W`).

Use the arrow keys to walk left and right!

---

## Hints

<details><summary>Hint 1 — Building the quads table</summary>

Loop from 0 to 3. Each frame is `FRAME_W` pixels wide, so frame `i` starts at `x = i * FRAME_W`. The full canvas is `FRAME_W * NUM_FRAMES` wide.

```lua
quads = {}
for i = 0, NUM_FRAMES - 1 do
    quads[i + 1] = love.graphics.newQuad(
        i * FRAME_W, 0,
        FRAME_W, FRAME_H,
        FRAME_W * NUM_FRAMES, FRAME_H
    )
end
```
</details>

<details><summary>Hint 2 — Ticking the animation timer</summary>

Only tick the timer when the character is walking. When standing still, go back to frame 1.

```lua
if isWalking then
    animTimer = animTimer + dt
    if animTimer >= FRAME_DURATION then
        animTimer    = animTimer - FRAME_DURATION
        currentFrame = (currentFrame % NUM_FRAMES) + 1
    end
else
    currentFrame = 1
    animTimer    = 0
end
```
</details>

<details><summary>Hint 3 — Drawing the character with the flip</summary>

Set the color to white first so the sprite shows its true colors. Then draw normally when facing right, and mirror when facing left.

```lua
love.graphics.setColor(1, 1, 1)

if facingLeft then
    love.graphics.draw(spritesheet, quads[currentFrame],
                       charX + FRAME_W, charY,
                       0, -1, 1)
else
    love.graphics.draw(spritesheet, quads[currentFrame], charX, charY)
end
```
</details>

---

## Stretch Goals

1. **Jump!** Press Space to launch the character upward (`charVY = -400`). While in the air, always show frame 3 (arms out). Apply gravity each update to bring them back down.

2. **Run!** Hold Shift to move faster. Double `CHAR_SPEED` and halve `FRAME_DURATION` to `0.06` so the legs move faster too.

3. **Parallax background!** Draw two layers of scenery (clouds, hills, trees) that scroll at different speeds as the character moves — a far layer at 0.2× speed and a near layer at 0.6×. This creates a free illusion of depth.
