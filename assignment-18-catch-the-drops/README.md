# Assignment 18: Mini Project — Catch the Drops!

You've learned all the building blocks. Now it's time to put them together and build a real game! This is your first mini project — and it's totally doable. You've already seen every piece of this before.

---

## What you'll learn

How to combine movement, tables, loops, and collision into one working arcade game.

---

## How it works

Picture a summer rainstorm. Raindrops are falling from the sky. You're holding a bucket. Your job? Run left and right to catch as many drops as you can. Miss too many and you're out!

That's the whole game. Here's how the code works:

**The bucket** is a rectangle near the bottom of the screen. When you press the left or right arrow key, it slides that direction. It can't go off the edge of the screen.

**The drops** are stored in a table — like a list on a whiteboard. Every 0.8 seconds, a new drop is added to the list with a random position at the top of the screen. Each frame, every drop in the list moves down a little (using `d.speed * dt`, just like the bouncing ball from earlier).

**Catching a drop** means checking: is this drop overlapping the bucket? If yes — score goes up, drop gets removed from the list.

**Missing a drop** means it slid past the bottom of the screen without being caught. Lives go down. When lives hit zero, it's game over.

**Getting harder** — every frame, the spawn timer ticks down a tiny bit (so drops appear more often) and the drops fall a little faster. This is what makes the game feel exciting instead of boring!

The game has three screens, just like assignment 12:
- **Title** — shows instructions, waits for Enter
- **Playing** — the actual game
- **Game over** — shows your score, waits for R to restart

---

## Your mission

About 70% of the game is already written. You need to fill in three TODOs:

| TODO | What to do |
|------|------------|
| **TODO 1** | Make the game get harder over time (drops fall faster, spawn more often) |
| **TODO 2** | Check if a drop was **caught** by the bucket |
| **TODO 3** | Check if a drop **fell off** the bottom (missed) |

TODOs 2 and 3 both live inside the drop loop. They use `if ... elseif ...` so the same drop can't be both caught and missed in the same frame.

Once TODO 3 is working, remove the temporary cleanup block just below it — it was only there to keep the game from crashing while TODOs 2 and 3 were empty.

---

## Hints

<details><summary>Hint 1 — Making it harder (TODO 1)</summary>

Every frame, nudge `spawnInterval` a tiny bit smaller (so drops appear more often) and `dropSpeed` a tiny bit bigger (so they fall faster). Use `math.max` and `math.min` to set a floor and ceiling so things don't go crazy:

```lua
spawnInterval = math.max(0.25, spawnInterval - dt * 0.01)
dropSpeed     = math.min(450,  dropSpeed     + dt * 5)
```

`math.max(0.25, ...)` means "never go below 0.25 seconds between drops."
`math.min(450, ...)` means "never go faster than 450 pixels per second."

</details>

<details><summary>Hint 2 — Checking if a drop lands in the bucket (TODO 2)</summary>

A drop (circle) is caught if its centre `(d.x, d.y)` is roughly inside the bucket rectangle. Check all four sides:

```lua
if d.x > bucket.x - d.radius and d.x < bucket.x + bucket.w + d.radius and
   d.y + d.radius > bucket.y  and d.y - d.radius < bucket.y + bucket.h then
    score      = score + 1
    catchFlash = 0.08
    table.remove(drops, i)
```

The `d.radius` fudge on the left and right sides makes the catch feel fair — you don't have to be pixel-perfect to catch it.

</details>

<details><summary>Hint 3 — Checking if a drop hit the ground (TODO 3)</summary>

Use `elseif` (not a separate `if`) so the game only runs this check when the drop was NOT caught. A drop has fallen off the screen when its bottom edge (`d.y + d.radius`) is below `SCREEN_H`:

```lua
elseif d.y - d.radius > SCREEN_H then
    lives = lives - 1
    table.remove(drops, i)
    if lives <= 0 then
        highScore = math.max(score, highScore)
        gameState = "gameover"
    end
end
```

After this is working, delete the "Temporary" block a few lines below — it was just a placeholder.

</details>

---

## Stretch Goals

1. **Combo bonus** — count consecutive catches without missing. Every 5 in a row, award 5 bonus points and flash the screen gold.
2. **Special drops** — make 10% of drops gold. Catching one gives 3 points instead of 1.
3. **Growing bucket** — every 10 points, the bucket grows 5 pixels wider (up to a maximum of 140). Reward the player for doing well!
4. **Poison drops** — give 15% of drops a red/purple colour. Catching one costs a life instead of giving a point. Now the player has to dodge some drops while chasing others.
5. **Wind** — every few seconds, add a slow left or right drift to all falling drops. Show a small arrow on the HUD so the player can see which way the wind is blowing.
