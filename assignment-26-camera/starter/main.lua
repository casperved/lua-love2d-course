-- Assignment 26: Camera & Scrolling World
-- Starter file — fill in the three TODO sections to make the camera work!

SCREEN_W   = 800
SCREEN_H   = 600
LEVEL_W    = 2400   -- the world is 3 screens wide

GRAVITY    = 800
MOVE_SPEED = 220
JUMP_SPEED = -500

-- Smooth camera lag (visual extra — already set up for you)
CAM_LAG = 6   -- higher = snappier; lower = floatier

-- Camera position: how many pixels from the left edge of the world we are showing.
-- Both start at 0 (looking at the very start of the level).
camX       = 0
camXSmooth = 0   -- this is the one we actually use in translate (lerps toward camX)

player = {
    x  = 80,
    y  = 500,
    w  = 36,
    h  = 48,
    vx = 0,
    vy = 0,
    onGround = false,
}

platforms = {
    { x = 100,  y = 460, w = 160, h = 18 },
    { x = 340,  y = 380, w = 150, h = 18 },
    { x = 560,  y = 300, w = 170, h = 18 },
    { x = 800,  y = 420, w = 140, h = 18 },
    { x = 1000, y = 330, w = 180, h = 18 },
    { x = 1240, y = 250, w = 150, h = 18 },
    { x = 1480, y = 370, w = 160, h = 18 },
    { x = 1700, y = 290, w = 140, h = 18 },
    { x = 1930, y = 430, w = 170, h = 18 },
    { x = 2150, y = 340, w = 200, h = 18 },
}

floor = { x = 0, y = SCREEN_H - 20, w = LEVEL_W, h = 20 }

coins = {
    { x = 180,  y = 430, r = 10, collected = false },
    { x = 415,  y = 350, r = 10, collected = false },
    { x = 645,  y = 270, r = 10, collected = false },
    { x = 870,  y = 390, r = 10, collected = false },
    { x = 1090, y = 300, r = 10, collected = false },
    { x = 1315, y = 220, r = 10, collected = false },
    { x = 1560, y = 340, r = 10, collected = false },
    { x = 1775, y = 260, r = 10, collected = false },
    { x = 2015, y = 400, r = 10, collected = false },
    { x = 2250, y = 310, r = 10, collected = false },
}

score      = 0
totalCoins = #coins

-- Timer used to animate coins bobbing up and down
coinTimer = 0

function love.load()
    love.window.setTitle("Assignment 26 – Camera & Scrolling World")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())
end

function love.update(dt)
    player.onGround = false
    coinTimer = coinTimer + dt

    -- Gravity and vertical movement
    player.vy = player.vy + GRAVITY * dt
    player.y  = player.y  + player.vy * dt

    -- Horizontal movement
    player.vx = 0
    if love.keyboard.isDown("left")  then player.vx = -MOVE_SPEED end
    if love.keyboard.isDown("right") then player.vx =  MOVE_SPEED end
    player.x = player.x + player.vx * dt

    -- Clamp player to level bounds
    player.x = math.max(0, math.min(player.x, LEVEL_W - player.w))

    -- Platform landing
    local allSurfaces = {}
    for i = 1, #platforms do allSurfaces[i] = platforms[i] end
    allSurfaces[#allSurfaces + 1] = floor

    for i = 1, #allSurfaces do
        local p  = allSurfaces[i]
        local ox = player.x < p.x + p.w and player.x + player.w > p.x
        local oy = player.y < p.y + p.h and player.y + player.h > p.y
        if ox and oy and player.vy > 0 then
            player.y        = p.y - player.h
            player.vy       = 0
            player.onGround = true
        end
    end

    -- Jumping
    if player.onGround then
        if love.keyboard.isDown("space") or love.keyboard.isDown("up") then
            player.vy       = JUMP_SPEED
            player.onGround = false
        end
    end

    -- Coin collection
    for i = 1, #coins do
        local c = coins[i]
        if not c.collected then
            local cx = c.x - (player.x + player.w / 2)
            local cy = c.y - (player.y + player.h / 2)
            if math.sqrt(cx * cx + cy * cy) < c.r + 14 then
                c.collected = true
                score = score + 1
            end
        end
    end

    -- =========================================================
    -- TODO 1: Calculate camX
    --   You want the player to sit in the middle of the screen.
    --   Set camX so the centre of the player lines up with the
    --   centre of the screen.  Then clamp it so it never goes
    --   below 0 or above LEVEL_W - SCREEN_W.
    -- =========================================================
    -- camX = player.x + player.w / 2 - SCREEN_W / 2
    -- camX = math.max(0, math.min(camX, LEVEL_W - SCREEN_W))

    -- Smooth camera: lerp camXSmooth toward camX each frame.
    -- (This line is already done — it needs a correct camX to work.)
    camXSmooth = camXSmooth + (camX - camXSmooth) * CAM_LAG * dt
end

function love.draw()
    love.graphics.setBackgroundColor(0.15, 0.15, 0.25)

    -- =========================================================
    -- TODO 2: Apply the camera transform
    --   Before drawing any part of the world, call:
    --       love.graphics.push()
    --       love.graphics.translate(-camXSmooth, 0)
    --   After drawing all world objects, call:
    --       love.graphics.pop()
    --   Everything between push and pop will be shifted left by
    --   camXSmooth pixels — that is what makes the world scroll!
    -- =========================================================
    -- love.graphics.push()
    -- love.graphics.translate(-camXSmooth, 0)

    -- Parallax sky strip (visual extra — draw at half camera speed)
    love.graphics.push()
    love.graphics.translate(camXSmooth * 0.5, 0)
    love.graphics.setColor(0.18, 0.20, 0.38)
    love.graphics.rectangle("fill", 0, 0, LEVEL_W * 0.5, SCREEN_H - 20)
    love.graphics.pop()

    -- Draw floor
    love.graphics.setColor(0.35, 0.55, 0.35)
    love.graphics.rectangle("fill", floor.x, floor.y, floor.w, floor.h)

    -- Draw platforms with a lighter top stripe
    for i = 1, #platforms do
        local p = platforms[i]
        love.graphics.setColor(0.55, 0.38, 0.20)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setColor(0.70, 0.55, 0.35)
        love.graphics.rectangle("fill", p.x, p.y, p.w, 5)
    end

    -- Draw coins with a gentle bob animation
    for i = 1, #coins do
        local c = coins[i]
        if not c.collected then
            local bob = math.sin(coinTimer * 3 + i) * 3
            love.graphics.setColor(1.0, 0.85, 0.10)
            love.graphics.circle("fill", c.x, c.y + bob, c.r)
            love.graphics.setColor(1, 1, 0.8, 0.7)
            love.graphics.circle("fill", c.x - 3, c.y + bob - 3, 3)
        end
    end

    -- Draw player
    love.graphics.setColor(0.90, 0.45, 0.20)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- Eye facing direction (visual extra)
    local eyeOffX = player.vx >= 0 and (player.w - 10) or 6
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x + eyeOffX, player.y + 12, 5)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.circle("fill", player.x + eyeOffX + (player.vx >= 0 and 1 or -1), player.y + 13, 2)

    -- TODO 2 (continued): uncomment this pop() to close the camera transform
    -- love.graphics.pop()

    -- =========================================================
    -- TODO 3: Draw the HUD after pop
    --   Anything drawn here uses normal screen coordinates and
    --   will stay fixed in place while the world scrolls.
    --   Print the score, controls, and anything else you like.
    -- =========================================================
    -- love.graphics.setColor(0, 0, 0, 0.5)
    -- love.graphics.rectangle("fill", 6, 6, 220, 54)
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.print("Score: " .. score .. " / " .. totalCoins, 12, 10)
    -- love.graphics.print("Arrow keys: move   Space/Up: jump", 12, 30)

    -- Visual extra: progress bar showing how far across the level the player is.
    -- (Draw this after pop so it stays fixed at the bottom of the screen.)
    local progress = player.x / (LEVEL_W - player.w)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 10, SCREEN_H - 18, SCREEN_W - 20, 10)
    love.graphics.setColor(0.90, 0.45, 0.20)
    love.graphics.rectangle("fill", 10, SCREEN_H - 18, (SCREEN_W - 20) * progress, 10)
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.print("Level progress", 10, SCREEN_H - 34)
end
