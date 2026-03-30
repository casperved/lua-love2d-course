-- Assignment 32: Tower Defense — SOLUTION
-- Visual extras:
--   1. Tower range ring shown when mouse hovers over a tower
--   2. Bullet trails — each bullet remembers its last 3 positions

-- ============================================================
-- CONSTANTS
-- ============================================================
SCREEN_W = 800
SCREEN_H = 600

MAX_TOWERS     = 15
TOWER_SIZE     = 24
TOWER_RANGE    = 120
TOWER_COOLDOWN = 0.8
BULLET_SPEED   = 300
HIT_RADIUS     = 8

SPAWN_INTERVAL_BASE = 2.0
ENEMIES_PER_WAVE    = 10

-- Number of trail positions stored per bullet
TRAIL_LENGTH = 3

-- ============================================================
-- PATH
-- ============================================================
PATH = {
    {x=50,  y=500},
    {x=200, y=150},
    {x=400, y=450},
    {x=600, y=150},
    {x=750, y=400},
    {x=600, y=550},
    {x=300, y=520},
    {x=100, y=350},
}

-- ============================================================
-- GAME STATE
-- ============================================================
towers        = {}
enemies       = {}
bullets       = {}

lives         = 5
score         = 0
towersLeft    = MAX_TOWERS
wave          = 1

spawnTimer    = 0
spawnInterval = SPAWN_INTERVAL_BASE
enemiesSpawnedThisWave = 0

gameState = "playing"   -- "playing" | "gameover"

-- ============================================================
-- HELPERS
-- ============================================================
function dist(ax, ay, bx, by)
    local dx = bx - ax
    local dy = by - ay
    return math.sqrt(dx*dx + dy*dy)
end

function tooCloseToPath(px, py)
    for _, wp in ipairs(PATH) do
        if dist(px, py, wp.x, wp.y) < 40 then
            return true
        end
    end
    return false
end

-- ============================================================
-- ENEMY LOGIC  (from assignment 31)
-- ============================================================
function spawnEnemy()
    local start = PATH[1]
    table.insert(enemies, {
        x             = start.x,
        y             = start.y,
        speed         = 100,
        waypointIndex = 2,
        hp            = 2,
        maxHp         = 2,
        dead          = false,
    })
end

-- Move one enemy along the path. Returns true when it exits.
function moveEnemy(e, dt)
    if e.waypointIndex > #PATH then
        return true
    end

    local target = PATH[e.waypointIndex]
    local dx = target.x - e.x
    local dy = target.y - e.y
    local d  = math.sqrt(dx*dx + dy*dy)

    if d < 4 then
        e.x = target.x
        e.y = target.y
        e.waypointIndex = e.waypointIndex + 1
    else
        e.x = e.x + (dx / d) * e.speed * dt
        e.y = e.y + (dy / d) * e.speed * dt
    end

    return false
end

-- ============================================================
-- TOWER LOGIC
-- ============================================================
function placeTower(px, py)
    if towersLeft <= 0 then return end
    if tooCloseToPath(px, py) then return end

    towersLeft = towersLeft - 1
    table.insert(towers, {
        x        = px,
        y        = py,
        range    = TOWER_RANGE,
        cooldown = 0,
        damage   = 1,
    })
end

function updateTowers(dt)
    for _, tower in ipairs(towers) do
        if tower.cooldown > 0 then
            tower.cooldown = tower.cooldown - dt
        end

        if tower.cooldown <= 0 then
            -- ================================================
            -- TODO 1 SOLUTION: Tower targeting
            -- Pick the enemy furthest along the path that is
            -- within range (highest waypointIndex wins).
            -- ================================================
            local target      = nil
            local bestProgress = -1

            for _, e in ipairs(enemies) do
                if not e.dead then
                    local dx = e.x - tower.x
                    local dy = e.y - tower.y
                    local d  = math.sqrt(dx*dx + dy*dy)
                    if d < tower.range then
                        if e.waypointIndex > bestProgress then
                            bestProgress = e.waypointIndex
                            target = e
                        end
                    end
                end
            end

            -- Fire when we have a target
            if target then
                tower.cooldown = TOWER_COOLDOWN
                table.insert(bullets, {
                    x      = tower.x,
                    y      = tower.y,
                    vx     = 0,
                    vy     = 0,
                    target = target,
                    damage = tower.damage,
                    speed  = BULLET_SPEED,
                    dead   = false,
                    -- Visual extra 2: trail ring buffer
                    trail  = {},
                })
            end
        end
    end
end

-- ============================================================
-- BULLET LOGIC
-- ============================================================
function updateBullets(dt)
    for _, b in ipairs(bullets) do
        -- If the target died before the bullet arrived, discard
        if b.target.dead then
            b.dead = true
        end

        if not b.dead then
            -- Visual extra 2: record trail position before moving
            table.insert(b.trail, 1, {x = b.x, y = b.y})
            if #b.trail > TRAIL_LENGTH then
                table.remove(b.trail)   -- drop oldest
            end

            -- ================================================
            -- TODO 2 SOLUTION: Bullet homing
            -- Recalculate direction to target every frame and
            -- move the bullet toward it.
            -- ================================================
            local dx  = b.target.x - b.x
            local dy  = b.target.y - b.y
            local len = math.sqrt(dx*dx + dy*dy)

            if len > 0 then
                b.vx = (dx / len) * b.speed
                b.vy = (dy / len) * b.speed
            end

            b.x = b.x + b.vx * dt
            b.y = b.y + b.vy * dt

            -- ================================================
            -- TODO 3 SOLUTION: Enemy health + death
            -- When close enough, deal damage. If hp reaches 0,
            -- mark the enemy dead and award score.
            -- ================================================
            local hitDist = dist(b.x, b.y, b.target.x, b.target.y)
            if hitDist < HIT_RADIUS then
                b.target.hp = b.target.hp - b.damage

                if b.target.hp <= 0 then
                    b.target.dead = true
                    score = score + 1
                end

                b.dead = true   -- bullet is spent
            end
        end
    end

    -- Clean up dead bullets (backwards to keep indices stable)
    for i = #bullets, 1, -1 do
        if bullets[i].dead then
            table.remove(bullets, i)
        end
    end
end

-- ============================================================
-- WAVE / SPAWN LOGIC
-- ============================================================
function updateSpawner(dt)
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnTimer = spawnTimer - spawnInterval
        spawnEnemy()
        enemiesSpawnedThisWave = enemiesSpawnedThisWave + 1

        if enemiesSpawnedThisWave >= ENEMIES_PER_WAVE then
            wave = wave + 1
            enemiesSpawnedThisWave = 0
            spawnInterval = math.max(0.5, spawnInterval - 0.1)
        end
    end
end

-- ============================================================
-- RESET
-- ============================================================
function resetGame()
    towers        = {}
    enemies       = {}
    bullets       = {}
    lives         = 5
    score         = 0
    towersLeft    = MAX_TOWERS
    wave          = 1
    spawnTimer    = 0
    spawnInterval = SPAWN_INTERVAL_BASE
    enemiesSpawnedThisWave = 0
    gameState     = "playing"
end

-- ============================================================
-- LÖVE CALLBACKS
-- ============================================================
function love.load()
    love.window.setTitle("Tower Defense — Assignment 32 Solution")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())
end

function love.update(dt)
    if gameState ~= "playing" then return end

    updateSpawner(dt)

    -- Move enemies and check for exits
    for i = #enemies, 1, -1 do
        local e = enemies[i]
        if not e.dead then
            local exited = moveEnemy(e, dt)
            if exited then
                lives = lives - 1
                e.dead = true
                if lives <= 0 then
                    gameState = "gameover"
                end
            end
        end
    end

    -- Remove dead enemies
    for i = #enemies, 1, -1 do
        if enemies[i].dead then
            table.remove(enemies, i)
        end
    end

    updateTowers(dt)
    updateBullets(dt)
end

function love.mousepressed(x, y, button)
    if gameState ~= "playing" then return end
    if button == 1 then
        placeTower(x, y)
    end
end

function love.keypressed(key)
    if key == "r" then
        resetGame()
    end
    if key == "escape" then
        love.event.quit()
    end
end

-- ============================================================
-- DRAWING
-- ============================================================
function drawPath()
    -- Wide dirt-coloured road
    love.graphics.setColor(0.35, 0.28, 0.18)
    love.graphics.setLineWidth(18)
    local points = {}
    for _, wp in ipairs(PATH) do
        table.insert(points, wp.x)
        table.insert(points, wp.y)
    end
    love.graphics.line(points)
    love.graphics.setLineWidth(1)

    -- Waypoint markers
    love.graphics.setColor(0.5, 0.4, 0.25)
    for _, wp in ipairs(PATH) do
        love.graphics.circle("fill", wp.x, wp.y, 5)
    end
end

function drawEnemies()
    for _, e in ipairs(enemies) do
        -- Body
        love.graphics.setColor(0.85, 0.2, 0.2)
        love.graphics.circle("fill", e.x, e.y, 12)
        -- Outline
        love.graphics.setColor(0.5, 0.1, 0.1)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", e.x, e.y, 12)
        love.graphics.setLineWidth(1)

        -- HP bar
        local barW  = 24
        local ratio = math.max(0, e.hp / e.maxHp)
        love.graphics.setColor(0.15, 0.15, 0.15)
        love.graphics.rectangle("fill", e.x - barW/2, e.y - 22, barW, 4)
        love.graphics.setColor(0.1, 0.9, 0.2)
        love.graphics.rectangle("fill", e.x - barW/2, e.y - 22, barW * ratio, 4)
    end
end

-- Visual extra 1: show range ring on hovered towers
function drawTowers()
    local mx, my = love.mouse.getPosition()

    for _, t in ipairs(towers) do
        -- Range ring if mouse is nearby
        local d = dist(mx, my, t.x, t.y)
        if d < TOWER_SIZE then
            love.graphics.setColor(0.6, 0.8, 1.0, 0.15)
            love.graphics.circle("fill", t.x, t.y, t.range)
            love.graphics.setColor(0.6, 0.8, 1.0, 0.5)
            love.graphics.setLineWidth(1)
            love.graphics.circle("line", t.x, t.y, t.range)
        end

        -- Base square
        local half = TOWER_SIZE / 2
        love.graphics.setColor(0.2, 0.25, 0.35)
        love.graphics.rectangle("fill", t.x - half, t.y - half, TOWER_SIZE, TOWER_SIZE)
        -- Square outline
        love.graphics.setColor(0.4, 0.5, 0.7)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", t.x - half, t.y - half, TOWER_SIZE, TOWER_SIZE)
        love.graphics.setLineWidth(1)
        -- Cannon top circle
        love.graphics.setColor(0.7, 0.8, 1.0)
        love.graphics.circle("fill", t.x, t.y, 8)
        love.graphics.setColor(0.3, 0.4, 0.6)
        love.graphics.circle("line", t.x, t.y, 8)
    end
end

-- Visual extra 2: fading bullet trails
function drawBullets()
    for _, b in ipairs(bullets) do
        -- Draw trail dots, fading out with distance from head
        for i, pos in ipairs(b.trail) do
            local alpha = 0.6 * (1 - i / (TRAIL_LENGTH + 1))
            love.graphics.setColor(1, 0.9, 0.1, alpha)
            love.graphics.circle("fill", pos.x, pos.y, 4 - i)
        end

        -- Bullet head
        love.graphics.setColor(1, 0.95, 0.3)
        love.graphics.circle("fill", b.x, b.y, 4)
    end
end

function drawHUD()
    -- Frosted bar at top
    love.graphics.setColor(0, 0, 0, 0.55)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, 36)

    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.print("Lives: " .. lives, 10, 10)

    love.graphics.setColor(1, 0.9, 0.2)
    love.graphics.print("Score: " .. score, 160, 10)

    love.graphics.setColor(0.6, 0.9, 1.0)
    love.graphics.print("Towers left: " .. towersLeft, 310, 10)

    love.graphics.setColor(0.8, 1.0, 0.6)
    love.graphics.print("Wave: " .. wave, 510, 10)

    -- Placement hint at the bottom
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.print("Left-click to place tower (stay off the path!) | R = restart | ESC = quit",
        10, SCREEN_H - 22)
end

function drawGameOver()
    love.graphics.setColor(0, 0, 0, 0.72)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.printf("GAME OVER", 0, SCREEN_H/2 - 60, SCREEN_W, "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: " .. score .. "      Wave reached: " .. wave,
        0, SCREEN_H/2, SCREEN_W, "center")

    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf("Press R to play again", 0, SCREEN_H/2 + 56, SCREEN_W, "center")
end

function love.draw()
    -- Grass background
    love.graphics.setColor(0.18, 0.38, 0.18)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    drawPath()
    drawTowers()
    drawEnemies()
    drawBullets()
    drawHUD()

    if gameState == "gameover" then
        drawGameOver()
    end

    -- Reset so nothing bleeds between frames
    love.graphics.setColor(1, 1, 1)
end
