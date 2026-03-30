-- Assignment 23: Object-Oriented Lua (STARTER)
-- A Ball class built from Lua tables and metatables.
-- ONE set of methods (update, draw) works for every instance.
-- Click anywhere to spawn new balls. Each is fully independent.
--
-- Your three TODOs:
--   TODO 1 – set Ball.__index and use setmetatable inside Ball.new
--   TODO 2 – write Ball:update(dt)  (move + bounce off all 4 walls)
--   TODO 3 – write Ball:draw()      (set color, draw filled circle)

SCREEN_W = 800
SCREEN_H = 600

-- ============================================================
-- Ball class
-- ============================================================

Ball = {}

-- TODO 1a: Tell Lua that when a key is missing on an instance,
--          it should look it up in Ball instead.
--          Put this line right here, above Ball.new:
-- Ball.__index = Ball

function Ball.new(x, y, vx, vy, radius, r, g, b)
    -- TODO 1b: Replace the stub below with a real setmetatable call.
    --          setmetatable(instance, metatable) creates a blank table
    --          and attaches Ball as its metatable so methods are found.
    -- local self = setmetatable({}, Ball)
    local self = {}   -- stub: methods won't be found yet (fix with TODO 1)

    self.x      = x
    self.y      = y
    self.vx     = vx
    self.vy     = vy
    self.radius = radius
    self.r      = r       -- red   (0–1)
    self.g      = g       -- green (0–1)
    self.b      = b       -- blue  (0–1)

    -- Visual extra: each ball also stores a slightly lighter "glow" color
    self.glowR  = math.min(r + 0.3, 1)
    self.glowG  = math.min(g + 0.3, 1)
    self.glowB  = math.min(b + 0.3, 1)

    return self
end

-- TODO 2: Write Ball:update(dt)
--   Move the ball using its velocity:
--     self.x = self.x + self.vx * dt
--     self.y = self.y + self.vy * dt
--   Then bounce off each of the 4 walls:
--     if self.x - self.radius < 0 then          -- left wall
--         self.vx = -self.vx
--         self.x  = self.radius
--     end
--     if self.x + self.radius > SCREEN_W then   -- right wall
--         self.vx = -self.vx
--         self.x  = SCREEN_W - self.radius
--     end
--     -- do the same for top (self.y - self.radius < 0)
--     -- and bottom (self.y + self.radius > SCREEN_H)
function Ball:update(dt)
    -- (fill this in — see the hints above)
end

-- TODO 3: Write Ball:draw()
--   Step 1 – draw a soft glow ring behind the ball (optional visual extra):
--     love.graphics.setColor(self.glowR * 0.35, self.glowG * 0.35, self.glowB * 0.35)
--     love.graphics.circle("fill", self.x, self.y, self.radius + 9)
--   Step 2 – draw the filled circle in the ball's own color:
--     love.graphics.setColor(self.r, self.g, self.b)
--     love.graphics.circle("fill", self.x, self.y, self.radius)
--   Step 3 – draw a faint white outline so the ball pops:
--     love.graphics.setColor(1, 1, 1, 0.4)
--     love.graphics.circle("line", self.x, self.y, self.radius)
function Ball:draw()
    -- (fill this in — see the hints above)
end

-- ============================================================
-- Helper: spawn a ball with random velocity and color
-- ============================================================

function spawnBall(x, y)
    local speed  = math.random(120, 320)
    local angle  = math.random() * math.pi * 2
    local vx     = math.cos(angle) * speed
    local vy     = math.sin(angle) * speed
    local radius = math.random(10, 28)
    local r      = math.random(4, 10) / 10
    local g      = math.random(2, 10) / 10
    local b      = math.random(4, 10) / 10
    balls[#balls + 1] = Ball.new(x, y, vx, vy, radius, r, g, b)
end

-- ============================================================
-- LÖVE callbacks
-- ============================================================

balls = {}

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Assignment 23 – OOP Bouncing Balls")

    -- Spawn 8 balls at different starting positions
    spawnBall(100, 100)
    spawnBall(700, 100)
    spawnBall(400, 300)
    spawnBall(200, 500)
    spawnBall(600, 450)
    spawnBall(350, 150)
    spawnBall(550, 250)
    spawnBall(150, 380)
end

function love.update(dt)
    for i = 1, #balls do
        balls[i]:update(dt)
    end
end

function love.draw()
    -- Dark starfield background
    love.graphics.setColor(0.05, 0.05, 0.15)
    love.graphics.rectangle("fill", 0, 0, SCREEN_W, SCREEN_H)

    -- Draw all balls (each one calls its own :draw method)
    for i = 1, #balls do
        balls[i]:draw()
    end

    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Click anywhere to spawn a ball!", 10, 10)
    love.graphics.print("Balls alive: " .. #balls, 10, 30)
    love.graphics.print("Press Escape to quit", 10, 50)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnBall(x, y)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
