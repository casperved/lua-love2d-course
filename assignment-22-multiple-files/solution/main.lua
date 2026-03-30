-- Assignment 22 Solution: Multiple Files
-- Game loop and state machine. All game logic lives in the modules.

SCREEN_W = 800
SCREEN_H = 600

-- SOLUTION: require all three modules.
-- Each require call runs the corresponding .lua file and returns its table.
utils     = require("utils")
Player    = require("player")
Asteroids = require("asteroids")

-- Game state: "title", "playing", "gameover"
state = "title"
score = 0
lives = 3

-- VISUAL EXTRA: simple star field rendered on the title / playing screens
stars = {}

function buildStars()
    stars = {}
    for i = 1, 80 do
        stars[i] = {
            x     = math.random(0, SCREEN_W),
            y     = math.random(0, SCREEN_H),
            size  = math.random() * 1.5 + 0.5,
            speed = math.random(20, 60),
        }
    end
end

function love.load()
    love.window.setTitle("Asteroid Dodge — Assignment 22")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())

    buildStars()
    Player.init()
    Asteroids.init()
end

function love.update(dt)
    -- Stars scroll regardless of game state (visual extra)
    for _, s in ipairs(stars) do
        s.y = s.y + s.speed * dt
        if s.y > SCREEN_H then s.y = 0 end
    end

    if state ~= "playing" then return end

    Player.update(dt)
    Asteroids.update(dt)

    -- Collect newly dodged asteroids for scoring
    score = score + Asteroids.countNewDodged()

    -- Collision check using the real distance function
    if Asteroids.checkCollision(Player.x, Player.y, Player.radius) then
        lives = lives - 1
        Asteroids.init()
        if lives <= 0 then
            state = "gameover"
        end
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end

    if state == "title" and key == "space" then
        Player.init()
        Asteroids.init()
        score = 0
        lives = 3
        state = "playing"
    end

    if state == "gameover" and key == "space" then
        Player.init()
        Asteroids.init()
        score = 0
        lives = 3
        state = "playing"
    end

    if state == "gameover" and key == "q" then
        state = "title"
    end
end

-- ---------------------------------------------------------------
-- Drawing
-- ---------------------------------------------------------------

function drawCenteredText(text, y, size)
    size = size or "medium"
    love.graphics.setFont(love.graphics.newFont(
        size == "large" and 32 or size == "small" and 14 or 20))
    local w = love.graphics.getFont():getWidth(text)
    love.graphics.print(text, (SCREEN_W - w) / 2, y)
end

function drawStars()
    for _, s in ipairs(stars) do
        love.graphics.setColor(1, 1, 1, s.size * 0.4)
        love.graphics.circle("fill", s.x, s.y, s.size)
    end
end

function drawLives()
    -- Draw small heart icons for each remaining life
    love.graphics.setFont(love.graphics.newFont(16))
    for i = 1, lives do
        love.graphics.setColor(1, 0.3, 0.4)
        love.graphics.print("♥", SCREEN_W - 30 * i, 10)
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.06, 0.06, 0.10)

    -- Scrolling star field (visual extra)
    drawStars()

    if state == "title" then
        love.graphics.setColor(1, 1, 1)
        drawCenteredText("ASTEROID DODGE", 150, "large")

        love.graphics.setColor(0.7, 0.7, 0.7)
        drawCenteredText("Arrow keys to move. Dodge the rocks!", 220, "small")
        drawCenteredText("Rocks that pass you score a point. You have 3 lives.", 244, "small")

        love.graphics.setColor(1, 1, 0.4)
        drawCenteredText("Press SPACE to start", 320)

    elseif state == "playing" then
        Asteroids.draw()
        Player.draw()

        -- HUD
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score, 10, 10)
        drawLives()

    elseif state == "gameover" then
        love.graphics.setColor(1, 0.4, 0.4)
        drawCenteredText("GAME OVER", 160, "large")

        love.graphics.setColor(1, 1, 1)
        drawCenteredText("Final Score: " .. score, 250)

        love.graphics.setColor(0.7, 0.7, 0.7)
        drawCenteredText("SPACE — play again     Q — title", 450, "small")
    end
end
