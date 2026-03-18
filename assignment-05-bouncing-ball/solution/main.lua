-- Assignment 05: Bouncing Ball (SOLUTION)
-- A ball that moves and bounces off all four walls.
-- The key idea: flipping velocity (multiplying by -1) = bouncing!

ballX = 400
ballY = 300
ballRadius = 25
ballVX = 250    -- pixels per second, rightward
ballVY = 180    -- pixels per second, downward

SCREEN_W = 800
SCREEN_H = 600

-- We'll change color on each bounce for fun
ballColorR = 1
ballColorG = 0.4
ballColorB = 0.1

function love.load()
    math.randomseed(os.time())  -- seed random so colors are different each run
end

function love.update(dt)
    -- Move the ball
    ballX = ballX + ballVX * dt
    ballY = ballY + ballVY * dt

    -- Bounce off LEFT wall
    if ballX - ballRadius < 0 then
        ballVX = -ballVX            -- flip horizontal direction
        ballX = ballRadius          -- snap back so we don't get stuck
        newRandomColor()
    end

    -- Bounce off RIGHT wall
    if ballX + ballRadius > SCREEN_W then
        ballVX = -ballVX
        ballX = SCREEN_W - ballRadius
        newRandomColor()
    end

    -- Bounce off TOP wall
    if ballY - ballRadius < 0 then
        ballVY = -ballVY            -- flip vertical direction
        ballY = ballRadius
        newRandomColor()
    end

    -- Bounce off BOTTOM wall
    if ballY + ballRadius > SCREEN_H then
        ballVY = -ballVY
        ballY = SCREEN_H - ballRadius
        newRandomColor()
    end
end

-- Helper: pick a random bright color for the ball
function newRandomColor()
    ballColorR = math.random(5, 10) / 10
    ballColorG = math.random(2, 9)  / 10
    ballColorB = math.random(0, 8)  / 10
end

function love.draw()
    -- Dark background
    love.graphics.setColor(0.05, 0.05, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Soft glow behind the ball
    love.graphics.setColor(ballColorR * 0.4, ballColorG * 0.4, ballColorB * 0.4)
    love.graphics.circle("fill", ballX, ballY, ballRadius + 8)

    -- The ball itself
    love.graphics.setColor(ballColorR, ballColorG, ballColorB)
    love.graphics.circle("fill", ballX, ballY, ballRadius)

    -- Shiny outline
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", ballX, ballY, ballRadius)

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Watch it bounce!  Press R to reset.", 10, 10)
    love.graphics.print("Velocity:  vx=" .. math.floor(ballVX) .. "  vy=" .. math.floor(ballVY), 10, 30)
end

function love.keypressed(key)
    if key == "r" then
        ballX = 400
        ballY = 300
        ballVX = 250
        ballVY = 180
    end
    if key == "escape" then
        love.event.quit()
    end
end
