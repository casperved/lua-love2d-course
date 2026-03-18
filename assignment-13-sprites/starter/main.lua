-- Assignment 13: Sprites & Images
-- Usually you load a .png file as a sprite. Since we're keeping things simple,
-- we'll CREATE our sprite by drawing shapes onto a Canvas.
-- A Canvas is like a mini screen you can draw on, then use later!

shipCanvas = nil   -- we'll create this in love.load
shipW = 60
shipH = 80

ship = {
    x = 400, y = 300,
    angle = 0,       -- rotation in radians
    speed = 180
}

-- Stars are generated once here so love.draw doesn't need math.randomseed each frame
stars = {}

function love.load()
    -- Pre-generate star positions
    math.randomseed(42)
    for i = 1, 80 do
        stars[i] = {
            x = math.random(800),
            y = math.random(600),
            r = math.random(1, 2)
        }
    end

    -- Create a canvas and draw a spaceship shape on it
    shipCanvas = love.graphics.newCanvas(shipW, shipH)
    love.graphics.setCanvas(shipCanvas)  -- start drawing TO the canvas
        love.graphics.clear(0, 0, 0, 0)  -- transparent background
        love.graphics.setColor(0.3, 0.8, 1)
        -- Ship body (triangle-ish shape)
        love.graphics.polygon("fill", shipW/2, 0, shipW, shipH, shipW/2, shipH*0.7, 0, shipH)
        -- Cockpit
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.circle("fill", shipW/2, shipH*0.35, 10)
        -- Engine glow
        love.graphics.setColor(1, 0.5, 0.1)
        love.graphics.rectangle("fill", shipW*0.35, shipH*0.8, shipW*0.3, shipH*0.15)
    love.graphics.setCanvas()  -- stop drawing to canvas, back to screen
    love.graphics.setColor(1, 1, 1)  -- reset color
end

function love.update(dt)
    -- Move the ship with WASD
    if love.keyboard.isDown("w") then
        ship.y = ship.y - ship.speed * dt
        ship.angle = -math.pi / 2   -- pointing up
    elseif love.keyboard.isDown("s") then
        ship.y = ship.y + ship.speed * dt
        ship.angle = math.pi / 2    -- pointing down
    end
    if love.keyboard.isDown("a") then
        ship.x = ship.x - ship.speed * dt
        ship.angle = math.pi        -- pointing left
    elseif love.keyboard.isDown("d") then
        ship.x = ship.x + ship.speed * dt
        ship.angle = 0              -- pointing right
    end
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

    -- TODO 1: Draw the shipCanvas using love.graphics.draw()
    -- The 4th argument is rotation (ship.angle)
    -- The 5th and 6th are scaleX and scaleY (use 1, 1 for normal size)
    -- The 7th and 8th are the origin offset (centre of the canvas):
    --   ox = shipW / 2,  oy = shipH / 2
    -- This makes the ship rotate around its centre!
    --
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.draw(shipCanvas, ship.x, ship.y, ship.angle, 1, 1, shipW/2, shipH/2)

    -- Placeholder rectangle so it doesn't look empty:
    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", ship.x - 20, ship.y - 25, 40, 50)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("WASD to move. Fill in TODO 1 to see the real ship!", 10, 10)

    -- TODO 2: Add a thruster effect — when W is held, draw a small orange
    -- flame below the ship (a small triangle using love.graphics.polygon).
    -- Hint: position it at (ship.x, ship.y + shipH/2 + 5)
end
