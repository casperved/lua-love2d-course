-- Assignment 28: GLSL Shaders
-- Starter file — fill in the three TODO sections to make the shaders work.
--
-- Controls:
--   1 = no shader (normal)
--   2 = grayscale      ← you write this one (TODO 1)
--   3 = scanlines      ← you write this one (TODO 2)
--   4 = colour tint    ← already done for you as a reference
--   5 = vignette       ← already done as a bonus example

SCREEN_W = 800
SCREEN_H = 600

-- Which shader mode is active (1–5). activeShader is nil when no effect is on.
shaderMode   = 1
activeShader = nil

-- A bouncing ball that gives the scene something interesting to look at.
ball = { x = 200, y = 300, vx = 140, vy = 90, r = 22 }

-- ─────────────────────────────────────────────
function love.load()
    love.window.setMode(SCREEN_W, SCREEN_H)
    love.window.setTitle("Assignment 28 – GLSL Shaders")

    -- We draw the whole scene into this canvas first, then show the canvas
    -- through a shader. That way the shader affects everything at once.
    sceneCanvas = love.graphics.newCanvas(SCREEN_W, SCREEN_H)

    -- ── TODO 1: Write the grayscale shader ───────────────────────────────────
    -- A grayscale shader reads each pixel, mixes the red/green/blue channels
    -- into a single brightness value, then uses that value for all three
    -- channels so the result looks grey.
    --
    -- The mixing weights (0.299, 0.587, 0.114) match how human eyes perceive
    -- brightness — green contributes most, blue least.
    --
    -- Uncomment and complete the lines below:
    --
    -- grayscaleShader = love.graphics.newShader([[
    --     vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    --         vec4 pixel = Texel(tex, texCoord) * color;
    --         float g = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
    --         return vec4(g, g, g, pixel.a);
    --     }
    -- ]])

    -- ── TODO 2: Write the scanlines shader ───────────────────────────────────
    -- A scanlines shader mimics old CRT televisions by darkening every other
    -- few rows of pixels. love_PixelCoord.y gives the current screen row
    -- (0, 1, 2, …). mod(y, 6.0) cycles from 0 to 5.9 — when it is less
    -- than 3.0 you are in a "dark" row and should multiply rgb by 0.5.
    --
    -- Uncomment and complete the lines below:
    --
    -- scanlinesShader = love.graphics.newShader([[
    --     vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    --         vec4 pixel = Texel(tex, texCoord) * color;
    --         if (mod(love_PixelCoord.y, 6.0) < 3.0) {
    --             pixel.rgb *= 0.5;
    --         }
    --         return pixel;
    --     }
    -- ]])

    -- ── Tint shader — already done for you as a reference ────────────────────
    -- This shader reads a uniform vec3 called "tint" that Lua sends every
    -- frame. A "uniform" is a variable you set from Lua and read in GLSL.
    tintShader = love.graphics.newShader([[
        uniform vec3 tint;
        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec4 pixel = Texel(tex, texCoord) * color;
            return vec4(pixel.rgb * tint, pixel.a);
        }
    ]])

    -- ── Vignette shader — bonus example ──────────────────────────────────────
    -- Darkens the corners to draw the eye toward the centre of the screen.
    -- length(uv) is the distance from the centre; smoothstep fades it nicely.
    vignetteShader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec4 pixel = Texel(tex, texCoord) * color;
            vec2 uv = texCoord - vec2(0.5);
            float dist = length(uv);
            float vignette = 1.0 - smoothstep(0.3, 0.75, dist);
            pixel.rgb *= vignette;
            return pixel;
        }
    ]])

    shaderNames = { "Normal", "Grayscale", "Scanlines", "Colour Tint", "Vignette" }
end

-- ─────────────────────────────────────────────
function love.update(dt)
    -- Move the ball and bounce it off each wall.
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    if ball.x - ball.r < 0 then
        ball.x = ball.r
        ball.vx = -ball.vx
    elseif ball.x + ball.r > SCREEN_W then
        ball.x = SCREEN_W - ball.r
        ball.vx = -ball.vx
    end

    if ball.y - ball.r < 0 then
        ball.y = ball.r
        ball.vy = -ball.vy
    elseif ball.y + ball.r > SCREEN_H then
        ball.y = SCREEN_H - ball.r
        ball.vy = -ball.vy
    end

    -- The tint shader needs a fresh colour every frame to pulse through a rainbow.
    if shaderMode == 4 then
        local t = love.timer.getTime()
        tintShader:send("tint", {
            0.5 + 0.5 * math.sin(t * 1.1),
            0.5 + 0.5 * math.sin(t * 0.7 + 2),
            0.5 + 0.5 * math.sin(t * 0.9 + 4)
        })
    end
end

-- ─────────────────────────────────────────────
function love.keypressed(key)
    if key == "1" then
        shaderMode   = 1
        activeShader = nil
    elseif key == "2" then
        shaderMode   = 2
        activeShader = grayscaleShader   -- will be nil until TODO 1 is done
    elseif key == "3" then
        shaderMode   = 3
        activeShader = scanlinesShader   -- will be nil until TODO 2 is done
    elseif key == "4" then
        shaderMode   = 4
        activeShader = tintShader
    elseif key == "5" then
        shaderMode   = 5
        activeShader = vignetteShader
    end
end

-- ─────────────────────────────────────────────
-- Draws the colourful scene (shapes + bouncing ball).
-- This is called while the render target is sceneCanvas, not the screen.
function drawScene()
    love.graphics.clear(0.15, 0.15, 0.25)

    -- Colourful background rectangles
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", 50,  80,  200, 120, 8, 8)

    love.graphics.setColor(0.2, 0.7, 0.3)
    love.graphics.rectangle("fill", 320, 200, 160, 160, 8, 8)

    love.graphics.setColor(0.2, 0.4, 0.9)
    love.graphics.rectangle("fill", 560, 60,  180, 100, 8, 8)

    love.graphics.setColor(0.9, 0.8, 0.1)
    love.graphics.rectangle("fill", 100, 380, 140, 140, 8, 8)

    love.graphics.setColor(0.8, 0.3, 0.9)
    love.graphics.rectangle("fill", 550, 350, 200, 130, 8, 8)

    -- Orange strip along the top
    love.graphics.setColor(1, 0.5, 0.1, 0.4)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, 40)

    -- Bouncing ball with a soft glow ring behind it
    love.graphics.setColor(1, 0.4, 0.1, 0.25)
    love.graphics.circle("fill", ball.x, ball.y, ball.r + 12)

    love.graphics.setColor(1, 0.6, 0.1)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)

    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.circle("line", ball.x, ball.y, ball.r)
end

-- ─────────────────────────────────────────────
function love.draw()
    -- Step 1: render the full scene into sceneCanvas (off-screen).
    love.graphics.setCanvas(sceneCanvas)
    love.graphics.clear()
    drawScene()
    love.graphics.setCanvas()   -- back to the real screen

    -- TODO 3: Apply activeShader when drawing sceneCanvas to the screen. ──────
    -- Right now the canvas is drawn with no shader (you just see the normal
    -- scene). Add two lines:
    --   • Before the draw call: love.graphics.setShader(activeShader)
    --   • After  the draw call: love.graphics.setShader()
    -- The second call resets the shader so the HUD below is drawn normally.
    --
    -- love.graphics.setShader(activeShader)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sceneCanvas, 0, 0)
    -- love.graphics.setShader()

    -- HUD — drawn after shader reset so it is always readable.
    love.graphics.setColor(0, 0, 0, 0.55)
    love.graphics.rectangle("fill", 6, 6, 280, 80, 4, 4)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press 1-5 to switch shader", 12, 12)
    love.graphics.print("Active: " .. shaderNames[shaderMode], 12, 32)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 12, 52)
end
