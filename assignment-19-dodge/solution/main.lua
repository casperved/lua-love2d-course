-- Assignment 19: Mini Project — Dodge! — SOLUTION
-- All three TODOs are complete. Enemies spawn from edges, steer toward
-- the player, and trigger game over on contact.

SCREEN_W = 800
SCREEN_H = 600

gameState = "title"

player = { x = 400, y = 300, size = 20, speed = 280 }

enemies      = {}
spawnTimer   = 0
spawnInterval = 1.0

survivalTime = 0
bestTime     = 0

-- Brief flash when a new wave of enemies starts (cosmetic)
dangerFlash = 0

function love.load()
    math.randomseed(os.time())
end

-- ============================================================
-- spawnEnemy — TODO 1 COMPLETE
-- Picks a random edge and places an enemy just off-screen there.
-- ============================================================
function spawnEnemy()
    local side = math.random(1, 4)
    local ex, ey

    if side == 1 then
        -- Top edge
        ex = math.random(0, SCREEN_W)
        ey = -15
    elseif side == 2 then
        -- Bottom edge
        ex = math.random(0, SCREEN_W)
        ey = SCREEN_H + 15
    elseif side == 3 then
        -- Left edge
        ex = -15
        ey = math.random(0, SCREEN_H)
    else
        -- Right edge
        ex = SCREEN_W + 15
        ey = math.random(0, SCREEN_H)
    end

    table.insert(enemies, {
        x     = ex,
        y     = ey,
        size  = 12,
        speed = math.random(80, 180)
    })
end

-- ============================================================
-- love.update
-- ============================================================
function love.update(dt)
    if gameState ~= "playing" then return end

    -- Player movement (arrow keys or WASD)
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end

    -- Keep player inside the screen
    player.x = math.max(player.size, math.min(SCREEN_W - player.size, player.x))
    player.y = math.max(player.size, math.min(SCREEN_H - player.size, player.y))

    -- Timers
    survivalTime = survivalTime + dt
    dangerFlash  = math.max(0, dangerFlash - dt)

    -- Spawn rate increases over time
    spawnTimer    = spawnTimer + dt
    spawnInterval = math.max(0.25, 1.0 - survivalTime * 0.03)
    if spawnTimer >= spawnInterval then
        spawnEnemy()
        spawnTimer  = 0
        dangerFlash = 0.05  -- tiny red pulse on each spawn
    end

    -- Update all enemies
    for i = #enemies, 1, -1 do
        local e = enemies[i]

        -- TODO 2 — COMPLETE: steer toward the player
        local dx  = player.x - e.x
        local dy  = player.y - e.y
        local len = math.sqrt(dx * dx + dy * dy)
        if len > 0 then
            e.x = e.x + (dx / len) * e.speed * dt
            e.y = e.y + (dy / len) * e.speed * dt
        end

        -- TODO 3 — COMPLETE: circle-circle collision with player
        local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
        if dist < player.size + e.size then
            bestTime  = math.max(bestTime, survivalTime)
            gameState = "gameover"
            return  -- stop processing immediately
        end
    end
end

-- ============================================================
-- love.draw
-- ============================================================
function love.draw()
    -- Background
    love.graphics.setColor(0.08, 0.08, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Danger flash (subtle red tint when an enemy spawns)
    if dangerFlash > 0 then
        love.graphics.setColor(1, 0.1, 0.1, dangerFlash * 3)
        love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
    end

    if gameState == "title" then
        love.graphics.setColor(0.3, 1, 0.5)
        love.graphics.print("D O D G E !", 310, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Move with Arrow Keys or WASD.", 265, 270)
        love.graphics.print("Survive as long as you can!", 270, 300)
        love.graphics.print("Press ENTER to start.", 300, 370)

    elseif gameState == "playing" then
        -- Draw enemies
        for i = 1, #enemies do
            local e = enemies[i]
            -- Slightly lighter ring to make them look round
            love.graphics.setColor(0.9, 0.15, 0.15)
            love.graphics.circle("fill", e.x, e.y, e.size)
            love.graphics.setColor(1, 0.4, 0.4)
            love.graphics.circle("line", e.x, e.y, e.size)
        end

        -- Draw player
        love.graphics.setColor(0.3, 1, 0.5)
        love.graphics.circle("fill", player.x, player.y, player.size)
        -- Eye / highlight
        love.graphics.setColor(0.1, 0.4, 0.2)
        love.graphics.circle("fill", player.x + 5, player.y - 5, 5)
        love.graphics.setColor(0.6, 1, 0.7)
        love.graphics.circle("fill", player.x - 6, player.y - 8, 3)

        -- HUD
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("Time: %.1fs",  survivalTime), 10, 10)
        love.graphics.print(string.format("Best: %.1fs",  bestTime),     10, 30)
        love.graphics.print("Enemies: " .. #enemies,                     10, 50)

    elseif gameState == "gameover" then
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", 220, 190, 360, 200)
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("YOU WERE CAUGHT!", 295, 220)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("Survived: %.1f seconds", survivalTime), 260, 280)
        love.graphics.print(string.format("Best:      %.1f seconds", bestTime),    260, 305)
        love.graphics.print("Press R to try again.", 300, 355)
    end
end

-- ============================================================
-- love.keypressed
-- ============================================================
function love.keypressed(key)
    if gameState == "title" and key == "return" then
        enemies      = {}
        survivalTime = 0
        spawnTimer   = 0
        spawnInterval = 1.0
        player.x     = 400
        player.y     = 300
        gameState    = "playing"
    elseif gameState == "gameover" and key == "r" then
        enemies      = {}
        survivalTime = 0
        spawnTimer   = 0
        spawnInterval = 1.0
        player.x     = 400
        player.y     = 300
        gameState    = "playing"
    end
end
