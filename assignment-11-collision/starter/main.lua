-- Assignment 11: Collision Detection
-- How do we know when two things are touching? Math!
-- We'll check if a player rectangle overlaps with obstacle rectangles.

player = { x = 100, y = 250, w = 50, h = 50, speed = 200 }
isColliding = false

obstacles = {
    { x = 300, y = 200, w = 80, h = 80 },
    { x = 500, y = 300, w = 120, h = 60 },
    { x = 150, y = 420, w = 60, h = 100 },
}

-- TODO 1: Write a function called checkCollision(a, b) that returns true
-- if rectangle a overlaps rectangle b, and false otherwise.
-- Use the AABB formula:
-- return a.x < b.x + b.w and
--        a.x + a.w > b.x and
--        a.y < b.y + b.h and
--        a.y + a.h > b.y
--
-- function checkCollision(a, b)
--     return ?
-- end

-- Safe placeholder so the rest of the code doesn't crash:
function checkCollision(a, b)
    return false  -- replace this with the real formula!
end

function love.load()
end

function love.update(dt)
    -- Move the player
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("up")    then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("down")  then player.y = player.y + player.speed * dt end

    -- TODO 2: Check collision with each obstacle.
    -- Set isColliding = false first, then loop through obstacles.
    -- If checkCollision(player, obstacles[i]) is true, set isColliding = true.
    isColliding = false
    -- for i = 1, #obstacles do
    --     if checkCollision(player, obstacles[i]) then
    --         isColliding = true
    --     end
    -- end
end

function love.draw()
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw obstacles
    love.graphics.setColor(0.5, 0.3, 0.8)
    for i = 1, #obstacles do
        love.graphics.rectangle("fill", obstacles[i].x, obstacles[i].y, obstacles[i].w, obstacles[i].h)
    end

    -- TODO 3: Draw the player. If isColliding, use red (1, 0.2, 0.2). Otherwise use green (0.2, 1, 0.4).
    -- if isColliding then
    --     love.graphics.setColor(1, 0.2, 0.2)
    -- else
    --     love.graphics.setColor(0.2, 1, 0.4)
    -- end
    -- love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.setColor(0.2, 1, 0.4)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Arrow keys to move. Touch a purple box!", 10, 10)
    if isColliding then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("COLLISION!", 10, 30)
    end
end
