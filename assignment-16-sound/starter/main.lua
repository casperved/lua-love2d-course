-- Assignment 16: Sound Effects
-- Sound makes games feel alive! A thud when you get hit, a ding when you dodge,
-- a background tune that fills the silence — all of it comes from .ogg files
-- loaded with love.audio.newSource.
--
-- Before you start, download three free .ogg files from freesound.org:
--   hit.ogg    — a short thud or zap
--   dodge.ogg  — a small beep or ding
--   music.ogg  — a looping background track
-- Place all three in this folder (next to main.lua).

-- ============================================================
-- Safe sound loader — returns nil instead of crashing if
-- the file does not exist or cannot be decoded.
-- ============================================================
local function tryLoadSound(filename, soundType)
    local ok, result = pcall(love.audio.newSource, filename, soundType or "static")
    if ok then
        return result
    else
        print("Note: could not load '" .. filename .. "' — continuing without it.")
        return nil
    end
end

-- ============================================================
-- TODO 1: Load your three sound files.
-- Replace the nil values with tryLoadSound calls.
-- Use "static" for short effects, "stream" for long music.
-- ============================================================
hitSound   = nil   -- hitSound   = tryLoadSound("hit.ogg",   "static")
dodgeSound = nil   -- dodgeSound = tryLoadSound("dodge.ogg", "static")
music      = nil   -- music      = tryLoadSound("music.ogg", "stream")

-- ============================================================
-- TODO 2: Start background music looping.
-- Check that music loaded, then set it looping and play it.
-- ============================================================
-- if music then
--     music:setLooping(true)
--     music:setVolume(0.6)
--     music:play()
-- end

-- ============================================================
-- Game state
-- ============================================================
player = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids = {}
lives = 3
score = 0
survivalTimer = 0
spawnTimer = 0
spawnInterval = 1.5
gameOver = false

-- Visual flash — a colour burst on the screen so you can see
-- events clearly even if sound files are missing.
flashTimer = 0
flashColor = {1, 1, 1}

-- ============================================================
-- love.load
-- ============================================================
function love.load()
    math.randomseed(os.time())
end

-- ============================================================
-- Helper: play a sound from the beginning (safe)
-- ============================================================
function playSound(source)
    if source then
        source:stop()   -- rewind so overlapping hits sound crisp
        source:play()
    end
end

-- ============================================================
-- Helper: flash the screen a colour for a brief moment
-- ============================================================
function triggerFlash(r, g, b)
    flashTimer = 0.12
    flashColor = {r, g, b}
end

-- ============================================================
-- Spawn one asteroid at a random x position above the screen
-- ============================================================
function spawnAsteroid()
    table.insert(asteroids, {
        x      = math.random(20, 780),
        y      = -30,
        radius = math.random(15, 35),
        speed  = math.random(150, 300)
    })
end

-- ============================================================
-- love.update
-- ============================================================
function love.update(dt)
    if gameOver then return end

    -- Player movement
    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    player.x = math.max(0, math.min(750, player.x))

    -- Timers
    survivalTimer = survivalTimer + dt
    score         = math.floor(survivalTimer * 10)
    flashTimer    = math.max(0, flashTimer - dt)

    -- Spawning — gradually speeds up over time
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnAsteroid()
        spawnTimer    = 0
        spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)
    end

    -- Update each asteroid
    for i = #asteroids, 1, -1 do
        local a = asteroids[i]
        a.y = a.y + a.speed * dt

        if a.y - a.radius > 620 then
            -- Asteroid left the screen safely — dodge!
            table.remove(asteroids, i)
            -- TODO 3: Play the dodge sound here.
            -- playSound(dodgeSound)
            triggerFlash(0.2, 1, 0.2)       -- green flash

        elseif a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
               a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
            -- Collision!
            table.remove(asteroids, i)
            lives = lives - 1
            -- TODO 4: Play the hit sound here.
            -- playSound(hitSound)
            triggerFlash(1, 0.2, 0.2)       -- red flash

            if lives <= 0 then
                gameOver = true
                -- TODO 5: Stop the music when the game ends.
                -- if music then music:stop() end
            end
        end
    end
end

-- ============================================================
-- love.draw
-- ============================================================
function love.draw()
    -- Dark space background
    love.graphics.setColor(0.04, 0.04, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Colour flash overlay
    if flashTimer > 0 then
        local alpha = (flashTimer / 0.12) * 0.5   -- fade out smoothly
        love.graphics.setColor(flashColor[1], flashColor[2], flashColor[3], alpha)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end

    -- Asteroids
    love.graphics.setColor(0.6, 0.5, 0.4)
    for i = 1, #asteroids do
        local a = asteroids[i]
        love.graphics.circle("fill", a.x, a.y, a.radius)
        -- Slightly lighter edge for a bit of depth
        love.graphics.setColor(0.75, 0.65, 0.55)
        love.graphics.circle("line", a.x, a.y, a.radius)
        love.graphics.setColor(0.6, 0.5, 0.4)
    end

    -- Player ship
    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    -- Cockpit window
    love.graphics.setColor(0.8, 1, 1)
    love.graphics.rectangle("fill", player.x + 18, player.y + 5, 14, 10)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score .. "  Lives: " .. lives, 10, 10)

    -- Sound status (handy reminder while setting up)
    local hitStatus   = hitSound   and "hit.ogg OK"    or "hit.ogg missing"
    local dodgeStatus = dodgeSound and "dodge.ogg OK"  or "dodge.ogg missing"
    local musicStatus = music      and "music.ogg OK"  or "music.ogg missing"
    love.graphics.setColor(0.6, 0.9, 0.6)
    love.graphics.print(hitStatus .. " | " .. dodgeStatus .. " | " .. musicStatus, 10, 580)

    -- Game over overlay
    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.55)
        love.graphics.rectangle("fill", 180, 250, 440, 100)
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER!  Final Score: " .. score, 220, 270)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press R to play again", 295, 310)
    end
end

-- ============================================================
-- love.keypressed
-- ============================================================
function love.keypressed(key)
    if key == "r" and gameOver then
        -- Reset everything
        asteroids     = {}
        lives         = 3
        score         = 0
        survivalTimer = 0
        spawnTimer    = 0
        spawnInterval = 1.5
        player.x      = 375
        gameOver      = false

        -- TODO 6: Restart the music from the beginning.
        -- if music then
        --     music:seek(0)
        --     music:play()
        -- end
    end
end
