-- Assignment 02: Shapes & Colors
-- Paint a sunny-day scene using rectangles, circles, and lines.
-- The window is 800 pixels wide and 600 pixels tall.
-- (0, 0) is the TOP-LEFT corner. x grows right, y grows down.
-- IMPORTANT: draw backgrounds first — later shapes appear ON TOP of earlier ones!

function love.load()
end

function love.update(dt)
end

function love.draw()

    -- =====================
    -- SKY (already done!)
    -- =====================
    love.graphics.setColor(0.4, 0.7, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- =====================
    -- GROUND
    -- =====================
    -- TODO 1: Draw the ground.
    -- Use love.graphics.setColor then love.graphics.rectangle("fill", x, y, w, h).
    -- The ground should cover the bottom part of the 800x600 screen.

    -- =====================
    -- SUN
    -- =====================
    -- TODO 2: Draw the sun.
    -- Use love.graphics.setColor then love.graphics.circle("fill", x, y, radius).
    -- Place it near the top-right of the sky.

    -- =====================
    -- HOUSE BODY
    -- =====================
    -- TODO 3: Draw the house body.
    -- A warm-colored filled rectangle sitting on the ground, roughly centered.

    -- =====================
    -- ROOF
    -- =====================
    -- TODO 4: Draw the roof as two lines meeting at a peak above the house.
    -- Use love.graphics.line(x1, y1, x2, y2) — one line for each slope.

    -- =====================
    -- DOOR
    -- =====================
    -- TODO 5: Draw the door.
    -- A small, tall, dark-colored rectangle at the base of the house.

    -- =====================
    -- WINDOWS
    -- =====================
    -- TODO 6: Draw two windows on the house.
    -- Two small light-blue rectangles, one on each side of the door.

    -- =====================
    -- CLOUD
    -- =====================
    -- TODO 7: Draw a fluffy cloud using three overlapping white circles.
    -- Place them close together so they merge into one cloud shape.

    -- =====================
    -- SECOND CLOUD
    -- =====================
    -- TODO 8: Draw a second cloud somewhere else in the sky.
    -- Make it a bit smaller than the first to give a sense of distance.

end
