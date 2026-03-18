-- Assignment 11: Collision Detection — SOLUTION
-- The player turns red when touching any purple obstacle, green when safe.

player = { x = 100, y = 250, w = 50, h = 50, speed = 200 }
isColliding = false

obstacles = {
    { x = 300, y = 200, w = 80,  h = 80  },
    { x = 500, y = 300, w = 120, h = 60  },
    { x = 150, y = 420, w = 60,  h = 100 },
}

-- AABB collision: returns true if rectangle a and rectangle b overlap.
function checkCollision(a, b)
    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end

function love.load()
end

function love.update(dt)
    -- Move the player with arrow keys
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("up")    then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("down")  then player.y = player.y + player.speed * dt end

    -- Check collision against every obstacle
    isColliding = false
    for i = 1, #obstacles do
        if checkCollision(player, obstacles[i]) then
            isColliding = true
        end
    end
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

    -- Draw player: red on collision, green when clear
    if isColliding then
        love.graphics.setColor(1, 0.2, 0.2)
    else
        love.graphics.setColor(0.2, 1, 0.4)
    end
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
