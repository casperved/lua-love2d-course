-- Assignment 16: Sound Effects
-- Sound brings games to life! In LÖVE2D, you load audio files and play them.
-- For this assignment, put .ogg sound files in the same folder as main.lua.
-- You can download free sounds from: https://freesound.org

-- We use pcall() to safely try loading sounds.
-- If the file doesn't exist, it just skips it without crashing.

local function tryLoadSound(filename, soundType)
    local ok, result = pcall(love.audio.newSource, filename, soundType or "static")
    if ok then return result else return nil end
end

-- TODO 1: Try loading your sound files. Place .ogg files in this folder.
-- Replace the filenames with your actual sound files!
-- hitSound    = tryLoadSound("hit.ogg", "static")
-- dodgeSound  = tryLoadSound("dodge.ogg", "static")
-- music       = tryLoadSound("music.ogg", "stream")

hitSound   = nil
dodgeSound = nil
music      = nil

-- TODO 2: If music loaded successfully, set it to loop and play it.
-- if music then
--     music:setLooping(true)
--     music:play()
-- end

player = { x = 375, y = 530, w = 50, h = 30, speed = 300 }
asteroids = {}
lives = 3
score = 0
survivalTimer = 0
spawnTimer = 0
spawnInterval = 1.5
gameOver = false

-- Visual flash effect (used when no sound is loaded, so you can still see events)
flashTimer = 0
flashColor = {1, 1, 1}

function love.load()
    math.randomseed(os.time())
end

function playSound(source)
    if source then
        source:stop()
        source:play()
    end
end

function triggerFlash(r, g, b)
    flashTimer = 0.1
    flashColor = {r, g, b}
end

function spawnAsteroid()
    table.insert(asteroids, {
        x = math.random(20, 780), y = -30,
        radius = math.random(15, 35),
        speed = math.random(150, 300)
    })
end

function love.update(dt)
    if gameOver then return end

    if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    player.x = math.max(0, math.min(750, player.x))

    survivalTimer = survivalTimer + dt
    score = math.floor(survivalTimer * 10)
    flashTimer = math.max(0, flashTimer - dt)

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
            -- TODO 3: Play the dodge sound here (asteroid passed without hitting you)
            -- playSound(dodgeSound)
            triggerFlash(0.2, 1, 0.2)  -- green flash
        else
            if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
               a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
                table.remove(asteroids, i)
                lives = lives - 1
                -- TODO 4: Play the hit sound here
                -- playSound(hitSound)
                triggerFlash(1, 0.2, 0.2)  -- red flash
                if lives <= 0 then
                    gameOver = true
                    -- TODO 5: Stop the music when game is over
                    -- if music then music:stop() end
                end
            end
        end
    end
end

function love.draw()
    -- Flash overlay
    if flashTimer > 0 then
        love.graphics.setColor(flashColor[1], flashColor[2], flashColor[3], flashTimer * 4)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end

    love.graphics.setColor(0.04, 0.04, 0.12)
    if flashTimer <= 0 then
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end

    love.graphics.setColor(0.6, 0.5, 0.4)
    for i = 1, #asteroids do
        love.graphics.circle("fill", asteroids[i].x, asteroids[i].y, asteroids[i].radius)
    end

    love.graphics.setColor(0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score .. "  Lives: " .. lives, 10, 10)

    local soundStatus = hitSound and "Loaded!" or "No sound file yet"
    love.graphics.print("Sound: " .. soundStatus, 10, 30)

    if gameOver then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER! Score: " .. score .. "  Press R", 250, 280)
    end
end

function love.keypressed(key)
    if key == "r" and gameOver then
        asteroids = {}
        lives = 3
        score = 0
        survivalTimer = 0
        spawnTimer = 0
        spawnInterval = 1.5
        player.x = 375
        gameOver = false
        -- TODO 6: Restart the music
        -- if music then music:seek(0) music:play() end
    end
end
