# Assignment 14: Timers & Spawning ⏱️☄️

Games need things to happen on a schedule — enemies that appear every few seconds, power-ups that spawn randomly, waves that get harder over time. The trick is a simple pattern called the **accumulator timer**. Let's learn it!

---

## The Accumulator Timer Pattern

LÖVE gives us `dt` (delta time) — the number of seconds that passed since the last frame. It's a tiny number, usually around `0.016` (about 16 milliseconds at 60 fps).

We add `dt` to a counter every frame. When that counter reaches our threshold, we do something and reset it:

```lua
spawnTimer    = 0      -- counts up
spawnInterval = 2.0    -- spawn something every 2 seconds

function love.update(dt)
    spawnTimer = spawnTimer + dt

    if spawnTimer >= spawnInterval then
        spawnSomething()    -- do the thing!
        spawnTimer = 0      -- reset the clock
    end
end
```

That's it! No external libraries, no complicated code — just a number that counts up and resets.

---

## Increasing Difficulty Over Time

A great game gets harder as you play. One easy way: make `spawnInterval` shrink as time passes.

```lua
-- Recalculate interval each frame — gets smaller as survivalTimer grows
spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)
```

- `math.max(0.3, ...)` makes sure it never goes below 0.3 seconds (don't want an impossible game!).
- The longer `survivalTimer` is, the smaller `spawnInterval` becomes.

---

## Circle vs. Rectangle Collision

This game has circular asteroids and a rectangular player. A simple (slightly generous) check:

```lua
-- Treat the circle as if it's a square of size (radius * 2) overlapping the player rect
if circleX > playerX - radius and circleX < playerX + playerW + radius and
   circleY > playerY - radius and circleY < playerY + playerH + radius then
    -- collision!
end
```

It's not pixel-perfect, but it's fast and feels fair to the player.

---

## Your Mission

- Asteroids fall from the top of the screen at random horizontal positions.
- The player moves **left and right** with arrow keys to dodge them.
- Score = how many seconds you've survived.
- Every frame the spawn interval shrinks — it keeps getting faster!
- When an asteroid hits the player, it's **Game Over**.

---

## TODOs in the Starter File

1. **TODO 1** — Implement the spawn timer: add `dt`, check against `spawnInterval`, call `spawnAsteroid()`, reset.
2. **TODO 2** — Reduce `spawnInterval` over time using `math.max`.
3. **TODO 3** — Implement the circle-rectangle collision check for each asteroid.

---

## Hints

<details><summary>Hint 1 — The spawn timer</summary>

```lua
spawnTimer = spawnTimer + dt
if spawnTimer >= spawnInterval then
    spawnAsteroid()
    spawnTimer = 0
end
```

Put this block inside `love.update`, after the player movement code.
</details>

<details><summary>Hint 2 — Ramping up difficulty</summary>

```lua
spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)
```

Add this line right after you update `spawnTimer`. It recalculates the interval every frame based on how long the player has survived.
</details>

<details><summary>Hint 3 — Asteroid collision check</summary>

Inside the asteroid loop, in the `else` branch (when the asteroid hasn't fallen off screen):

```lua
if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
   a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
    gameOver = true
end
```
</details>

---

## Stretch Goals

1. **Asteroid splitting** — When an asteroid goes off-screen without hitting you, occasionally spawn two smaller ones the next time.
2. **Shields** — Press Space to activate a brief shield (invincibility for 1 second). Only usable once every 10 seconds. Show a cooldown bar!
3. **Score multiplier** — If you dodge 5 asteroids in a row without getting close to any, activate a ×2 score multiplier for 5 seconds.
