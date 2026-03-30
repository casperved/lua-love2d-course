-- Assignment 07: Functions — SOLUTION
-- A landscape scene built by calling two reusable functions.

SCREEN_W = 800
SCREEN_H = 600

function love.load() end
function love.update(dt) end

-- Draws a house centered at the top-left corner (x, y) with the given size and color.
function drawHouse(x, y, size, r, g, b)
    -- Wall
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", x, y, size, size * 0.8)
    -- Roof (darker shade of the wall color)
    love.graphics.setColor(r * 0.6, g * 0.6, b * 0.6)
    love.graphics.polygon("fill",
        x - size * 0.1, y,
        x + size * 0.5, y - size * 0.5,
        x + size * 1.1, y)
    -- Door
    love.graphics.setColor(0.3, 0.2, 0.1)
    love.graphics.rectangle("fill", x + size * 0.35, y + size * 0.4, size * 0.3, size * 0.4)
    -- Window
    love.graphics.setColor(0.7, 0.9, 1)
    love.graphics.rectangle("fill", x + size * 0.1, y + size * 0.15, size * 0.25, size * 0.25)
end

-- Draws a simple triangle-on-rectangle tree centered at (x, y).
function drawTree(x, y, size)
    -- Trunk
    love.graphics.setColor(0.5, 0.3, 0.1)
    love.graphics.rectangle("fill", x - size * 0.1, y + size * 0.4, size * 0.2, size * 0.6)
    -- Leaves (triangle)
    love.graphics.setColor(0.2, 0.7, 0.2)
    love.graphics.polygon("fill",
        x, y,
        x - size * 0.5, y + size * 0.6,
        x + size * 0.5, y + size * 0.6)
end

function love.draw()
    -- Sky
    love.graphics.setColor(0.4, 0.7, 1)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)
    -- Ground
    love.graphics.setColor(0.3, 0.65, 0.2)
    love.graphics.rectangle("fill", 0, 420, SCREEN_W, SCREEN_H - 420)

    -- Three houses — same function, different arguments
    drawHouse(80,  300, 120, 0.9, 0.8, 0.6)   -- sandy yellow
    drawHouse(300, 320, 100, 0.7, 0.4, 0.4)   -- brick red
    drawHouse(530, 290, 130, 0.6, 0.7, 0.9)   -- pale blue

    -- Trees placed between and beside the houses
    drawTree(240, 310, 90)
    drawTree(490, 305, 80)
    drawTree(700, 300, 100)

    -- Sun (stretch goal example)
    love.graphics.setColor(1, 0.95, 0.3)
    love.graphics.circle("fill", 730, 70, 40)
    love.graphics.setColor(1, 0.95, 0.3, 0.4)
    for i = 0, 7 do
        local a = i * math.pi / 4
        love.graphics.line(
            730 + math.cos(a) * 50, 70 + math.sin(a) * 50,
            730 + math.cos(a) * 65, 70 + math.sin(a) * 65)
    end
end
