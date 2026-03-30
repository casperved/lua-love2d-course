-- Assignment 03B: Tables as Color Palettes (SOLUTION)
-- Three palettes, each holding three colors (one per ball).
-- Press Space to cycle through palettes.

palettes = {
    { {1,0.2,0.2}, {1,0.8,0.2}, {0.2,0.6,1} },   -- warm
    { {0.2,1,0.5}, {0.1,0.8,0.8}, {0.5,0.2,1} },  -- cool
    { {1,1,1}, {0.7,0.7,0.7}, {0.4,0.4,0.4} },    -- grayscale
}
currentPalette = 1

BALL_Y  = 300
BALL_X  = { 200, 400, 600 }
RADIUS  = 60

function love.load() end
function love.update(dt) end

function love.keypressed(key)
    if key == "space" then
        -- Modulo wraps the counter: 1→2→3→1→2→3→...
        currentPalette = currentPalette % #palettes + 1
    end
end

function love.draw()
    -- Dark background
    love.graphics.setColor(0.1, 0.1, 0.15)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw three circles, one color per slot in the current palette
    local pal = palettes[currentPalette]
    for i = 1, 3 do
        local c = pal[i]
        -- c[1] = red slot, c[2] = green slot, c[3] = blue slot
        love.graphics.setColor(c[1], c[2], c[3])
        love.graphics.circle("fill", BALL_X[i], BALL_Y, RADIUS)

        -- Subtle outline so balls are visible even on matching backgrounds
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.circle("line", BALL_X[i], BALL_Y, RADIUS)
    end

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Palette " .. currentPalette .. " of " .. #palettes .. "  (Space to cycle)", 10, 10)
    love.graphics.print("Press Space to change colors!", 10, 560)
end
