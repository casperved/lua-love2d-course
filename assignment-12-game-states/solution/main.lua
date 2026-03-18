-- Assignment 12: Game States — SOLUTION
-- Three states: "title", "playing", "gameover"

gameState = "title"

player = { x = 375, y = 500, w = 50, h = 30, speed = 300 }
enemy  = { x = 400, y = -40, w = 40, h = 40, speed = 200 }
lives  = 3
score  = 0

function love.load()
    math.randomseed(os.time())
    resetEnemy()
end

function resetEnemy()
    enemy.x = math.random(50, 750)
    enemy.y = -40
    enemy.speed = 200 + score * 5
end

function checkCollision(a, b)
    return a.x < b.x + b.w and a.x + a.w > b.x and
           a.y < b.y + b.h and a.y + a.h > b.y
end

function love.update(dt)
    if gameState == "playing" then
        -- Move player left/right, clamped to screen
        if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
        if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
        player.x = math.max(0, math.min(750, player.x))

        -- Move enemy down
        enemy.y = enemy.y + enemy.speed * dt

        -- Enemy dodged — score a point
        if enemy.y > 620 then
            score = score + 1
            resetEnemy()
        end

        -- Enemy hit player — lose a life
        if checkCollision(player, enemy) then
            lives = lives - 1
            resetEnemy()
            if lives <= 0 then
                gameState = "gameover"
            end
        end
    end
end

function love.draw()
    -- Background
    love.graphics.setColor(0.08, 0.08, 0.18)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    if gameState == "title" then
        -- Title screen
        love.graphics.setColor(0.3, 0.8, 1)
        love.graphics.print("DODGE!", 330, 180)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Avoid the falling red box.", 280, 250)
        love.graphics.print("Move with LEFT and RIGHT arrow keys.", 250, 275)
        love.graphics.print("You have 3 lives. Good luck!", 290, 300)

        love.graphics.setColor(0.9, 0.9, 0.3)
        love.graphics.print("Press ENTER to start!", 300, 370)

    elseif gameState == "playing" then
        -- Draw enemy
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)

        -- Draw player
        love.graphics.setColor(0.2, 0.8, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

        -- HUD
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score,  10, 10)
        love.graphics.print("Lives: " .. lives,  10, 30)
        love.graphics.print("Arrow keys to dodge!", 10, 560)

    elseif gameState == "gameover" then
        -- Dark overlay panel
        love.graphics.setColor(0, 0, 0, 0.65)
        love.graphics.rectangle("fill", 150, 200, 500, 200)

        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER", 330, 230)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("You dodged " .. score .. " times — not bad!", 270, 275)
        love.graphics.print("Press R to play again.", 305, 320)
        love.graphics.print("Press Escape to quit.", 310, 345)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if gameState == "title" and key == "return" then
        gameState = "playing"

    elseif gameState == "gameover" and key == "r" then
        -- Reset everything and go back to title
        gameState = "title"
        lives  = 3
        score  = 0
        player.x = 375
        resetEnemy()
    end
end
