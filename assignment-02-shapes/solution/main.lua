-- Assignment 02: Shapes & Colors (SOLUTION)
-- A complete sunny-day scene built entirely from basic shapes.
-- Study this if you got stuck, and make sure you understand each drawing call!

function love.load()
end

function love.update(dt)
end

function love.draw()

    -- SKY: a big light-blue rectangle covering the whole screen
    love.graphics.setColor(0.4, 0.7, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- GROUND: a green rectangle across the bottom fifth of the screen
    love.graphics.setColor(0.2, 0.7, 0.2)
    love.graphics.rectangle("fill", 0, 400, 800, 200)

    -- SUN: a yellow circle near the top-right corner
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", 680, 80, 50)

    -- HOUSE BODY: a warm-brown rectangle sitting on the ground
    love.graphics.setColor(0.6, 0.4, 0.2)
    love.graphics.rectangle("fill", 250, 280, 200, 120)

    -- ROOF: two red lines forming a triangle peak above the house
    love.graphics.setColor(0.8, 0.1, 0.1)
    love.graphics.line(240, 280, 350, 180)   -- left slope
    love.graphics.line(350, 180, 460, 280)   -- right slope

    -- DOOR: a small dark rectangle on the house
    love.graphics.setColor(0.35, 0.2, 0.08)
    love.graphics.rectangle("fill", 330, 340, 40, 60)

    -- WINDOWS: two small light-blue squares
    love.graphics.setColor(0.6, 0.85, 1)
    love.graphics.rectangle("fill", 265, 300, 45, 40)  -- left window
    love.graphics.rectangle("fill", 390, 300, 45, 40)  -- right window

    -- CLOUD: three overlapping white circles = fluffy cloud!
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 150, 120, 35)
    love.graphics.circle("fill", 190, 105, 35)
    love.graphics.circle("fill", 230, 120, 35)

    -- SECOND CLOUD (bonus!): a smaller one further right
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 500, 90, 25)
    love.graphics.circle("fill", 530, 78, 25)
    love.graphics.circle("fill", 560, 90, 25)

end
