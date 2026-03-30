-- Assignment 25: Platformer Physics
-- Starter file — fill in the three TODO sections to bring the physics to life!

SCREEN_W = 800
SCREEN_H = 600

GRAVITY    = 800   -- pixels per second squared (how fast falling accelerates)
MOVE_SPEED = 220   -- horizontal speed in pixels per second
JUMP_SPEED = -500  -- negative = upward on screen

-- Player table: position, size, and velocity
player = {
    x  = 80,
    y  = 500,
    w  = 36,
    h  = 48,
    vx = 0,
    vy = 0,
    onGround = false,
}

-- Five platforms (each is a rectangle: x, y, width, height)
platforms = {
    { x = 100, y = 460, w = 160, h = 18 },
    { x = 300, y = 380, w = 140, h = 18 },
    { x = 480, y = 300, w = 180, h = 18 },
    { x = 200, y = 220, w = 130, h = 18 },
    { x = 560, y = 180, w = 150, h = 18 },
}

-- The floor: a wide invisible platform at the bottom of the screen
floor = { x = 0, y = SCREEN_H - 20, w = SCREEN_W, h = 20 }

-- Trail particles drawn while the player is in the air (visual extra — already done for you)
trail = {}

function love.load()
    love.window.setTitle("Assignment 25 – Platformer Physics")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())
end

function love.update(dt)
    -- Reset onGround every frame.
    -- The collision loop below will set it back to true if the player is still touching something.
    player.onGround = false

    -- =========================================================
    -- TODO 1: Apply gravity
    --   Every frame, add GRAVITY * dt to player.vy (speed grows).
    --   Then move player.y by player.vy * dt (position changes).
    --   Order matters: update speed first, then position.
    -- =========================================================
    -- player.vy = player.vy + GRAVITY * dt
    -- player.y  = player.y  + player.vy * dt

    -- Horizontal movement (already done for you)
    player.vx = 0
    if love.keyboard.isDown("left")  then player.vx = -MOVE_SPEED end
    if love.keyboard.isDown("right") then player.vx =  MOVE_SPEED end
    player.x = player.x + player.vx * dt

    -- Keep the player inside the screen horizontally
    player.x = math.max(0, math.min(player.x, SCREEN_W - player.w))

    -- =========================================================
    -- TODO 2: Platform landing check (AABB)
    --   Build a list of all solid surfaces: all platforms + the floor.
    --   Loop over every surface. For each one:
    --     - Check X overlap: player left < surface right  AND  player right > surface left
    --     - Check Y overlap: player top  < surface bottom AND  player bottom > surface top
    --     - Also check player.vy > 0 (only land when falling, not when jumping up)
    --   If all three are true:
    --     - Set player.y  = surface.y - player.h  (sit on top)
    --     - Set player.vy = 0                     (stop falling)
    --     - Set player.onGround = true             (remember we landed)
    -- =========================================================
    -- local allSurfaces = {}
    -- for i = 1, #platforms do
    --     allSurfaces[i] = platforms[i]
    -- end
    -- allSurfaces[#allSurfaces + 1] = floor
    --
    -- for i = 1, #allSurfaces do
    --     local p  = allSurfaces[i]
    --     local ox = player.x < p.x + p.w and player.x + player.w > p.x
    --     local oy = player.y < p.y + p.h and player.y + player.h > p.y
    --     if ox and oy and player.vy > 0 then
    --         player.y        = p.y - player.h
    --         player.vy       = 0
    --         player.onGround = true
    --     end
    -- end

    -- =========================================================
    -- TODO 3: Jumping
    --   If player.onGround is true AND Space or Up is pressed,
    --   set player.vy = JUMP_SPEED (the big negative number at the top).
    --   Also set player.onGround = false so the jump registers immediately.
    -- =========================================================
    -- if player.onGround then
    --     if love.keyboard.isDown("space") or love.keyboard.isDown("up") then
    --         player.vy       = JUMP_SPEED
    --         player.onGround = false
    --     end
    -- end

    -- Visual extra: leave a fading trail while the player is in the air
    if not player.onGround then
        trail[#trail + 1] = {
            x       = player.x + player.w / 2,
            y       = player.y + player.h,
            life    = 0.25,
            maxLife = 0.25,
        }
    end

    -- Age trail particles and remove expired ones
    for i = #trail, 1, -1 do
        trail[i].life = trail[i].life - dt
        if trail[i].life <= 0 then
            table.remove(trail, i)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.15, 0.15, 0.25)

    -- Draw the trail (visual extra — already done for you)
    for i = 1, #trail do
        local t     = trail[i]
        local alpha = t.life / t.maxLife
        love.graphics.setColor(0.90, 0.45, 0.20, alpha * 0.5)
        local r = 6 * alpha
        love.graphics.circle("fill", t.x, t.y, r)
    end

    -- Draw floor
    love.graphics.setColor(0.35, 0.55, 0.35)
    love.graphics.rectangle("fill", floor.x, floor.y, floor.w, floor.h)

    -- Draw platforms with a lighter top stripe for depth
    for i = 1, #platforms do
        local p = platforms[i]
        love.graphics.setColor(0.55, 0.38, 0.20)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setColor(0.70, 0.55, 0.35)
        love.graphics.rectangle("fill", p.x, p.y, p.w, 5)  -- lighter top edge
    end

    -- Draw player body
    love.graphics.setColor(0.90, 0.45, 0.20)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- Draw a small eye that faces the direction the player is moving (visual extra)
    local eyeOffX = player.vx >= 0 and (player.w - 10) or 6
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x + eyeOffX, player.y + 12, 5)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.circle("fill", player.x + eyeOffX + (player.vx >= 0 and 1 or -1), player.y + 13, 2)

    -- HUD
    love.graphics.setColor(1, 1, 1, 1)
    local groundText = player.onGround and "ON GROUND" or "IN AIR"
    love.graphics.print(groundText, 10, 10)
    love.graphics.print("Arrow keys: move   Space / Up: jump", 10, 30)
end
