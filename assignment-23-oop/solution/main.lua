-- Assignment 23: Object-Oriented Lua (SOLUTION)
-- A Ball class built from Lua tables and metatables.
-- ONE set of methods (update, draw) works for every instance.
-- Click anywhere to spawn new balls. Each is fully independent.

SCREEN_W = 800
SCREEN_H = 600

-- ============================================================
-- Ball class
-- ============================================================

Ball = {}
Ball.__index = Ball   -- key step: missing keys on instances fall through here

function Ball.new(x, y, vx, vy, radius, r, g, b)
    -- setmetatable(instance, metatable):
    --   'self' starts as a blank table {}
    --   Ball acts as the metatable, and Ball.__index = Ball means
    --   any method lookup on self that fails will check Ball instead.
    local self = setmetatable({}, Ball)

    self.x      = x
    self.y      = y
    self.vx     = vx
    self.vy     = vy
    self.radius = radius
    self.r      = r
    self.g      = g
    self.b      = b

    -- Visual extra: each ball also stores a slightly lighter "glow" color
    self.glowR  = math.min(r + 0.3, 1)
    self.glowG  = math.min(g + 0.3, 1)
    self.glowB  = math.min(b + 0.3, 1)

    return self
end

function Ball:update(dt)
    -- Move the ball
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Bounce off LEFT wall
    if self.x - self.radius < 0 then
        self.vx = -self.vx
        self.x  = self.radius
    end

    -- Bounce off RIGHT wall
    if self.x + self.radius > SCREEN_W then
        self.vx = -self.vx
        self.x  = SCREEN_W - self.radius
    end

    -- Bounce off TOP wall
    if self.y - self.radius < 0 then
        self.vy = -self.vy
        self.y  = self.radius
    end

    -- Bounce off BOTTOM wall
    if self.y + self.radius > SCREEN_H then
        self.vy = -self.vy
        self.y  = SCREEN_H - self.radius
    end
end

function Ball:draw()
    -- Visual extra 1: soft glow ring behind the ball
    love.graphics.setColor(self.glowR * 0.35, self.glowG * 0.35, self.glowB * 0.35)
    love.graphics.circle("fill", self.x, self.y, self.radius + 9)

    -- Filled circle in the ball's own color
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", self.x, self.y, self.radius)

    -- Visual extra 2: bright specular highlight (small white circle, offset up-left)
    love.graphics.setColor(1, 1, 1, 0.55)
    love.graphics.circle("fill", self.x - self.radius * 0.28, self.y - self.radius * 0.28,
                         self.radius * 0.28)

    -- Crisp white outline
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.circle("line", self.x, self.y, self.radius)
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
