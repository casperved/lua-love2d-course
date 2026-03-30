-- Assignment 31: Waypoint Pathfinding — SOLUTION
-- Enemies march along an S-shaped path. Click to destroy them before they escape.
--
-- Visual extras:
--   1. Each enemy rotates to face its direction of travel (arrow drawn on body).
--   2. A health bar floats above each enemy (ready for assignment-32 towers).

SCREEN_W = 800
SCREEN_H = 600

ENEMY_RADIUS       = 14
WAYPOINT_THRESHOLD = 20
SPAWN_INTERVAL     = 2.5
ENEMY_SPEED        = 110

-- Winding S-shaped path — enemies walk index 1 → #path
path = {
    {x=50,  y=500},
    {x=200, y=150},
    {x=400, y=450},
    {x=600, y=150},
    {x=750, y=400},
    {x=600, y=550},
    {x=300, y=520},
    {x=100, y=350},
}

enemies    = {}
lives      = 5
score      = 0
spawnTimer = 0
gameOver   = false

-- ─── helpers ────────────────────────────────────────────────────────────────

function spawnEnemy()
    local e = {
        x             = path[1].x,
        y             = path[1].y,
        speed         = ENEMY_SPEED,
        waypointIndex = 1,
        angle         = 0,    -- visual extra 1: facing direction (radians)
        hp            = 1,    -- visual extra 2: health (full = 1.0)
        maxHp         = 1,
    }
    table.insert(enemies, e)
end

function resetGame()
    enemies    = {}
    lives      = 5
    score      = 0
    spawnTimer = 0
    gameOver   = false
end

-- ─── love callbacks ─────────────────────────────────────────────────────────

function love.load()
    love.window.setTitle("Assignment 31 — Waypoint Pathfinding (Solution)")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())
end

function love.update(dt)
    if gameOver then return end

    -- Spawn on timer
    spawnTimer = spawnTimer + dt
    if spawnTimer >= SPAWN_INTERVAL then
        spawnTimer = spawnTimer - SPAWN_INTERVAL
        spawnEnemy()
    end

    -- Update enemies — iterate backward so table.remove is safe
    for i = #enemies, 1, -1 do
        local e = enemies[i]

        -- ── Move toward current waypoint (TODO 1) ────────────────────────
        local target = path[e.waypointIndex]
        local dx     = target.x - e.x
        local dy     = target.y - e.y
        local dist   = math.sqrt(dx*dx + dy*dy)

        if dist > 0 then
            local nx = dx / dist   -- normalized x component
            local ny = dy / dist   -- normalized y component
            e.x = e.x + nx * e.speed * dt
            e.y = e.y + ny * e.speed * dt

            -- Visual extra 1: store the angle so we can draw a direction arrow
            e.angle = math.atan2(ny, nx)
        end

        -- ── Advance to the next waypoint when close enough (TODO 2) ──────
        if dist < WAYPOINT_THRESHOLD then
            e.waypointIndex = e.waypointIndex + 1
        end

        -- ── Handle enemy reaching the exit (TODO 3) ──────────────────────
        if e.waypointIndex > #path then
            table.remove(enemies, i)
            lives = lives - 1
        end
    end

    -- Game-over check
    if lives <= 0 then
        lives    = 0
        gameOver = true
    end
end

function love.mousepressed(mx, my, button)
    if button ~= 1 then return end

    if gameOver then
        resetGame()
        return
    end

    -- Click within enemy radius → destroy that enemy
    for i = #enemies, 1, -1 do
        local e  = enemies[i]
        local dx = mx - e.x
        local dy = my - e.y
        if math.sqrt(dx*dx + dy*dy) <= ENEMY_RADIUS then
            table.remove(enemies, i)
            score = score + 1
            break   -- one click, one enemy
        end
    end
end

function love.keypressed(key)
    if key == "r"      then resetGame()       end
    if key == "escape" then love.event.quit() end
end

-- ─── drawing ────────────────────────────────────────────────────────────────

function love.draw()
    love.graphics.setBackgroundColor(0.08, 0.10, 0.12)
    love.graphics.clear()

    drawPath()
    drawEnemies()
    drawHUD()

    if gameOver then drawGameOver() end
end

function drawPath()
    -- Path lines
    love.graphics.setColor(0.30, 0.30, 0.30)
    love.graphics.setLineWidth(4)
    for i = 1, #path - 1 do
        love.graphics.line(path[i].x, path[i].y, path[i+1].x, path[i+1].y)
    end
    love.graphics.setLineWidth(1)

    -- Waypoint dots
    for k, wp in ipairs(path) do
        if k == 1 then
            -- Start: bright green
            love.graphics.setColor(0.2, 1.0, 0.4)
            love.graphics.circle("fill", wp.x, wp.y, 10)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("START", wp.x + 13, wp.y - 8)
        elseif k == #path then
            -- Exit: bright red
            love.graphics.setColor(1.0, 0.2, 0.2)
            love.graphics.circle("fill", wp.x, wp.y, 10)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("EXIT", wp.x + 13, wp.y - 8)
        else
            -- Intermediate waypoints: grey
            love.graphics.setColor(0.55, 0.55, 0.55)
            love.graphics.circle("line", wp.x, wp.y, 6)
        end
    end
end

function drawEnemies()
    for _, e in ipairs(enemies) do
        -- ── Body ─────────────────────────────────────────────────────────
        love.graphics.setColor(1.0, 0.40, 0.08)
        love.graphics.circle("fill", e.x, e.y, ENEMY_RADIUS)

        -- Specular highlight
        love.graphics.setColor(1.0, 0.72, 0.35)
        love.graphics.circle("fill", e.x - 4, e.y - 4, ENEMY_RADIUS * 0.38)

        -- Outline
        love.graphics.setColor(0.75, 0.15, 0.0)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", e.x, e.y, ENEMY_RADIUS)
        love.graphics.setLineWidth(1)

        -- ── Visual extra 1: direction arrow ───────────────────────────────
        -- A small line pointing in the direction the enemy is travelling.
        local arrowLen = ENEMY_RADIUS - 2
        local ax = e.x + math.cos(e.angle) * arrowLen
        local ay = e.y + math.sin(e.angle) * arrowLen
        love.graphics.setColor(1, 1, 1, 0.85)
        love.graphics.setLineWidth(2)
        love.graphics.line(e.x, e.y, ax, ay)
        -- Arrow head (small filled circle at tip)
        love.graphics.circle("fill", ax, ay, 2.5)
        love.graphics.setLineWidth(1)

        -- ── Visual extra 2: health bar ────────────────────────────────────
        -- Floats 6px above the enemy. Shows current hp as a green/red bar.
        local barW  = ENEMY_RADIUS * 2.2
        local barH  = 4
        local barX  = e.x - barW / 2
        local barY  = e.y - ENEMY_RADIUS - 10

        -- Background (empty health, dark red)
        love.graphics.setColor(0.5, 0.05, 0.05)
        love.graphics.rectangle("fill", barX, barY, barW, barH, 2)

        -- Filled portion (current health, bright green)
        local hpFraction = math.max(0, e.hp / e.maxHp)
        love.graphics.setColor(0.15, 0.85, 0.25)
        love.graphics.rectangle("fill", barX, barY, barW * hpFraction, barH, 2)
    end
end

function drawHUD()
    -- Lives in red hearts (just text for simplicity)
    love.graphics.setColor(1, 0.35, 0.35)
    love.graphics.print("Lives: " .. lives, 10, 10)

    -- Score
    love.graphics.setColor(0.9, 0.85, 0.2)
    love.graphics.print("Score: " .. score, 10, 30)

    -- Active enemy count
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Enemies on path: " .. #enemies, 10, 50)

    -- Controls reminder
    love.graphics.setColor(0.45, 0.45, 0.45)
    love.graphics.print("Left-click to destroy  |  R = restart  |  Esc = quit", 10, SCREEN_H - 22)
end

function drawGameOver()
    -- Dim overlay
    love.graphics.setColor(0, 0, 0, 0.65)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Title
    love.graphics.setColor(1.0, 0.25, 0.25)
    love.graphics.printf("GAME OVER", 0, SCREEN_H/2 - 50, SCREEN_W, "center")

    -- Final score
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: " .. score .. " enemies destroyed", 0, SCREEN_H/2 + 5, SCREEN_W, "center")

    -- Prompt
    love.graphics.setColor(0.65, 0.65, 0.65)
    love.graphics.printf("Click or press R to try again", 0, SCREEN_H/2 + 42, SCREEN_W, "center")
end
