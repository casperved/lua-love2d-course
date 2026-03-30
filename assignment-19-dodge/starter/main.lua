-- Assignment 19: Mini Project — Dodge!
-- Enemies swarm in from all sides. Move to survive!
-- Fill in the three TODOs to complete the game.

SCREEN_W = 800
SCREEN_H = 600

gameState = "title"

player = { x = 400, y = 300, size = 20, speed = 280 }

enemies      = {}
spawnTimer   = 0
spawnInterval = 1.0

survivalTime = 0
bestTime     = 0

-- Brief flash when a new enemy spawns (cosmetic — already works)
dangerFlash = 0

function love.load()
    math.randomseed(os.time())
end

-- ============================================================
-- spawnEnemy
-- Called on a timer to add one new enemy to the enemies table.
-- ============================================================
function spawnEnemy()
    -- TODO 1: Spawn an enemy at a random edge of the screen.
    --
    -- Step 1 — pick a random side: local side = math.random(1, 4)
    -- Step 2 — set ex, ey based on the side:
    --   side 1 = top    → random x across the screen, y = -15 (above screen)
    --   side 2 = bottom → random x across the screen, y = SCREEN_H + 15
    --   side 3 = left   → x = -15,            random y down the screen
    --   side 4 = right  → x = SCREEN_W + 15,  random y down the screen
    -- Step 3 — add the enemy to the table with size=12 and a random speed.
    --
    -- local side = math.random(1, 4)
    -- local ex, ey
    -- if side == 1 then
    --     ex = math.random(0, SCREEN_W)
    --     ey = -15
    -- elseif side == 2 then
    --     ex = math.random(0, SCREEN_W)
    --     ey = SCREEN_H + 15
    -- elseif side == 3 then
    --     ex = -15
    --     ey = math.random(0, SCREEN_H)
    -- else
    --     ex = SCREEN_W + 15
    --     ey = math.random(0, SCREEN_H)
    -- end
    -- table.insert(enemies, {
    --     x     = ex,
    --     y     = ey,
    --     size  = 12,
    --     speed = math.random(80, 180)
    -- })
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

        -- TODO 2: Move this enemy toward the player.
        --
        -- Calculate how far the enemy is from the player in x and y:
        --   dx = player.x - e.x
        --   dy = player.y - e.y
        -- Then find the total distance (len) using math.sqrt.
        -- Divide dx and dy by len to get a direction of length 1.
        -- Move the enemy along that direction multiplied by e.speed * dt.
        --
        -- local dx  = player.x - e.x
        -- local dy  = player.y - e.y
        -- local len = math.sqrt(dx * dx + dy * dy)
        -- if len > 0 then
        --     e.x = e.x + (dx / len) * e.speed * dt
        --     e.y = e.y + (dy / len) * e.speed * dt
        -- end

        -- TODO 3: Check if this enemy is touching the player.
        --
        -- Two circles overlap when the distance between their centres
        -- is less than the sum of their radii (player.size + e.size).
        -- If they overlap: save the best time and set gameState = "gameover".
        -- Add  return  after so the loop stops immediately.
        --
        -- local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
        -- if dist < player.size + e.size then
        --     bestTime  = math.max(bestTime, survivalTime)
        --     gameState = "gameover"
        --     return
        -- end
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
        enemies       = {}
        survivalTime  = 0
        spawnTimer    = 0
        spawnInterval = 1.0
        player.x      = 400
        player.y      = 300
        gameState     = "playing"
    elseif gameState == "gameover" and key == "r" then
        enemies       = {}
        survivalTime  = 0
        spawnTimer    = 0
        spawnInterval = 1.0
        player.x      = 400
        player.y      = 300
        gameState     = "playing"
    end
end
