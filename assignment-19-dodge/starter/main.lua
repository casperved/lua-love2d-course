-- Assignment 19: Mini Project — Dodge!
-- Enemies swarm in from all sides. Move to survive!
-- Fill in the TODOs to complete the game.

SCREEN_W = 800
SCREEN_H = 600

gameState = "title"

player = { x = 400, y = 300, size = 20, speed = 280 }

enemies = {}
spawnTimer    = 0
spawnInterval = 1.0

survivalTime = 0
bestTime     = 0

function love.load()
    math.randomseed(os.time())
end

function spawnEnemy()
    -- TODO 1: Spawn an enemy at a random edge of the screen.
    -- Pick a random side (1=top, 2=bottom, 3=left, 4=right)
    -- Set the enemy's starting x, y based on the side.
    -- Give it a speed of math.random(80, 180).
    --
    -- local side = math.random(1, 4)
    -- local ex, ey
    -- if side == 1 then ex = math.random(SCREEN_W) ey = -15
    -- elseif side == 2 then ex = math.random(SCREEN_W) ey = SCREEN_H + 15
    -- elseif side == 3 then ex = -15 ey = math.random(SCREEN_H)
    -- else ex = SCREEN_W + 15 ey = math.random(SCREEN_H) end
    -- table.insert(enemies, {x=ex, y=ey, size=12, speed=math.random(80, 180)})

    -- Placeholder — does nothing until TODO 1 is filled in:
end

function love.update(dt)
    if gameState ~= "playing" then return end

    -- Move player
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then player.y = player.y + player.speed * dt end

    -- Clamp player to screen
    player.x = math.max(player.size, math.min(SCREEN_W - player.size, player.x))
    player.y = math.max(player.size, math.min(SCREEN_H - player.size, player.y))

    survivalTime = survivalTime + dt

    -- Spawn enemies (rate increases over time)
    spawnTimer    = spawnTimer + dt
    spawnInterval = math.max(0.25, 1.0 - survivalTime * 0.03)
    if spawnTimer >= spawnInterval then
        spawnEnemy()
        spawnTimer = 0
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local e = enemies[i]

        -- TODO 2: Move the enemy toward the player.
        -- Calculate the direction vector from enemy to player:
        -- dx = player.x - e.x,  dy = player.y - e.y
        -- Normalize it (divide by its length), then multiply by e.speed * dt.
        --
        -- local dx = player.x - e.x
        -- local dy = player.y - e.y
        -- local len = math.sqrt(dx*dx + dy*dy)
        -- if len > 0 then
        --     e.x = e.x + (dx/len) * e.speed * dt
        --     e.y = e.y + (dy/len) * e.speed * dt
        -- end

        -- TODO 3: Check if this enemy touches the player.
        -- Distance between centres < player.size + e.size means collision.
        --
        -- local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
        -- if dist < player.size + e.size then
        --     bestTime = math.max(bestTime, survivalTime)
        --     gameState = "gameover"
        -- end
    end
end

function love.draw()
    love.graphics.setColor(0.08, 0.08, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    if gameState == "title" then
        love.graphics.setColor(0.3, 1, 0.5)
        love.graphics.print("D O D G E !", 310, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Move with Arrow Keys or WASD.", 265, 270)
        love.graphics.print("Survive as long as you can!", 270, 300)
        love.graphics.print("Press ENTER to start.", 300, 370)

    elseif gameState == "playing" then
        -- Draw enemies
        love.graphics.setColor(1, 0.25, 0.25)
        for i = 1, #enemies do
            love.graphics.circle("fill", enemies[i].x, enemies[i].y, enemies[i].size)
        end

        -- Draw player
        love.graphics.setColor(0.3, 1, 0.5)
        love.graphics.circle("fill", player.x, player.y, player.size)
        -- Player "eye"
        love.graphics.setColor(0.1, 0.4, 0.2)
        love.graphics.circle("fill", player.x + 5, player.y - 5, 5)

        -- HUD
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("Time: %.1fs", survivalTime), 10, 10)
        love.graphics.print(string.format("Best: %.1fs", bestTime),     10, 30)

    elseif gameState == "gameover" then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("YOU WERE CAUGHT!", 295, 220)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(string.format("Survived: %.1f seconds", survivalTime), 275, 280)
        love.graphics.print(string.format("Best:      %.1f seconds", bestTime),    275, 305)
        love.graphics.print("Press R to try again.", 300, 370)
    end
end

function love.keypressed(key)
    if gameState == "title" and key == "return" then
        enemies      = {}
        survivalTime = 0
        spawnTimer   = 0
        player.x     = 400
        player.y     = 300
        gameState    = "playing"
    elseif gameState == "gameover" and key == "r" then
        enemies      = {}
        survivalTime = 0
        spawnTimer   = 0
        player.x     = 400
        player.y     = 300
        gameState    = "playing"
    end
end
