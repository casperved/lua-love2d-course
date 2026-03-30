-- Assignment 08: Tables — STARTER
-- Every left-click plants a flower. All flowers live in a table.

flowers = {}   -- an empty bag; we'll fill it with flower mini-tables

function love.load()
    math.randomseed(os.time())
end

-- ============================================================
-- TODO 1: Write spawnFlower(x, y).
-- Create a table with fields x, y, r, g, b, size, maxSize.
-- Insert it into flowers.
function spawnFlower(x, y)
    -- your code here
end
-- ============================================================

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnFlower(x, y)
    end
end

function love.update(dt)
    -- TODO 2: Grow each flower's bloom from size 0 up to its maxSize.
    -- Loop through every flower (for i = 1, #flowers do).
    -- Get the flower with: local f = flowers[i]
    -- If f.size < f.maxSize, increase f.size a little.
    -- Use math.min so it never exceeds f.maxSize.
end

function love.draw()
    -- Sky
    love.graphics.setColor(0.4, 0.7, 1.0)
    love.graphics.rectangle("fill", 0, 0, 800, 200)

    -- Grassy field
    love.graphics.setColor(0.2, 0.5, 0.2)
    love.graphics.rectangle("fill", 0, 200, 800, 400)

    -- TODO 3: Loop through every flower in the table and draw it.
    -- For each flower f draw:
    --   a) A stem   — a thick green line going downward from (f.x, f.y).
    --   b) Petals   — 5 small circles arranged in a ring; use a loop with angles.
    --   c) Bloom    — a filled circle at (f.x, f.y) with radius f.size.
    --   d) Center   — a small bright yellow circle at (f.x, f.y).
    --
    -- PLACEHOLDER so the window isn't completely blank while you work:
    love.graphics.setColor(1, 1, 0.6, 0.3)
    love.graphics.circle("fill", 0, 0, 5)   -- PLACEHOLDER — replace this

    -- UI overlay
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Click anywhere to plant a flower!", 10, 10)
    love.graphics.print("Flowers planted: " .. #flowers, 10, 30)
end
