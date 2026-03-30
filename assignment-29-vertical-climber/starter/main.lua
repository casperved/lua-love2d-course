-- Assignment 29: Vertical Climber (STARTER)
--
-- Three TODOs for you to fill in:
--   TODO 1 – camera update (one-way upward scroll + lerp)
--   TODO 2 – platform landing (AABB check, downward only)
--   TODO 3 – spark burst on power-up collection + save best height
--
-- Run this now. The player stands on the starting platform and can walk
-- left/right, but falls through every platform (TODO 2 is missing) and
-- the camera never moves up (TODO 1 is missing). Fill in the TODOs one
-- at a time — the game comes alive fast!

SCREEN_W = 800
SCREEN_H = 600
WORLD_H  = 9000   -- y=9000 is the bottom (start); y=0 is the very top

GRAVITY    = 800
JUMP_SPEED = -520
MOVE_SPEED = 240

BOOST_DURATION = 3.0   -- seconds the speed boost lasts
BOOST_MULT     = 1.9   -- speed multiplier while boosted

SAVE_FILE = "best_height.txt"

-- ── State ───────────────────────────────────────────────────────────
gameState     = "title"
heightReached = 0
bestHeight    = 0
newRecord     = false
recordFlash   = 0

-- camY is the world-y shown at the TOP of the screen.
-- camYTarget is where we want the camera to be; camY lerps toward it.
camY       = WORLD_H - SCREEN_H
camYTarget = WORLD_H - SCREEN_H

speedBoostTimer = 0
sparks          = {}   -- spark particles (filled in TODO 3)
streakTrail     = {}   -- speed-boost trail (already working)

-- ── Player ──────────────────────────────────────────────────────────
player = {
    x        = SCREEN_W / 2 - 14,
    y        = 0,    -- set properly in resetGame()
    w        = 28,
    h        = 36,
    vx       = 0,
    vy       = 0,
    onGround = false,
}

platforms = {}
powerups  = {}

-- ── Persistence ─────────────────────────────────────────────────────
-- TODO 3: Replace the stub bodies below with real love.filesystem calls.
function saveScore(h)
    -- love.filesystem.write(SAVE_FILE, tostring(h))
end

function loadScore()
    -- if love.filesystem.getInfo(SAVE_FILE) then
    --     return tonumber(love.filesystem.read(SAVE_FILE)) or 0
    -- end
    return 0   -- always returns 0 until TODO 3 is done
end

-- ── Reset ────────────────────────────────────────────────────────────
function resetGame()
    -- Starting platform is at y = WORLD_H - 150 = 8850
    -- Place the player exactly on top of it
    player.x        = SCREEN_W / 2 - player.w / 2
    player.y        = (WORLD_H - 150) - player.h
    player.vx       = 0
    player.vy       = 0
    player.onGround = false

    camY       = WORLD_H - SCREEN_H
    camYTarget = WORLD_H - SCREEN_H

    speedBoostTimer = 0
    sparks          = {}
    streakTrail     = {}
    newRecord       = false
    recordFlash     = 0
    heightReached   = 0
end

-- ── love.load ────────────────────────────────────────────────────────
function love.load()
    love.window.setTitle("Vertical Climber")
    love.window.setMode(SCREEN_W, SCREEN_H)
    math.randomseed(os.time())

    bestHeight = loadScore()

    -- Generate platforms.
    -- Platforms cycle through three horizontal zones (left / centre / right).
    -- This guarantees the player can always reach the next platform with one
    -- jump — no dead ends, no impossible gaps.
    platforms = {}

    local PLATFORM_BASE = WORLD_H - 150   -- y = 8850  (wide starting platform)
    table.insert(platforms, { x = SCREEN_W/2 - 150, y = PLATFORM_BASE, w = 300, h = 16 })

    -- Step = 100 px, jitter = ±10 px  →  max gap ≈ 110 px  < 169 px jump height
    for i = 1, 70 do
        local w     = math.random(90, 150)
        local baseY = PLATFORM_BASE - (i * 100) + math.random(-10, 10)
        local zone  = (i - 1) % 3              -- cycles 0 (left), 1 (centre), 2 (right)
        local zoneX = zone * 240 + math.random(20, 60)
        local x     = math.max(0, math.min(zoneX, SCREEN_W - w))
        table.insert(platforms, { x = x, y = baseY, w = w, h = 16 })
    end

    -- Power-ups: roughly one every 4 platforms
    powerups = {}
    for i = 1, 15 do
        local baseY = WORLD_H - 700 - (i * 480) + math.random(-60, 60)
        table.insert(powerups, {
            x         = math.random(60, SCREEN_W - 60),
            y         = baseY,
            r         = 12,
            collected = false,
            bobTimer  = 0,
        })
    end

    resetGame()
end

-- ── love.update ──────────────────────────────────────────────────────
function love.update(dt)
    if gameState == "title" then return end

    if gameState == "gameover" then
        if newRecord then recordFlash = recordFlash + dt end
        return
    end

    -- Gravity: pull player downward every frame
    player.vy = player.vy + GRAVITY * dt
    player.y  = player.y  + player.vy * dt

    -- Horizontal movement (speed boost multiplier applied when active)
    local spd = MOVE_SPEED * (speedBoostTimer > 0 and BOOST_MULT or 1)
    player.vx = 0
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then
        player.vx = -spd
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.vx =  spd
    end
    player.x = player.x + player.vx * dt

    -- Horizontal wrap: walk off one edge, appear on the other
    if player.x + player.w < 0 then
        player.x = SCREEN_W
    elseif player.x > SCREEN_W then
        player.x = -player.w
    end

    -- ────────────────────────────────────────────────────────────────
    -- TODO 2 — Platform landing
    --
    -- Reset onGround first — the loop below will set it back to true
    -- if the player is actually standing on something.
    player.onGround = false
    --
    -- Loop through every platform and check five things at once:
    --   1. player.vy > 0                       (player is falling, not rising)
    --   2. player.x + player.w > plat.x        (player's right edge past plat left)
    --   3. player.x < plat.x + plat.w          (player's left edge before plat right)
    --   4. player.y + player.h >= plat.y        (player's feet reached the surface)
    --   5. player.y < plat.y                    (player's head is still above surface)
    --
    -- When all five are true, snap the player on top and stop falling.
    --
    -- for _, plat in ipairs(platforms) do
    --     if player.vy > 0
    --        and player.x + player.w > plat.x
    --        and player.x            < plat.x + plat.w
    --        and player.y + player.h >= plat.y
    --        and player.y            <  plat.y
    --     then
    --         player.y        = plat.y - player.h
    --         player.vy       = 0
    --         player.onGround = true
    --     end
    -- end
    -- ────────────────────────────────────────────────────────────────

    -- Track the highest point reached this run
    heightReached = math.max(heightReached,
        math.floor(WORLD_H - (player.y + player.h)))

    -- ────────────────────────────────────────────────────────────────
    -- TODO 1 — Camera update
    --
    -- camYTarget should only ever get smaller (camera only scrolls up).
    -- If the player climbs into the upper 40% of the screen, pull the
    -- target upward to keep them in view.
    -- Clamp so we never scroll past the world edges.
    -- Then lerp camY smoothly toward camYTarget.
    --
    -- if player.y < camYTarget + SCREEN_H * 0.4 then
    --     camYTarget = player.y - SCREEN_H * 0.4
    -- end
    -- camYTarget = math.max(0, math.min(camYTarget, WORLD_H - SCREEN_H))
    -- camY = camY + (camYTarget - camY) * 8 * dt
    -- ────────────────────────────────────────────────────────────────

    -- Death check: feet dropped more than 20 px below the camera's bottom edge
    if player.y + player.h > camY + SCREEN_H + 20 then
        if heightReached > bestHeight then
            bestHeight = heightReached
            -- TODO 3: save the new best height to a file
            -- saveScore(bestHeight)
            newRecord = true
        end
        gameState = "gameover"
        return
    end

    -- Speed boost countdown
    if speedBoostTimer > 0 then
        speedBoostTimer = speedBoostTimer - dt
    end

    -- Power-up collection
    for _, pu in ipairs(powerups) do
        if not pu.collected then
            pu.bobTimer = pu.bobTimer + dt

            -- Distance between player centre and power-up centre
            local pcx = player.x + player.w / 2
            local pcy = player.y + player.h / 2
            local dx  = pcx - pu.x
            local dy  = pcy - pu.y
            if math.sqrt(dx * dx + dy * dy) < player.w / 2 + pu.r then
                pu.collected    = true
                speedBoostTimer = BOOST_DURATION

                -- TODO 3 — Spark burst
                -- Spawn 16 sparks flying outward in a full circle.
                -- Use (k / 16) * math.pi * 2  to get evenly spaced angles.
                --
                -- for k = 1, 16 do
                --     local angle = (k / 16) * math.pi * 2
                --     local spd2  = math.random(80, 200)
                --     sparks[#sparks + 1] = {
                --         x       = pu.x,
                --         y       = pu.y,
                --         vx      = math.cos(angle) * spd2,
                --         vy      = math.sin(angle) * spd2,
                --         life    = math.random(20, 50) / 100,
                --         maxLife = 0.5,
                --     }
                -- end
            end
        end
    end

    -- Update sparks: move, age, remove dead ones (iterate backwards for safe removal)
    for i = #sparks, 1, -1 do
        local s = sparks[i]
        s.x    = s.x + s.vx * dt
        s.y    = s.y + s.vy * dt
        s.life = s.life - dt
        if s.life <= 0 then table.remove(sparks, i) end
    end

    -- Speed-streak trail (visual extra — already working)
    if speedBoostTimer > 0 then
        streakTrail[#streakTrail + 1] = {
            x = player.x, y = player.y,
            w = player.w, h = player.h,
            life = 0.15, maxLife = 0.15,
        }
    end
    for i = #streakTrail, 1, -1 do
        local t = streakTrail[i]
        t.life = t.life - dt
        if t.life <= 0 then table.remove(streakTrail, i) end
    end
end

-- ── love.keypressed ──────────────────────────────────────────────────
function love.keypressed(key)
    if key == "escape" then love.event.quit() end

    if gameState == "title" and key == "space" then
        resetGame()
        gameState = "playing"
    elseif gameState == "playing" then
        if (key == "space" or key == "up" or key == "w") and player.onGround then
            player.vy       = JUMP_SPEED
            player.onGround = false
        end
    elseif gameState == "gameover" and key == "space" then
        resetGame()
        gameState = "playing"
    end
end

-- ── love.draw ────────────────────────────────────────────────────────
function love.draw()
    love.graphics.setBackgroundColor(0.06, 0.06, 0.14)

    -- Title screen
    if gameState == "title" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("VERTICAL CLIMBER", 0, 180, SCREEN_W, "center")
        love.graphics.setColor(0.7, 0.9, 1)
        love.graphics.printf(
            "Climb as high as you can!\nGrab the cyan orbs for a speed boost.\nDon't fall off the bottom!",
            0, 250, SCREEN_W, "center")
        if bestHeight > 0 then
            love.graphics.setColor(1, 0.85, 0.2)
            love.graphics.printf("Best: " .. bestHeight .. " px", 0, 360, SCREEN_W, "center")
        end
        love.graphics.setColor(0.3, 1, 0.5)
        love.graphics.printf("Press SPACE to play", 0, 430, SCREEN_W, "center")
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.printf("Arrow keys / WASD: move   Space / W / Up: jump",
            0, 470, SCREEN_W, "center")
        return
    end

    -- Game-over screen
    if gameState == "gameover" then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.printf("YOU FELL!", 0, 170, SCREEN_W, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Height reached: " .. heightReached .. " px",
            0, 250, SCREEN_W, "center")
        love.graphics.setColor(1, 0.85, 0.2)
        love.graphics.printf("Best: " .. bestHeight .. " px", 0, 285, SCREEN_W, "center")
        if newRecord then
            local alpha = 0.5 + 0.5 * math.sin(recordFlash * 7)
            love.graphics.setColor(1, 1, 0, alpha)
            love.graphics.printf("NEW RECORD!", 0, 340, SCREEN_W, "center")
        end
        love.graphics.setColor(0.3, 1, 0.5)
        love.graphics.printf("Press SPACE to try again", 0, 420, SCREEN_W, "center")
        return
    end

    -- ── World drawing (camera offset applied) ────────────────────────
    love.graphics.push()
    love.graphics.translate(0, -camY)   -- shift the entire world upward on screen

    -- Speed-streak trail
    for _, t in ipairs(streakTrail) do
        local frac = t.life / t.maxLife
        love.graphics.setColor(1, 0.55, 0.1, frac * 0.3)
        love.graphics.rectangle("fill", t.x, t.y, t.w, t.h)
    end

    -- Platforms — colour shifts from earthy brown (low) to icy blue (high)
    for _, plat in ipairs(platforms) do
        local t  = 1 - (plat.y / WORLD_H)
        local r  = 0.55 + (0.25 - 0.55) * t
        local g  = 0.38 + (0.65 - 0.38) * t
        local b  = 0.18 + (0.90 - 0.18) * t
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", plat.x, plat.y, plat.w, plat.h)
        love.graphics.setColor(r + 0.15, g + 0.15, b + 0.12)
        love.graphics.rectangle("fill", plat.x, plat.y, plat.w, 4)
    end

    -- Power-ups with bobbing and glow
    local now = love.timer.getTime()
    for i, pu in ipairs(powerups) do
        if not pu.collected then
            local bob       = math.sin(now * 3 + i) * 4
            local glowAlpha = 0.20 + 0.15 * math.sin(now * 4 + i)
            love.graphics.setColor(0.2, 1, 0.9, glowAlpha)
            love.graphics.circle("fill", pu.x, pu.y + bob, pu.r + 8)
            love.graphics.setColor(0.2, 0.9, 0.9)
            love.graphics.circle("fill", pu.x, pu.y + bob, pu.r)
            love.graphics.setColor(1, 1, 0.4, 0.5)
            love.graphics.circle("fill", pu.x - 3, pu.y + bob - 3, pu.r * 0.45)
            love.graphics.setColor(1, 1, 1, 0.6)
            love.graphics.circle("line", pu.x, pu.y + bob, pu.r)
        end
    end

    -- Sparks (drawn in world space so they stay where the power-up was)
    for _, s in ipairs(sparks) do
        local frac = s.life / s.maxLife
        love.graphics.setColor(1, 0.85 * frac + 0.15, 0.1, frac)
        love.graphics.circle("fill", s.x, s.y, 5 * frac)
    end

    -- Player
    if speedBoostTimer > 0 then
        local pulse = 0.5 + 0.5 * math.sin(now * 10)
        love.graphics.setColor(1, 0.5, 0, 0.30 + pulse * 0.25)
        love.graphics.rectangle("fill",
            player.x - 5, player.y - 5, player.w + 10, player.h + 10)
        love.graphics.setColor(1, 0.75, 0.1)
    else
        love.graphics.setColor(0.25, 0.80, 0.40)
    end
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    -- Eyes (face the direction of movement)
    local eyeOff = (player.vx >= 0) and (player.w - 10) or 5
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x + eyeOff, player.y + 10, 4)
    love.graphics.setColor(0.05, 0.05, 0.05)
    love.graphics.circle("fill",
        player.x + eyeOff + (player.vx >= 0 and 1 or -1), player.y + 11, 2)

    love.graphics.pop()

    -- ── HUD (screen space — drawn after pop so it never scrolls) ─────
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 6, 6, 210, speedBoostTimer > 0 and 70 or 50)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Height: " .. heightReached .. " px", 12, 10)
    love.graphics.setColor(0.5, 1, 0.6)
    love.graphics.print("Best:   " .. bestHeight   .. " px", 12, 30)
    if speedBoostTimer > 0 then
        local alpha = 0.6 + 0.4 * math.sin(now * 8)
        love.graphics.setColor(1, 0.85, 0.1, alpha)
        love.graphics.print(string.format("BOOST! %.1f s", speedBoostTimer), 12, 50)
    end

    -- Right-edge progress bar
    local progress = math.min(1, heightReached / WORLD_H)
    local barH     = SCREEN_H - 20
    love.graphics.setColor(0.15, 0.15, 0.25, 0.8)
    love.graphics.rectangle("fill", SCREEN_W - 16, 10, 10, barH)
    if progress > 0 then
        love.graphics.setColor(0.3, 1, 0.5, 0.9)
        love.graphics.rectangle("fill",
            SCREEN_W - 16, 10 + barH * (1 - progress), 10, barH * progress)
    end
    love.graphics.setColor(0.6, 0.6, 0.7)
    love.graphics.rectangle("line", SCREEN_W - 16, 10, 10, barH)
end
