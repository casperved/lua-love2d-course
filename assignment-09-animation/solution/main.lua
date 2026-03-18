-- Assignment 09: Smooth Animation with Delta Time — SOLUTION
-- A sun, one planet, its moon, and a bonus second planet.

sunX      = 400
sunY      = 300
sunRadius = 50

-- Planet 1
orbitRadius = 180
angle       = 0
orbitSpeed  = 1.2
planetRadius = 22
planetX = sunX + orbitRadius
planetY = sunY

-- Moon of planet 1
moonAngle       = 0
moonOrbitRadius = 50
moonSpeed       = 3.5
moonRadius      = 10
moonX = planetX + moonOrbitRadius
moonY = planetY

-- Planet 2 (bonus)
orbit2Radius = 290
angle2       = math.pi     -- start on the opposite side
orbitSpeed2  = 0.6
planet2Radius = 16
planet2X = sunX + orbit2Radius
planet2Y = sunY

-- Trail for planet 1
trail = {}
MAX_TRAIL = 40

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    -- Planet 1 orbit
    angle   = angle + orbitSpeed * dt
    planetX = sunX + math.cos(angle) * orbitRadius
    planetY = sunY + math.sin(angle) * orbitRadius

    -- Moon orbits planet 1
    moonAngle = moonAngle + moonSpeed * dt
    moonX     = planetX + math.cos(moonAngle) * moonOrbitRadius
    moonY     = planetY + math.sin(moonAngle) * moonOrbitRadius

    -- Planet 2 orbit
    angle2   = angle2 + orbitSpeed2 * dt
    planet2X = sunX + math.cos(angle2) * orbit2Radius
    planet2Y = sunY + math.sin(angle2) * orbit2Radius

    -- Record trail positions
    table.insert(trail, {x = planetX, y = planetY})
    if #trail > MAX_TRAIL then
        table.remove(trail, 1)
    end
end

function love.draw()
    -- Space background
    love.graphics.setColor(0.03, 0.03, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Orbit paths
    love.graphics.setColor(0.18, 0.18, 0.18)
    love.graphics.circle("line", sunX, sunY, orbitRadius)
    love.graphics.circle("line", sunX, sunY, orbit2Radius)

    -- Planet 1 trail
    for i, p in ipairs(trail) do
        local alpha = i / #trail * 0.5
        love.graphics.setColor(0.3, 0.6, 1, alpha)
        love.graphics.circle("fill", p.x, p.y, 3)
    end

    -- Moon orbit path (around planet)
    love.graphics.setColor(0.22, 0.22, 0.22)
    love.graphics.circle("line", planetX, planetY, moonOrbitRadius)

    -- Sun (with a soft outer glow)
    love.graphics.setColor(1.0, 0.7, 0.1, 0.25)
    love.graphics.circle("fill", sunX, sunY, sunRadius + 20)
    love.graphics.setColor(1.0, 0.85, 0.1)
    love.graphics.circle("fill", sunX, sunY, sunRadius)

    -- Planet 2 (reddish)
    love.graphics.setColor(0.9, 0.4, 0.2)
    love.graphics.circle("fill", planet2X, planet2Y, planet2Radius)

    -- Planet 1 (blue)
    love.graphics.setColor(0.2, 0.5, 1.0)
    love.graphics.circle("fill", planetX, planetY, planetRadius)

    -- Moon (grey)
    love.graphics.setColor(0.75, 0.75, 0.75)
    love.graphics.circle("fill", moonX, moonY, moonRadius)

    -- UI
    love.graphics.setColor(1, 1, 1, 0.85)
    love.graphics.print("Solar system!  Press R to reset angles.", 10, 10)
    love.graphics.print(
        string.format("Planet angle: %.2f rad", angle), 10, 30
    )
end

function love.keypressed(key)
    if key == "r" then
        angle     = 0
        moonAngle = 0
        angle2    = math.pi
        trail     = {}
    end
end
