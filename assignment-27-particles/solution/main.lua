-- Assignment 27: Particle Systems — SOLUTION
-- A campfire scene with fire, smoke, and click-triggered spark bursts.

SCREEN_W = 800
SCREEN_H = 600

FIRE_X = SCREEN_W / 2
FIRE_Y = SCREEN_H - 140

-- ─────────────────────────────────────────────
function love.load()
    love.window.setMode(SCREEN_W, SCREEN_H)
    love.window.setTitle("Assignment 27 – Particle Systems (Solution)")
    math.randomseed(os.time())

    -- Shared 4×4 white square — tiny but all we need.
    local canvas = love.graphics.newCanvas(4, 4)
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 4, 4)
    love.graphics.setCanvas()
    particleImg = canvas

    -- ── Fire ─────────────────────────────────────────────────────────
    firePS = love.graphics.newParticleSystem(particleImg, 200)
    firePS:setParticleLifetime(0.3, 0.8)
    firePS:setEmissionRate(80)
    firePS:setSpeed(40, 120)
    firePS:setDirection(-math.pi / 2)    -- straight up
    firePS:setSpread(0.6)                -- slight random cone
    firePS:setSizes(1.5, 0.2)           -- shrinks as it rises
    firePS:setColors(
        1,   0.6, 0,   1,    -- born:  vivid orange, fully visible
        1,   0.2, 0,   0.5,  -- mid:   deep red, half faded
        0.1, 0.1, 0.1, 0     -- dies:  near-black, invisible
    )
    firePS:start()

    -- ── Smoke ────────────────────────────────────────────────────────
    smokePS = love.graphics.newParticleSystem(particleImg, 100)
    smokePS:setParticleLifetime(1.2, 2.5)
    smokePS:setEmissionRate(20)
    smokePS:setSpeed(15, 40)             -- much slower than fire
    smokePS:setDirection(-math.pi / 2)
    smokePS:setSpread(0.4)
    smokePS:setSizes(0.5, 2.0)          -- grows as it drifts up
    smokePS:setColors(
        0.3, 0.3, 0.3, 0.6,  -- dark grey, semi-transparent at birth
        0.8, 0.8, 0.8, 0.2,  -- light grey, nearly gone
        1,   1,   1,   0     -- white, fully invisible at death
    )
    -- Visual extra 1: gentle upward acceleration gives smoke a lazy drift
    smokePS:setLinearAcceleration(-8, -10, 8, -5)
    smokePS:start()

    -- ── Spark burst (manual emit only) ───────────────────────────────
    sparkPS = love.graphics.newParticleSystem(particleImg, 80)
    sparkPS:setParticleLifetime(0.3, 0.7)
    sparkPS:setEmissionRate(0)           -- silent until we call :emit()
    sparkPS:setSpeed(80, 220)
    sparkPS:setDirection(0)
    sparkPS:setSpread(math.pi * 2)       -- full 360° burst
    sparkPS:setSizes(1.2, 0.1)
    sparkPS:setColors(
        1,   1,   0.4, 1,    -- bright yellow
        1,   0.6, 0,   0.5,  -- orange, fading
        1,   1,   1,   0     -- white, gone
    )
    -- Visual extra 2: gravity pulls sparks down slightly
    sparkPS:setLinearAcceleration(0, 60, 0, 120)

    -- Keep a list of recent click positions for the glow effect
    clickGlows = {}
end

-- ─────────────────────────────────────────────
function love.update(dt)
    firePS:update(dt)
    smokePS:update(dt)
    sparkPS:update(dt)

    -- Age out the glow rings drawn at click sites
    for i = #clickGlows, 1, -1 do
        clickGlows[i].age = clickGlows[i].age + dt
        if clickGlows[i].age > 0.5 then
            table.remove(clickGlows, i)
        end
    end
end

-- ─────────────────────────────────────────────
function love.mousepressed(x, y, button)
    if button == 1 then
        sparkPS:moveTo(x, y)
        sparkPS:emit(20)
        -- Visual extra 3: record click position for a brief glow ring
        table.insert(clickGlows, { x = x, y = y, age = 0 })
    end
end

-- ─────────────────────────────────────────────
function love.draw()
    love.graphics.setBackgroundColor(0.05, 0.05, 0.12)

    -- Stars (simple static dots for atmosphere)
    love.graphics.setColor(1, 1, 1, 0.6)
    math.randomseed(42)   -- fixed seed so stars don't move
    for _ = 1, 80 do
        local sx = math.random(0, SCREEN_W)
        local sy = math.random(0, SCREEN_H - 200)
        love.graphics.circle("fill", sx, sy, math.random(1, 2))
    end
    math.randomseed(os.time())   -- restore random state for everything else

    -- Ground
    love.graphics.setColor(0.12, 0.08, 0.04)
    love.graphics.rectangle("fill", 0, SCREEN_H - 120, SCREEN_W, 120)

    -- Log pile
    love.graphics.setColor(0.25, 0.15, 0.05)
    love.graphics.rectangle("fill", FIRE_X - 60, FIRE_Y + 10, 120, 18, 6, 6)
    love.graphics.setColor(0.35, 0.20, 0.07)
    love.graphics.rectangle("fill", FIRE_X - 45, FIRE_Y + 18, 90, 12, 4, 4)

    -- Warm glow on the ground beneath the fire
    love.graphics.setColor(1, 0.4, 0, 0.12)
    love.graphics.ellipse("fill", FIRE_X, FIRE_Y + 20, 90, 20)

    -- Click glow rings
    for _, g in ipairs(clickGlows) do
        local alpha = 1 - (g.age / 0.5)
        local radius = 10 + g.age * 60
        love.graphics.setColor(1, 0.9, 0.3, alpha * 0.5)
        love.graphics.circle("line", g.x, g.y, radius)
    end

    -- Particle systems
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(smokePS, FIRE_X, FIRE_Y)
    love.graphics.draw(firePS,  FIRE_X, FIRE_Y)
    love.graphics.draw(sparkPS, 0, 0)

    -- HUD
    love.graphics.setColor(0.9, 0.85, 0.7)
    love.graphics.print("Click anywhere to create sparks!", 10, 10)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 30)
end
