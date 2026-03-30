-- Assignment 05b: Gravity!
-- Same bouncing ball as assignment 05, but now the ball falls under gravity.
-- One new line in love.update does all the magic. Can you find it?

SCREEN_W  = 800
SCREEN_H  = 600
GRAVITY   = 500     -- pixels per second squared

ballX      = 400
ballY      = 100    -- starts near the top so it has room to fall
ballRadius = 22
ballVX     = 180    -- initial horizontal speed (pixels/sec)
ballVY     = 0      -- starts with ZERO vertical speed — gravity handles the rest

-- Each bounce off the floor/ceiling multiplies velocity by this,
-- so the ball loses a little energy each time (like a real rubber ball).
BOUNCE_DAMPEN = 0.85

ballR = 1
ballG = 0.5
ballB = 0.1

function love.load()
    math.randomseed(os.time())
end

function love.update(dt)
    -- TODO 1: Apply gravity.
    -- Every frame, add a little more downward speed to ballVY.
    -- Hint: "gravity" means vy grows by GRAVITY pixels/sec every second.
    -- ballVY = ballVY + GRAVITY * dt

    -- TODO 2: Move the ball.
    -- Same as assignment 05 — add velocity * dt to each position.
    -- ballX = ballX + ballVX * dt
    -- ballY = ballY + ballVY * dt

    -- TODO 3: Bounce off the LEFT wall.
    -- The ball's left edge is: ballX - ballRadius
    if ballX - ballRadius < 0 then
        -- Flip horizontal velocity, snap, change colour (3 lines)
        -- ballVX = -ballVX
        -- ballX  = ballRadius
        -- newRandomColor()
    end

    -- TODO 4: Bounce off the RIGHT wall (at x = SCREEN_W).
    -- The ball's right edge is: ballX + ballRadius
    -- When should it flip? What should ballX snap to?

    -- TODO 5: Bounce off the TOP wall (at y = 0).
    -- The ball's top edge is: ballY - ballRadius
    -- With gravity the ball rarely hits the ceiling, but it can!
    -- Use BOUNCE_DAMPEN here too: ballVY = -ballVY * BOUNCE_DAMPEN

    -- TODO 6: Bounce off the BOTTOM wall (the "floor", at y = SCREEN_H).
    -- The ball's bottom edge is: ballY + ballRadius
    -- This is the main bounce. Use BOUNCE_DAMPEN so energy is lost:
    --   ballVY = -ballVY * BOUNCE_DAMPEN
    -- (This makes each bounce a little shorter than the last — very satisfying!)
end

-- Helper: pick a random bright colour for the ball (already done for you!)
function newRandomColor()
    ballR = math.random(5, 10) / 10
    ballG = math.random(2, 9)  / 10
    ballB = math.random(0, 8)  / 10
end

function love.draw()
    -- Dark background
    love.graphics.setColor(0.05, 0.05, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Subtle floor line
    love.graphics.setColor(0.3, 0.3, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.line(0, SCREEN_H - 1, SCREEN_W, SCREEN_H - 1)
    love.graphics.setLineWidth(1)

    -- Soft glow behind the ball
    love.graphics.setColor(ballR * 0.35, ballG * 0.35, ballB * 0.35)
    love.graphics.circle("fill", ballX, ballY, ballRadius + 10)

    -- The ball itself
    love.graphics.setColor(ballR, ballG, ballB)
    love.graphics.circle("fill", ballX, ballY, ballRadius)

    -- Shiny outline
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.circle("line", ballX, ballY, ballRadius)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Gravity ball!  Press R to reset.", 10, 10)
    love.graphics.print("vx = " .. math.floor(ballVX) .. " px/s", 10, 30)
    love.graphics.print("vy = " .. math.floor(ballVY) .. " px/s  (falling speed — watch it grow!)", 10, 50)
end

function love.keypressed(key)
    if key == "r" then
        -- Reset the ball to its starting position and speed
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
