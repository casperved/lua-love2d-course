-- Assignment 17: Procedural Generation
-- Instead of placing everything by hand, we let math.random() do it!
-- Press SPACE to generate a new random world.

TILE_SIZE = 40
COLS      = 20
ROWS      = 15

stars = {}   -- will hold {x, y, radius, brightness, phase} for each star
tiles = {}   -- 2D grid: tiles[row][col] = true means wall, false means floor

twinkleTime = 0   -- used to animate star brightness in love.update

function love.load()
    math.randomseed(os.time())   -- seed randomness with the clock so each run differs
    generate()
end

-- ============================================================
-- generate() — build a fresh random world
-- ============================================================
function generate()

    -- TODO 1: Fill the stars table with 120 random stars.
    -- Each star needs: x (0–800), y (0–600), radius (1–3),
    -- brightness (0.5–1.0 using math.random()*0.5+0.5),
    -- and a phase (math.random() * math.pi * 2  for the twinkle offset).
    stars = {}
    -- for i = 1, 120 do
    --     table.insert(stars, {
    --         x          = math.random(0, 800),
    --         y          = math.random(0, 600),
    --         radius     = math.random(1, 3),
    --         brightness = math.random() * 0.5 + 0.5,
    --         phase      = math.random() * math.pi * 2
    --     })
    -- end

    -- TODO 2: Build the dungeon tile grid.
    -- tiles[row][col] = true  means wall
    -- tiles[row][col] = false means floor
    -- Rule 1: border tiles (row 1, row ROWS, col 1, col COLS) are always walls.
    -- Rule 2: all other tiles are walls 30% of the time (math.random() < 0.3).
    tiles = {}
    -- for row = 1, ROWS do
    --     tiles[row] = {}
    --     for col = 1, COLS do
    --         local isBorder = (row == 1 or row == ROWS or col == 1 or col == COLS)
    --         tiles[row][col] = isBorder or (math.random() < 0.3)
    --     end
    -- end

end

-- ============================================================
-- love.update — advance the twinkle timer
-- ============================================================
function love.update(dt)
    twinkleTime = twinkleTime + dt
end

-- ============================================================
-- love.draw
-- ============================================================
function love.draw()
    -- Dark night sky background
    love.graphics.setColor(0.03, 0.03, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 3: Draw all the stars.
    -- Loop over every entry in the stars table.
    -- Use math.sin(twinkleTime * 2 + s.phase) * 0.15 to get a gentle twinkle amount.
    -- Clamp the final brightness: math.max(0.3, math.min(1, s.brightness + twinkle))
    -- Then call love.graphics.setColor and love.graphics.circle.
    -- for i = 1, #stars do
    --     local s       = stars[i]
    --     local twinkle = math.sin(twinkleTime * 2 + s.phase) * 0.15
    --     local bright  = math.max(0.3, math.min(1, s.brightness + twinkle))
    --     love.graphics.setColor(bright, bright, bright * 0.9 + 0.1)
    --     love.graphics.circle("fill", s.x, s.y, s.radius)
    -- end

    -- TODO 4: Draw the dungeon tiles.
    -- Loop over every row and column.
    -- If tiles[row][col] is true → wall colour (0.38, 0.28, 0.48)
    -- If tiles[row][col] is false → floor colour (0.09, 0.07, 0.14)
    -- Pixel position: x = (col-1)*TILE_SIZE,  y = (row-1)*TILE_SIZE
    -- Draw each tile as TILE_SIZE-1 wide and TILE_SIZE-1 tall (1 px gap between tiles).
    -- for row = 1, ROWS do
    --     for col = 1, COLS do
    --         if tiles[row] and tiles[row][col] then
    --             love.graphics.setColor(0.38, 0.28, 0.48)
    --         else
    --             love.graphics.setColor(0.09, 0.07, 0.14)
    --         end
    --         love.graphics.rectangle(
    --             "fill",
    --             (col - 1) * TILE_SIZE,
    --             (row - 1) * TILE_SIZE,
    --             TILE_SIZE - 1,
    --             TILE_SIZE - 1
    --         )
    --     end
    -- end

    -- Thin outline around the whole dungeon area
    love.graphics.setColor(0.55, 0.4, 0.7)
    love.graphics.rectangle("line", 0, 0, COLS * TILE_SIZE, ROWS * TILE_SIZE)

    -- Instruction text
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.print("Press SPACE to generate a new world!", 220, 570)
end

-- ============================================================
-- love.keypressed
-- ============================================================
function love.keypressed(key)
    if key == "space" then
        -- TODO 5: Call generate() to build a brand-new random world.
        -- generate()
    end
end
