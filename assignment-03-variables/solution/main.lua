-- Assignment 03: Variables & Math (SOLUTION)
-- See how changing ballX, ballY, or ballRadius moves/resizes everything at once!
-- Try editing those values and re-running to see the ball jump around.

-- The ball's position — change these numbers and re-run!
ballX = 400
ballY = 300
ballRadius = 40

-- The ball's color stored as a table (orange: full red, half green, no blue)
ballColor = {1, 0.5, 0}

function love.load()
    -- Nothing extra to load for this assignment.
end

function love.update(dt)
    -- No movement yet. We'll add that in the next assignment!
end

function love.draw()
    -- Dark space-like background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw the ball using our variables
    -- Access the table values with [1], [2], [3]
    love.graphics.setColor(ballColor[1], ballColor[2], ballColor[3])
    love.graphics.circle("fill", ballX, ballY, ballRadius)

    -- Draw a subtle outline so we can see the edge clearly
    love.graphics.setColor(1, 0.8, 0.3)
    love.graphics.circle("line", ballX, ballY, ballRadius)

    -- Display the ball's coordinates in the corner
    -- The .. operator joins (concatenates) strings and numbers together
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Ball position:  x = " .. ballX .. "  y = " .. ballY, 10, 10)
    love.graphics.print("Ball radius: " .. ballRadius, 10, 30)
    love.graphics.print("(Try changing ballX, ballY, and ballRadius at the top!)", 10, 560)
end
