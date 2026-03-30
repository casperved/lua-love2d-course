-- Assignment 05b: Gravity! (SOLUTION)
-- A ball that falls under gravity and bounces off all four walls.
-- The twist vs. assignment 05: one extra line each frame adds to vy,
-- making the ball accelerate downward just like a real rubber ball.

SCREEN_W  = 800
SCREEN_H  = 600
GRAVITY   = 500     -- pixels per second squared (try cranking this to 1200!)

ballX      = 400
ballY      = 100    -- starts near the top so there is room to fall
ballRadius = 22
ballVX     = 180    -- initial horizontal speed (pixels/sec)
ballVY     = 0      -- starts with zero vertical speed; gravity does the rest

-- Each floor bounce multiplies velocity by this — loses a little energy.
-- 1.0 = perfect bounce forever; 0.7 = dies out quickly.
BOUNCE_DAMPEN = 1.01

ballR = 1
ballG = 0.5
ballB = 0.1

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    -- ── Step 1: apply gravity ──────────────────────────────────────────
    -- Every frame, the ball falls a little faster.
    -- This mirrors real physics: acceleration = constant force / mass.
    ballVY = ballVY + GRAVITY * dt

    -- ── Step 2: move ──────────────────────────────────────────────────
    ballX = ballX + ballVX * dt
    ballY = ballY + ballVY * dt

    -- ── Step 3: bounce off LEFT wall ──────────────────────────────────
    if ballX - ballRadius < 0 then
        ballVX = -ballVX
        ballX  = ballRadius
        newRandomColor()
    end

    -- ── Step 4: bounce off RIGHT wall ─────────────────────────────────
    if ballX + ballRadius > SCREEN_W then
        ballVX = -ballVX
        ballX  = SCREEN_W - ballRadius
        newRandomColor()
    end

    -- ── Step 5: bounce off TOP wall ───────────────────────────────────
    -- (Rare with gravity, but the ball can still reach the ceiling if
    --  it starts with enough upward speed or after a hard bounce.)
    if ballY - ballRadius < 0 then
        ballVY = -ballVY * BOUNCE_DAMPEN
        ballY  = ballRadius
        newRandomColor()
    end

    -- ── Step 6: bounce off BOTTOM wall (the "floor") ──────────────────
    -- Multiply by -BOUNCE_DAMPEN instead of just -1 so the bounce
    -- is slightly shorter each time, like a real rubber ball.
    if ballY + ballRadius > SCREEN_H then
        ballVY = -ballVY * BOUNCE_DAMPEN
        ballY  = SCREEN_H - ballRadius
        newRandomColor()
    end
end

-- Helper: pick a random bright colour for the ball
function newRandomColor()
    ballR = math.random(5, 10) / 10
    ballG = math.random(2, 9)  / 10
    ballB = math.random(0, 8)  / 10
end

function love.draw()
    -- Dark background
    love.graphics.setColor(0.05, 0.05, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Subtle floor line so the learner can see the "ground"
    love.graphics.setColor(0.3, 0.3, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.line(0, SCREEN_H - 1, SCREEN_W, SCREEN_H - 1)
    love.graphics.setLineWidth(1)

    -- Soft glow behind the ball (dimmer version of ball colour)
    love.graphics.setColor(ballR * 0.35, ballG * 0.35, ballB * 0.35)
    love.graphics.circle("fill", ballX, ballY, ballRadius + 10)

    -- The ball itself
    love.graphics.setColor(ballR, ballG, ballB)
    love.graphics.circle("fill", ballX, ballY, ballRadius)

    -- Shiny outline
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.circle("line", ballX, ballY, ballRadius)

    -- Small specular highlight in the top-left of the ball
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.circle("fill", ballX - ballRadius * 0.3, ballY - ballRadius * 0.3, ballRadius * 0.25)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Gravity ball!  Press R to reset.", 10, 10)
    love.graphics.print("vx = " .. math.floor(ballVX) .. " px/s", 10, 30)

    -- Show vy in a different colour when falling vs rising — fun to watch!
    if ballVY > 0 then
        love.graphics.setColor(1, 0.6, 0.2)   -- orange = falling
    else
        love.graphics.setColor(0.4, 0.9, 1)   -- cyan = rising
    end
    love.graphics.print("vy = " .. math.floor(ballVY) .. " px/s  (falling speed)", 10, 50)

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("GRAVITY = " .. GRAVITY .. " px/s²   BOUNCE_DAMPEN = " .. BOUNCE_DAMPEN, 10, 70)
end

function love.keypressed(key)
    if key == "r" then
        -- Reset ball to starting state
        ballX  = 400
        ballY  = 100
        ballVX = 180
        ballVY = 0
        ballR  = 1
        ballG  = 0.5
        ballB  = 0.1
    end
    if key == "escape" then
        love.event.quit()
    end
end
