-- Assignment 07: Functions
-- A function is like a recipe. Write it once, use it anywhere!

-- TODO 1: Write a function called drawStar(x, y, outerR, innerR, r, g, b)
--
-- It should build 10 vertex points alternating between outerR and innerR,
-- set the color, then draw a filled polygon.
--
-- Here is the full vertex formula — copy it inside your function:
--
--   local verts = {}
--   for i = 0, 9 do
--       local angle  = math.pi * i / 5 - math.pi / 2
--       local radius = (i % 2 == 0) and outerR or innerR
--       table.insert(verts, x + math.cos(angle) * radius)
--       table.insert(verts, y + math.sin(angle) * radius)
--   end
--   love.graphics.setColor(r, g, b)
--   love.graphics.polygon("fill", verts)
--
-- function drawStar(x, y, outerR, innerR, r, g, b)
--     -- your code here
-- end

-- TODO 3 (bonus): Write a drawShootingStar(x, y) function here too.
-- It should draw a small star with a line tail behind it.
-- Hint: use love.graphics.line then call drawStar!
--
-- function drawShootingStar(x, y)
--     -- your code here
-- end

function love.load()
end

function love.update(dt)
end

function love.draw()
    -- Night sky background
    love.graphics.setColor(0.03, 0.03, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 2: Call drawStar at least 8 times with different positions, sizes, and colors.
    -- For example:
    --   drawStar(400, 120, 50, 20, 1.0, 0.9, 0.2)   -- large golden star
    --   drawStar(100,  80, 20,  8, 1.0, 1.0, 0.9)   -- small white star
    -- Keep going! Try big stars, tiny stars, blue ones, red ones...

    -- Instructions text
    love.graphics.setColor(0.6, 0.6, 0.8)
    love.graphics.print("Implement drawStar() and fill the sky with stars!", 10, 575)
end
