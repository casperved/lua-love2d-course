-- Assignment 06: Patterns with Loops
-- Instead of drawing 100 circles by hand, use a loop!

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

    -- TODO 1: Write a for loop for rows:
    --   for row = 1, ROWS do
    --
    --   Inside that loop, write another for loop for columns:
    --     for col = 1, COLS do

    -- TODO 2: Inside BOTH loops, calculate the x and y position:
    --   local x = col * SPACING - SPACING / 2 + 45
    --   local y = row * SPACING - SPACING / 2 + 30

    -- TODO 3: Make the color depend on the row and col.
    --   local r = col / COLS
    --   local g = row / ROWS
    --   local b = 0.5
    --   love.graphics.setColor(r, g, b)

    -- TODO 4: Draw a filled circle at (x, y) with RADIUS:
    --   love.graphics.circle("fill", x, y, RADIUS)

    -- Don't forget to close both loops!
    --   end   (closes the inner "col" loop)
    -- end     (closes the outer "row" loop)

    -- Helper text so the window isn't blank while you work
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Complete the TODOs to fill this screen with colorful circles!", 10, 570)
end
