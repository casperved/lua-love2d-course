-- Assignment 15: Score & HUD
-- Your job: build a proper arcade HUD with a formatted score,
-- a high score that sticks around, and heart-shaped life icons.

player = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids = {}
score = 0
lives = 3
highScore = 0
survivalTimer = 0
spawnTimer = 0
spawnInterval = 1.5
gameOver = false

-- Flash state for heart-lost animation (you'll use this in TODO 2)
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

-- ─────────────────────────────────────────────────────────────────────────────
-- TODO 1: Write the drawHeart function.
--
-- It should draw a heart shape at position (x, y).
-- Use two circles for the bumpy top and a triangle for the pointy bottom.
-- When filled is true  → draw in red   (r=1, g=0.2, b=0.2)
-- When filled is false → draw in grey  (r=0.35, g=0.35, b=0.35)
--
-- Replace the placeholder function below with your real one.
--
-- function drawHeart(x, y, size, filled)
--     local r, g, b = 1, 0.2, 0.2
--     if not filled then r, g, b = 0.35, 0.35, 0.35 end
--     love.graphics.setColor(r, g, b)
--     -- Left bump
--     love.graphics.circle("fill", x - size*0.25, y, size*0.35)
--     -- Right bump
--     love.graphics.circle("fill", x + size*0.25, y, size*0.35)
--     -- Bottom point (triangle)
--     love.graphics.polygon("fill",
--         x - size*0.6, y + size*0.15,
--         x + size*0.6, y + size*0.15,
--         x,            y + size*0.75)
-- end

-- Placeholder so the program doesn't crash before TODO 1 is done:
function drawHeart(x, y, size, filled)
    love.graphics.setColor(filled and 1 or 0.3, 0.2, 0.2)
    love.graphics.circle("fill", x, y, size * 0.4)
end
-- ─────────────────────────────────────────────────────────────────────────────

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

                -- ─────────────────────────────────────────────────────────────
                -- TODO 2: An asteroid just hit the player!
                --
                -- 1. Subtract 1 from lives.
                -- 2. Set heartFlash = 0.4  (triggers the brief white flash).
                -- 3. If lives have reached 0:
                --      a. Set gameOver = true
                --      b. Update highScore so it keeps the best run ever:
                --         highScore = math.max(highScore, score)
                --
                -- lives = lives - 1
                -- heartFlash = 0.4
                -- if lives <= 0 then
                --     gameOver  = true
                --     highScore = math.max(highScore, score)
                -- end
                -- ─────────────────────────────────────────────────────────────

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

    -- ─────────────────────────────────────────────────────────────────────────
    -- TODO 3: Draw the real HUD here, replacing the plain-text placeholder below.
    --
    -- Steps:
    --   a. Draw a semi-transparent dark bar across the top:
    --      love.graphics.setColor(0, 0, 0, 0.45)
    --      love.graphics.rectangle("fill", 0, 0, 800, 55)
    --
    --   b. Draw the SCORE label and the zero-padded number:
    --      love.graphics.setColor(0.9, 0.9, 0.3)
    --      love.graphics.print("SCORE", 10, 8)
    --      love.graphics.setColor(1, 1, 1)
    --      love.graphics.print(string.format("%06d", score), 10, 26)
    --
    --   c. Draw the BEST (high score) label and number next to it:
    --      love.graphics.setColor(0.6, 0.8, 1)
    --      love.graphics.print("BEST", 160, 8)
    --      love.graphics.setColor(1, 1, 1)
    --      love.graphics.print(string.format("%06d", highScore), 160, 26)
    --
    --   d. Draw the speed indicator (already done for you in the solution):
    --      love.graphics.setColor(0.6, 0.6, 0.6)
    --      love.graphics.print(string.format("%.1f ast/s", 1 / spawnInterval), 320, 18)
    --
    --   e. Draw three hearts on the right side.
    --      Loop i from 1 to 3. A heart is filled when i <= lives.
    --      Also handle the flash: if heartFlash > 0 and i == lives + 1,
    --      draw a white circle instead of the heart.
    --
    --      for i = 1, 3 do
    --          local hx = 700 + i * 33
    --          local hy = 24
    --          local isFilled = (i <= lives)
    --          if heartFlash > 0 and i == lives + 1 then
    --              love.graphics.setColor(1, 1, 1)
    --              love.graphics.circle("fill", hx, hy, 14)
    --          else
    --              drawHeart(hx, hy, 22, isFilled)
    --          end
    --      end

    -- Placeholder HUD (remove or replace this once TODO 3 is done):
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("SCORE " .. score,          10, 10)
    love.graphics.print("BEST  " .. highScore,       10, 30)
    love.graphics.print("LIVES " .. lives,           10, 50)
    -- ─────────────────────────────────────────────────────────────────────────

    -- Controls reminder at bottom
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.print("Left / Right arrows to dodge asteroids", 250, 565)

    -- Game Over screen
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
