-- Assignment 09: Smooth Animation with Delta Time
-- Use dt to move things at the same speed on every computer.
-- Use math.cos / math.sin to move things in circles.

sunX      = 400
sunY      = 300
sunRadius = 50

-- Planet 1
orbitRadius  = 180   -- how far from the sun
angle        = 0     -- current angle in radians (starts pointing right)
orbitSpeed   = 1.2   -- radians per second
planetRadius = 22

-- Initialise planetX/Y so love.draw works before the first update
planetX = sunX + orbitRadius
planetY = sunY

-- Moon of planet 1
moonAngle       = 0
moonOrbitRadius = 50
moonSpeed       = 3.5
moonRadius      = 10

-- Initialise moonX/Y similarly
moonX = planetX + moonOrbitRadius
moonY = planetY

-- ============================================================
-- Planet 2 is already done. Read it to see the pattern you'll
-- use for planet 1 in TODO 1.
orbit2Radius  = 290
angle2        = math.pi   -- start on the opposite side of the sun
orbitSpeed2   = 0.6
planet2Radius = 16

planet2X = sunX + orbit2Radius
planet2Y = sunY
-- ============================================================

-- Trail for planet 1 (pre-filled — study it for the stretch goal)
trail     = {}
MAX_TRAIL = 40

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    -- TODO 1: Update planet 1's angle and position.
    -- Add orbitSpeed * dt to angle.
    -- Then calculate planetX = sunX + math.cos(angle) * orbitRadius.
    -- (Same formula as planet 2 above — just use angle and orbitRadius.)

    -- TODO 2: Update the moon's angle and position.
    -- Same pattern as TODO 1, but orbit around the planet.
    -- Use planetX and planetY as the center instead of sunX and sunY.

    -- Planet 2 orbit (already done for you — notice the pattern is the same)
    angle2   = angle2 + orbitSpeed2 * dt
    planet2X = sunX + math.cos(angle2) * orbit2Radius
    planet2Y = sunY + math.sin(angle2) * orbit2Radius

    -- Trail update (pre-filled — study this for the stretch goal)
    table.insert(trail, {x = planetX, y = planetY})
    if #trail > MAX_TRAIL then
        table.remove(trail, 1)
    end
end

function love.draw()
    -- Space background
    love.graphics.setColor(0.03, 0.03, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Orbit paths (faint circles)
    love.graphics.setColor(0.18, 0.18, 0.18)
    love.graphics.circle("line", sunX, sunY, orbitRadius)
    love.graphics.circle("line", sunX, sunY, orbit2Radius)

    -- Planet 1 trail (pre-filled — study this for the stretch goal)
    for i, p in ipairs(trail) do
        local alpha = i / #trail * 0.5
        love.graphics.setColor(0.3, 0.6, 1, alpha)
        love.graphics.circle("fill", p.x, p.y, 3)
    end

    -- Moon orbit ring (around the planet)
    love.graphics.setColor(0.22, 0.22, 0.22)
    love.graphics.circle("line", planetX, planetY, moonOrbitRadius)

    -- Sun (with a soft outer glow)
    love.graphics.setColor(1.0, 0.7, 0.1, 0.25)
    love.graphics.circle("fill", sunX, sunY, sunRadius + 20)
    love.graphics.setColor(1.0, 0.85, 0.1)
    love.graphics.circle("fill", sunX, sunY, sunRadius)

    -- Planet 2 (reddish) — already drawn for you
    love.graphics.setColor(0.9, 0.4, 0.2)
    love.graphics.circle("fill", planet2X, planet2Y, planet2Radius)

    -- TODO 3: Draw the sun, planet 1, and the moon.
    -- Draw planet 1 as a blue circle at (planetX, planetY) with radius planetRadius.
    -- Draw the moon as a grey circle at (moonX, moonY) with radius moonRadius.
    -- (The sun is already drawn above — no need to draw it again.)

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
