-- Assignment 15: Score & HUD
-- A HUD (Heads-Up Display) shows important info to the player.
-- Let's add a score, lives, and a high-score tracker!

player = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids = {}
score = 0
lives = 3
highScore = 0
survivalTimer = 0
spawnTimer = 0
spawnInterval = 1.5
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

-- TODO 1: Write a function called drawHeart(x, y, size, filled)
-- that draws a heart shape at (x, y).
-- A heart can be approximated with 2 circles and a downward triangle.
-- If filled is true, draw in red. If false, draw in dark grey (empty life).
--
-- function drawHeart(x, y, size, filled)
--     local r, g, b = 1, 0.2, 0.2
--     if not filled then r, g, b = 0.35, 0.35, 0.35 end
--     love.graphics.setColor(r, g, b)
--     love.graphics.circle("fill", x - size*0.25, y, size*0.35)
--     love.graphics.circle("fill", x + size*0.25, y, size*0.35)
--     love.graphics.polygon("fill",
--         x - size*0.6, y + size*0.15,
--         x + size*0.6, y + size*0.15,
--         x,            y + size*0.75)
-- end

-- Placeholder so code runs without crashing:
function drawHeart(x, y, size, filled)
    love.graphics.setColor(filled and 1 or 0.3, 0.2, 0.2)
    love.graphics.circle("fill", x, y, size * 0.4)
end

function love.update(dt)
    if gameOver then return end

    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    player.x = math.max(0, math.min(750, player.x))

    survivalTimer = survivalTimer + dt
    score = math.floor(survivalTimer * 10)

    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnAsteroid()
        spawnTimer = 0
        spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)
    end

    for i = #asteroids, 1, -1 do
        local a = asteroids[i]
        a.y = a.y + a.speed * dt
        if a.y - a.radius > 620 then
            table.remove(asteroids, i)
        else
            if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
               a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
                table.remove(asteroids, i)
                -- TODO 2: Subtract 1 from lives.
                -- If lives <= 0, set gameOver = true and update highScore.
                lives = lives - 1
                if lives <= 0 then
                    gameOver = true
                    -- highScore = math.max(highScore, score)
                end
            end
        end
    end
end

function love.draw()
    love.graphics.setColor(0.04, 0.04, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    love.graphics.setColor(0.6, 0.5, 0.4)
    for i = 1, #asteroids do
        love.graphics.circle("fill", asteroids[i].x, asteroids[i].y, asteroids[i].radius)
    end

    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- TODO 3: Draw the HUD at the top of the screen.
    -- Score: use string.format to zero-pad to 6 digits: string.format("%06d", score)
    -- High Score: display it below the score.
    -- Lives: draw a heart for each life slot (1 to 3) using drawHeart.
    --   for i = 1, 3 do
    --       drawHeart(700 + i * 35, 25, 20, i <= lives)
    --   end

    -- Placeholder HUD (replace this with the real HUD above):
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score:      " .. score,     10, 10)
    love.graphics.print("High Score: " .. highScore, 10, 30)
    love.graphics.print("Lives: " .. lives,           10, 50)

    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", 150, 220, 500, 160)
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER", 330, 250)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Final Score: " .. string.format("%06d", score),     290, 290)
        love.graphics.print("High Score:  " .. string.format("%06d", highScore), 290, 315)
        love.graphics.print("Press R to play again", 295, 350)
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
    end
    if key == "escape" then
        love.event.quit()
    end
end
