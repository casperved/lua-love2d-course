-- Assignment 03c: Snowman
-- All positions and sizes flow from five master variables.
-- Change snowmanX or snowmanY and the whole snowman moves!

function love.load()
    love.window.setTitle("Snowman")
    love.window.setMode(800, 600)

    -- ── Master variables ───────────────────────────────────────────────────
    snowmanX      = 400   -- horizontal centre of the bottom circle
    snowmanY      = 440   -- vertical centre of the bottom circle
    bottomRadius  = 80
    middleRadius  = 55
    headRadius    = 38

    -- ── Derived positions (calculated once from the master variables) ──────
    middleY = snowmanY - bottomRadius - middleRadius
    headY   = middleY  - middleRadius - headRadius

    -- ── Hat dimensions (derived from headRadius so they always fit) ────────
    hatBrimW  = headRadius * 2.8   -- wide flat brim
    hatBrimH  = headRadius * 0.35
    hatTopW   = headRadius * 1.6   -- narrower top block
    hatTopH   = headRadius * 1.4

    -- ── Static snowflake positions (decoration only — not part of the system)
    snowflakes = {
        {x = 80,  y = 60},  {x = 160, y = 130}, {x = 30,  y = 200},
        {x = 620, y = 80},  {x = 710, y = 170}, {x = 760, y = 50},
        {x = 200, y = 320}, {x = 550, y = 260}, {x = 680, y = 310},
        {x = 100, y = 400}, {x = 490, y = 390}, {x = 730, y = 420},
    }
end

function love.draw()
    -- ── Night sky background ───────────────────────────────────────────────
    love.graphics.setColor(0.08, 0.10, 0.22)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- ── Snowy ground ───────────────────────────────────────────────────────
    love.graphics.setColor(0.92, 0.96, 1.0)
    love.graphics.rectangle("fill", 0, 530, 800, 70)
    -- soft edge on the snow surface
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 528, 800, 6)

    -- ── Decorative snowflakes ──────────────────────────────────────────────
    love.graphics.setColor(1, 1, 1, 0.7)
    for _, sf in ipairs(snowflakes) do
        love.graphics.circle("fill", sf.x, sf.y, 3)
    end

    -- ── Stick arms (lines) ─────────────────────────────────────────────────
    -- Left arm: extends up-left from the side of the middle circle
    love.graphics.setColor(0.45, 0.28, 0.10)
    love.graphics.setLineWidth(4)
    love.graphics.line(
        snowmanX - middleRadius,          middleY,
        snowmanX - middleRadius - 55,     middleY - 40
    )
    -- small twig on left arm
    love.graphics.line(
        snowmanX - middleRadius - 35,     middleY - 25,
        snowmanX - middleRadius - 50,     middleY - 50
    )
    -- Right arm
    love.graphics.line(
        snowmanX + middleRadius,          middleY,
        snowmanX + middleRadius + 55,     middleY - 40
    )
    -- small twig on right arm
    love.graphics.line(
        snowmanX + middleRadius + 35,     middleY - 25,
        snowmanX + middleRadius + 50,     middleY - 50
    )
    love.graphics.setLineWidth(1)

    -- ── Bottom circle ──────────────────────────────────────────────────────
    love.graphics.setColor(0.95, 0.98, 1.0)
    love.graphics.circle("fill", snowmanX, snowmanY, bottomRadius)
    love.graphics.setColor(0.80, 0.88, 0.95)   -- subtle outline
    love.graphics.circle("line", snowmanX, snowmanY, bottomRadius)

    -- ── Middle circle ──────────────────────────────────────────────────────
    love.graphics.setColor(0.95, 0.98, 1.0)
    love.graphics.circle("fill", snowmanX, middleY, middleRadius)
    love.graphics.setColor(0.80, 0.88, 0.95)
    love.graphics.circle("line", snowmanX, middleY, middleRadius)

    -- ── Three buttons down the middle circle ───────────────────────────────
    love.graphics.setColor(0.18, 0.14, 0.12)
    local btnSpacing = middleRadius * 0.55
    love.graphics.circle("fill", snowmanX, middleY - btnSpacing, 5)
    love.graphics.circle("fill", snowmanX, middleY,              5)
    love.graphics.circle("fill", snowmanX, middleY + btnSpacing, 5)

    -- ── Head circle ────────────────────────────────────────────────────────
    love.graphics.setColor(0.95, 0.98, 1.0)
    love.graphics.circle("fill", snowmanX, headY, headRadius)
    love.graphics.setColor(0.80, 0.88, 0.95)
    love.graphics.circle("line", snowmanX, headY, headRadius)

    -- ── Top hat (brim first, then the tall top block) ──────────────────────
    love.graphics.setColor(0.10, 0.10, 0.12)
    -- brim: centred on snowmanX, sits just above the head circle top
    local brimY = headY - headRadius - hatBrimH
    love.graphics.rectangle("fill",
        snowmanX - hatBrimW / 2,
        brimY,
        hatBrimW,
        hatBrimH
    )
    -- top block: centred, sits on top of the brim
    love.graphics.rectangle("fill",
        snowmanX - hatTopW / 2,
        brimY - hatTopH,
        hatTopW,
        hatTopH
    )
    -- hat band: a thin coloured stripe just above the brim
    love.graphics.setColor(0.65, 0.10, 0.10)
    love.graphics.rectangle("fill",
        snowmanX - hatTopW / 2,
        brimY - 9,
        hatTopW,
        9
    )

    -- ── Eyes (two dark dots) ───────────────────────────────────────────────
    love.graphics.setColor(0.12, 0.10, 0.10)
    love.graphics.circle("fill", snowmanX - headRadius * 0.35, headY - headRadius * 0.15, 5)
    love.graphics.circle("fill", snowmanX + headRadius * 0.35, headY - headRadius * 0.15, 5)

    -- ── Carrot nose (small orange rectangle, slightly angled would need push/pop
    --    so we use a simple horizontal rectangle) ───────────────────────────
    love.graphics.setColor(0.95, 0.45, 0.05)
    love.graphics.rectangle("fill",
        snowmanX - 2,
        headY + headRadius * 0.05,
        headRadius * 0.6,
        6
    )
    -- carrot tip highlight
    love.graphics.setColor(0.85, 0.35, 0.02)
    love.graphics.rectangle("fill",
        snowmanX + headRadius * 0.45,
        headY + headRadius * 0.05 + 1,
        headRadius * 0.15,
        4
    )

    -- ── Info label ─────────────────────────────────────────────────────────
    love.graphics.setColor(0.75, 0.85, 1.0)
    love.graphics.print(
        "Snowman at  x=" .. snowmanX .. "   y=" .. snowmanY,
        10, 10
    )
    love.graphics.print(
        "Try changing snowmanX / snowmanY at the top of love.load!",
        10, 30
    )
end
