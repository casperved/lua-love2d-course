-- Assignment 15: Score & HUD — SOLUTION
-- Proper HUD: zero-padded score, persistent high score, heart-shaped life icons.

player = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids = {}
score = 0
lives = 3
highScore = 0
survivalTimer = 0
spawnTimer = 0
spawnInterval = 1.5
gameOver = false

-- Flash state for heart-lost animation
heartFlash = 0   -- counts down in seconds; >0 means a heart was just lost

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

-- Draw a heart icon at (x, y) with a given size.
-- filled=true → red heart; filled=false → grey empty heart.
function drawHeart(x, y, size, filled)
    local r, g, b = 1, 0.2, 0.2
    if not filled then r, g, b = 0.35, 0.35, 0.35 end
    love.graphics.setColor(r, g, b)
    -- Left bump
    love.graphics.circle("fill", x - size*0.25, y, size*0.35)
    -- Right bump
    love.graphics.circle("fill", x + size*0.25, y, size*0.35)
    -- Bottom point (triangle)
    love.graphics.polygon("fill",
        x - size*0.6, y + size*0.15,
        x + size*0.6, y + size*0.15,
        x,            y + size*0.75)
end

function love.update(dt)
    if gameOver then return end

    -- Player movement
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    player.x = math.max(0, math.min(750, player.x))

    -- Timer and score (×10 multiplier makes it feel more satisfying)
    survivalTimer = survivalTimer + dt
    score = math.floor(survivalTimer * 10)

    -- Heart flash timer
    if heartFlash > 0 then heartFlash = heartFlash - dt end

    -- Spawn timer with difficulty ramp
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnAsteroid()
        spawnTimer = 0
    end
    spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)

    -- Update asteroids
    for i = #asteroids, 1, -1 do
        local a = asteroids[i]
        a.y = a.y + a.speed * dt

        if a.y - a.radius > 620 then
            table.remove(asteroids, i)
        else
            -- Circle-rectangle collision
            if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
               a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
                table.remove(asteroids, i)
                lives = lives - 1
                heartFlash = 0.4   -- trigger brief flash
                if lives <= 0 then
                    gameOver  = true
                    highScore = math.max(highScore, score)
                end
            end
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

    -- Player
    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.setColor(0.6, 1, 1)
    love.graphics.rectangle("fill", player.x + 10, player.y + 5, player.w - 20, 10)

    -- ── HUD ──────────────────────────────────────────────────────────────────

    -- Semi-transparent top bar
    love.graphics.setColor(0, 0, 0, 0.45)
    love.graphics.rectangle("fill", 0, 0, 800, 55)

    -- Score (zero-padded to 6 digits)
    love.graphics.setColor(0.9, 0.9, 0.3)
    love.graphics.print("SCORE", 10, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("%06d", score), 10, 26)

    -- High score
    love.graphics.setColor(0.6, 0.8, 1)
    love.graphics.print("BEST", 160, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("%06d", highScore), 160, 26)

    -- Speed indicator
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.print(string.format("%.1f ast/s", 1 / spawnInterval), 320, 18)

    -- Hearts (right side)
    for i = 1, 3 do
        local hx = 700 + i * 33
        local hy = 24
        local isFilled = (i <= lives)

        -- Flash white when a life was just lost
        if heartFlash > 0 and i == lives + 1 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", hx, hy, 14)
        else
            drawHeart(hx, hy, 22, isFilled)
        end
    end

    -- Controls reminder at bottom
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.print("Left / Right arrows to dodge asteroids", 250, 565)

    -- ── Game Over Screen ─────────────────────────────────────────────────────
    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.72)
        love.graphics.rectangle("fill", 130, 200, 540, 200)

        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("G A M E   O V E R", 295, 220)

        love.graphics.setColor(0.9, 0.9, 0.3)
        love.graphics.print("Final Score:", 220, 275)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("%06d", score), 390, 275)

        love.graphics.setColor(0.6, 0.8, 1)
        love.graphics.print("Best Score:", 220, 305)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("%06d", highScore), 390, 305)

        if score >= highScore and score > 0 then
            love.graphics.setColor(1, 0.85, 0.1)
            love.graphics.print("NEW HIGH SCORE!", 295, 335)
        end

        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.print("Press R to play again  |  Escape to quit", 215, 368)
    end
end

function love.keypressed(key)
    if key == "r" and gameOver then
        asteroids     = {}
        score         = 0
        lives         = 3
        survivalTimer = 0
        spawnTimer    = 0
        spawnInterval = 1.5
        player.x      = 375
        gameOver      = false
        heartFlash    = 0
    end
    if key == "escape" then
        love.event.quit()
    end
end
