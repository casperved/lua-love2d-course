-- Assignment 10: Mouse Input — SOLUTION
-- Click balloons to pop them. Distance formula + backwards removal.

balloons      = {}
score         = 0
spawnTimer    = 0
spawnInterval = 1.2

-- Pop particles for a small burst effect
particles = {}

function love.load()
    math.randomseed(os.time())
    for i = 1, 5 do
        spawnBalloon()
    end
end

function spawnBalloon()
    table.insert(balloons, {
        x      = math.random(60, 740),
        y      = math.random(500, 650),
        radius = math.random(25, 45),
        speed  = math.random(60, 120),
        r      = math.random(),
        g      = math.random(),
        b      = math.random()
    })
end

function spawnParticles(bx, by, br, bg, bb)
    for p = 1, 10 do
        local angle = math.random() * math.pi * 2
        local speed = math.random(60, 180)
        table.insert(particles, {
            x     = bx,
            y     = by,
            vx    = math.cos(angle) * speed,
            vy    = math.sin(angle) * speed,
            life  = 0.5,
            r     = br,
            g     = bg,
            b     = bb
        })
    end
end

function love.update(dt)
    -- Move balloons upward
    for i = 1, #balloons do
        balloons[i].y = balloons[i].y - balloons[i].speed * dt
    end

    -- Remove balloons that left the screen
    for i = #balloons, 1, -1 do
        if balloons[i].y + balloons[i].radius < 0 then
            table.remove(balloons, i)
        end
    end

    -- Spawn timer
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnTimer = 0
        spawnBalloon()
    end

    -- Update pop particles
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x    = p.x + p.vx * dt
        p.y    = p.y + p.vy * dt
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

function love.draw()
    -- Sky
    love.graphics.setColor(0.5, 0.8, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Balloons
    for i = 1, #balloons do
        local b = balloons[i]

        love.graphics.setColor(b.r, b.g, b.b)
        love.graphics.circle("fill", b.x, b.y, b.radius)

        -- Highlight
        love.graphics.setColor(1, 1, 1, 0.35)
        love.graphics.circle("fill",
            b.x - b.radius * 0.3,
            b.y - b.radius * 0.3,
            b.radius * 0.3
        )

        -- String
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.line(b.x, b.y + b.radius, b.x - 5, b.y + b.radius + 30)
    end

    -- Pop particles
    for _, p in ipairs(particles) do
        local alpha = p.life / 0.5
        love.graphics.setColor(p.r, p.g, p.b, alpha)
        love.graphics.circle("fill", p.x, p.y, 5 * alpha)
    end

    -- UI
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Click the balloons to pop them!", 10, 30)
    love.graphics.print("Balloons in the air: " .. #balloons, 10, 50)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Loop BACKWARDS so removing an item is always safe
        for i = #balloons, 1, -1 do
            local b  = balloons[i]
            local dx = x - b.x
            local dy = y - b.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance < b.radius then
                -- Spawn a little burst of particles at the pop location
                spawnParticles(b.x, b.y, b.r, b.g, b.b)
                table.remove(balloons, i)
                score = score + 1
                break   -- only pop one balloon per click
            end
        end
    end
end
