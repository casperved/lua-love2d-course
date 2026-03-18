-- Assignment 01: Hello, World!
-- Your first LÖVE2D program. Fill in the TODOs below!
-- Run this file with LÖVE2D and see what appears on screen.

function love.load()
    -- This runs once when the game starts.
    -- We don't need to set anything up for this assignment.
end

function love.update(dt)
    -- This runs every frame (~60 times per second).
    -- We don't need it yet, but LÖVE2D expects it to exist!
end

function love.draw()
    -- This runs every frame to draw things on screen.
    -- Remember: setColor first, then print!

    -- TODO 1: Set the color to red.
    -- Colors use three numbers (red, green, blue) each from 0 to 1.
    -- Pure red is (1, 0, 0) — full red, no green, no blue.
    -- love.graphics.setColor(?, ?, ?)

    -- TODO 2: Print "Hello, World!" at position x=100, y=100
    -- love.graphics.print("?", ?, ?)

    -- TODO 3: Set the color to a bright sky blue: (0, 0.5, 1)
    -- love.graphics.setColor(?, ?, ?)

    -- TODO 4: Print your own name at position x=100, y=150
    -- love.graphics.print("My name is ?", ?, ?)

    -- TODO 5: Pick ANY color you like and print one more message at y=200
    -- Hint: try (0, 1, 0.5) for a minty green, or make up your own!
    -- love.graphics.setColor(?, ?, ?)
    -- love.graphics.print("?", 100, 200)
end
