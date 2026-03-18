-- Assignment 05: Bouncing Ball
-- The ball moves on its own and bounces off the walls!
-- Velocity (vx, vy) tells us how fast AND which direction it moves.
-- When a wall is hit, we flip the velocity with * -1 to reverse direction.

ballX = 400
ballY = 300
ballRadius = 25
ballVX = 250    -- horizontal speed: positive = moving right
ballVY = 180    -- vertical speed:   positive = moving down

SCREEN_W = 800
SCREEN_H = 600

function love.load()
end

function love.update(dt)
    -- Move the ball (this part is already done for you!)
    ballX = ballX + ballVX * dt
    ballY = ballY + ballVY * dt

    -- Now we need to check if the ball has hit any wall.
    -- If it has, we flip the matching velocity to make it bounce.
    -- We also snap the ball back so it doesn't get stuck past the wall.

    -- TODO 1: Bounce off the LEFT wall (x = 0)
    -- The left edge of the ball is ballX - ballRadius.
    -- If that is less than 0, flip ballVX and snap ballX back.
    -- if ballX - ballRadius < 0 then
    --     ballVX = ballVX * ?   -- flip direction!
    --     ballX = ballRadius    -- snap back to just touching the wall
    -- end

    -- TODO 2: Bounce off the RIGHT wall (x = SCREEN_W)
    -- The right edge of the ball is ballX + ballRadius.
    -- (Write the whole if block yourself!)

    -- TODO 3: Bounce off the TOP wall (y = 0)
    -- The top edge of the ball is ballY - ballRadius.

    -- TODO 4: Bounce off the BOTTOM wall (y = SCREEN_H)
    -- The bottom edge of the ball is ballY + ballRadius.
end

function love.draw()
    -- Background
    love.graphics.setColor(0.05, 0.05, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- The bouncing ball
    love.graphics.setColor(1, 0.4, 0.1)
    love.graphics.circle("fill", ballX, ballY, ballRadius)

    -- A bright outline to make it pop
    love.graphics.setColor(1, 0.7, 0.3)
    love.graphics.circle("line", ballX, ballY, ballRadius)

    -- Instructions
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Watch it bounce!  Press R to reset.", 10, 10)
end

function love.keypressed(key)
    -- Press R to reset the ball to the center
    if key == "r" then
        ballX = 400
        ballY = 300
        ballVX = 250
        ballVY = 180
    end
    -- Press Escape to quit
    if key == "escape" then
        love.event.quit()
    end
end
