-- Assignment 03B: Tables as Color Palettes
-- A table holds several values together.
-- Access them with [1], [2], [3] — like numbered slots on a shelf.
-- Press Space to cycle through color palettes.

-- palettes is a table of palettes.
-- Each palette is a table of three colors.
-- Each color is a table: {red, green, blue} with values 0 to 1.
palettes = {
    -- Palette 1: warm tones (already done — study this as your template!)
    { {1,0.2,0.2}, {1,0.8,0.2}, {0.2,0.6,1} },

    -- TODO 1: Add palette 2 here — pick three colors you like.
    -- Each color is {red, green, blue}. Example: {0.2, 1, 0.5}

    -- TODO 2: Add palette 3 here — try something totally different!

}
currentPalette = 1

BALL_Y  = 300
BALL_X  = { 200, 400, 600 }  -- x positions of the three balls
RADIUS  = 60

function love.load() end
function love.update(dt) end

function love.keypressed(key)
    -- TODO 3: When Space is pressed, advance currentPalette to the next one.
    -- It should cycle: 1 → 2 → 3 → 1 → 2 → 3 → ...
    -- Hint: use the modulo operator % and #palettes.
    if key == "space" then
        -- your code here
    end
end

function love.draw()
    -- Dark background
    love.graphics.setColor(0.1, 0.1, 0.15)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- Draw three circles using the current palette.
    -- This loop is already written — read it to understand how table access works!
    local pal = palettes[currentPalette]
    for i = 1, 3 do
        local c = pal[i]
        -- c[1] is the red slot, c[2] is green, c[3] is blue
        love.graphics.setColor(c[1], c[2], c[3])
        love.graphics.circle("fill", BALL_X[i], BALL_Y, RADIUS)
    end

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Palette " .. currentPalette .. " of " .. #palettes .. "  (Space to cycle)", 10, 10)
    love.graphics.print("Press Space to change colors!", 10, 560)
end
