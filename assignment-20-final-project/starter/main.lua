-- Assignment 20: Final Project — Mini Space Shooter (STARTER)
-- Five TODOs are left for you to fill in.
-- Everything else is already working — run the game to see what you have so far!
--
-- HOW TO PLAY (once the TODOs are done):
--   Left / Right arrows (or A / D)  — move the ship
--   Space                           — shoot
--   Survive, shoot enemies, don't let them reach the bottom!

-- ============================================================
-- SETTINGS
-- ============================================================
SCREEN_W = 800
SCREEN_H = 600

-- ============================================================
-- GAME STATE
-- ============================================================
gameState = "title"   -- "title"  →  "playing"  →  "gameover"

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
    shootCooldown = 0,   -- counts down to 0; you can only shoot when it hits 0
    invincible    = 0,   -- counts down to 0 after being hit (ship flickers)
}

-- ============================================================
-- BULLETS (player shots)
-- ============================================================
bullets      = {}
BULLET_SPEED = 500

-- ============================================================
-- ENEMIES
-- ============================================================
enemies       = {}
spawnTimer    = 0
spawnInterval = 1.2
gameTimer     = 0   -- how many seconds the current run has lasted

-- ============================================================
-- STARS (scrolling background decoration)
-- ============================================================
stars = {}

-- ============================================================
-- EXPLOSIONS (tiny particles that appear when something is destroyed)
-- ============================================================
explosions = {}

-- ============================================================
-- love.load — runs once at startup
-- ============================================================
function love.load()
    math.randomseed(os.time())

    -- Build a starfield: 80 dots at random positions, sizes, and scroll speeds
    for i = 1, 80 do
        table.insert(stars, {
            x          = math.random(0, SCREEN_W),
            y          = math.random(0, SCREEN_H),
            radius     = math.random(1, 2),
            brightness = math.random() * 0.5 + 0.4,
            speed      = math.random(20, 60)   -- slower = feels farther away
        })
    end
end

-- ============================================================
-- resetGame — clears tables and resets the player for a fresh run
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
-- spawnEnemy — adds one alien saucer at a random x at the top
-- ============================================================
function spawnEnemy()
    local speed = math.random(80, 160) + gameTimer * 2   -- gets faster over time
    speed       = math.min(speed, 280)                   -- but never faster than this
    table.insert(enemies, {
        x      = math.random(10, SCREEN_W - 50),
        y      = -40,
        w      = 36,
        h      = 28,
        speed  = speed,
        hue    = math.random()   -- gives each enemy a slightly different tint
    })
end

-- ============================================================
-- spawnExplosion — creates 8 tiny particles that fly outward from (cx, cy)
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
-- checkCollision — rectangle vs rectangle overlap test
-- ============================================================
-- TODO 5: The placeholder below always returns false, so bullets and enemies
-- pass through each other. Replace the body with the real AABB formula.
-- Hint: two rectangles overlap when NONE of these is true:
--   a is fully to the right of b   (a.x >= b.x + b.w)
--   a is fully to the left of b    (a.x + a.w <= b.x)
--   a is fully below b             (a.y >= b.y + b.h)
--   a is fully above b             (a.y + a.h <= b.y)
-- Flip all four conditions (use < / >) and AND them together.
--
-- return a.x < b.x + b.w and
--        a.x + a.w > b.x and
--        a.y < b.y + b.h and
--        a.y + a.h > b.y
function checkCollision(a, b)
    return false   -- replace this line!
end

-- ============================================================
-- love.update — runs every frame
-- ============================================================
function love.update(dt)

    -- === TODO 1: SCROLL THE STARS ===
    -- Loop through every star. Move it downward by its speed * dt.
    -- When a star falls off the bottom (s.y > SCREEN_H + 4),
    -- wrap it back to the top (s.y = -4) and pick a new random s.x.
    --
    -- for i = 1, #stars do
    --     local s = stars[i]
    --     s.y = s.y + s.speed * dt
    --     if s.y > SCREEN_H + 4 then
    --         s.y = -4
    --         s.x = math.random(0, SCREEN_W)
    --     end
    -- end

    if gameState ~= "playing" then return end

    gameTimer = gameTimer + dt

    -- === TODO 2: MOVE THE PLAYER ===
    -- Check if the left or right arrow key (or A / D) is held down.
    -- Move player.x by player.speed * dt in the matching direction.
    -- Then clamp player.x so the ship can't leave the screen edges.
    --
    -- if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    --     player.x = player.x - player.speed * dt
    -- end
    -- if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    --     player.x = player.x + player.speed * dt
    -- end
    -- player.x = math.max(0, math.min(SCREEN_W - player.w, player.x))

    -- === TODO 3: SHOOT BULLETS ===
    -- Count the cooldown down toward 0 each frame:
    player.shootCooldown = math.max(0, player.shootCooldown - dt)
    -- Now: if Space is held AND the cooldown has reached 0, spawn two bullets.
    -- Place one at (player.x + 8, player.y) with w=4, h=14
    -- and one at  (player.x + player.w - 12, player.y) with w=4, h=14
    -- Then set player.shootCooldown = 0.18
    --
    -- if love.keyboard.isDown("space") and player.shootCooldown <= 0 then
    --     table.insert(bullets, { x = player.x + 8,             y = player.y, w = 4, h = 14 })
    --     table.insert(bullets, { x = player.x + player.w - 12, y = player.y, w = 4, h = 14 })
    --     player.shootCooldown = 0.18
    -- end

    -- === INVINCIBILITY TIMER (already done for you) ===
    player.invincible = math.max(0, player.invincible - dt)

    -- === TODO 4: MOVE BULLETS UPWARD AND REMOVE OFF-SCREEN ONES ===
    -- Loop through bullets backwards (so removing an item is safe).
    -- Each frame: subtract BULLET_SPEED * dt from b.y  (moving it up).
    -- If b.y + b.h < 0 the bullet is fully off the top — remove it.
    --
    -- for i = #bullets, 1, -1 do
    --     local b = bullets[i]
    --     b.y = b.y - BULLET_SPEED * dt
    --     if b.y + b.h < 0 then
    --         table.remove(bullets, i)
    --     end
    -- end

    -- === SPAWN ENEMIES (already done for you) ===
    spawnTimer    = spawnTimer + dt
    spawnInterval = math.max(0.35, 1.2 - gameTimer * 0.04)
    if spawnTimer >= spawnInterval then
        spawnEnemy()
        spawnTimer = 0
    end

    -- === UPDATE ENEMIES (already done for you) ===
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

        -- Check bullet vs enemy collision  (needs checkCollision to work!)
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

            -- Check enemy vs player collision  (needs checkCollision to work!)
            elseif player.invincible <= 0 and checkCollision(e, player) then
                spawnExplosion(player.x + player.w/2, player.y + player.h/2, 0.4, 0.7, 1)
                table.remove(enemies, i)
                player.lives     = player.lives - 1
                player.invincible = 1.5

                if player.lives <= 0 then
                    player.highScore = math.max(player.score, player.highScore)
                    gameState        = "gameover"
                end
            end
        end
    end

    -- Score ticks up every second you survive
    if math.floor(gameTimer) > math.floor(gameTimer - dt) then
        player.score = player.score + 1
    end

    -- === UPDATE EXPLOSIONS (already done for you) ===
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
-- love.draw — runs every frame to draw everything
-- ============================================================
function love.draw()
    -- Deep space background
    love.graphics.setColor(0.02, 0.02, 0.08)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Scrolling stars (drawn regardless of game state)
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

        -- Draw enemies (alien saucer shape: two ellipses stacked)
        for i = 1, #enemies do
            local e = enemies[i]
            love.graphics.setColor(0.9 - e.hue * 0.3, 0.2, 0.2 + e.hue * 0.4)
            love.graphics.ellipse("fill", e.x + e.w/2, e.y + e.h * 0.7, e.w/2,     e.h * 0.3)
            love.graphics.ellipse("fill", e.x + e.w/2, e.y + e.h * 0.5, e.w * 0.4, e.h * 0.5)
        end

        -- Draw player ship (flickers when invincible)
        local drawPlayer = player.invincible <= 0 or
                           (math.floor(player.invincible * 10) % 2 == 0)
        if drawPlayer then
            -- Body (triangle shape using polygon)
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
-- love.keypressed — fires once when a key is first pressed
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
