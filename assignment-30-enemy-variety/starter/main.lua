-- Assignment 30: Enemy Variety — STARTER
-- Three enemy types in one table; your job is to fill in their movement logic.
-- Run with: love .  (from inside the starter/ folder)

SCREEN_W = 800
SCREEN_H = 600

-- ── Player ────────────────────────────────────────────────────────────────────
player = {
    x = SCREEN_W / 2,
    y = SCREEN_H / 2,
    r = 16,
    speed = 220,
    lives = 3,
    invincible = 0,    -- countdown timer; > 0 means the player is invincible
}

-- ── Enemies ───────────────────────────────────────────────────────────────────
enemies = {}

-- Each enemy type gets its own spawn timer and interval constant.
chaserTimer    = 0
bouncerTimer   = 0
patrollerTimer = 0

CHASER_INTERVAL    = 4
BOUNCER_INTERVAL   = 3
PATROLLER_INTERVAL = 6

-- ── Hit flash ─────────────────────────────────────────────────────────────────
-- A red border flashes around the screen for a moment when the player is hit.
hitFlash = 0
HIT_FLASH_DURATION = 0.3

-- ── Score ─────────────────────────────────────────────────────────────────────
score = 0   -- total seconds survived

-- ── Helper: collision tests ───────────────────────────────────────────────────

-- Circle vs. circle — returns true when they overlap
function circlesOverlap(ax, ay, ar, bx, by, br)
    local dx = ax - bx
    local dy = ay - by
    return (dx * dx + dy * dy) < (ar + br) ^ 2
end

-- Circle vs. axis-aligned rectangle — returns true when they overlap
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
    -- Random starting direction and speed; spawns somewhere inside the screen
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
    love.window.setTitle("Assignment 30 – Enemy Variety")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())
    resetGame()
end

-- ── love.update ───────────────────────────────────────────────────────────────
function love.update(dt)
    -- Stop updating gameplay when the player is dead
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
    -- Keep the player inside the screen
    player.x = math.max(player.r, math.min(SCREEN_W - player.r, player.x))
    player.y = math.max(player.r, math.min(SCREEN_H - player.r, player.y))

    -- Tick the invincibility and hit-flash timers
    if player.invincible > 0 then player.invincible = player.invincible - dt end
    if hitFlash > 0          then hitFlash          = hitFlash - dt          end

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
            -- TODO 1: Make the chaser move toward the player every frame.
            --
            -- The idea: compute a direction vector from the enemy to the player,
            -- shrink it to length 1 (divide by its length), then move by speed * dt.
            --
            --   Step 1 — direction vector:
            --     local dx = player.x - e.x
            --     local dy = player.y - e.y
            --
            --   Step 2 — straight-line distance:
            --     local dist = math.sqrt(dx * dx + dy * dy)
            --
            --   Step 3 — move (guard against dist == 0 to avoid divide-by-zero):
            --     if dist > 0 then
            --         e.x = e.x + (dx / dist) * e.speed * dt
            --         e.y = e.y + (dy / dist) * e.speed * dt
            --     end
            --
            -- Uncomment the block below when you are ready:
            --[[
            local dx   = player.x - e.x
            local dy   = player.y - e.y
            local dist = math.sqrt(dx * dx + dy * dy)
            if dist > 0 then
                e.x = e.x + (dx / dist) * e.speed * dt
                e.y = e.y + (dy / dist) * e.speed * dt
            end
            --]]

        elseif e.type == "bouncer" then
            -- TODO 2: Move the bouncer by its velocity and bounce off all four walls.
            --
            --   Step 1 — move by stored velocity:
            --     e.x = e.x + e.vx * dt
            --     e.y = e.y + e.vy * dt
            --
            --   Step 2 — check each wall; if the edge crosses it, snap back inside
            --             and flip the relevant velocity so it bounces:
            --     Left:   if e.x - e.r < 0        then e.x = e.r;            e.vx =  math.abs(e.vx) end
            --     Right:  if e.x + e.r > SCREEN_W  then e.x = SCREEN_W - e.r; e.vx = -math.abs(e.vx) end
            --     Top:    if e.y - e.r < 0        then e.y = e.r;            e.vy =  math.abs(e.vy) end
            --     Bottom: if e.y + e.r > SCREEN_H  then e.y = SCREEN_H - e.r; e.vy = -math.abs(e.vy) end
            --
            -- Uncomment the block below when you are ready:
            --[[
            e.x = e.x + e.vx * dt
            e.y = e.y + e.vy * dt
            if e.x - e.r < 0        then e.x = e.r;             e.vx =  math.abs(e.vx) end
            if e.x + e.r > SCREEN_W then e.x = SCREEN_W - e.r;  e.vx = -math.abs(e.vx) end
            if e.y - e.r < 0        then e.y = e.r;             e.vy =  math.abs(e.vy) end
            if e.y + e.r > SCREEN_H then e.y = SCREEN_H - e.r;  e.vy = -math.abs(e.vy) end
            --]]

        elseif e.type == "patroller" then
            -- TODO 3: Move the patroller back and forth between e.x1 and e.x2.
            --
            -- e.dir is 1 (going right) or -1 (going left).
            -- Multiply by e.dir to make it move in the right direction automatically.
            --
            --   Step 1 — move horizontally:
            --     e.x = e.x + e.dir * e.speed * dt
            --
            --   Step 2 — reached the right end? snap and reverse:
            --     if e.x >= e.x2 then e.x = e.x2; e.dir = -1 end
            --
            --   Step 3 — reached the left end? snap and reverse:
            --     if e.x <= e.x1 then e.x = e.x1; e.dir =  1 end
            --
            -- Uncomment the block below when you are ready:
            --[[
            e.x = e.x + e.dir * e.speed * dt
            if e.x >= e.x2 then e.x = e.x2; e.dir = -1 end
            if e.x <= e.x1 then e.x = e.x1; e.dir =  1 end
            --]]
        end
    end

    -- ── Collision detection ───────────────────────────────────────────────────
    -- Already written for you. Chasers and bouncers are circles; patrollers are
    -- rectangles, so they each use the matching collision helper.
    if player.invincible <= 0 then
        for _, e in ipairs(enemies) do
            local hit = false
            if e.type == "chaser" or e.type == "bouncer" then
                hit = circlesOverlap(player.x, player.y, player.r, e.x, e.y, e.r)
            elseif e.type == "patroller" then
                hit = circleRectOverlap(player.x, player.y, player.r,
                                        e.x - e.w / 2, e.y - e.h / 2, e.w, e.h)
            end
            if hit then
                player.lives      = player.lives - 1
                player.invincible = 1.5
                hitFlash          = HIT_FLASH_DURATION
                break   -- only one hit per frame
            end
        end
    end
end

-- ── love.keypressed ───────────────────────────────────────────────────────────
function love.keypressed(key)
    if key == "r"      then resetGame()        end
    if key == "escape" then love.event.quit()  end
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

        -- Small type label above each enemy (helps you tell them apart while testing)
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
        -- Toggle visibility ~8 times per second to create a flashing effect
        showPlayer = (math.floor(player.invincible * 8) % 2 == 0)
    end
    if showPlayer then
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", player.x, player.y, player.r)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.circle("line", player.x, player.y, player.r)
    end

    -- Red screen-edge flash when the player is hit
    if hitFlash > 0 then
        local alpha = (hitFlash / HIT_FLASH_DURATION) * 0.8
        love.graphics.setColor(1, 0, 0, alpha)
        local t = 12
        love.graphics.rectangle("fill", 0,              0,              SCREEN_W, t)
        love.graphics.rectangle("fill", 0,              SCREEN_H - t,   SCREEN_W, t)
        love.graphics.rectangle("fill", 0,              0,              t,        SCREEN_H)
        love.graphics.rectangle("fill", SCREEN_W - t,   0,              t,        SCREEN_H)
    end

    -- ── HUD ───────────────────────────────────────────────────────────────────
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. math.floor(score) .. "s", 10, 10)
    love.graphics.print("Lives: " .. player.lives,             10, 30)

    -- Life dots in the top-right corner
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
