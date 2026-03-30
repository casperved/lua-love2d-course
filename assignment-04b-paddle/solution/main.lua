-- Assignment 04b: Paddle Alignment
-- Move your paddle up and down to line it up with the glowing green target zone.
-- Press R to move the target to a new random position.

SCREEN_W = 800
SCREEN_H = 600

paddleX = 40
paddleY = 270       -- starts roughly centred
paddleW = 20
paddleH = 80
paddleSpeed = 220

-- Target zone: a glowing horizontal band on the right side
targetX = 700
targetW = 60
targetY = 200       -- top of the target band (randomised on R)
targetH = 80

aligned = false     -- true when paddle centre overlaps the target band

-- A small timer used to pulse the glow brightness
pulseTimer = 0

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    pulseTimer = pulseTimer + dt

    -- Move the paddle UP
    if love.keyboard.isDown("up") then
        paddleY = paddleY - paddleSpeed * dt
    end

    -- Move the paddle DOWN
    if love.keyboard.isDown("down") then
        paddleY = paddleY + paddleSpeed * dt
    end

    -- Clamp paddle so it never leaves the screen
    if paddleY < 0 then paddleY = 0 end
    if paddleY + paddleH > SCREEN_H then paddleY = SCREEN_H - paddleH end

    -- Check alignment: paddle centre must be inside the target band
    local paddleCentre = paddleY + paddleH / 2
    aligned = (paddleCentre >= targetY) and (paddleCentre <= targetY + targetH)
end

function love.keypressed(key)
    if key == "r" then
        -- Move the target to a new random Y position
        targetY = math.random(50, SCREEN_H - targetH - 50)
        aligned = false
    end
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    -- ── Background ─────────────────────────────────────────────────────────
    love.graphics.setColor(0.10, 0.10, 0.18)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Subtle screen-wide green flash when aligned
    if aligned then
        local flash = 0.08 + 0.04 * math.sin(pulseTimer * 8)
        love.graphics.setColor(0, flash, 0)
        love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
    end

    -- ── Guide line on the left (subtle vertical rail for the paddle) ────────
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(paddleX + paddleW / 2, 0, paddleX + paddleW / 2, SCREEN_H)

    -- ── Target zone ─────────────────────────────────────────────────────────
    -- Outer soft glow (wider, very transparent)
    local glowPulse = 0.15 + 0.06 * math.sin(pulseTimer * 3)
    love.graphics.setColor(0, glowPulse * 1.5, 0, 0.25)
    love.graphics.rectangle("fill", targetX - 6, targetY - 6, targetW + 12, targetH + 12)

    -- Main target band (semi-transparent green)
    love.graphics.setColor(0.1, 0.7, 0.2, 0.45)
    love.graphics.rectangle("fill", targetX, targetY, targetW, targetH)

    -- Target border
    love.graphics.setColor(0.2, 1, 0.3)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", targetX, targetY, targetW, targetH)

    -- Centre tick mark inside the target
    local targetCentreY = targetY + targetH / 2
    love.graphics.setColor(0.3, 1, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(targetX + 8, targetCentreY, targetX + targetW - 8, targetCentreY)

    -- ── Paddle ──────────────────────────────────────────────────────────────
    -- Glow layer
    local cyanGlow = aligned and 0.9 or 0.4
    love.graphics.setColor(0, cyanGlow * 0.6, cyanGlow, 0.35)
    love.graphics.rectangle("fill", paddleX - 5, paddleY - 5, paddleW + 10, paddleH + 10)

    -- Paddle body
    love.graphics.setColor(0.2, 0.85, 1)
    love.graphics.rectangle("fill", paddleX, paddleY, paddleW, paddleH)

    -- Paddle highlight stripe
    love.graphics.setColor(0.6, 1, 1)
    love.graphics.rectangle("fill", paddleX + 3, paddleY + 4, 4, paddleH - 8)

    -- ── Aligned banner ──────────────────────────────────────────────────────
    if aligned then
        love.graphics.setColor(0.1, 1, 0.3)
        love.graphics.print("ALIGNED!  v", SCREEN_W / 2 - 52, SCREEN_H / 2 - 12,
                            0, 1.6, 1.6)
    end

    -- ── HUD ─────────────────────────────────────────────────────────────────
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Use UP / DOWN arrows to line your paddle up with the green target.", 10, 10)
    love.graphics.print("Press R to move the target to a new spot.", 10, 28)

    love.graphics.setColor(0.5, 0.5, 0.6)
    love.graphics.print("Paddle Y: " .. math.floor(paddleY) ..
                         "   Target Y: " .. math.floor(targetY), 10, SCREEN_H - 22)
end
