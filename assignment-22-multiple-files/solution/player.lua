-- player.lua  (solution)
-- Player ship: position, movement, drawing.
-- Visual extra: a subtle engine-glow trail behind the ship.

local utils = require("utils")

local Player = {}

Player.x      = 400
Player.y      = 520
Player.radius = 16
Player.speed  = 260
Player.color  = {0.3, 0.8, 1}

-- Trail for the visual extra
Player.trail     = {}
TRAIL_LIFETIME   = 0.3

function Player.init()
    Player.x     = 400
    Player.y     = 520
    Player.trail = {}
end

function Player.update(dt)
    local moved = false

    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then
        Player.x = Player.x - Player.speed * dt
        moved = true
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        Player.x = Player.x + Player.speed * dt
        moved = true
    end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then
        Player.y = Player.y - Player.speed * dt
        moved = true
    end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then
        Player.y = Player.y + Player.speed * dt
        moved = true
    end

    -- Clamp using the utils helper
    Player.x = utils.clamp(Player.x, Player.radius, 800 - Player.radius)
    Player.y = utils.clamp(Player.y, Player.radius, 600 - Player.radius)

    -- VISUAL EXTRA: record trail when moving
    if moved then
        table.insert(Player.trail, {x = Player.x, y = Player.y, age = 0})
    end
    for i = #Player.trail, 1, -1 do
        Player.trail[i].age = Player.trail[i].age + dt
        if Player.trail[i].age > TRAIL_LIFETIME then
            table.remove(Player.trail, i)
        end
    end
end

function Player.draw()
    -- VISUAL EXTRA: engine trail
    for _, pt in ipairs(Player.trail) do
        local frac  = 1 - pt.age / TRAIL_LIFETIME
        love.graphics.setColor(0.3, 0.8, 1, frac * 0.35)
        love.graphics.circle("fill", pt.x, pt.y, Player.radius * frac * 0.6)
    end

    -- Ship body
    love.graphics.setColor(Player.color)
    love.graphics.circle("fill", Player.x, Player.y, Player.radius)
    -- Outline
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.circle("line", Player.x, Player.y, Player.radius)
end

return Player
