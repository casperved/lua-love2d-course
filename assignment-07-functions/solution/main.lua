-- Assignment 07: Functions — SOLUTION

-- Draw a 5-pointed star centered at (x, y).
-- outerR = tip radius, innerR = notch radius, (r,g,b) = color.
function drawStar(x, y, outerR, innerR, r, g, b)
    local verts = {}
    for i = 0, 9 do
        local angle  = math.pi * i / 5 - math.pi / 2
        local radius = (i % 2 == 0) and outerR or innerR
        table.insert(verts, x + math.cos(angle) * radius)
        table.insert(verts, y + math.sin(angle) * radius)
    end
    love.graphics.setColor(r, g, b)
    love.graphics.polygon("fill", verts)
end

-- A shooting star: a small star with a fading line tail.
function drawShootingStar(x, y)
    love.graphics.setColor(1, 1, 1, 0.35)
    love.graphics.setLineWidth(2)
    love.graphics.line(x - 70, y - 35, x, y)
    love.graphics.setLineWidth(1)
    drawStar(x, y, 14, 6, 1, 1, 0.85)
end

-- Stars defined as {x, y, outerR, innerR, r, g, b}
local starfield = {
    -- Large feature stars
    {400, 110, 55, 22, 1.00, 0.92, 0.20},   -- golden, centre-top
    {120, 260, 40, 16, 0.70, 0.85, 1.00},   -- icy blue, left
    {680, 350, 38, 15, 1.00, 0.55, 0.35},   -- orange-red, right
    -- Medium stars
    {220,  70, 26, 10, 1.00, 1.00, 0.85},
    {560, 130, 22,  9, 0.85, 1.00, 0.85},
    {730,  80, 20,  8, 1.00, 0.80, 1.00},   -- pink
    {310, 410, 24, 10, 0.80, 0.90, 1.00},
    {590, 460, 22,  9, 1.00, 0.95, 0.60},
    -- Small background stars
    { 60, 140, 12,  5, 0.90, 0.90, 1.00},
    {170, 380, 11,  4, 1.00, 1.00, 1.00},
    {470, 300, 10,  4, 0.70, 1.00, 0.90},
    {650, 220, 13,  5, 1.00, 0.85, 0.60},
    {760, 490,  9,  4, 1.00, 1.00, 0.80},
}

function love.load()
    math.randomseed(42)
end

function love.update(dt)
end

function love.draw()
    -- Night sky gradient (approximate with two rectangles)
    love.graphics.setColor(0.03, 0.03, 0.12)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setColor(0.06, 0.04, 0.18)
    love.graphics.rectangle("fill", 0, 0, 800, 200)

    -- Draw all stars from the table
    for _, s in ipairs(starfield) do
        drawStar(s[1], s[2], s[3], s[4], s[5], s[6], s[7])
    end

    -- Shooting stars across the upper sky
    drawShootingStar(650,  60)
    drawShootingStar(300, 180)

    -- Tiny glint dots for extra depth
    love.graphics.setColor(1, 1, 1, 0.6)
    local dots = {
        {50,50},{150,200},{500,80},{720,160},{380,500},
        {80,480},{600,540},{240,530},{760,320},{430,380},
    }
    for _, d in ipairs(dots) do
        love.graphics.circle("fill", d[1], d[2], 2)
    end

    -- Label
    love.graphics.setColor(0.5, 0.5, 0.8, 0.9)
    love.graphics.print("A hand-crafted starfield — all drawn with drawStar()!", 10, 575)
end
