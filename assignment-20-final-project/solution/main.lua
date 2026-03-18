-- Assignment 20: Final Project — SOLUTION (Mini Space Shooter)
-- This is a complete example game to show what's possible with everything
-- you've learned in this course. Use it as inspiration!
--
-- HOW TO PLAY:
--   Left / Right  — move the ship
--   Space         — shoot
--   Survive, shoot enemies, don't let them reach the bottom!

-- ============================================================
-- SETTINGS
-- ============================================================
SCREEN_W = 800
SCREEN_H = 600

-- ============================================================
-- GAME STATE
-- ============================================================
gameState = "title"

-- ============================================================
-- PLAYER
-- ============================================================
player = {
    x        = SCREEN_W / 2 - 20,
    y        = SCREEN_H - 70,
    w        = 40,
    h        = 30,
    speed    = 320,
    lives    = 3,
    score    = 0,
    highScore = 0,
    shootCooldown = 0,   -- prevents shooting too fast
    invincible    = 0,   -- brief invincibility after being hit
}

-- ============================================================
-- BULLETS (player shots)
-- ============================================================
bullets = {}
BULLET_SPEED = 500

-- ============================================================
-- ENEMIES
-- ============================================================
enemies      = {}
spawnTimer   = 0
spawnInterval = 1.2
gameTimer    = 0   -- tracks how long the current game has lasted

-- ============================================================
-- STARS (background decoration)
-- ============================================================
stars = {}

-- ============================================================
-- EXPLOSIONS (brief visual effect when something is destroyed)
-- ============================================================
explosions = {}

-- ============================================================
-- love.load
-- ============================================================
function love.load()
    math.randomseed(os.time())
    -- Build a static starfield for the background
    for i = 1, 80 do
        table.insert(stars, {
            x          = math.random(0, SCREEN_W),
            y          = math.random(0, SCREEN_H),
            radius     = math.random(1, 2),
            brightness = math.random() * 0.5 + 0.4,
            speed      = math.random(20, 60)   -- slow parallax scroll
        })
    end
end

-- ============================================================
-- resetGame — called when starting or restarting a run
-- ============================================================
function resetGame()
    bullets       = {}
    enemies       = {}
    explosions    = {}
    spawnTimer    = 0
    spawnInterval = 1.2
    gameTimer     = 0

    player.x             = SCREEN_W / 2 - 20
    player.y             = SCREEN_H - 70
    player.lives         = 3
    player.score         = 0
    player.shootCooldown = 0
    player.invincible    = 0

    gameState = "playing"
end

-- ============================================================
-- spawnEnemy — creates one enemy at a random x at the top
-- ============================================================
function spawnEnemy()
    local speed = math.random(80, 160) + gameTimer * 2   -- gets faster over time
    speed       = math.min(speed, 280)                   -- cap it
    table.insert(enemies, {
        x      = math.random(10, SCREEN_W - 50),
        y      = -40,
        w      = 36,
        h      = 28,
        speed  = speed,
        -- Each enemy gets a slightly different tint
        hue    = math.random()
    })
end

-- ============================================================
-- spawnExplosion — a quick particle burst at (cx, cy)
-- ============================================================
function spawnExplosion(cx, cy, r, g, b)
    for i = 1, 8 do
        local angle = (i / 8) * math.pi * 2 + math.random() * 0.5
        local spd   = math.random(60, 160)
        table.insert(explosions, {
            x    = cx, y = cy,
            vx   = math.cos(angle) * spd,
            vy   = math.sin(angle) * spd,
            life = 0.4 + math.random() * 0.3,
            maxLife = 0.7,
            r = r, g = g, b = b,
            radius = math.random(2, 5)
        })
    end
end

-- ============================================================
-- checkCollision — rectangle vs rectangle
-- ============================================================
function checkCollision(a, b)
    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end

-- ============================================================
-- love.update
-- ============================================================
function love.update(dt)
    -- Scroll stars regardless of game state (nice visual)
    for i = 1, #stars do
        local s = stars[i]
        s.y = s.y + s.speed * dt
        if s.y > SCREEN_H + 4 then
            s.y = -4
            s.x = math.random(0, SCREEN_W)
        end
    end

    if gameState ~= "playing" then return end

    gameTimer = gameTimer + dt

    -- === PLAYER MOVEMENT ===
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end
    player.x = math.max(0, math.min(SCREEN_W - player.w, player.x))

    -- === SHOOTING ===
    player.shootCooldown = math.max(0, player.shootCooldown - dt)
    if love.keyboard.isDown("space") and player.shootCooldown <= 0 then
        -- Spawn two bullets side by side for a spread effect
        table.insert(bullets, { x = player.x + 8,                y = player.y, w = 4, h = 14 })
        table.insert(bullets, { x = player.x + player.w - 12,    y = player.y, w = 4, h = 14 })
        player.shootCooldown = 0.18
    end

    -- === INVINCIBILITY TIMER ===
    player.invincible = math.max(0, player.invincible - dt)

    -- === UPDATE BULLETS ===
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.y = b.y - BULLET_SPEED * dt
        if b.y + b.h < 0 then
            table.remove(bullets, i)
        end
    end

    -- === SPAWN ENEMIES ===
    spawnTimer    = spawnTimer + dt
    spawnInterval = math.max(0.35, 1.2 - gameTimer * 0.04)
    if spawnTimer >= spawnInterval then
        spawnEnemy()
        spawnTimer = 0
    end

    -- === UPDATE ENEMIES ===
    for i = #enemies, 1, -1 do
        local e = enemies[i]
        e.y = e.y + e.speed * dt

        -- Enemy reached the bottom — lose a life
        if e.y > SCREEN_H + 10 then
            table.remove(enemies, i)
            player.lives = player.lives - 1
            if player.lives <= 0 then
                player.highScore = math.max(player.score, player.highScore)
                gameState        = "gameover"
            end

        -- Check bullet vs enemy collisions
        else
            local hit = false
            for j = #bullets, 1, -1 do
                local b = bullets[j]
                if checkCollision(b, e) then
                    spawnExplosion(e.x + e.w/2, e.y + e.h/2, 1, 0.6, 0.2)
                    table.remove(bullets, j)
                    hit = true
                    player.score = player.score + 5
                    break
                end
            end
            if hit then
                table.remove(enemies, i)

            -- Check enemy vs player collision
            elseif player.invincible <= 0 and checkCollision(e, player) then
                spawnExplosion(player.x + player.w/2, player.y + player.h/2, 0.4, 0.7, 1)
                table.remove(enemies, i)
                player.lives     = player.lives - 1
                player.invincible = 1.5  -- 1.5 seconds of invincibility

                if player.lives <= 0 then
                    player.highScore = math.max(player.score, player.highScore)
                    gameState        = "gameover"
                end
            end
        end
    end

    -- Score ticks up over time too (survival bonus)
    if math.floor(gameTimer) > math.floor(gameTimer - dt) then
        player.score = player.score + 1
    end

    -- === UPDATE EXPLOSIONS ===
    for i = #explosions, 1, -1 do
        local p = explosions[i]
        p.x    = p.x + p.vx * dt
        p.y    = p.y + p.vy * dt
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(explosions, i)
        end
    end
end

-- ============================================================
-- love.draw
-- ============================================================
function love.draw()
    -- Deep space background
    love.graphics.setColor(0.02, 0.02, 0.08)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Scrolling stars
    for i = 1, #stars do
        local s = stars[i]
        love.graphics.setColor(s.brightness, s.brightness, s.brightness)
        love.graphics.circle("fill", s.x, s.y, s.radius)
    end

    -- -------------------------------------------------------
    if gameState == "title" then
        love.graphics.setColor(0.3, 0.8, 1)
        love.graphics.print("STAR SHOOTER", 290, 160)
        love.graphics.setColor(0.8, 0.8, 1)
        love.graphics.print("Arrow Keys / WASD  to move", 270, 240)
        love.graphics.print("SPACE              to shoot", 270, 265)
        love.graphics.print("Don't let enemies past your ship!", 230, 295)
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print("Press ENTER to start!", 295, 370)
        if player.highScore > 0 then
            love.graphics.setColor(0.7, 1, 0.7)
            love.graphics.print("High Score: " .. player.highScore, 330, 420)
        end

    -- -------------------------------------------------------
    elseif gameState == "playing" then
        -- Draw explosions (behind everything else)
        for i = 1, #explosions do
            local p     = explosions[i]
            local alpha = p.life / p.maxLife
            love.graphics.setColor(p.r, p.g, p.b, alpha)
            love.graphics.circle("fill", p.x, p.y, p.radius * alpha + 1)
        end

        -- Draw bullets
        love.graphics.setColor(1, 1, 0.4)
        for i = 1, #bullets do
            local b = bullets[i]
            love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
        end

        -- Draw enemies
        for i = 1, #enemies do
            local e = enemies[i]
            -- Alien saucer shape using two rectangles + a circle
            love.graphics.setColor(0.9 - e.hue * 0.3, 0.2, 0.2 + e.hue * 0.4)
            love.graphics.ellipse("fill", e.x + e.w/2, e.y + e.h * 0.7, e.w/2, e.h * 0.3)
            love.graphics.ellipse("fill", e.x + e.w/2, e.y + e.h * 0.5, e.w * 0.4, e.h * 0.5)
        end

        -- Draw player ship (flicker when invincible)
        local drawPlayer = player.invincible <= 0 or
                           (math.floor(player.invincible * 10) % 2 == 0)
        if drawPlayer then
            -- Body
            love.graphics.setColor(0.3, 0.75, 1)
            love.graphics.polygon("fill",
                player.x + player.w / 2, player.y,
                player.x + player.w,     player.y + player.h,
                player.x,                player.y + player.h)
            -- Engine glow
            love.graphics.setColor(1, 0.5, 0.1)
            love.graphics.rectangle("fill",
                player.x + player.w * 0.3,
                player.y + player.h,
                player.w * 0.4, 8)
            -- Cockpit
            love.graphics.setColor(0.8, 1, 1)
            love.graphics.circle("fill", player.x + player.w / 2, player.y + player.h * 0.55, 7)
        end

        -- HUD
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. player.score,     10, 10)
        love.graphics.print("Best:  " .. player.highScore, 10, 30)
        love.graphics.setColor(1, 0.35, 0.35)
        love.graphics.print(string.rep("<3 ", player.lives), SCREEN_W - 90, 10)

    -- -------------------------------------------------------
    elseif gameState == "gameover" then
        -- Dim overlay
        love.graphics.setColor(0, 0, 0, 0.65)
        love.graphics.rectangle("fill", 200, 180, 400, 240)

        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER", 330, 210)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score:      " .. player.score,     290, 270)
        love.graphics.print("High Score: " .. player.highScore, 290, 295)
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print("Press R to play again", 300, 360)
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.print("Press ENTER for title screen", 275, 385)
    end
end

-- ============================================================
-- love.keypressed
-- ============================================================
function love.keypressed(key)
    if gameState == "title" and key == "return" then
        resetGame()

    elseif gameState == "gameover" then
        if key == "r" then
            resetGame()
        elseif key == "return" then
            gameState = "title"
        end

    elseif key == "escape" then
        love.event.quit()
    end
end
