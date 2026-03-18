-- Assignment 02: Shapes & Colors
-- Let's paint a scene using shapes!
-- The screen is 800 pixels wide and 600 pixels tall.
-- Remember: (0,0) is the TOP-LEFT corner. x goes right, y goes down.

function love.load()
end

function love.update(dt)
end

function love.draw()

    -- =====================
    -- SKY (already done!)
    -- =====================
    love.graphics.setColor(0.4, 0.7, 1)         -- light blue
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- =====================
    -- GROUND
    -- =====================
    -- TODO 1: Set the color to green (0.2, 0.7, 0.2) and draw a rectangle
    -- for the ground. It should be 800 wide and 200 tall, starting at y=400.
    -- (This covers the bottom portion of the screen.)
    -- love.graphics.setColor(?, ?, ?)
    -- love.graphics.rectangle("fill", 0, 400, ?, ?)

    -- =====================
    -- SUN
    -- =====================
    -- TODO 2: Set the color to yellow (1, 1, 0) and draw a filled circle
    -- near the top-right of the screen. Try center (680, 80), radius 50.
    -- love.graphics.setColor(?, ?, ?)
    -- love.graphics.circle("fill", ?, ?, ?)

    -- =====================
    -- HOUSE BODY
    -- =====================
    -- TODO 3: Set the color to warm brown (0.6, 0.4, 0.2) and draw a
    -- rectangle at (250, 280) that is 200 wide and 120 tall.
    -- love.graphics.setColor(?, ?, ?)
    -- love.graphics.rectangle("fill", ?, ?, ?, ?)

    -- =====================
    -- ROOF
    -- =====================
    -- TODO 4: Set color to red (0.8, 0.1, 0.1).
    -- Draw two lines to make a triangle roof over the house:
    --   Left slope:  from (240, 280) to (350, 180)
    --   Right slope: from (350, 180) to (460, 280)
    -- love.graphics.setColor(?, ?, ?)
    -- love.graphics.line(?, ?, ?, ?)
    -- love.graphics.line(?, ?, ?, ?)

    -- =====================
    -- CLOUD
    -- =====================
    -- TODO 5: Set color to white (1, 1, 1) and draw 3 circles close together
    -- to make a fluffy cloud shape!
    -- Try centers around (150, 120), (190, 105), (230, 120) with radius 35.
    -- love.graphics.setColor(?, ?, ?)
    -- love.graphics.circle("fill", ?, ?, ?)
    -- love.graphics.circle("fill", ?, ?, ?)
    -- love.graphics.circle("fill", ?, ?, ?)

end
