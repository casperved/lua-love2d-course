-- Assignment 17: Procedural Generation — SOLUTION
-- Press SPACE to regenerate the world. Every press gives a new result!

TILE_SIZE = 40
COLS      = 20
ROWS      = 15

stars = {}
tiles = {}

-- Twinkling state: each star has a phase offset so they don't all pulse together
twinkleTime = 0

function love.load()
    math.randomseed(os.time())
    generate()
end

-- ============================================================
-- generate() — build a fresh random world
-- ============================================================
function generate()
    -- === Stars (TODO 1 — complete) ===
    stars = {}
    for i = 1, 120 do
        table.insert(stars, {
            x          = math.random(0, 800),
            y          = math.random(0, 600),
            radius     = math.random(1, 3),
            brightness = math.random() * 0.5 + 0.5,
            phase      = math.random() * math.pi * 2   -- random twinkle offset
        })
    end

    -- === Dungeon tile grid (TODO 2 — complete) ===
    -- tiles[row][col] = true  means wall
    -- tiles[row][col] = false means floor
    tiles = {}
    for row = 1, ROWS do
        tiles[row] = {}
        for col = 1, COLS do
            local isBorder = (row == 1 or row == ROWS or col == 1 or col == COLS)
            -- Border cells are always walls; interior cells: 30% chance of wall
            tiles[row][col] = isBorder or (math.random() < 0.3)
        end
    end
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

    -- === Draw stars (TODO 3 — complete) ===
    for i = 1, #stars do
        local s = stars[i]
        -- Gentle twinkle: oscillate brightness slightly using sin()
        local twinkle   = math.sin(twinkleTime * 2 + s.phase) * 0.15
        local bright    = math.max(0.3, math.min(1, s.brightness + twinkle))
        love.graphics.setColor(bright, bright, bright * 0.9 + 0.1)
        love.graphics.circle("fill", s.x, s.y, s.radius)
    end

    -- === Draw dungeon tiles (TODO 4 — complete) ===
    for row = 1, ROWS do
        for col = 1, COLS do
            if tiles[row] and tiles[row][col] then
                -- Wall: dark purple-grey
                love.graphics.setColor(0.38, 0.28, 0.48)
            else
                -- Floor: very dark, with a faint blue tint
                love.graphics.setColor(0.09, 0.07, 0.14)
            end
            love.graphics.rectangle(
                "fill",
                (col - 1) * TILE_SIZE,
                (row - 1) * TILE_SIZE,
                TILE_SIZE - 1,
                TILE_SIZE - 1
            )
        end
    end

    -- Thin outline around the whole dungeon
    love.graphics.setColor(0.55, 0.4, 0.7)
    love.graphics.rectangle("line", 0, 0, COLS * TILE_SIZE, ROWS * TILE_SIZE)

    -- Instruction text at the bottom
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.print("Press SPACE to generate a new world!", 220, 570)
end

-- ============================================================
-- love.keypressed
-- ============================================================
function love.keypressed(key)
    if key == "space" then
        generate()   -- TODO 5 — complete
    end
end
