-- Assignment 04b: Paddle Alignment
-- Your job: fill in the TODOs inside love.update(dt) so the paddle moves!

SCREEN_W = 800
SCREEN_H = 600

paddleX = 40
paddleY = 270       -- starts roughly centred
paddleW = 20
paddleH = 80
paddleSpeed = 220

-- Target zone on the right side of the screen
targetX = 700
targetW = 60
targetY = 200
targetH = 80

aligned = false     -- set to true when the paddle lines up with the target

pulseTimer = 0      -- used for the glow animation in love.draw (already working)

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    pulseTimer = pulseTimer + dt

    -- TODO 1: Move the paddle UP when the "up" arrow key is held.
    -- The if-header is given — write the one line that goes inside it.
    -- Hint: moving UP means paddleY gets SMALLER (y increases downward on screen).
    if love.keyboard.isDown("up") then
        -- write one line here: subtract paddleSpeed * dt from paddleY
    end

    -- TODO 2: Move the paddle DOWN when the "down" arrow key is held.
    -- Write the full if block yourself — same pattern as TODO 1, but in reverse.
    -- Hint: moving DOWN means paddleY gets LARGER.

    -- TODO 3: Check alignment.
    -- Work out the paddle's centre Y: paddleY + paddleH / 2
    -- If it falls between targetY and targetY + targetH, set aligned = true.
    -- Otherwise set aligned = false.
    -- (Two lines of if-statements will do it — or one condition using 'and'.)

    -- Already done for you — clamps the paddle so it can't leave the screen.
    -- Read it to understand how boundary clamping works!
    if paddleY < 0 then paddleY = 0 end
    if paddleY + paddleH > SCREEN_H then paddleY = SCREEN_H - paddleH end
end

-- Already done for you — R key moves the target to a new random spot.
function love.keypressed(key)
    if key == "r" then
        targetY = math.random(50, SCREEN_H - targetH - 50)
        aligned = false
    end
    if key == "escape" then
        love.event.quit()
    end
end

-- Already done for you — focus on love.update above!
function love.draw()
    -- Background
    love.graphics.setColor(0.10, 0.10, 0.18)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Green screen flash when aligned
    if aligned then
        local flash = 0.08 + 0.04 * math.sin(pulseTimer * 8)
        love.graphics.setColor(0, flash, 0)
        love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
    end

    -- Subtle guide line on the left
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(paddleX + paddleW / 2, 0, paddleX + paddleW / 2, SCREEN_H)

    -- Target zone glow
    local glowPulse = 0.15 + 0.06 * math.sin(pulseTimer * 3)
    love.graphics.setColor(0, glowPulse * 1.5, 0, 0.25)
    love.graphics.rectangle("fill", targetX - 6, targetY - 6, targetW + 12, targetH + 12)

    -- Target zone band
    love.graphics.setColor(0.1, 0.7, 0.2, 0.45)
    love.graphics.rectangle("fill", targetX, targetY, targetW, targetH)

    -- Target zone border
    love.graphics.setColor(0.2, 1, 0.3)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", targetX, targetY, targetW, targetH)

    -- Centre tick inside target
    local targetCentreY = targetY + targetH / 2
    love.graphics.setColor(0.3, 1, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(targetX + 8, targetCentreY, targetX + targetW - 8, targetCentreY)

    -- Paddle glow
    local cyanGlow = aligned and 0.9 or 0.4
    love.graphics.setColor(0, cyanGlow * 0.6, cyanGlow, 0.35)
    love.graphics.rectangle("fill", paddleX - 5, paddleY - 5, paddleW + 10, paddleH + 10)

    -- Paddle body
    love.graphics.setColor(0.2, 0.85, 1)
    love.graphics.rectangle("fill", paddleX, paddleY, paddleW, paddleH)

    -- Paddle highlight stripe
    love.graphics.setColor(0.6, 1, 1)
    love.graphics.rectangle("fill", paddleX + 3, paddleY + 4, 4, paddleH - 8)

    -- "ALIGNED!" banner
    if aligned then
        love.graphics.setColor(0.1, 1, 0.3)
        love.graphics.print("ALIGNED!  v", SCREEN_W / 2 - 52, SCREEN_H / 2 - 12,
                            0, 1.6, 1.6)
    end

    -- HUD text
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Use UP / DOWN arrows to line your paddle up with the green target.", 10, 10)
    love.graphics.print("Press R to move the target to a new spot.", 10, 28)

    love.graphics.setColor(0.5, 0.5, 0.6)
    love.graphics.print("Paddle Y: " .. math.floor(paddleY) ..
                         "   Target Y: " .. math.floor(targetY), 10, SCREEN_H - 22)
end
