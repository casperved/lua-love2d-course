-- Assignment 04: Keyboard Input (SOLUTION)
-- A square that moves with arrow keys or WASD.
-- Notice how each direction is its own if block — they're all independent,
-- so holding two keys at once gives you diagonal movement for free!

playerX = 370
playerY = 270
playerSize = 60
playerSpeed = 200    -- pixels per second

function love.load()
end

function love.update(dt)
    -- Move LEFT: decrease x
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        playerX = playerX - playerSpeed * dt
    end

    -- Move RIGHT: increase x
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        playerX = playerX + playerSpeed * dt
    end

    -- Move UP: decrease y (y goes DOWN on screen, so up = smaller y)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        playerY = playerY - playerSpeed * dt
    end

    -- Move DOWN: increase y
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        playerY = playerY + playerSpeed * dt
    end

    -- BONUS: Keep the player inside the screen edges
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
