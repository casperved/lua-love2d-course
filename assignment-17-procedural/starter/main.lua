-- Assignment 17: Procedural Generation
-- Instead of placing everything by hand, we let math.random() do it!
-- Press SPACE to generate a new random world.

TILE_SIZE = 40
COLS = 20
ROWS = 15

stars = {}      -- list of {x, y, radius, brightness}
tiles = {}      -- 2D grid: tiles[row][col] = true means wall

function love.load()
    math.randomseed(os.time())
    generate()
end

function generate()
    -- TODO 1: Clear and regenerate the stars table.
    -- Create 120 stars with random x (0-800), random y (0-600),
    -- random radius (1-3), and random brightness (0.5-1.0).
    stars = {}
    -- for i = 1, 120 do
    --     table.insert(stars, {
    --         x = math.random(0, 800),
    --         y = math.random(0, 600),
    --         radius = math.random(1, 3),
    --         brightness = math.random() * 0.5 + 0.5
    --     })
    -- end

    -- TODO 2: Generate the dungeon tile grid.
    -- For each row and column, randomly decide if it's a wall (30% chance).
    -- Always make the border cells walls.
    tiles = {}
    -- for row = 1, ROWS do
    --     tiles[row] = {}
    --     for col = 1, COLS do
    --         local isBorder = (row == 1 or row == ROWS or col == 1 or col == COLS)
    --         tiles[row][col] = isBorder or (math.random() < 0.3)
    --     end
    -- end
end

function love.update(dt)
end

function love.draw()
    -- Night sky background
    love.graphics.setColor(0.03, 0.03, 0.1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 3: Draw all the stars
    -- for i = 1, #stars do
    --     local s = stars[i]
    --     love.graphics.setColor(s.brightness, s.brightness, s.brightness)
    --     love.graphics.circle("fill", s.x, s.y, s.radius)
    -- end

    -- TODO 4: Draw the dungeon tiles
    -- (col-1)*TILE_SIZE and (row-1)*TILE_SIZE give the pixel position
    -- for row = 1, ROWS do
    --     for col = 1, COLS do
    --         if tiles[row] and tiles[row][col] then
    --             love.graphics.setColor(0.4, 0.3, 0.5)
    --         else
    --             love.graphics.setColor(0.1, 0.08, 0.15)
    --         end
    --         love.graphics.rectangle("fill", (col-1)*TILE_SIZE, (row-1)*TILE_SIZE, TILE_SIZE-1, TILE_SIZE-1)
    --     end
    -- end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press SPACE to generate a new world!", 220, 570)
end

function love.keypressed(key)
    if key == "space" then
        -- TODO 5: Call generate() to create a new random world
        -- generate()
    end
end
