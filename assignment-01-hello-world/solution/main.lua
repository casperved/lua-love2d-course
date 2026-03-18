-- Assignment 01: Hello, World! (SOLUTION)
-- Don't peek until you've really tried! But if you're stuck, that's okay.
-- Read through this carefully and make sure you understand each line.

function love.load()
    -- Nothing to set up for this assignment.
end

function love.update(dt)
    -- Nothing to update yet.
end

function love.draw()
    -- Step 1: Set color to red, then print "Hello, World!"
    -- Red = full red (1), no green (0), no blue (0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("Hello, World!", 100, 100)

    -- Step 2: Set color to bright sky blue, then print a name
    -- (0 red, 0.5 green, 1 full blue = nice bright blue)
    love.graphics.setColor(0, 0.5, 1)
    love.graphics.print("My name is Alex!", 100, 150)

    -- Step 3: A minty green for a third message
    -- (0 red, 1 full green, 0.5 half blue = mint green)
    love.graphics.setColor(0, 1, 0.5)
    love.graphics.print("I'm learning Lua — and it's awesome!", 100, 200)
end
