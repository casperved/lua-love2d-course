-- Assignment 13: Sprites & Images — SOLUTION
-- Canvas-based "sprite" spaceship with rotation and thruster flame.

shipCanvas = nil
shipW = 60
shipH = 80

ship = {
    x     = 400,
    y     = 300,
    angle = -math.pi / 2,   -- start pointing up
    speed = 180,
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

    -- Build the ship canvas once
    shipCanvas = love.graphics.newCanvas(shipW, shipH)
    love.graphics.setCanvas(shipCanvas)
        love.graphics.clear(0, 0, 0, 0)

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
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
end

function love.update(dt)
    ship.moving = false

    if love.keyboard.isDown("w") then
        ship.y     = ship.y - ship.speed * dt
        ship.angle = -math.pi / 2
        ship.moving = true
    elseif love.keyboard.isDown("s") then
        ship.y     = ship.y + ship.speed * dt
        ship.angle = math.pi / 2
        ship.moving = true
    end

    if love.keyboard.isDown("a") then
        ship.x     = ship.x - ship.speed * dt
        ship.angle = math.pi
        ship.moving = true
    elseif love.keyboard.isDown("d") then
        ship.x     = ship.x + ship.speed * dt
        ship.angle = 0
        ship.moving = true
    end

    -- Wrap around screen edges
    if ship.x < -shipW  then ship.x = 800 + shipW  end
    if ship.x > 800 + shipW  then ship.x = -shipW  end
    if ship.y < -shipH  then ship.y = 600 + shipH  end
    if ship.y > 600 + shipH  then ship.y = -shipH  end
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

    -- Thruster flame — drawn before the ship so it appears behind it
    if ship.moving and love.keyboard.isDown("w") then
        -- Flame points downward from the bottom centre of the ship
        -- We compute where "below centre" is in screen space by rotating a down vector
        local flameOffX = math.cos(ship.angle + math.pi/2) * (shipH/2 + 8)
        local flameOffY = math.sin(ship.angle + math.pi/2) * (shipH/2 + 8)
        local fx = ship.x + flameOffX
        local fy = ship.y + flameOffY

        -- Outer flame (orange)
        love.graphics.setColor(1, 0.45, 0.05, 0.85)
        love.graphics.polygon("fill",
            fx - 9,  fy,
            fx + 9,  fy,
            fx,      fy + 22)

        -- Inner flame (yellow)
        love.graphics.setColor(1, 0.9, 0.2, 0.9)
        love.graphics.polygon("fill",
            fx - 5,  fy,
            fx + 5,  fy,
            fx,      fy + 13)
    end

    -- Draw the ship canvas, rotated around its centre
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        shipCanvas,
        ship.x, ship.y,
        ship.angle + math.pi/2,  -- canvas nose points up; angle 0 = right, so offset by 90°
        1, 1,
        shipW / 2, shipH / 2
    )

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("WASD to move", 10, 10)
    love.graphics.print("Ship wraps around the edges!", 10, 30)
end
