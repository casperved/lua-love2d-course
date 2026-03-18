# Assignment 18: Mini Project — Catch the Drops!

You've made it to your first **mini project**! This is a bigger challenge — a complete game where you'll fill in the most important parts yourself. Take your time, read the comments carefully, and remember: every great game developer started exactly where you are right now.

---

## What You're Building

**Catch the Drops** is a classic arcade-style game:

- A **bucket** slides left and right at the bottom of the screen (arrow keys).
- Colourful **raindrops** fall from the top.
- **Catch a drop** in the bucket → earn a point.
- **Miss a drop** (it hits the ground) → lose a life.
- You start with **3 lives**.
- Over time drops fall faster and spawn more often — survive as long as you can!
- Your **high score** is remembered for the whole session.

About 70% of the game is already written for you. Your job is to fill in the three most important pieces of logic.

---

## The Three TODOs

| # | What to do | Where |
|---|-----------|-------|
| TODO 1 | Gradually increase drop speed and spawn rate over time | `love.update` |
| TODO 2 | Check if a drop was **caught** by the bucket | Inside the drop loop |
| TODO 3 | Check if a drop **fell off** the bottom (missed) | Inside the drop loop, after the caught check |

The tricky part is TODO 2 and 3: you need to check them carefully because you can't remove the same drop twice. The starter code uses `elseif` to make sure only one check runs per drop per frame.

---

## Collision Refresher

A drop (a circle) is caught if its centre is roughly inside the bucket rectangle. A simple check:

```lua
-- d = drop, bucket = bucket table
if d.x > bucket.x - d.radius and
   d.x < bucket.x + bucket.w + d.radius and
   d.y + d.radius > bucket.y and
   d.y - d.radius < bucket.y + bucket.h then
    -- caught!
end
```

The `d.radius` expansion on the x-axis makes the catch feel fair — you don't have to be pixel-perfect.

---

## Hints

<details><summary>Hint 1 — Difficulty scaling (TODO 1)</summary>

Add these two lines inside `love.update`, in the section that runs each frame while playing:

```lua
spawnInterval = math.max(0.25, spawnInterval - dt * 0.01)
dropSpeed     = math.min(450,  dropSpeed     + dt * 5)
```

`math.max(0.25, ...)` stops the interval from going below 0.25 seconds (so spawns don't become impossible). `math.min(450, ...)` caps the speed so drops don't become a blur.

</details>

<details><summary>Hint 2 — Caught vs missed (TODOs 2 & 3)</summary>

Use `if ... elseif ...` so the game can't both catch and miss the same drop:

```lua
if d.x > bucket.x - d.radius and d.x < bucket.x + bucket.w + d.radius and
   d.y + d.radius > bucket.y and d.y - d.radius < bucket.y + bucket.h then
    -- CAUGHT
    score = score + 1
    table.remove(drops, i)
elseif d.y - d.radius > SCREEN_H then
    -- MISSED
    lives = lives - 1
    table.remove(drops, i)
    if lives <= 0 then
        highScore  = math.max(score, highScore)
        gameState  = "gameover"
    end
end
```

Remember: loop backwards (`for i = #drops, 1, -1`) when removing items from a table while looping!

</details>

<details><summary>Hint 3 — Nothing seems to happen?</summary>

Check that your code is inside `elseif gameState == "playing" then` in `love.update`. Also make sure you removed the "Temporary" block that silently removes drops at the bottom — it sits just below TODO 3 in the starter file and needs to be replaced by your TODO 3 code.

</details>

---

## Stretch Goals

1. **Combo bonus** — track consecutive catches without missing. Every 5 in a row, award 5 bonus points and flash the screen gold.
2. **Special drops** — 10% of drops are gold; catching one gives 3 points instead of 1.
3. **Growing bucket** — every 10 points, the bucket grows 5 pixels wider (up to a maximum of 140). This rewards skillful play!
