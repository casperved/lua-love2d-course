-- Assignment 20: Final Project — YOUR GAME!
-- This is your blank canvas. Build whatever game you want!
-- The template below gives you a working starting point.

-- ============================================================
-- GAME SETTINGS (change these!)
-- ============================================================
SCREEN_W   = 800
SCREEN_H   = 600
GAME_TITLE = "My Awesome Game"  -- change this to your game's name

-- ============================================================
-- GAME STATE
-- ============================================================
gameState = "title"  -- "title", "playing", "gameover"

-- ============================================================
-- PLAYER  (feel free to rename or redesign)
-- ============================================================
player = {
    x     = SCREEN_W / 2,
    y     = SCREEN_H / 2,
    w     = 40,
    h     = 40,
    speed = 250,
    -- Add more fields as you need them:
    -- health  = 3,
    -- score   = 0,
    -- jumping = false,
    -- vy      = 0,   -- for gravity / jumping
}

-- ============================================================
-- Add your other game objects here:
-- enemies   = {}
-- bullets   = {}
-- platforms = {}
-- ============================================================

-- ============================================================
-- love.load — runs once at startup
-- ============================================================
function love.load()
    math.randomseed(os.time())
    -- Load images, sounds, fonts here.
    -- Example: myImage = love.graphics.newImage("player.png")
end

-- ============================================================
-- love.update — runs every frame (dt = seconds since last frame)
-- ============================================================
function love.update(dt)
    if gameState == "title" then
        -- Nothing to update on the title screen yet.

    elseif gameState == "playing" then
        -- === PLAYER MOVEMENT ===
        -- Basic 4-direction movement (customize or replace):
        if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            player.x = player.x + player.speed * dt
        end
        if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then
            player.y = player.y - player.speed * dt
        end
        if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then
            player.y = player.y + player.speed * dt
        end

        -- Keep player on screen (optional — remove if your game scrolls):
        player.x = math.max(0, math.min(SCREEN_W - player.w, player.x))
        player.y = math.max(0, math.min(SCREEN_H - player.h, player.y))

        -- === ADD YOUR GAME LOGIC HERE ===
        -- Ideas:
        --   Update enemies
        --   Move bullets
        --   Check collisions
        --   Tick timers
        --   Spawn things

    elseif gameState == "gameover" then
        -- Nothing to update on the game-over screen.
    end
end

-- ============================================================
-- love.draw — runs every frame to draw everything
-- ============================================================
function love.draw()
    -- Background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    if gameState == "title" then
        -- === TITLE SCREEN ===
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print(GAME_TITLE, SCREEN_W / 2 - 80, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press ENTER to start!", SCREEN_W / 2 - 70, 300)

    elseif gameState == "playing" then
        -- === GAME SCREEN ===
        -- Draw your game objects here!

        -- Player (a simple rectangle for now — replace with your art!)
        love.graphics.setColor(0.3, 0.8, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

        -- Draw enemies, bullets, platforms, etc.

        -- HUD (score, lives, timer — connect these to your real variables)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: 0", 10, 10)  -- replace 0 with your score variable

    elseif gameState == "gameover" then
        -- === GAME OVER SCREEN ===
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.print("GAME OVER", SCREEN_W / 2 - 45, 230)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press R to play again.", SCREEN_W / 2 - 70, 300)
    end
end

-- ============================================================
-- love.keypressed — fires once when a key is first pressed
-- ============================================================
function love.keypressed(key)
    if gameState == "title" and key == "return" then
        gameState = "playing"
        -- Reset your game variables here!

    elseif gameState == "gameover" and key == "r" then
        gameState = "playing"
        -- Reset your game variables here!
        player.x = SCREEN_W / 2
        player.y = SCREEN_H / 2

    elseif key == "escape" then
        love.event.quit()
    end
end

-- ============================================================
-- love.mousepressed — fires when a mouse button is clicked
-- ============================================================
function love.mousepressed(x, y, button)
    -- Handle mouse clicks here (if your game uses them).
end

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

-- Rectangle vs rectangle collision (from Assignment 11!)
function checkCollision(a, b)
    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end

-- Distance between two points (from Assignment 10!)
function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Add your own helper functions below!
