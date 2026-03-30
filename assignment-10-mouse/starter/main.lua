-- Assignment 10: Mouse Input — STARTER
-- Click the balloons to pop them!
-- Your job: fill in love.mousepressed so clicks actually do something.

balloons      = {}
score         = 0
spawnTimer    = 0
spawnInterval = 1.2

-- Pop particles for a small burst effect
particles = {}

function love.load()
    math.randomseed(os.time())
    -- Spawn a few balloons right away so the screen isn't empty
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

-- Spawns a burst of tiny coloured particles at position (bx, by).
-- Called when a balloon is popped. You don't need to change this.
function spawnParticles(bx, by, br, bg, bb)
    for p = 1, 10 do
        local angle = math.random() * math.pi * 2
        local speed = math.random(60, 180)
        table.insert(particles, {
            x    = bx,
            y    = by,
            vx   = math.cos(angle) * speed,
            vy   = math.sin(angle) * speed,
            life = 0.5,
            r    = br,
            g    = bg,
            b    = bb
        })
    end
end

function love.update(dt)
    -- Move every balloon upward
    for i = 1, #balloons do
        balloons[i].y = balloons[i].y - balloons[i].speed * dt
    end

    -- Remove balloons that drifted off the top of the screen
    -- (looping backwards — the safe pattern for removing while iterating)
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

    -- Update pop particles (move them and fade them out)
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
        love.graphics.circle("fill",
            b.x - b.radius * 0.3,
            b.y - b.radius * 0.3,
            b.radius * 0.3
        )

        -- String
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.line(b.x, b.y + b.radius, b.x - 5, b.y + b.radius + 30)
    end

    -- Draw pop particles
    for _, p in ipairs(particles) do
        local alpha = p.life / 0.5
        love.graphics.setColor(p.r, p.g, p.b, alpha)
        love.graphics.circle("fill", p.x, p.y, 5 * alpha)
    end

    -- Score display
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Click the balloons to pop them!", 10, 30)
    love.graphics.print("Balloons in the air: " .. #balloons, 10, 50)
end

function love.mousepressed(x, y, button)
    if button == 1 then

        -- TODO 1: Loop through the balloons table backwards.
        -- Looping backwards is the safe way to remove items during a loop —
        -- removing an item doesn't shift the ones you haven't visited yet.
        -- The first two lines of the loop are given below — fill in the body.
        for i = #balloons, 1, -1 do
            local b = balloons[i]

            -- TODO 2: Calculate the distance from the click to this balloon's centre.
            -- Name your variables dx, dy, and dist.
            -- dx = the horizontal gap between the click x and b.x
            -- dy = the vertical gap between the click y and b.y
            -- dist = math.sqrt(dx squared plus dy squared)

            -- TODO 3: If dist < b.radius, the click landed inside the balloon.
            -- Spawn the particle burst, remove the balloon from the table,
            -- add 10 to score, then break.

        end

    end
end
