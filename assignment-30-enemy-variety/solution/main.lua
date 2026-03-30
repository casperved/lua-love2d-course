-- Assignment 30: Enemy Variety — SOLUTION
-- Three enemy types in one table, each with its own movement behaviour.
-- Visual extras:
--   1. Small type labels drawn above every enemy in matching colour
--   2. Brief red screen-edge flash when the player takes a hit

SCREEN_W = 800
SCREEN_H = 600

-- ── Player ────────────────────────────────────────────────────────────────────
player = {
    x = SCREEN_W / 2,
    y = SCREEN_H / 2,
    r = 16,
    speed = 220,
    lives = 3,
    invincible = 0,    -- counts down; > 0 = invincible + flashing
}

-- ── Enemies ───────────────────────────────────────────────────────────────────
enemies = {}

-- Spawn timers
chaserTimer    = 0
bouncerTimer   = 0
patrollerTimer = 0

CHASER_INTERVAL    = 4
BOUNCER_INTERVAL   = 3
PATROLLER_INTERVAL = 6

-- ── Hit flash ─────────────────────────────────────────────────────────────────
-- A red border around the screen for a short time after the player is hit.
hitFlash = 0          -- countdown timer
HIT_FLASH_DURATION = 0.3

-- ── Score ─────────────────────────────────────────────────────────────────────
score = 0

-- ── Helper: collision tests ───────────────────────────────────────────────────
-- Circle vs. circle: true if overlapping
function circlesOverlap(ax, ay, ar, bx, by, br)
    local dx = ax - bx
    local dy = ay - by
    return (dx * dx + dy * dy) < (ar + br) ^ 2
end

-- Circle vs. axis-aligned rectangle: true if overlapping
-- rx, ry is the top-left corner of the rectangle
function circleRectOverlap(cx, cy, cr, rx, ry, rw, rh)
    local nearX = math.max(rx, math.min(cx, rx + rw))
    local nearY = math.max(ry, math.min(cy, ry + rh))
    local dx = cx - nearX
    local dy = cy - nearY
    return (dx * dx + dy * dy) < cr * cr
end

-- ── Spawn helpers ─────────────────────────────────────────────────────────────
function spawnChaser()
    -- Arrive from a random edge so it always enters from off-screen
    local side = math.random(4)
    local x, y
    if side == 1 then x = math.random(SCREEN_W); y = -20
    elseif side == 2 then x = SCREEN_W + 20;     y = math.random(SCREEN_H)
    elseif side == 3 then x = math.random(SCREEN_W); y = SCREEN_H + 20
    else                   x = -20;               y = math.random(SCREEN_H) end
    table.insert(enemies, {
        type   = "chaser",
        x      = x, y = y,
        r      = 14,
        speed  = 150,
        colour = {1, 0.2, 0.2},
        label  = "CHASER",
    })
end

function spawnBouncer()
    -- Random direction and speed; spawn somewhere inside the screen
    local angle = math.random() * math.pi * 2
    local spd   = math.random(100, 180)
    table.insert(enemies, {
        type   = "bouncer",
        x      = math.random(50, SCREEN_W - 50),
        y      = math.random(50, SCREEN_H - 50),
        r      = 12,
        vx     = math.cos(angle) * spd,
        vy     = math.sin(angle) * spd,
        colour = {0.2, 0.4, 1},
        label  = "BOUNCER",
    })
end

function spawnPatroller()
    -- Random horizontal patrol lane
    local x1 = math.random(40, 300)
    local x2 = math.random(500, SCREEN_W - 40)
    local yp  = math.random(60, SCREEN_H - 60)
    table.insert(enemies, {
        type   = "patroller",
        x      = x1,
        y      = yp,
        w      = 20, h = 20,
        x1     = x1, x2 = x2,
        speed  = 120,
        dir    = 1,          -- 1 = moving right, -1 = moving left
        colour = {1, 0.9, 0.1},
        label  = "PATROL",
    })
end

-- ── Reset ─────────────────────────────────────────────────────────────────────
function resetGame()
    player.x          = SCREEN_W / 2
    player.y          = SCREEN_H / 2
    player.lives      = 3
    player.invincible = 0
    enemies        = {}
    chaserTimer    = 0
    bouncerTimer   = 0
    patrollerTimer = 0
    score          = 0
    hitFlash       = 0
end

-- ── love.load ─────────────────────────────────────────────────────────────────
function love.load()
    love.window.setTitle("Assignment 30 – Enemy Variety (Solution)")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())
    resetGame()
end

-- ── love.update ───────────────────────────────────────────────────────────────
function love.update(dt)
    -- Don't update gameplay when dead
    if player.lives <= 0 then return end

    score = score + dt

    -- ── Player input & movement ───────────────────────────────────────────────
    local px, py = 0, 0
    if love.keyboard.isDown("w") or love.keyboard.isDown("up")    then py = py - 1 end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down")  then py = py + 1 end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then px = px - 1 end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then px = px + 1 end

    local plen = math.sqrt(px * px + py * py)
    if plen > 0 then
        player.x = player.x + (px / plen) * player.speed * dt
        player.y = player.y + (py / plen) * player.speed * dt
    end
    -- Clamp player inside the screen
    player.x = math.max(player.r, math.min(SCREEN_W - player.r, player.x))
    player.y = math.max(player.r, math.min(SCREEN_H - player.r, player.y))

    -- Tick invincibility timer
    if player.invincible > 0 then
        player.invincible = player.invincible - dt
    end

    -- Tick hit-flash timer
    if hitFlash > 0 then
        hitFlash = hitFlash - dt
    end

    -- ── Spawn timers ──────────────────────────────────────────────────────────
    chaserTimer = chaserTimer + dt
    if chaserTimer >= CHASER_INTERVAL then
        chaserTimer = chaserTimer - CHASER_INTERVAL
        spawnChaser()
    end

    bouncerTimer = bouncerTimer + dt
    if bouncerTimer >= BOUNCER_INTERVAL then
        bouncerTimer = bouncerTimer - BOUNCER_INTERVAL
        spawnBouncer()
    end

    patrollerTimer = patrollerTimer + dt
    if patrollerTimer >= PATROLLER_INTERVAL then
        patrollerTimer = patrollerTimer - PATROLLER_INTERVAL
        spawnPatroller()
    end

    -- ── Enemy movement ────────────────────────────────────────────────────────
    for _, e in ipairs(enemies) do

        if e.type == "chaser" then
            -- ── Chaser: normalize direction toward player, move at constant speed ──
            -- 1. Vector from enemy to player
            local dx = player.x - e.x
            local dy = player.y - e.y
            -- 2. Length of that vector
            local dist = math.sqrt(dx * dx + dy * dy)
            -- 3. Divide by length to get a unit vector, scale by speed * dt
            if dist > 0 then
                e.x = e.x + (dx / dist) * e.speed * dt
                e.y = e.y + (dy / dist) * e.speed * dt
            end

        elseif e.type == "bouncer" then
            -- ── Bouncer: constant velocity + wall bouncing ───────────────────────
            -- Move by stored velocity
            e.x = e.x + e.vx * dt
            e.y = e.y + e.vy * dt
            -- Bounce off each wall; snap back + flip the relevant velocity component
            if e.x - e.r < 0        then e.x = e.r;             e.vx =  math.abs(e.vx) end
            if e.x + e.r > SCREEN_W then e.x = SCREEN_W - e.r;  e.vx = -math.abs(e.vx) end
            if e.y - e.r < 0        then e.y = e.r;             e.vy =  math.abs(e.vy) end
            if e.y + e.r > SCREEN_H then e.y = SCREEN_H - e.r;  e.vy = -math.abs(e.vy) end

        elseif e.type == "patroller" then
            -- ── Patroller: horizontal back-and-forth between x1 and x2 ──────────
            -- e.dir is 1 (right) or -1 (left)
            e.x = e.x + e.dir * e.speed * dt
            -- Reached right boundary → snap and reverse
            if e.x >= e.x2 then e.x = e.x2; e.dir = -1 end
            -- Reached left boundary → snap and reverse
            if e.x <= e.x1 then e.x = e.x1; e.dir =  1 end
        end
    end

    -- ── Collision detection ───────────────────────────────────────────────────
    if player.invincible <= 0 then
        for _, e in ipairs(enemies) do
            local hit = false
            if e.type == "chaser" or e.type == "bouncer" then
                -- Circle vs. circle
                hit = circlesOverlap(player.x, player.y, player.r, e.x, e.y, e.r)
            elseif e.type == "patroller" then
                -- Circle (player) vs. AABB (patroller); top-left corner = x-w/2, y-h/2
                hit = circleRectOverlap(player.x, player.y, player.r,
                                        e.x - e.w / 2, e.y - e.h / 2, e.w, e.h)
            end
            if hit then
                player.lives      = player.lives - 1
                player.invincible = 1.5
                hitFlash          = HIT_FLASH_DURATION
                break  -- only one hit per frame
            end
        end
    end
end

-- ── love.keypressed ───────────────────────────────────────────────────────────
function love.keypressed(key)
    if key == "r" then
        resetGame()
    end
    if key == "escape" then
        love.event.quit()
    end
end

-- ── love.draw ─────────────────────────────────────────────────────────────────
function love.draw()
    love.graphics.setBackgroundColor(0.08, 0.08, 0.12)

    -- ── Enemies ───────────────────────────────────────────────────────────────
    for _, e in ipairs(enemies) do
        -- Body
        love.graphics.setColor(e.colour)
        if e.type == "patroller" then
            love.graphics.rectangle("fill", e.x - e.w / 2, e.y - e.h / 2, e.w, e.h)
        else
            love.graphics.circle("fill", e.x, e.y, e.r)
        end

        -- Visual extra 1: small label above the enemy in matching colour
        love.graphics.setColor(e.colour[1], e.colour[2], e.colour[3], 0.85)
        local labelY
        if e.type == "patroller" then
            labelY = e.y - e.h / 2 - 14
        else
            labelY = e.y - e.r - 14
        end
        love.graphics.printf(e.label, e.x - 40, labelY, 80, "center")
    end

    -- ── Player (flash during invincibility) ───────────────────────────────────
    local showPlayer = true
    if player.invincible > 0 then
        -- Flash at ~8 Hz by toggling visibility based on time
        showPlayer = (math.floor(player.invincible * 8) % 2 == 0)
    end
    if showPlayer then
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", player.x, player.y, player.r)
        -- Thin white ring outline to make the player pop against light enemies
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.circle("line", player.x, player.y, player.r)
    end

    -- Visual extra 2: red screen-edge flash on hit
    if hitFlash > 0 then
        local alpha = (hitFlash / HIT_FLASH_DURATION) * 0.8
        love.graphics.setColor(1, 0, 0, alpha)
        local thickness = 12
        -- Top
        love.graphics.rectangle("fill", 0, 0, SCREEN_W, thickness)
        -- Bottom
        love.graphics.rectangle("fill", 0, SCREEN_H - thickness, SCREEN_W, thickness)
        -- Left
        love.graphics.rectangle("fill", 0, 0, thickness, SCREEN_H)
        -- Right
        love.graphics.rectangle("fill", SCREEN_W - thickness, 0, thickness, SCREEN_H)
    end

    -- ── HUD ───────────────────────────────────────────────────────────────────
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. math.floor(score) .. "s", 10, 10)
    love.graphics.print("Lives: " .. player.lives,            10, 30)

    -- Life hearts / dots
    for i = 1, 3 do
        if i <= player.lives then
            love.graphics.setColor(1, 0.3, 0.3)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
        end
        love.graphics.circle("fill", SCREEN_W - 30 - (3 - i) * 22, 20, 8)
    end

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.print("WASD / Arrows to move   R to restart   Esc to quit",
                         10, SCREEN_H - 22)

    -- ── Game-over overlay ─────────────────────────────────────────────────────
    if player.lives <= 0 then
        love.graphics.setColor(0, 0, 0, 0.65)
        love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

        love.graphics.setColor(1, 0.25, 0.25)
        love.graphics.printf("GAME OVER", 0, SCREEN_H / 2 - 36, SCREEN_W, "center")

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("You survived " .. math.floor(score) .. " seconds",
                              0, SCREEN_H / 2 + 4, SCREEN_W, "center")
        love.graphics.printf("Press R to play again",
                              0, SCREEN_H / 2 + 30, SCREEN_W, "center")
    end

    love.graphics.setColor(1, 1, 1)
end
