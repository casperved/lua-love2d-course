-- Assignment 03c: Snowman
-- Your job: fill in the TODO sections so a complete snowman appears.
-- The secret: ALL positions are calculated from just five variables at the top.
-- Change snowmanX and the WHOLE snowman moves. That's the power of variables!

function love.load()
    love.window.setTitle("Snowman")
    love.window.setMode(800, 600)

    -- ── TODO 1: Set the master variables ──────────────────────────────────
    -- These five numbers control the snowman's position and size.
    -- Good starting values: snowmanX=400, snowmanY=440, bottotmRadius=80,
    --                        middleRadius=55, headRadius=38
    snowmanX     = 0   -- TODO 1: try 400
    snowmanY     = 0   -- TODO 1: try 440
    bottomRadius = 0   -- TODO 1: try 80
    middleRadius = 0   -- TODO 1: try 55
    headRadius   = 0   -- TODO 1: try 38

    -- ── TODO 2: Calculate derived positions ───────────────────────────────
    -- The middle circle sits directly on top of the bottom circle.
    -- Its centre is:  snowmanY  MINUS  bottomRadius  MINUS  middleRadius
    -- The head sits on top of the middle circle in the same way.
    middleY = 0   -- TODO 2: snowmanY - bottomRadius - middleRadius
    headY   = 0   -- TODO 2: middleY  - middleRadius - headRadius

    -- ── Hat dimensions (you can leave these as-is or tweak them) ──────────
    hatBrimW = 106
    hatBrimH = 13
    hatTopW  = 61
    hatTopH  = 53
end

function love.draw()
    -- ── Night sky background (pre-filled — no changes needed) ─────────────
    love.graphics.setColor(0.08, 0.10, 0.22)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- ── Snowy ground (pre-filled — no changes needed) ─────────────────────
    love.graphics.setColor(0.92, 0.96, 1.0)
    love.graphics.rectangle("fill", 0, 530, 800, 70)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 528, 800, 6)

    -- ── Decorative snowflakes (pre-filled — no changes needed) ────────────
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.circle("fill", 80,  60,  3)
    love.graphics.circle("fill", 160, 130, 3)
    love.graphics.circle("fill", 30,  200, 3)
    love.graphics.circle("fill", 620, 80,  3)
    love.graphics.circle("fill", 710, 170, 3)
    love.graphics.circle("fill", 760, 50,  3)
    love.graphics.circle("fill", 200, 320, 3)
    love.graphics.circle("fill", 550, 260, 3)
    love.graphics.circle("fill", 680, 310, 3)

    -- ── TODO 3: Draw the stick arms ───────────────────────────────────────
    -- Use love.graphics.line() and love.graphics.setColor()
    -- Colour suggestion: brown  →  setColor(0.45, 0.28, 0.10)
    -- Left arm goes from the left edge of the middle circle outward-and-up.
    -- Right arm is the mirror image.
    -- (Leave this TODO as a comment for now; come back after the circles work)
    -- love.graphics.setColor(0.45, 0.28, 0.10)
    -- love.graphics.setLineWidth(4)
    -- love.graphics.line( ... )   -- left arm
    -- love.graphics.line( ... )   -- right arm
    -- love.graphics.setLineWidth(1)

    -- ── Bottom circle (pre-filled as an example) ──────────────────────────
    -- Notice how it uses snowmanX and snowmanY — try changing those values!
    love.graphics.setColor(0.95, 0.98, 1.0)
    love.graphics.circle("fill", snowmanX, snowmanY, bottomRadius)

    -- ── TODO 4: Draw the middle circle ────────────────────────────────────
    -- Same colour as the bottom circle.
    -- Centre: snowmanX (same horizontal position), middleY (calculated above).
    -- Radius: middleRadius.
    -- love.graphics.setColor( ... )
    -- love.graphics.circle("fill", snowmanX, middleY, middleRadius)

    -- ── TODO 5: Draw three button dots on the middle circle ───────────────
    -- Colour: very dark brown  →  setColor(0.18, 0.14, 0.12)
    -- Three small circles centred on snowmanX, spaced evenly along middleY.
    -- love.graphics.setColor( ... )
    -- love.graphics.circle("fill", snowmanX, middleY - ??, 5)
    -- love.graphics.circle("fill", snowmanX, middleY,      5)
    -- love.graphics.circle("fill", snowmanX, middleY + ??, 5)

    -- ── TODO 6: Draw the head circle ──────────────────────────────────────
    -- Centre: snowmanX, headY.   Radius: headRadius.
    -- love.graphics.setColor( ... )
    -- love.graphics.circle("fill", snowmanX, headY, headRadius)

    -- ── TODO 7: Draw the top hat ──────────────────────────────────────────
    -- Two rectangles: a wide flat brim and a taller narrow top.
    -- Both are centred on snowmanX.
    -- The brim sits just above the top of the head circle.
    -- Hint: the top of the head circle is at  headY - headRadius
    -- Hat colour suggestion: near-black  →  setColor(0.10, 0.10, 0.12)
    -- love.graphics.setColor( ... )
    -- local brimY = headY - headRadius - hatBrimH
    -- love.graphics.rectangle("fill", snowmanX - hatBrimW/2, brimY, hatBrimW, hatBrimH)
    -- love.graphics.rectangle("fill", snowmanX - hatTopW/2,  brimY - hatTopH, hatTopW, hatTopH)

    -- ── TODO 8: Draw the eyes ─────────────────────────────────────────────
    -- Two small dark circles on the head, one left of centre and one right.
    -- love.graphics.setColor(0.12, 0.10, 0.10)
    -- love.graphics.circle("fill", snowmanX - ??, headY - ??, 5)
    -- love.graphics.circle("fill", snowmanX + ??, headY - ??, 5)

    -- ── TODO 9: Draw the carrot nose ──────────────────────────────────────
    -- A small orange rectangle sticking out to the right of centre.
    -- Colour: orange  →  setColor(0.95, 0.45, 0.05)
    -- love.graphics.setColor(0.95, 0.45, 0.05)
    -- love.graphics.rectangle("fill", snowmanX - 2, headY + ??, headRadius * 0.6, 6)

    -- ── Info label (pre-filled) ───────────────────────────────────────────
    love.graphics.setColor(0.75, 0.85, 1.0)
    love.graphics.print("Snowman at  x=" .. snowmanX .. "   y=" .. snowmanY, 10, 10)
    love.graphics.print("Try changing snowmanX / snowmanY at the top of love.load!", 10, 30)
end
