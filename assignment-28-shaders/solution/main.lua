-- Assignment 28: GLSL Shaders — SOLUTION
-- A colourful scene with four switchable post-process shader effects.

SCREEN_W = 800
SCREEN_H = 600

shaderMode   = 1
activeShader = nil

ball = { x = 200, y = 300, vx = 140, vy = 90, r = 22 }

-- ─────────────────────────────────────────────
function love.load()
    love.window.setMode(SCREEN_W, SCREEN_H)
    love.window.setTitle("Assignment 28 – GLSL Shaders (Solution)")

    sceneCanvas = love.graphics.newCanvas(SCREEN_W, SCREEN_H)

    -- ── Grayscale shader ─────────────────────────────────────────────
    -- Converts every pixel to its luminance value using standard weights.
    grayscaleShader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec4 pixel = Texel(tex, texCoord) * color;
            float g = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
            return vec4(g, g, g, pixel.a);
        }
    ]])

    -- ── Scanlines shader ─────────────────────────────────────────────
    -- Dims every other 3-pixel horizontal band, mimicking a CRT display.
    scanlinesShader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec4 pixel = Texel(tex, texCoord) * color;
            if (mod(love_PixelCoord.y, 6.0) < 3.0) {
                pixel.rgb *= 0.5;
            }
            return pixel;
        }
    ]])

    -- ── Colour tint shader ───────────────────────────────────────────
    -- Multiplies rgb by a uniform vec3 sent from Lua each frame.
    tintShader = love.graphics.newShader([[
        uniform vec3 tint;
        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec4 pixel = Texel(tex, texCoord) * color;
            return vec4(pixel.rgb * tint, pixel.a);
        }
    ]])

    -- Visual extra 1: a vignette shader available as a fifth mode (press 5)
    -- Darkens the corners to draw attention to the centre.
    vignetteShader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec4 pixel = Texel(tex, texCoord) * color;
            vec2 uv = texCoord - vec2(0.5);          // centre at 0,0
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
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    if ball.x - ball.r < 0 then
        ball.x = ball.r;  ball.vx = -ball.vx
    elseif ball.x + ball.r > SCREEN_W then
        ball.x = SCREEN_W - ball.r;  ball.vx = -ball.vx
    end

    if ball.y - ball.r < 0 then
        ball.y = ball.r;  ball.vy = -ball.vy
    elseif ball.y + ball.r > SCREEN_H then
        ball.y = SCREEN_H - ball.r;  ball.vy = -ball.vy
    end

    -- Update the pulsing tint uniform every frame
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
    if     key == "1" then shaderMode = 1; activeShader = nil
    elseif key == "2" then shaderMode = 2; activeShader = grayscaleShader
    elseif key == "3" then shaderMode = 3; activeShader = scanlinesShader
    elseif key == "4" then shaderMode = 4; activeShader = tintShader
    elseif key == "5" then shaderMode = 5; activeShader = vignetteShader
    end
end

-- ─────────────────────────────────────────────
function drawScene()
    love.graphics.clear(0.15, 0.15, 0.25)

    -- Background shapes
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

    -- Visual extra 2: a simple gradient strip across the top using two triangles
    love.graphics.setColor(1, 0.5, 0.1, 0.4)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, 40)

    -- Moving ball with a glow ring
    love.graphics.setColor(1, 0.4, 0.1, 0.25)
    love.graphics.circle("fill", ball.x, ball.y, ball.r + 12)

    love.graphics.setColor(1, 0.6, 0.1)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)

    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.circle("line", ball.x, ball.y, ball.r)
end

-- ─────────────────────────────────────────────
function love.draw()
    -- Step 1: render the full scene into sceneCanvas
    love.graphics.setCanvas(sceneCanvas)
    love.graphics.clear()
    drawScene()
    love.graphics.setCanvas()

    -- Step 2: draw the canvas through the active shader (nil = passthrough)
    love.graphics.setShader(activeShader)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sceneCanvas, 0, 0)
    love.graphics.setShader()   -- always reset — draw HUD without any shader

    -- HUD
    love.graphics.setColor(0, 0, 0, 0.55)
    love.graphics.rectangle("fill", 6, 6, 280, 80, 4, 4)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press 1-5 to switch shader", 12, 12)
    love.graphics.print("Active: " .. shaderNames[shaderMode], 12, 32)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 12, 52)
end
