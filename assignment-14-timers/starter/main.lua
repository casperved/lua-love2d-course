-- Assignment 14: Timers & Spawning
-- Use an accumulator timer to spawn asteroids on a schedule.
-- Survive as long as you can — it gets faster over time!

player        = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids     = {}
score         = 0
survivalTimer = 0
spawnTimer    = 0
spawnInterval = 1.5   -- seconds between spawns (gets smaller over time)
gameOver      = false

function love.load()
    math.randomseed(os.time())
end

function spawnAsteroid()
    table.insert(asteroids, {
        x      = math.random(20, 780),
        y      = -30,
        radius = math.random(15, 35),
        speed  = math.random(150, 300)
    })
end

function love.update(dt)
    if gameOver then return end

    -- Player movement
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    player.x = math.max(0, math.min(750, player.x))

    -- Survival timer and score
    survivalTimer = survivalTimer + dt
    score = math.floor(survivalTimer)

    -- TODO 1: Implement the spawn timer.
    -- Add dt to spawnTimer every frame.
    -- When spawnTimer reaches spawnInterval, call spawnAsteroid() and reset spawnTimer to 0.
    -- spawnTimer = spawnTimer + dt
    -- if spawnTimer >= spawnInterval then
    --     spawnAsteroid()
    --     spawnTimer = 0
    -- end

    -- TODO 2: Make the game harder over time.
    -- Recalculate spawnInterval so it shrinks as survivalTimer grows, but never below 0.3.
    -- spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)

    -- Move asteroids and check for collisions
    for i = #asteroids, 1, -1 do
        local a = asteroids[i]
        a.y = a.y + a.speed * dt

        if a.y - a.radius > 620 then
            -- Asteroid fell off the bottom safely
            table.remove(asteroids, i)
        else
            -- TODO 3: Check if this asteroid hit the player.
            -- Use the expanded-rectangle trick: check if the circle centre (a.x, a.y)
            -- is inside the player rectangle padded outward by a.radius on every side.
            -- If it is, set gameOver = true.
            -- if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
            --    a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
            --     gameOver = true
            -- end
        end
    end
end

function love.draw()
    -- Background
    love.graphics.setColor(0.04, 0.04, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Asteroids
    for i = 1, #asteroids do
        local a = asteroids[i]
        love.graphics.setColor(0.65, 0.54, 0.43)
        love.graphics.circle("fill", a.x, a.y, a.radius)
        love.graphics.setColor(0.5, 0.42, 0.33)
        love.graphics.circle("line", a.x, a.y, a.radius)
    end

    -- Player ship
    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    -- Cockpit tint
    love.graphics.setColor(0.6, 1, 1)
    love.graphics.rectangle("fill", player.x + 10, player.y + 5, player.w - 20, 10)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Survived: " .. score .. "s", 10, 10)
    love.graphics.print("Speed: " .. string.format("%.1f", 1 / spawnInterval) .. " asteroids/s", 10, 30)
    love.graphics.print("Left/Right arrows to dodge!", 10, 560)

    -- Game over overlay
    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.65)
        love.graphics.rectangle("fill", 150, 230, 500, 140)
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER!", 330, 255)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("You survived " .. score .. " seconds!", 285, 295)
        love.graphics.print("Press R to try again.", 305, 330)
    end
end

function love.keypressed(key)
    if key == "r" and gameOver then
        asteroids     = {}
        score         = 0
        survivalTimer = 0
        spawnTimer    = 0
        spawnInterval = 1.5
        player.x      = 375
        gameOver      = false
    end
    if key == "escape" then
        love.event.quit()
    end
end
