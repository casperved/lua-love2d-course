-- Assignment 03: Variables & Math
-- Variables are like labeled boxes that hold values.
-- Change a variable once and watch everything that uses it update!

-- TODO 1: Create a variable called ballX and set it to 400
-- ballX = ?

-- TODO 2: Create a variable called ballY and set it to 300
-- ballY = ?

-- TODO 3: Create a variable called ballRadius and set it to 40
-- ballRadius = ?

-- TODO 4: Create a variable called ballColor and set it to an orange color.
-- In Lua, a table stores multiple values together using curly braces: { }
-- Orange is (1, 0.5, 0) for (red, green, blue).
-- ballColor = {?, ?, ?}

function love.load()
    -- Variables are set above. Nothing extra needed here yet!
    -- But in future assignments, love.load() is a great place to set things up.
end

function love.update(dt)
    -- No movement yet — just a still image this time.
end

function love.draw()
    -- Dark background so the orange ball pops!
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 5: Set the drawing color using ballColor, then draw the ball.
    -- Access table values with [1], [2], [3]:
    -- love.graphics.setColor(ballColor[1], ballColor[2], ballColor[3])
    -- love.graphics.circle("fill", ?, ?, ?)

    -- TODO 6: Display the ball's position as text in the top-left corner.
    -- Use .. to join strings and numbers together: "x = " .. ballX
    love.graphics.setColor(1, 1, 1)
    -- love.graphics.print("x = " .. ? .. "  y = " .. ?, 10, 10)
end
