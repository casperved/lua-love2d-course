-- Assignment 04: Keyboard Input
-- Let's make something move! You'll use the keyboard to control a square.
-- Your job: fill in the four TODOs inside love.update(dt).

playerX = 370           -- starting x position (pixels from the left edge)
playerY = 270           -- starting y position (pixels from the top edge)
playerSize = 60         -- width and height of the square
playerSpeed = 200       -- how fast it moves, in pixels per second

function love.load()
end

function love.update(dt)
    -- love.keyboard.isDown("key") returns true while that key is being held.
    -- We multiply by dt so the speed feels the same on every computer.

    -- TODO 1: Move LEFT when "left" or "a" is held.
    -- Moving left means playerX gets smaller.
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        -- write one line here: subtract playerSpeed * dt from playerX
    end

    -- TODO 2: Move RIGHT when "right" or "d" is held.
    -- (same pattern — write the full if block yourself this time)

    -- TODO 3: Move UP when "up" or "w" is held.
    -- Remember: on screen, UP means y gets SMALLER, not larger!

    -- TODO 4: Move DOWN when "down" or "s" is held.

    -- Already done for you — read this to understand screen boundaries:
    if playerX < 0 then playerX = 0 end
    if playerY < 0 then playerY = 0 end
    if playerX + playerSize > 800 then playerX = 800 - playerSize end
    if playerY + playerSize > 600 then playerY = 600 - playerSize end
end

function love.draw()
    -- Background
    love.graphics.setColor(0.15, 0.15, 0.25)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Glow effect: a slightly larger, dimmer square behind the player
    love.graphics.setColor(0.1, 0.5, 0.7)
    love.graphics.rectangle("fill", playerX - 4, playerY - 4, playerSize + 8, playerSize + 8)

    -- Player square
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.rectangle("fill", playerX, playerY, playerSize, playerSize)

    -- Instructions
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Use arrow keys or WASD to move!", 10, 10)
    love.graphics.print("Position: (" .. math.floor(playerX) .. ", " .. math.floor(playerY) .. ")", 10, 30)
end
