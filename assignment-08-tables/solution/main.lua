-- Assignment 08: Tables — SOLUTION
-- Every left-click plants a flower. All flowers live in a table.

flowers = {}

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    -- Grow each flower's bloom from 0 up to its full size (stretch goal built in)
    for i = 1, #flowers do
        local f = flowers[i]
        if f.size < f.maxSize then
            f.size = math.min(f.size + dt * 40, f.maxSize)
        end
    end
end

function love.draw()
    -- Sky
    love.graphics.setColor(0.4, 0.7, 1.0)
    love.graphics.rectangle("fill", 0, 0, 800, 200)

    -- Grassy field
    love.graphics.setColor(0.2, 0.5, 0.2)
    love.graphics.rectangle("fill", 0, 200, 800, 400)

    -- Draw every flower
    for i = 1, #flowers do
        local f = flowers[i]

        -- Stem
        love.graphics.setColor(0.1, 0.55, 0.1)
        love.graphics.setLineWidth(3)
        love.graphics.line(f.x, f.y, f.x, f.y + 45)
        love.graphics.setLineWidth(1)

        -- Petals (5 small circles around the bloom for a flower shape)
        love.graphics.setColor(f.r * 0.8, f.g * 0.8, f.b * 0.8)
        for p = 0, 4 do
            local angle  = (p / 5) * math.pi * 2
            local petalX = f.x + math.cos(angle) * f.size * 0.8
            local petalY = f.y + math.sin(angle) * f.size * 0.8
            love.graphics.circle("fill", petalX, petalY, f.size * 0.6)
        end

        -- Central bloom
        love.graphics.setColor(f.r, f.g, f.b)
        love.graphics.circle("fill", f.x, f.y, f.size)

        -- Bright center dot
        love.graphics.setColor(1, 1, 0.6)
        love.graphics.circle("fill", f.x, f.y, f.size * 0.3)
    end

    -- UI overlay
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Click anywhere to plant a flower!", 10, 10)
    love.graphics.print("Flowers planted: " .. #flowers, 10, 30)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local newFlower = {
            x       = x,
            y       = y,
            r       = math.random(),
            g       = math.random(),
            b       = math.random(),
            size    = 0,                          -- starts tiny
            maxSize = math.random(12, 22),        -- grows to a random final size
        }
        table.insert(flowers, newFlower)
    end
end
