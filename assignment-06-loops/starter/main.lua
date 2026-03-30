-- Assignment 06: Patterns with Loops
-- Instead of drawing 48 circles by hand, let loops do the work!

COLS    = 8    -- number of columns
ROWS    = 6    -- number of rows
SPACING = 90   -- pixels between circle centers
RADIUS  = 30   -- radius of each circle

function love.load()
end

function love.update(dt)
end

function love.draw()
    love.graphics.setColor(0.05, 0.05, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 1: Write the outer for loop (rows).
    -- It should count from 1 to ROWS.

        -- TODO 2: Write the inner for loop (columns) inside the outer one.
        -- It should count from 1 to COLS.

            -- TODO 3: Calculate x and y position for this circle.
            -- x = col * SPACING + some offset to center the grid
            -- y = row * SPACING + some offset to center the grid
            -- Use local variables.

            -- TODO 4: Calculate a color based on position.
            -- r = col / COLS  (goes from near-0 to 1 across the columns)
            -- g = row / ROWS  (goes from near-0 to 1 down the rows)

            -- TODO 5: Set the color and draw a filled circle.
            -- Use love.graphics.setColor and love.graphics.circle.

    -- Helper text so the window isn't blank while you work
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.print("Fill in the TODOs to draw a grid of colorful circles!", 10, 575)
end
