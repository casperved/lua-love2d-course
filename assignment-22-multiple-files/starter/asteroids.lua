-- asteroids.lua
-- Manages the list of falling asteroids: spawning, moving, drawing,
-- and collision detection with the player.

local utils = require("utils")

local Asteroids = {}

Asteroids.list = {}

ASTEROID_SPEED_MIN  = 80
ASTEROID_SPEED_MAX  = 200
ASTEROID_RADIUS_MIN = 12
ASTEROID_RADIUS_MAX = 28
SPAWN_INTERVAL      = 1.2   -- seconds between spawns

spawnTimer = 0

function Asteroids.init()
    Asteroids.list = {}
    spawnTimer     = 0
end

function Asteroids.update(dt)
    -- Spawn new asteroids on a timer
    spawnTimer = spawnTimer + dt
    if spawnTimer >= SPAWN_INTERVAL then
        spawnTimer = 0
        local a = {
            x      = math.random(20, 780),
            y      = -30,
            r      = math.random(ASTEROID_RADIUS_MIN, ASTEROID_RADIUS_MAX),
            speed  = math.random(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX),
            angle  = 0,
            spin   = (math.random() - 0.5) * 4,
            dodged = false,
            scored = false,
        }
        table.insert(Asteroids.list, a)
    end

    -- Move each asteroid downward; mark as dodged when it leaves the screen
    for _, a in ipairs(Asteroids.list) do
        a.y     = a.y + a.speed * dt
        a.angle = a.angle + a.spin * dt
        if a.y > 600 + a.r and not a.dodged then
            a.dodged = true
        end
    end

    -- Remove asteroids that are well off-screen
    for i = #Asteroids.list, 1, -1 do
        if Asteroids.list[i].y > 640 then
            table.remove(Asteroids.list, i)
        end
    end
end

-- Returns how many asteroids were newly dodged this frame (for scoring).
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

        love.graphics.push()
        love.graphics.translate(a.x, a.y)
        love.graphics.rotate(a.angle)

        local sides = 7
        local verts = {}
        for i = 0, sides - 1 do
            local angle = (i / sides) * math.pi * 2
            local jag   = a.r * (0.75 + ((i * 137 + a.r * 3) % 31) / 100)
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

-- ---------------------------------------------------------------
-- TODO 2: Replace the stub below with a real collision check.
-- Loop over Asteroids.list. Each asteroid has .x, .y, and .r
-- (radius). The player has centre (px, py) and radius pr.
-- Two circles overlap when the distance between their centres is
-- less than the sum of their radii.
-- Use utils.distance to measure the distance.
-- Return true as soon as one hit is found; return false at the end.
-- ---------------------------------------------------------------
function Asteroids.checkCollision(px, py, pr)
    -- Stub: always returns false, so the player can never die.
    -- Delete this line and replace it with the real loop!
    return false
    -- for _, a in ipairs(Asteroids.list) do
    --     if utils.distance(px, py, a.x, a.y) < pr + a.r then
    --         return true
    --     end
    -- end
    -- return false
end

return Asteroids
