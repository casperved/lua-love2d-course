-- Assignment 10: Mouse Input
-- Click the balloons to pop them! We'll use the distance formula to check
-- if the click landed on a balloon.

balloons      = {}
score         = 0
spawnTimer    = 0
spawnInterval = 1.2

function love.load()
    math.randomseed(os.time())
    -- Spawn a few balloons at the start so the screen isn't empty
    for i = 1, 5 do
        spawnBalloon()
    end
end

function spawnBalloon()
    local balloon = {
        x      = math.random(60, 740),
        y      = math.random(500, 650),
        radius = math.random(25, 45),
        speed  = math.random(60, 120),
        r      = math.random(),
        g      = math.random(),
        b      = math.random()
    }
    table.insert(balloons, balloon)
end

function love.update(dt)
    -- Move every balloon upward
    for i = 1, #balloons do
        balloons[i].y = balloons[i].y - balloons[i].speed * dt
    end

    -- Remove balloons that drifted off the top of the screen
    for i = #balloons, 1, -1 do
        if balloons[i].y + balloons[i].radius < 0 then
            table.remove(balloons, i)
        end
    end

    -- Spawn a new balloon on a regular timer
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnTimer = 0
        spawnBalloon()
    end
end

function love.draw()
    -- Sky background
    love.graphics.setColor(0.5, 0.8, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw every balloon
    for i = 1, #balloons do
        local b = balloons[i]

        -- Balloon body
        love.graphics.setColor(b.r, b.g, b.b)
        love.graphics.circle("fill", b.x, b.y, b.radius)

        -- Shiny highlight
        love.graphics.setColor(1, 1, 1, 0.35)
        love.graphics.circle("fill", b.x - b.radius * 0.3, b.y - b.radius * 0.3, b.radius * 0.3)

        -- String
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.line(b.x, b.y + b.radius, b.x - 5, b.y + b.radius + 30)
    end

    -- Score display
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Click the balloons to pop them!", 10, 30)
    love.graphics.print("Balloons in the air: " .. #balloons, 10, 50)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- TODO 1: Loop through the balloons table BACKWARDS.
        -- This is the safe way to remove items during a loop!
        --   for i = #balloons, 1, -1 do
        --       local b = balloons[i]

        -- TODO 2: Calculate the distance from the click to the balloon center:
        --   local dx       = x - b.x
        --   local dy       = y - b.y
        --   local distance = math.sqrt(dx * dx + dy * dy)

        -- TODO 3: If distance < b.radius, the click hit this balloon!
        --   Remove it, add 1 to score, then break out of the loop.
        --   if distance < b.radius then
        --       table.remove(balloons, i)
        --       score = score + 1
        --       break
        --   end

        --   end  (close the for loop)
    end
end
