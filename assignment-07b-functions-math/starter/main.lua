-- Assignment 07B: Functions with Math
-- Use math.cos and math.sin to build star shapes, then fill a sky with them.

-- Stars defined as {x, y, outerR, innerR, r, g, b}
-- (This table is pre-filled — it's boilerplate, not the learning target.)
local starfield = {
    -- Large feature stars
    {400, 110, 55, 22, 1.00, 0.92, 0.20},
    {120, 260, 40, 16, 0.70, 0.85, 1.00},
    {680, 350, 38, 15, 1.00, 0.55, 0.35},
    -- Medium stars
    {220,  70, 26, 10, 1.00, 1.00, 0.85},
    {560, 130, 22,  9, 0.85, 1.00, 0.85},
    {730,  80, 20,  8, 1.00, 0.80, 1.00},
    {310, 410, 24, 10, 0.80, 0.90, 1.00},
    {590, 460, 22,  9, 1.00, 0.95, 0.60},
    -- Small background stars
    { 60, 140, 12,  5, 0.90, 0.90, 1.00},
    {170, 380, 11,  4, 1.00, 1.00, 1.00},
    {470, 300, 10,  4, 0.70, 1.00, 0.90},
    {650, 220, 13,  5, 1.00, 0.85, 0.60},
    {760, 490,  9,  4, 1.00, 1.00, 0.80},
}

-- ============================================================
-- TODO 1: Write the drawStar function.
-- Signature: function drawStar(x, y, outerR, innerR, r, g, b)
--
-- A 5-pointed star has 10 vertices alternating between outer tips and inner
-- notches. The loop below visits all 10 vertices — fill in the body.
--
-- PLACEHOLDER — replace this with the real function.
function drawStar(x, y, outerR, innerR, r, g, b)
    -- PLACEHOLDER — replace this
    love.graphics.setColor(r, g, b, 0.3)
    love.graphics.circle("fill", x, y, outerR * 0.5)
end
-- When you write the real function:
--   1. Create a local empty table called verts.
--   2. Use this loop header (fill in the body):
--        for i = 0, 9 do
--   3. Inside the loop:
--      - Calculate the angle for this vertex:
--        angle = math.pi * i / 5 - math.pi / 2
--      - Decide the radius: if i is even use outerR, if odd use innerR.
--        Hint: (i % 2 == 0) is true when i is even.
--      - Calculate the vertex x position: x + math.cos(angle) * radius
--      - Calculate the vertex y position: y + math.sin(angle) * radius
--      - table.insert both into verts.
--   4. After the loop: setColor, then polygon("fill", verts).
-- ============================================================

-- ============================================================
-- TODO 2: Write the drawShootingStar function.
-- Signature: function drawShootingStar(x, y)
--
-- A shooting star is two things at the same spot:
--   a) A faint white line going from (x-70, y-35) to (x, y)  — the tail.
--   b) A small star at (x, y) drawn by calling drawStar.
function drawShootingStar(x, y)
    -- your code here
end
-- ============================================================

function love.load()
    math.randomseed(42)
end

function love.update(dt)
end

function love.draw()
    -- Night sky background
    love.graphics.setColor(0.03, 0.03, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setColor(0.06, 0.04, 0.18)
    love.graphics.rectangle("fill", 0, 0, 800, 200)

    -- TODO 3: Loop through the starfield table using ipairs and call drawStar
    -- for each entry. Each entry s holds: s[1]=x, s[2]=y, s[3]=outerR,
    -- s[4]=innerR, s[5]=r, s[6]=g, s[7]=b.
    -- Hint: for i, s in ipairs(starfield) do

    -- TODO 4: Call drawShootingStar twice for two shooting stars.
    -- Suggested positions: (650, 60) and (300, 180).

    -- Tiny glint dots for extra depth (pre-filled for you)
    love.graphics.setColor(1, 1, 1, 0.6)
    local dots = {
        {50,50},{150,200},{500,80},{720,160},{380,500},
        {80,480},{600,540},{240,530},{760,320},{430,380},
    }
    for _, d in ipairs(dots) do
        love.graphics.circle("fill", d[1], d[2], 2)
    end

    love.graphics.setColor(0.5, 0.5, 0.8, 0.9)
    love.graphics.print("A hand-crafted starfield — all drawn with drawStar()!", 10, 575)
end
