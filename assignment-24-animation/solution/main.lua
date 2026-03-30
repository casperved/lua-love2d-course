-- Assignment 24: Spritesheet Animation (SOLUTION)
-- A walking stick-figure with a canvas-based spritesheet.
-- No external image files — every pixel is drawn in code.
-- Arrow keys to walk left/right; animation plays while moving.

SCREEN_W       = 800
SCREEN_H       = 600
FRAME_W        = 64
FRAME_H        = 64
NUM_FRAMES     = 4
FRAME_DURATION = 0.12   -- seconds per frame
CHAR_SPEED     = 180    -- pixels per second

-- ============================================================
-- Spritesheet builder
-- Returns a 256×64 Canvas with 4 stick-figure walking frames.
-- ============================================================

function buildSpritesheet()
    local canvas = love.graphics.newCanvas(FRAME_W * NUM_FRAMES, FRAME_H)

    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)

    local function drawFrame(ox, legSpread, armRaise)
        local cx    = ox + 32
        local headY  = 10
        local neckY  = 20
        local waistY = 40
        local feetY  = 58

        love.graphics.setLineWidth(2)
        love.graphics.setColor(0.95, 0.85, 0.7)
        love.graphics.circle("fill", cx, headY, 7)   -- head

        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.setLineWidth(2.5)
        love.graphics.line(cx, neckY, cx, waistY)                            -- torso
        love.graphics.line(cx, neckY + 6, cx - 14, neckY + 6 - armRaise)    -- left arm
        love.graphics.line(cx, neckY + 6, cx + 14, neckY + 6 - armRaise)    -- right arm
        love.graphics.line(cx, waistY,    cx - legSpread, feetY)             -- left leg
        love.graphics.line(cx, waistY,    cx + legSpread, feetY)             -- right leg

        love.graphics.setLineWidth(1)
    end

    -- 4 frames of a simple walk cycle
    drawFrame(0,    14,  10)   -- frame 1: legs wide, arms up
    drawFrame(64,    2,  -8)   -- frame 2: legs together, arms down
    drawFrame(128,  14,  10)   -- frame 3: legs wide again (opposite foot leads)
    drawFrame(192,   2,  -8)   -- frame 4: legs together, arms down

    love.graphics.setCanvas()
    return canvas
end

-- ============================================================
-- LÖVE callbacks
-- ============================================================

spritesheet  = nil
quads        = {}
currentFrame = 1
animTimer    = 0
charX        = SCREEN_W / 2 - FRAME_W / 2
charY        = SCREEN_H / 2 - FRAME_H / 2
facingLeft   = false
isWalking    = false

-- Visual extra: shadow variables
SHADOW_ALPHA = 0.25

function love.load()
    love.window.setTitle("Assignment 24 – Spritesheet Animation")
    math.randomseed(os.time())

    -- Build the canvas-based spritesheet
    spritesheet = buildSpritesheet()

    -- Build the quads array: one quad per frame, each 64px wide
    quads = {}
    for i = 0, NUM_FRAMES - 1 do
        quads[i + 1] = love.graphics.newQuad(
            i * FRAME_W, 0,          -- top-left of this frame in the canvas
            FRAME_W, FRAME_H,        -- size of one frame
            FRAME_W * NUM_FRAMES, FRAME_H   -- full canvas dimensions
        )
    end
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

    -- Advance animation when walking; freeze on frame 1 when idle
    if isWalking then
        animTimer = animTimer + dt
        if animTimer >= FRAME_DURATION then
            animTimer    = animTimer - FRAME_DURATION   -- preserve leftover time
            currentFrame = (currentFrame % NUM_FRAMES) + 1
        end
    else
        currentFrame = 1   -- idle pose
        animTimer    = 0
    end
end

function love.draw()
    -- Visual extra 1: gradient-ish sky (two layered rectangles)
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

    -- Visual extra 2: drop shadow under the character
    -- Draw an ellipse below the character; its width changes with frame
    -- to give the impression the feet are shifting.
    local shadowW = 28 + (currentFrame % 2) * 6   -- wobble width with step
    love.graphics.setColor(0, 0, 0, SHADOW_ALPHA)
    love.graphics.ellipse("fill",
        charX + FRAME_W / 2,
        charY + FRAME_H + 2,
        shadowW, 6)

    -- Draw the character sprite
    love.graphics.setColor(1, 1, 1)   -- white = no color tint

    if facingLeft then
        -- Flip horizontally: sx = -1 mirrors around the draw x,
        -- so we shift x right by FRAME_W to keep the sprite in place.
        love.graphics.draw(spritesheet, quads[currentFrame],
                           charX + FRAME_W, charY,
                           0,    -- rotation
                           -1,   -- sx: flip horizontal
                           1)    -- sy: normal vertical
    else
        love.graphics.draw(spritesheet, quads[currentFrame], charX, charY)
    end

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
