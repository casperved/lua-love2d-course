-- Assignment 14: Timers & Spawning
-- We use a timer to spawn things at regular intervals.
-- The longer you survive, the faster they come!

player = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids = {}
score = 0
survivalTimer = 0
spawnTimer = 0
spawnInterval = 1.5   -- seconds between spawns (gets smaller over time)
gameOver = false

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
    if gameOver then return end  -- stop updating if game is over

    -- Move player
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end

    -- Clamp player to screen
    player.x = math.max(0, math.min(750, player.x))

    -- Survival score
    survivalTimer = survivalTimer + dt
    score = math.floor(survivalTimer)

    -- TODO 1: Implement the spawn timer.
    -- Add dt to spawnTimer each frame.
    -- When spawnTimer >= spawnInterval, call spawnAsteroid() and reset spawnTimer to 0.
    -- spawnTimer = spawnTimer + dt
    -- if spawnTimer >= spawnInterval then
    --     spawnAsteroid()
    --     spawnTimer = 0
    -- end

    -- TODO 2: Make the game harder over time.
    -- Recalculate spawnInterval so it shrinks as survivalTimer grows (but never below 0.3).
    -- spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)

    -- Move asteroids and check collision with player
    for i = #asteroids, 1, -1 do
        local a = asteroids[i]
        a.y = a.y + a.speed * dt

        -- Remove if off screen
        if a.y - a.radius > 620 then
            table.remove(asteroids, i)
        else
            -- TODO 3: Check collision between player (rectangle) and asteroid (circle).
            -- A simple approximation: check if the circle centre is inside
            -- the player rectangle expanded outward by the asteroid radius.
            -- if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
            --    a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
            --     gameOver = true
            -- end
        end
    end
end

function love.draw()
    love.graphics.setColor(0.04, 0.04, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw asteroids
    love.graphics.setColor(0.6, 0.5, 0.4)
    for i = 1, #asteroids do
        local a = asteroids[i]
        love.graphics.circle("fill", a.x, a.y, a.radius)
    end

    -- Draw player
    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Survived: " .. score .. "s", 10, 10)
    love.graphics.print("Left/Right arrows to dodge!", 10, 30)

    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", 150, 240, 500, 120)
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER!", 330, 260)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("You survived " .. score .. " seconds.", 285, 295)
        love.graphics.print("Press R to try again.", 305, 325)
    end
end

function love.keypressed(key)
    if key == "r" and gameOver then
        asteroids    = {}
        score        = 0
        survivalTimer = 0
        spawnTimer   = 0
        spawnInterval = 1.5
        player.x     = 375
        gameOver     = false
    end
    if key == "escape" then
        love.event.quit()
    end
end
