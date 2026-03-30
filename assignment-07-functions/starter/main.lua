-- Assignment 07: Functions
-- Write a function once, call it many times with different arguments!

SCREEN_W = 800
SCREEN_H = 600

-- ============================================================
-- TODO 1: Write the drawHouse function.
-- Signature: function drawHouse(x, y, size, r, g, b)
--
-- The function should draw four things using x, y, size, r, g, b:
--   a) The wall     — a rectangle. Use r, g, b as the wall color.
--   b) The roof     — a triangle (polygon). Make it a darker shade of the wall color.
--   c) The door     — a small rectangle near the bottom center of the wall.
--   d) The window   — a small light-blue rectangle on the upper-left of the wall.
--
-- Scale every measurement off `size` so the house grows/shrinks as a unit.
function drawHouse(x, y, size, r, g, b)
    -- your code here
end
-- ============================================================

-- ============================================================
-- TODO 2: Write the drawTree function.
-- Signature: function drawTree(x, y, size)
--
-- The function should draw two things:
--   a) The trunk  — a brown rectangle below the center point.
--   b) The leaves — a green triangle (polygon) above the trunk.
--
-- Scale measurements off `size`.
function drawTree(x, y, size)
    -- your code here
end
-- ============================================================

function love.load() end
function love.update(dt) end

function love.draw()
    -- Sky
    love.graphics.setColor(0.4, 0.7, 1)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Ground
    love.graphics.setColor(0.3, 0.65, 0.2)
    love.graphics.rectangle("fill", 0, 420, SCREEN_W, SCREEN_H - 420)

    -- TODO 3: Call drawHouse at least three times with different positions and colors.
    -- Suggested positions: (80, 300), (300, 320), (530, 290)
    -- Suggested sizes:     120, 100, 130
    -- Pick any r, g, b values you like for each house.

    -- TODO 4: Call drawTree at least twice with different positions and sizes.
    -- Suggested positions: (240, 310), (490, 305), (700, 300)
    -- Suggested sizes:     90, 80, 100
end
