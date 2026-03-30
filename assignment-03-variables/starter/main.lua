-- Assignment 03A: Variables
-- Variables are labeled boxes that hold values.
-- Change a variable once and watch everything that uses it update!

-- TODO 1: Give these variables good starting values so the ball appears on screen.
-- Right now they are all 0, which hides the ball in the top-left corner.
ballX      = 0   -- try 400 (center of the 800-wide screen)
ballY      = 0   -- try 300 (center of the 600-tall screen)
ballRadius = 0   -- try 40

ballR = 0        -- red amount (0 to 1)
ballG = 0        -- green amount (0 to 1)
ballB = 0        -- blue amount (0 to 1)

function love.load()
    -- Variables are all set above. Nothing extra needed here yet!
end

function love.update(dt)
    -- No movement yet — just a still image this time.
end

function love.draw()
    -- Dark space-like background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 2: Draw the ball using your variables.
    -- Set the color using ballR, ballG, ballB, then draw a filled circle
    -- at (ballX, ballY) with radius ballRadius.

    -- TODO 3: Print the ball's position as text in the top-left corner.
    -- Use .. to join strings and numbers together, like: "x = " .. ballX

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.print("(Fill in the TODOs at the top of the file!)", 10, 560)
end
