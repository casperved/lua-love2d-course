-- Assignment 18: Mini Project — Catch the Drops! — SOLUTION
-- All three TODOs are filled in. The game is fully playable.

-- === GAME SETTINGS ===
SCREEN_W = 800
SCREEN_H = 600

-- === GAME STATE ===
gameState = "title"  -- "title", "playing", "gameover"

-- === PLAYER (bucket) ===
bucket = {
    x = 375, y = 540,
    w = 80, h = 40,
    speed = 350
}

-- === DROPS ===
drops = {}
spawnTimer    = 0
spawnInterval = 0.8
dropSpeed     = 200

-- === SCORE & LIVES ===
score     = 0
lives     = 3
highScore = 0

-- === CATCH FLASH (brief visual reward when you catch a drop) ===
catchFlash = 0

function love.load()
    math.randomseed(os.time())
end

-- ============================================================
-- spawnDrop — add a new raindrop to the table
-- ============================================================
function spawnDrop()
    table.insert(drops, {
        x      = math.random(20, SCREEN_W - 20),
        y      = -15,
        radius = math.random(10, 20),
        speed  = dropSpeed + math.random(-30, 30),
        r      = math.random() * 0.3,
        g      = math.random() * 0.5 + 0.3,
        b      = math.random() * 0.5 + 0.5
    })
end

-- ============================================================
-- resetGame — called when starting or restarting
-- ============================================================
function resetGame()
    drops         = {}
    score         = 0
    lives         = 3
    spawnTimer    = 0
    spawnInterval = 0.8
    dropSpeed     = 200
    bucket.x      = 375
    catchFlash    = 0
    gameState     = "playing"
end

-- ============================================================
-- love.update
-- ============================================================
function love.update(dt)
    if gameState ~= "playing" then return end

    -- Move bucket
    if love.keyboard.isDown("left")  then bucket.x = bucket.x - bucket.speed * dt end
    if love.keyboard.isDown("right") then bucket.x = bucket.x + bucket.speed * dt end
    bucket.x = math.max(0, math.min(SCREEN_W - bucket.w, bucket.x))

    -- Spawn drops
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnDrop()
        spawnTimer = 0
    end

    -- TODO 1 — COMPLETE: gradually increase difficulty
    spawnInterval = math.max(0.25, spawnInterval - dt * 0.01)
    dropSpeed     = math.min(450,  dropSpeed     + dt * 5)

    -- Catch flash timer
    catchFlash = math.max(0, catchFlash - dt)

    -- Update drops
    for i = #drops, 1, -1 do
        local d = drops[i]
        d.y = d.y + d.speed * dt

        -- TODO 2 — COMPLETE: caught by bucket
        if d.x > bucket.x - d.radius and d.x < bucket.x + bucket.w + d.radius and
           d.y + d.radius > bucket.y  and d.y - d.radius < bucket.y + bucket.h then
            score      = score + 1
            catchFlash = 0.08
            table.remove(drops, i)

        -- TODO 3 — COMPLETE: fell off screen (missed)
        elseif d.y - d.radius > SCREEN_H then
            lives = lives - 1
            table.remove(drops, i)
            if lives <= 0 then
                highScore = math.max(score, highScore)
                gameState = "gameover"
            end
        end
    end
end

-- ============================================================
-- love.draw
-- ============================================================
function love.draw()
    -- Sky gradient
    love.graphics.setColor(0.05, 0.1, 0.3)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
    love.graphics.setColor(0.1, 0.05, 0.2)
    love.graphics.rectangle("fill", 0, SCREEN_H * 0.7, SCREEN_W, SCREEN_H * 0.3)

    if gameState == "title" then
        love.graphics.setColor(0.4, 0.8, 1)
        love.graphics.print("CATCH THE DROPS!", 250, 180)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Use LEFT / RIGHT arrow keys to move the bucket.", 195, 260)
        love.graphics.print("Don't let raindrops hit the ground!", 215, 290)
        love.graphics.print("Press ENTER to start!", 295, 360)

    elseif gameState == "playing" then
        -- Catch flash overlay
        if catchFlash > 0 then
            love.graphics.setColor(0.8, 1, 0.8, catchFlash * 5)
            love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
        end

        -- Draw drops
        for i = 1, #drops do
            local d = drops[i]
            love.graphics.setColor(d.r, d.g, d.b)
            love.graphics.circle("fill", d.x, d.y, d.radius)
            -- Highlight
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.circle("fill",
                d.x - d.radius * 0.3,
                d.y - d.radius * 0.3,
                d.radius * 0.25)
        end

        -- Draw bucket body
        love.graphics.setColor(0.5, 0.35, 0.2)
        love.graphics.rectangle("fill", bucket.x, bucket.y, bucket.w, bucket.h)
        -- Bucket handles
        love.graphics.setColor(0.7, 0.5, 0.3)
        love.graphics.rectangle("fill", bucket.x - 5,              bucket.y, 8, bucket.h)
        love.graphics.rectangle("fill", bucket.x + bucket.w - 3,   bucket.y, 8, bucket.h)
        -- Rim highlight
        love.graphics.setColor(0.85, 0.65, 0.4)
        love.graphics.rectangle("fill", bucket.x, bucket.y, bucket.w, 5)

        -- HUD
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score,     10, 10)
        love.graphics.print("Best:  " .. highScore, 10, 30)
        -- Hearts for lives
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print(string.rep("<3 ", lives), 660, 10)

    elseif gameState == "gameover" then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 240, 200, 320, 200)
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER!", 320, 220)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score,     340, 270)
        love.graphics.print("Best:  " .. highScore, 340, 295)
        love.graphics.print("Press R to play again!", 290, 350)
    end
end

-- ============================================================
-- love.keypressed
-- ============================================================
function love.keypressed(key)
    if gameState == "title" and key == "return" then
        resetGame()
    elseif gameState == "gameover" and key == "r" then
        resetGame()
    end
end
