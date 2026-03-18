-- Assignment 04: Keyboard Input
-- Let's make something move! We'll use the keyboard to control a square.
-- Check love.keyboard.isDown("key") every frame inside love.update(dt).

-- The player square's starting position and properties
playerX = 370        -- starting x position (pixels from left)
playerY = 270        -- starting y position (pixels from top)
playerSize = 60      -- width and height of the square
playerSpeed = 200    -- how fast it moves in pixels per second

function love.load()
    -- Nothing extra to set up here.
end

function love.update(dt)
    -- love.keyboard.isDown("key") returns true while that key is held.
    -- We multiply by dt so movement speed is the same on every computer.

    -- TODO 1: Move LEFT when the "left" arrow key OR "a" is held.
    -- Moving left = decreasing playerX.
    -- if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    --     playerX = playerX - ?
    -- end

    -- TODO 2: Move RIGHT when the "right" arrow key OR "d" is held.
    -- Moving right = increasing playerX.
    -- (Write the whole if block yourself this time!)

    -- TODO 3: Move UP when the "up" arrow key OR "w" is held.
    -- Moving up = DECREASING playerY (y goes downward on screen!)

    -- TODO 4: Move DOWN when the "down" arrow key OR "s" is held.
    -- Moving down = increasing playerY.
end

function love.draw()
    -- Background
    love.graphics.setColor(0.15, 0.15, 0.25)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw the player square
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.rectangle("fill", playerX, playerY, playerSize, playerSize)

    -- Instructions text
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Use arrow keys or WASD to move!", 10, 10)
    love.graphics.print("Position: (" .. math.floor(playerX) .. ", " .. math.floor(playerY) .. ")", 10, 30)
end
