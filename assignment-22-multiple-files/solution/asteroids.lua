-- asteroids.lua  (solution)
-- Spawns, moves, draws, and checks collisions for falling asteroids.

local utils = require("utils")

local Asteroids = {}

Asteroids.list = {}

ASTEROID_SPEED_MIN  = 80
ASTEROID_SPEED_MAX  = 200
ASTEROID_RADIUS_MIN = 12
ASTEROID_RADIUS_MAX = 28
SPAWN_INTERVAL      = 1.2

spawnTimer = 0

function Asteroids.init()
    Asteroids.list = {}
    spawnTimer     = 0
end

function Asteroids.update(dt)
    -- Spawn on timer
    spawnTimer = spawnTimer + dt
    if spawnTimer >= SPAWN_INTERVAL then
        spawnTimer = 0
        local a = {
            x      = math.random(20, 780),
            y      = -30,
            r      = math.random(ASTEROID_RADIUS_MIN, ASTEROID_RADIUS_MAX),
            speed  = math.random(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX),
            angle  = 0,            -- visual extra: rotation
            spin   = (math.random() - 0.5) * 4,
            dodged = false,
            scored = false,
        }
        table.insert(Asteroids.list, a)
    end

    for _, a in ipairs(Asteroids.list) do
        a.y     = a.y + a.speed * dt
        a.angle = a.angle + a.spin * dt   -- VISUAL EXTRA: spin
        if a.y > 600 + a.r and not a.dodged then
            a.dodged = true
        end
    end

    -- Remove off-screen asteroids
    for i = #Asteroids.list, 1, -1 do
        if Asteroids.list[i].y > 640 then
            table.remove(Asteroids.list, i)
        end
    end
end

function Asteroids.countNewDodged()
    local count = 0
    for _, a in ipairs(Asteroids.list) do
        if a.dodged and not a.scored then
            a.scored = true
            count    = count + 1
        end
    end
    return count
end

function Asteroids.draw()
    for _, a in ipairs(Asteroids.list) do
        local t = (a.r - ASTEROID_RADIUS_MIN) / (ASTEROID_RADIUS_MAX - ASTEROID_RADIUS_MIN)

        -- VISUAL EXTRA: draw a jagged polygon instead of a plain circle
        love.graphics.push()
        love.graphics.translate(a.x, a.y)
        love.graphics.rotate(a.angle)

        local sides = 7
        local verts = {}
        for i = 0, sides - 1 do
            local angle  = (i / sides) * math.pi * 2
            -- Add per-vertex noise baked into the asteroid table
            local jag    = a.r * (0.75 + ((i * 137 + a.r * 3) % 31) / 100)
            verts[#verts + 1] = math.cos(angle) * jag
            verts[#verts + 1] = math.sin(angle) * jag
        end

        love.graphics.setColor(1, 0.6 - t * 0.4, 0.1)
        love.graphics.polygon("fill", verts)
        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.polygon("line", verts)

        love.graphics.pop()
    end
end

-- SOLUTION: check whether any asteroid overlaps the player circle.
function Asteroids.checkCollision(px, py, pr)
    for _, a in ipairs(Asteroids.list) do
        if utils.distance(px, py, a.x, a.y) < pr + a.r then
            return true
        end
    end
    return false
end

return Asteroids
