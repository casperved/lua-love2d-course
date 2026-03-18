-- Assignment 06: Patterns with Loops — SOLUTION
-- Nested loops draw a full grid of colorful circles automatically.

COLS    = 8    -- number of columns
ROWS    = 6    -- number of rows
SPACING = 90   -- pixels between circle centers
RADIUS  = 30   -- radius of each circle

function love.load()
end

function love.update(dt)
end

function love.draw()
    -- Dark background
    love.graphics.setColor(0.05, 0.05, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Outer loop: one iteration per row
    for row = 1, ROWS do
        -- Inner loop: one iteration per column
        for col = 1, COLS do
            -- Calculate pixel position for this grid cell
            local x = col * SPACING - SPACING / 2 + 45
            local y = row * SPACING - SPACING / 2 + 30

            -- Color shifts across columns (red) and rows (green)
            local r = col / COLS
            local g = row / ROWS
            local b = 0.5

            -- Subtle glow: draw a slightly larger, dark circle first
            love.graphics.setColor(r * 0.4, g * 0.4, b * 0.4)
            love.graphics.circle("fill", x, y, RADIUS + 6)

            -- Main filled circle
            love.graphics.setColor(r, g, b)
            love.graphics.circle("fill", x, y, RADIUS)

            -- Small bright highlight for depth
            love.graphics.setColor(
                math.min(r + 0.4, 1),
                math.min(g + 0.4, 1),
                math.min(b + 0.4, 1),
                0.5
            )
            love.graphics.circle("fill", x - RADIUS * 0.3, y - RADIUS * 0.3, RADIUS * 0.25)
        end
    end

    -- UI
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.print(
        "Grid: " .. COLS .. " cols x " .. ROWS .. " rows = " .. (COLS * ROWS) .. " circles!",
        10, 575
    )
end
