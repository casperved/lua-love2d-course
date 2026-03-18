-- Assignment 08: Tables
-- Tables are like lists. We'll store all our flowers in a table!

-- TODO 1: Create an empty table called flowers (outside any function so all
-- functions can see it):
--   flowers = {}
flowers = {}   -- placeholder so the rest of the file doesn't crash

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
end

function love.draw()
    -- Sky
    love.graphics.setColor(0.4, 0.7, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 200)

    -- Grassy field
    love.graphics.setColor(0.2, 0.5, 0.2)
    love.graphics.rectangle("fill", 0, 200, 800, 400)

    -- TODO 2: Loop through the flowers table and draw each flower.
    -- Each flower has fields: f.x, f.y, f.r, f.g, f.b
    --
    -- for i = 1, #flowers do
    --     local f = flowers[i]
    --
    --     -- Green stem (a line going downward from the bloom)
    --     love.graphics.setColor(0.1, 0.6, 0.1)
    --     love.graphics.line(f.x, f.y, f.x, f.y + 40)
    --
    --     -- Colourful bloom
    --     love.graphics.setColor(f.r, f.g, f.b)
    --     love.graphics.circle("fill", f.x, f.y, 15)
    -- end

    -- Instructions
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Click anywhere to plant a flower!", 10, 10)
    love.graphics.print("Flowers planted: " .. #flowers, 10, 30)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- TODO 3: Create a new flower table with x, y, and random r, g, b values.
        -- Then insert it into the flowers table.
        --
        -- local newFlower = {
        --     x = x,
        --     y = y,
        --     r = math.random(),
        --     g = math.random(),
        --     b = math.random()
        -- }
        -- table.insert(flowers, newFlower)
    end
end
