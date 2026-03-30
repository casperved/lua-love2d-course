-- Assignment 24: Spritesheet Animation (STARTER)
-- A walking stick-figure built entirely in code — no image files needed!
-- We draw 4 animation frames onto a Canvas, then use Quads to show them
-- one at a time, fast enough to look like smooth movement.
--
-- Three TODOs for you to fill in:
--   TODO 1 – build the quads table (one Quad per frame)
--   TODO 2 – advance animTimer and currentFrame in love.update
--   TODO 3 – draw the character sprite (and handle the left-facing flip)

SCREEN_W       = 800
SCREEN_H       = 600
FRAME_W        = 64          -- each frame is 64×64 pixels
FRAME_H        = 64
NUM_FRAMES     = 4
FRAME_DURATION = 0.12        -- seconds to show each frame
CHAR_SPEED     = 180         -- pixels per second

-- ============================================================
-- Spritesheet builder
-- Draws 4 stick-figure walking poses onto a 256×64 Canvas.
-- You do NOT need to change anything in this function.
-- ============================================================

function buildSpritesheet()
    local canvas = love.graphics.newCanvas(FRAME_W * NUM_FRAMES, FRAME_H)

    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)   -- transparent background

    local function drawFrame(ox, legSpread, armRaise)
        local cx     = ox + 32
        local headY  = 10
        local neckY  = 20
        local waistY = 40
        local feetY  = 58

        love.graphics.setLineWidth(2)
        love.graphics.setColor(0.95, 0.85, 0.7)
        love.graphics.circle("fill", cx, headY, 7)   -- head

        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.setLineWidth(2.5)
        love.graphics.line(cx, neckY, cx, waistY)                          -- torso
        love.graphics.line(cx, neckY + 6, cx - 14, neckY + 6 - armRaise)  -- left arm
        love.graphics.line(cx, neckY + 6, cx + 14, neckY + 6 - armRaise)  -- right arm
        love.graphics.line(cx, waistY,    cx - legSpread, feetY)           -- left leg
        love.graphics.line(cx, waistY,    cx + legSpread, feetY)           -- right leg

        love.graphics.setLineWidth(1)
    end

    drawFrame(0,    14,  10)   -- frame 1: legs wide, arms up
    drawFrame(64,    2,  -8)   -- frame 2: legs together, arms down
    drawFrame(128,  14,  10)   -- frame 3: legs wide again
    drawFrame(192,   2,  -8)   -- frame 4: legs together, arms down

    love.graphics.setCanvas()
    return canvas
end

-- ============================================================
-- Globals
-- ============================================================

spritesheet  = nil
quads        = {}
currentFrame = 1
animTimer    = 0
charX        = SCREEN_W / 2 - FRAME_W / 2
charY        = SCREEN_H / 2 - FRAME_H / 2
facingLeft   = false
isWalking    = false

SHADOW_ALPHA = 0.25

-- ============================================================
-- LÖVE callbacks
-- ============================================================

function love.load()
    love.window.setTitle("Assignment 24 – Spritesheet Animation")
    math.randomseed(os.time())

    -- Build the spritesheet canvas (already done for you)
    spritesheet = buildSpritesheet()

    -- TODO 1: Build the quads table.
    -- A Quad is a "window" that selects one frame out of the spritesheet.
    -- Make one Quad for each of the 4 frames.
    -- Frame i (0-based) starts at x = i * FRAME_W on the canvas.
    -- The full canvas is (FRAME_W * NUM_FRAMES) wide and FRAME_H tall.
    --
    -- quads = {}
    -- for i = 0, NUM_FRAMES - 1 do
    --     quads[i + 1] = love.graphics.newQuad(
    --         i * FRAME_W, 0,           -- top-left corner of this frame
    --         FRAME_W, FRAME_H,         -- size of one frame
    --         FRAME_W * NUM_FRAMES, FRAME_H   -- full canvas size
    --     )
    -- end
end

function love.update(dt)
    isWalking = false

    if love.keyboard.isDown("right") then
        charX      = charX + CHAR_SPEED * dt
        facingLeft = false
        isWalking  = true
    end

    if love.keyboard.isDown("left") then
        charX      = charX - CHAR_SPEED * dt
        facingLeft = true
        isWalking  = true
    end

    -- Keep character on screen
    charX = math.max(0, math.min(charX, SCREEN_W - FRAME_W))

    -- TODO 2: Advance the animation timer.
    -- When isWalking is true:
    --   • Add dt to animTimer.
    --   • When animTimer reaches FRAME_DURATION, subtract FRAME_DURATION
    --     (keeps the leftover time — don't just set it to 0!) and advance
    --     currentFrame using: currentFrame = (currentFrame % NUM_FRAMES) + 1
    --     That wraps 1→2→3→4→1→2→... automatically.
    -- When isWalking is false, reset currentFrame to 1 and animTimer to 0.
    --
    -- if isWalking then
    --     animTimer = animTimer + dt
    --     if animTimer >= FRAME_DURATION then
    --         animTimer    = animTimer - FRAME_DURATION
    --         currentFrame = (currentFrame % NUM_FRAMES) + 1
    --     end
    -- else
    --     currentFrame = 1
    --     animTimer    = 0
    -- end
end

function love.draw()
    -- Sky: two layered rectangles give a simple gradient feel
    love.graphics.setColor(0.3, 0.55, 0.9)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
    love.graphics.setColor(0.55, 0.78, 1.0)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H / 2)

    -- Ground
    love.graphics.setColor(0.35, 0.65, 0.25)
    love.graphics.rectangle("fill", 0, SCREEN_H - 80, SCREEN_W, 80)

    -- Darker grass strip at the top of the ground
    love.graphics.setColor(0.25, 0.50, 0.18)
    love.graphics.rectangle("fill", 0, SCREEN_H - 80, SCREEN_W, 6)

    -- Drop shadow under the character (wobbles slightly with each step)
    local shadowW = 28 + (currentFrame % 2) * 6
    love.graphics.setColor(0, 0, 0, SHADOW_ALPHA)
    love.graphics.ellipse("fill",
        charX + FRAME_W / 2,
        charY + FRAME_H + 2,
        shadowW, 6)

    -- TODO 3: Draw the character.
    -- Set the color to white first (so the sprite has no color tint):
    --   love.graphics.setColor(1, 1, 1)
    --
    -- When facingLeft is false (facing right), draw normally:
    --   love.graphics.draw(spritesheet, quads[currentFrame], charX, charY)
    --
    -- When facingLeft is true, flip by passing sx = -1.
    -- Passing sx = -1 mirrors the image, but it shifts it left by FRAME_W.
    -- Fix that by adding FRAME_W to x:
    --   love.graphics.draw(spritesheet, quads[currentFrame],
    --                      charX + FRAME_W, charY,
    --                      0,    -- rotation
    --                      -1,   -- sx: flip horizontal
    --                      1)    -- sy: normal
    --
    -- love.graphics.setColor(1, 1, 1)
    -- if facingLeft then
    --     love.graphics.draw(spritesheet, quads[currentFrame],
    --                        charX + FRAME_W, charY,
    --                        0, -1, 1)
    -- else
    --     love.graphics.draw(spritesheet, quads[currentFrame], charX, charY)
    -- end

    -- HUD
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 5, 5, 260, 65)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Arrow keys: walk left / right", 10, 10)
    love.graphics.print("Frame: " .. currentFrame .. " / " .. NUM_FRAMES
                        .. "   timer: " .. string.format("%.2f", animTimer), 10, 30)
    love.graphics.print("Press Escape to quit", 10, 50)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
