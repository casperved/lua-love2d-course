-- Assignment 09: Smooth Animation with Delta Time
-- dt (delta time) makes animation look the same on any computer.
-- math.cos and math.sin help us make things move in circles!

sunX   = 400
sunY   = 300
sunRadius = 50

orbitRadius = 180   -- how far the planet is from the sun
angle       = 0     -- current angle in radians
orbitSpeed  = 1.2   -- radians per second

planetRadius = 22

-- Initialise planetX/Y so love.draw doesn't crash before the first update
planetX = sunX + orbitRadius   -- starts to the right of the sun
planetY = sunY

-- Moon orbiting the planet
moonAngle       = 0
moonOrbitRadius = 50
moonSpeed       = 3.5
moonRadius      = 10

-- Initialise moonX/Y similarly
moonX = planetX + moonOrbitRadius
moonY = planetY

function love.load()
end

function love.update(dt)
    -- TODO 1: Increase angle by orbitSpeed * dt each frame:
    --   angle = angle + orbitSpeed * dt

    -- TODO 2: Calculate the planet's position using the updated angle:
    --   planetX = sunX + math.cos(angle) * orbitRadius
    --   planetY = sunY + math.sin(angle) * orbitRadius

    -- TODO 3: Increase moonAngle and calculate the moon's position
    -- (the moon orbits the planet, so use planetX/Y as the center):
    --   moonAngle = moonAngle + moonSpeed * dt
    --   moonX     = planetX + math.cos(moonAngle) * moonOrbitRadius
    --   moonY     = planetY + math.sin(moonAngle) * moonOrbitRadius
end

function love.draw()
    -- Space background
    love.graphics.setColor(0.03, 0.03, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Faint planet orbit path
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.circle("line", sunX, sunY, orbitRadius)

    -- Sun (glowing yellow)
    love.graphics.setColor(1.0, 0.85, 0.1)
    love.graphics.circle("fill", sunX, sunY, sunRadius)

    -- TODO 4: Draw the planet as a blue-ish circle at (planetX, planetY):
    --   love.graphics.setColor(0.2, 0.5, 1)
    --   love.graphics.circle("fill", planetX, planetY, planetRadius)

    -- TODO 5: Draw the moon as a grey circle at (moonX, moonY):
    --   love.graphics.setColor(0.8, 0.8, 0.8)
    --   love.graphics.circle("fill", moonX, moonY, moonRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("A solar system!  Press R to reset angles.", 10, 10)
end

function love.keypressed(key)
    if key == "r" then
        angle     = 0
        moonAngle = 0
    end
end
