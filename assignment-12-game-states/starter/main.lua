-- Assignment 12: Game States
-- Most games have different "states": a menu, gameplay, game over, etc.
-- We use a variable to track which state we're in!

gameState = "title"  -- can be "title", "playing", or "gameover"

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
    -- TODO 1: Only run game logic when gameState == "playing"
    -- if gameState == "playing" then

        -- Move player left/right
        if love.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
        if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end

        -- Move enemy down
        enemy.y = enemy.y + enemy.speed * dt

        -- If enemy falls off bottom, score a point and reset
        if enemy.y > 620 then
            score = score + 1
            resetEnemy()
        end

        -- If enemy hits player, lose a life
        if checkCollision(player, enemy) then
            lives = lives - 1
            resetEnemy()
            -- TODO 2: If lives <= 0, change gameState to "gameover"
            -- if lives <= 0 then
            --     gameState = "gameover"
            -- end
        end

    -- end  (closes the gameState == "playing" check)
end

function love.draw()
    love.graphics.setColor(0.08, 0.08, 0.18)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    -- TODO 3: Draw different things depending on gameState
    -- if gameState == "title" then
    --     draw the title screen: game name, "Press Enter to start"
    -- elseif gameState == "playing" then
    --     draw the player, enemy, score, and lives
    -- elseif gameState == "gameover" then
    --     draw "Game Over", final score, "Press R to restart"
    -- end

    -- Placeholder so it doesn't look blank:
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Current state: " .. gameState, 10, 10)
    love.graphics.print("Fill in the TODOs!", 10, 30)
    -- Draw player and enemy as placeholders
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
end

function love.keypressed(key)
    -- TODO 4: Handle state transitions via keypresses
    -- if gameState == "title" and key == "return" then
    --     gameState = "playing"
    -- elseif gameState == "gameover" and key == "r" then
    --     gameState = "title"
    --     lives = 3
    --     score = 0
    --     resetEnemy()
    --     player.x = 375
    -- end
end
