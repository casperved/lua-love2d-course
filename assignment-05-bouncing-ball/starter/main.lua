-- Assignment 05: Bouncing Ball
-- A ball that moves on its own and bounces off all four walls.
-- Key idea: flipping a velocity (multiplying by -1) = bouncing!

ballX = 400
ballY = 300
ballRadius = 25
ballVX = 250    -- pixels per second, rightward
ballVY = 180    -- pixels per second, downward

SCREEN_W = 800
SCREEN_H = 600

-- Color of the ball (changes on each bounce once you wire it up)
ballColorR = 1
ballColorG = 0.4
ballColorB = 0.1

function love.load()
    math.randomseed(os.time())  -- so colors are different each run
end

function love.update(dt)
    -- Move the ball every frame (already done for you!)
    ballX = ballX + ballVX * dt
    ballY = ballY + ballVY * dt

    -- TODO 1: Bounce off the LEFT wall.
    -- The ball's left edge is: ballX - ballRadius
    -- When that goes below 0: flip ballVX, snap ballX, call newRandomColor()
    if ballX - ballRadius < 0 then
        -- write 3 lines here
    end

    -- TODO 2: Bounce off the RIGHT wall (at x = SCREEN_W).
    -- The ball's right edge is ballX + ballRadius.
    -- When should it flip? What should ballX snap to?

    -- TODO 3: Bounce off the TOP wall.

    -- TODO 4: Bounce off the BOTTOM wall.
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
    -- love.keypressed fires ONCE the moment a key is pressed — perfect for one-shot actions.
    -- (For smooth held movement, use love.keyboard.isDown instead — see assignment 04.)
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
