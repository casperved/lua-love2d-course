# Assignment 14: Timers & Spawning

## What you'll learn

How to make things happen on a schedule — like an enemy appearing every two seconds — using a simple counting trick called the **accumulator timer**.

---

## How it works

### The kitchen timer trick

Imagine a kitchen timer. You set it for two minutes. Every second that passes, you check: "Has it been two minutes yet?" If yes, the oven beeps and you reset the timer for next time.

That is exactly how we do it in code. We have a variable called `spawnTimer` that starts at zero. Every frame, we add a tiny bit of time to it (`dt` — remember, that's the time since the last frame). When it reaches our target (say, 1.5 seconds), we spawn an asteroid and reset `spawnTimer` back to zero.

```lua
spawnTimer = spawnTimer + dt       -- add a tiny bit each frame

if spawnTimer >= spawnInterval then
    spawnAsteroid()                -- time's up! do the thing
    spawnTimer = 0                 -- reset for next time
end
```

That's the whole pattern. No special libraries. Just a number counting up.

### Making the game harder over time

A good game gets harder as you play. We can shrink the gap between spawns as the player survives longer. The longer you last, the shorter `spawnInterval` gets, so asteroids come faster and faster.

We use `math.max` to make sure it never shrinks below 0.3 seconds — otherwise the game would become impossible!

```lua
spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)
```

Think of it like a factory machine speeding up — slowly at first, then relentlessly.

### Hitting a circle with a rectangle

The player is a rectangle. The asteroids are circles. Checking if they overlap exactly is tricky — but there is a good-enough shortcut.

Imagine drawing a bigger rectangle around the player — one that is padded outward by the asteroid's radius on every side. If the asteroid's centre point lands inside that bigger rectangle, we call it a hit. It is slightly generous, but it feels fair to the player.

```lua
if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
   a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
    gameOver = true
end
```

---

## Your mission

You are flying a little spaceship. Asteroids fall from the top of the screen. Dodge them with the left and right arrow keys. Your score is how many seconds you survive. The longer you last, the faster they fall.

Fill in the three TODOs in the starter file:

1. **TODO 1** — Make the spawn timer count up and trigger `spawnAsteroid()` when it is time.
2. **TODO 2** — Shrink `spawnInterval` over time so the game gets harder.
3. **TODO 3** — Detect when an asteroid hits the player and set `gameOver = true`.

---

## Hints

<details><summary>Hint 1 — Making the spawn timer work</summary>

Every frame, add `dt` to `spawnTimer`. When it is big enough, spawn an asteroid and reset the timer:

```lua
spawnTimer = spawnTimer + dt
if spawnTimer >= spawnInterval then
    spawnAsteroid()
    spawnTimer = 0
end
```

Put this inside `love.update`, after the player movement code.
</details>

<details><summary>Hint 2 — Speeding up over time</summary>

After updating `spawnTimer`, recalculate the interval. The longer `survivalTimer` is, the smaller the result — but `math.max` stops it going too low:

```lua
spawnInterval = math.max(0.3, 1.5 - survivalTimer * 0.05)
```

This one line is all you need. It runs every frame, so it stays up to date automatically.
</details>

<details><summary>Hint 3 — Asteroid collision</summary>

Inside the asteroid loop, in the `else` branch (the asteroid is still on screen), check whether the asteroid centre is inside the padded player rectangle:

```lua
if a.x > player.x - a.radius and a.x < player.x + player.w + a.radius and
   a.y > player.y - a.radius and a.y < player.y + player.h + a.radius then
    gameOver = true
end
```
</details>

---

## Stretch Goals

1. **Colour by speed** — Make fast asteroids red and slow ones grey. Use the asteroid's `speed` value to blend the colour.
2. **Shield powerup** — Press Space to turn on a shield for one second. It can only be used once every ten seconds. Show a small cooldown bar on screen.
3. **High score** — Track the best survival time across restarts. Display it on the game-over screen as "Best: X seconds".
