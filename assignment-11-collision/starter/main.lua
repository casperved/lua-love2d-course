-- Assignment 11: Collision Detection
-- Move the green square with the arrow keys.
-- When it touches a purple obstacle it should turn red.
-- You'll write the collision-detection logic to make that happen!

player = { x = 100, y = 250, w = 50, h = 50, speed = 200 }
isColliding = false

obstacles = {
    { x = 300, y = 200, w = 80,  h = 80  },
    { x = 500, y = 300, w = 120, h = 60  },
    { x = 150, y = 420, w = 60,  h = 100 },
}

-- TODO 1: Fill in the body of checkCollision so it returns true when
-- rectangle a and rectangle b are overlapping.
-- Replace "return false" with the four-condition AABB formula:
--   return a.x < b.x + b.w and
--          a.x + a.w > b.x and
--          a.y < b.y + b.h and
--          a.y + a.h > b.y
function checkCollision(a, b)
    return false  -- TODO 1: replace this with the real formula!
end

function love.load()
end

function love.update(dt)
    -- Move the player with arrow keys
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("up")    then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("down")  then player.y = player.y + player.speed * dt end

    -- TODO 2: Check for a collision against every obstacle.
    -- Reset isColliding to false first, then loop through the obstacles table.
    -- If checkCollision(player, obstacles[i]) returns true, set isColliding = true.
    -- isColliding = false
    -- for i = 1, #obstacles do
    --     if checkCollision(player, obstacles[i]) then
    --         isColliding = true
    --     end
    -- end
end

function love.draw()
    -- Background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw obstacles
    love.graphics.setColor(0.5, 0.3, 0.8)
    for i = 1, #obstacles do
        love.graphics.rectangle("fill", obstacles[i].x, obstacles[i].y, obstacles[i].w, obstacles[i].h)
    end

    -- TODO 3: Draw the player red when isColliding is true, green when false.
    -- Replace the plain green draw below with an if/else that picks the colour first.
    -- if isColliding then
    --     love.graphics.setColor(1, 0.2, 0.2)   -- red
    -- else
    --     love.graphics.setColor(0.2, 1, 0.4)   -- green
    -- end
    -- love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.setColor(0.2, 1, 0.4)  -- always green for now — fix in TODO 3
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- Instructions and status
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Arrow keys to move. Touch a purple box!", 10, 10)

    if isColliding then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("COLLISION!", 10, 30)
    else
        love.graphics.setColor(0.2, 1, 0.4)
        love.graphics.print("All clear!", 10, 30)
    end
end
