-- player.lua
-- Manages the player ship: position, movement, drawing.

local Player = {}

Player.x      = 400
Player.y      = 520
Player.radius = 16
Player.speed  = 260
Player.color  = {0.3, 0.8, 1}

function Player.init()
    Player.x = 400
    Player.y = 520
end

function Player.update(dt)
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then
        Player.x = Player.x - Player.speed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        Player.x = Player.x + Player.speed * dt
    end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then
        Player.y = Player.y - Player.speed * dt
    end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then
        Player.y = Player.y + Player.speed * dt
    end

    -- Clamp inside screen
    Player.x = math.max(Player.radius, math.min(800  - Player.radius, Player.x))
    Player.y = math.max(Player.radius, math.min(600 - Player.radius, Player.y))
end

function Player.draw()
    -- Body
    love.graphics.setColor(Player.color)
    love.graphics.circle("fill", Player.x, Player.y, Player.radius)
    -- Outline
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.circle("line", Player.x, Player.y, Player.radius)
end

return Player
