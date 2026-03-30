-- Assignment 21 Starter: Saving & Loading Data
-- A survival game with persistent best-time tracking.
-- Dodge the red enemy for as long as you can — your best time is saved to disk!

SCREEN_W = 800
SCREEN_H = 600

PLAYER_SPEED  = 200
PLAYER_RADIUS = 14
PLAYER_COLOR  = {0.2, 0.8, 1}

ENEMY_SPEED   = 120
ENEMY_RADIUS  = 18
ENEMY_COLOR   = {1, 0.3, 0.3}

SAVE_FILE     = "best_time.txt"

state         = "title"
timer         = 0
bestTime      = 0       -- will be loaded from disk
newRecord     = false
recordFlash   = 0

px, py        = 0, 0
ex, ey        = 0, 0

-- Visual extra: particle trail behind the player
trailPoints   = {}   -- list of {x, y, age}
TRAIL_MAX_AGE = 0.35

-- ---------------------------------------------------------------
-- TODO 1: Write the saveScore function.
-- It receives a number called `time` and should write it to
-- the file called SAVE_FILE ("best_time.txt").
-- love.filesystem.write needs a STRING, so convert with tostring.
-- ---------------------------------------------------------------
function saveScore(time)
    -- love.filesystem.write(SAVE_FILE, tostring(time))
end

-- ---------------------------------------------------------------
-- TODO 2: Write the loadScore function.
-- It should read SAVE_FILE and return the number inside.
-- If the file doesn't exist yet (first run), return 0.
-- Steps:
--   1. Check the file exists with love.filesystem.getInfo(SAVE_FILE)
--   2. Read the file with love.filesystem.read(SAVE_FILE)
--   3. Convert the text back to a number with tonumber(data)
--   4. Return 0 if the file doesn't exist
-- ---------------------------------------------------------------
function loadScore()
    -- if love.filesystem.getInfo(SAVE_FILE) then
    --     local data = love.filesystem.read(SAVE_FILE)
    --     return tonumber(data) or 0
    -- end
    return 0
end

function dist(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

function resetGame()
    px = SCREEN_W / 2
    py = SCREEN_H / 2
    ex = math.random(50, 150)
    ey = math.random(50, 150)
    timer       = 0
    newRecord   = false
    recordFlash = 0
    trailPoints = {}
end

function love.load()
    love.window.setTitle("Survival Timer — Assignment 21")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())

    -- ---------------------------------------------------------------
    -- TODO 3a: Load the best time from disk on startup.
    -- Call loadScore() and store the result in bestTime.
    -- ---------------------------------------------------------------
    -- bestTime = loadScore()

    resetGame()
end

function love.update(dt)
    if state == "title" then
        return
    end

    if state == "playing" then
        timer = timer + dt

        -- Player movement (WASD or arrow keys)
        local moveX, moveY = 0, 0
        if love.keyboard.isDown("w") or love.keyboard.isDown("up")    then moveY = -1 end
        if love.keyboard.isDown("s") or love.keyboard.isDown("down")  then moveY =  1 end
        if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then moveX = -1 end
        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then moveX =  1 end

        -- Normalise diagonal movement so corners aren't faster
        local len = math.sqrt(moveX * moveX + moveY * moveY)
        if len > 0 then
            moveX = moveX / len
            moveY = moveY / len
        end

        px = math.max(PLAYER_RADIUS, math.min(SCREEN_W - PLAYER_RADIUS, px + moveX * PLAYER_SPEED * dt))
        py = math.max(PLAYER_RADIUS, math.min(SCREEN_H - PLAYER_RADIUS, py + moveY * PLAYER_SPEED * dt))

        -- Record trail positions for the visual tail effect
        trailPoints[#trailPoints + 1] = {x = px, y = py, age = 0}
        for i = #trailPoints, 1, -1 do
            trailPoints[i].age = trailPoints[i].age + dt
            if trailPoints[i].age > TRAIL_MAX_AGE then
                table.remove(trailPoints, i)
            end
        end

        -- Enemy chases the player using a normalised direction vector
        local dx = px - ex
        local dy = py - ey
        local d  = math.sqrt(dx * dx + dy * dy)
        if d > 0 then
            ex = ex + (dx / d) * ENEMY_SPEED * dt
            ey = ey + (dy / d) * ENEMY_SPEED * dt
        end

        -- Collision: player touched the enemy
        if dist(px, py, ex, ey) < PLAYER_RADIUS + ENEMY_RADIUS then
            -- ---------------------------------------------------------------
            -- TODO 3b: Check for a new record and save it.
            -- If timer > bestTime, update bestTime, call saveScore, and
            -- set newRecord = true so the flashing message appears.
            -- ---------------------------------------------------------------
            -- if timer > bestTime then
            --     bestTime  = timer
            --     saveScore(bestTime)
            --     newRecord = true
            -- end
            state = "gameover"
        end

    elseif state == "gameover" then
        if newRecord then
            recordFlash = recordFlash + dt
        end
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end

    if state == "title" and key == "space" then
        resetGame()
        state = "playing"
    end

    if state == "gameover" and key == "space" then
        resetGame()
        state = "playing"
    end

    if state == "gameover" and key == "q" then
        state = "title"
    end
end

-- ---------------------------------------------------------------
-- Drawing
-- ---------------------------------------------------------------

function drawCenteredText(text, y, size)
    size = size or "medium"
    love.graphics.setFont(love.graphics.newFont(size == "large" and 32 or size == "small" and 14 or 20))
    local w = love.graphics.getFont():getWidth(text)
    love.graphics.print(text, (SCREEN_W - w) / 2, y)
end

function love.draw()
    love.graphics.setBackgroundColor(0.08, 0.08, 0.12)

    if state == "title" then
        -- Decorative gradient circles in the background
        for i = 1, 5 do
            local alpha = 0.04 + i * 0.02
            love.graphics.setColor(0.2, 0.5, 1, alpha)
            love.graphics.circle("fill", SCREEN_W / 2, SCREEN_H / 2, i * 80)
        end

        love.graphics.setColor(1, 1, 1)
        drawCenteredText("SURVIVAL TIMER", 160, "large")

        love.graphics.setColor(0.7, 0.7, 0.7)
        drawCenteredText("Dodge the red enemy for as long as you can!", 220, "small")

        -- Show the loaded best time (this is what TODO 3a enables)
        love.graphics.setColor(0.4, 1, 0.6)
        if bestTime > 0 then
            drawCenteredText(string.format("Best Time: %.2f s", bestTime), 290)
        else
            drawCenteredText("Best Time: --", 290)
        end

        love.graphics.setColor(1, 1, 0.4)
        drawCenteredText("Press SPACE to start", 370)

        love.graphics.setColor(0.5, 0.5, 0.5)
        drawCenteredText("WASD or Arrow Keys to move", 440, "small")

    elseif state == "playing" then
        -- Draw player trail
        for i, pt in ipairs(trailPoints) do
            local frac  = 1 - pt.age / TRAIL_MAX_AGE
            local alpha = frac * 0.4
            local r     = PLAYER_RADIUS * frac * 0.7
            love.graphics.setColor(PLAYER_COLOR[1], PLAYER_COLOR[2], PLAYER_COLOR[3], alpha)
            love.graphics.circle("fill", pt.x, pt.y, r)
        end

        -- Player
        love.graphics.setColor(PLAYER_COLOR)
        love.graphics.circle("fill", px, py, PLAYER_RADIUS)
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.circle("line", px, py, PLAYER_RADIUS)

        -- Enemy with pulsing glow
        local pulse = 0.5 + 0.5 * math.sin(love.timer.getTime() * 5)
        love.graphics.setColor(1, 0.2, 0.2, 0.15 + pulse * 0.15)
        love.graphics.circle("fill", ex, ey, ENEMY_RADIUS + 10 + pulse * 6)

        love.graphics.setColor(ENEMY_COLOR)
        love.graphics.circle("fill", ex, ey, ENEMY_RADIUS)
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.circle("line", ex, ey, ENEMY_RADIUS)

        -- HUD
        love.graphics.setColor(1, 1, 1)
        drawCenteredText(string.format("Time: %.2f s", timer), 10, "small")
        love.graphics.setColor(0.5, 0.9, 0.5)
        drawCenteredText(string.format("Best: %.2f s", bestTime), 30, "small")

    elseif state == "gameover" then
        love.graphics.setColor(1, 0.4, 0.4)
        drawCenteredText("GAME OVER", 160, "large")

        love.graphics.setColor(1, 1, 1)
        drawCenteredText(string.format("You survived: %.2f s", timer), 240)
        drawCenteredText(string.format("Best Time:    %.2f s", bestTime), 280)

        -- "New Record!" flashes for 3 seconds (only works after TODO 3b)
        if newRecord and recordFlash < 3 then
            local alpha = 0.5 + 0.5 * math.sin(recordFlash * 8)
            love.graphics.setColor(1, 1, 0, alpha)
            drawCenteredText("New Record!", 340, "large")
        end

        love.graphics.setColor(0.7, 0.7, 0.7)
        drawCenteredText("SPACE — play again     Q — title", 480, "small")
    end
end
