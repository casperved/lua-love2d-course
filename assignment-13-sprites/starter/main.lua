-- Assignment 13: Sprites & Images
-- A Canvas is like a blank piece of paper you draw shapes on once,
-- then stamp anywhere on screen — rotated, scaled, centred!

shipCanvas = nil   -- we'll create this in love.load
shipW = 60
shipH = 80

ship = {
    x      = 400,
    y      = 300,
    angle  = -math.pi / 2,   -- start pointing up
    speed  = 180,
    moving = false
}

stars = {}

function love.load()
    -- Pre-generate star positions with a fixed seed for consistency
    math.randomseed(42)
    for i = 1, 80 do
        stars[i] = {
            x = math.random(800),
            y = math.random(600),
            r = math.random(1, 2)
        }
    end

    -- Build the ship canvas once — draw all the ship shapes onto it
    shipCanvas = love.graphics.newCanvas(shipW, shipH)
    love.graphics.setCanvas(shipCanvas)   -- "pick up the pen"
        love.graphics.clear(0, 0, 0, 0)  -- transparent background

        -- Hull
        love.graphics.setColor(0.3, 0.8, 1)
        love.graphics.polygon("fill",
            shipW/2, 0,
            shipW,   shipH,
            shipW/2, shipH*0.7,
            0,       shipH)

        -- Wing highlights
        love.graphics.setColor(0.2, 0.6, 0.9)
        love.graphics.polygon("fill",
            shipW/2, shipH*0.3,
            shipW,   shipH,
            shipW/2, shipH*0.7)

        -- Cockpit
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.circle("fill", shipW/2, shipH*0.35, 10)

        -- Engine nozzle
        love.graphics.setColor(0.6, 0.6, 0.7)
        love.graphics.rectangle("fill", shipW*0.3, shipH*0.82, shipW*0.4, shipH*0.12)
    love.graphics.setCanvas()   -- "put down the pen" — back to drawing on screen
    love.graphics.setColor(1, 1, 1)
end

function love.update(dt)
    -- TODO 2: Reset ship.moving to false at the start of each frame
    -- ship.moving = false

    if love.keyboard.isDown("w") then
        ship.y     = ship.y - ship.speed * dt
        ship.angle = -math.pi / 2   -- pointing up
        -- TODO 2: Set ship.moving = true here
        -- ship.moving = true
    elseif love.keyboard.isDown("s") then
        ship.y     = ship.y + ship.speed * dt
        ship.angle = math.pi / 2    -- pointing down
        -- TODO 2: Set ship.moving = true here
        -- ship.moving = true
    end

    if love.keyboard.isDown("a") then
        ship.x     = ship.x - ship.speed * dt
        ship.angle = math.pi        -- pointing left
        -- TODO 2: Set ship.moving = true here
        -- ship.moving = true
    elseif love.keyboard.isDown("d") then
        ship.x     = ship.x + ship.speed * dt
        ship.angle = 0              -- pointing right
        -- TODO 2: Set ship.moving = true here
        -- ship.moving = true
    end

    -- Wrap around screen edges
    if ship.x < -shipW       then ship.x = 800 + shipW  end
    if ship.x > 800 + shipW  then ship.x = -shipW       end
    if ship.y < -shipH       then ship.y = 600 + shipH  end
    if ship.y > 600 + shipH  then ship.y = -shipH       end
end

function love.draw()
    -- Space background
    love.graphics.setColor(0.03, 0.03, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Stars
    love.graphics.setColor(1, 1, 1)
    for i = 1, #stars do
        love.graphics.circle("fill", stars[i].x, stars[i].y, stars[i].r)
    end

    -- TODO 3: Draw the thruster flame BEFORE the ship (so it appears behind it).
    -- Only show it when W is held and ship.moving is true.
    -- Position it just below the ship centre: fx = ship.x, fy = ship.y + shipH/2 + 8
    -- Draw two overlapping triangles using love.graphics.polygon:
    --   outer (orange): fx-9,fy  fx+9,fy  fx,fy+22
    --   inner (yellow): fx-5,fy  fx+5,fy  fx,fy+13
    --
    -- if ship.moving and love.keyboard.isDown("w") then
    --     local fx = ship.x
    --     local fy = ship.y + shipH / 2 + 8
    --     love.graphics.setColor(1, 0.45, 0.05, 0.85)
    --     love.graphics.polygon("fill", fx - 9, fy, fx + 9, fy, fx, fy + 22)
    --     love.graphics.setColor(1, 0.9, 0.2, 0.9)
    --     love.graphics.polygon("fill", fx - 5, fy, fx + 5, fy, fx, fy + 13)
    -- end

    -- TODO 1: Stamp the canvas onto the screen at the ship's position.
    -- Use love.graphics.draw() with rotation and a centred pivot point.
    -- The pivot (originX, originY) should be the centre of the canvas.
    -- Add math.pi/2 to ship.angle because the canvas nose points up
    -- but LÖVE's angle 0 means "pointing right" — the offset fixes that.
    --
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.draw(
    --     shipCanvas,
    --     ship.x, ship.y,
    --     ship.angle + math.pi/2,
    --     1, 1,
    --     shipW / 2, shipH / 2
    -- )

    -- Placeholder: a simple rectangle so something appears before TODO 1 is done.
    -- Delete this once you've filled in TODO 1!
    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", ship.x - 20, ship.y - 25, 40, 50)
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.circle("fill", ship.x, ship.y - 8, 8)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("WASD to move  |  Fill in the TODOs to see the real ship!", 10, 10)
    love.graphics.print("Ship wraps around the edges!", 10, 30)
end
