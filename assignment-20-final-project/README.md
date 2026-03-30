# Assignment 20: Final Project — Star Shooter

You made it. Seriously. You started with a blank screen and `print("Hello")`, and now you know how to move players, shoot bullets, detect collisions, spawn enemies, track scores, and build games with title screens and game-over states. That is a real skill set. Be proud.

---

## What you'll learn

How to put **everything together** into one complete, playable game.

---

## How it works

Think of this assignment like building a LEGO set. You already know what every individual piece does. Now you snap them all together into the final thing.

The game is a **mini space shooter**:

- You are a spaceship at the bottom of the screen.
- Alien saucers fall from the top.
- You shoot them with bullets before they slip past you.
- If an enemy gets past your ship, you lose a life. Lose all three and it's game over.
- Enemies get faster the longer you survive.

Here is how the pieces connect:

| Piece | What it does |
|---|---|
| `gameState` | A string — `"title"`, `"playing"`, or `"gameover"` — that decides what gets drawn and updated each frame. |
| `player` table | Holds the ship's position, speed, lives, score, and two timers: one for shoot rate, one for brief invincibility after being hit. |
| `bullets` table | Every time you press Space, two small rectangles are added here. Each frame they move upward. When they leave the screen, they're removed. |
| `enemies` table | A timer fires every second or so and adds a new saucer at the top. Each saucer moves downward. They get faster as `gameTimer` grows. |
| `explosions` table | When something is destroyed, a burst of tiny dots is added here. They fly outward and fade over about half a second. |
| `stars` table | 80 small dots that scroll downward slowly, giving the illusion of flying through space. |
| `checkCollision` | The same rectangle-overlap function from Assignment 11. It checks bullet-vs-enemy and enemy-vs-player. |
| `resetGame` | One function that clears all the tables and resets the player back to starting values. Called when a new run begins. |

The flow every frame looks like this:

```
love.update(dt)
  → scroll stars
  → move player left/right
  → move bullets upward, remove off-screen ones
  → spawn enemies on a timer
  → move enemies downward
      → if an enemy reaches the bottom: lose a life
      → if a bullet hits an enemy: remove both, spawn explosion, add score
      → if an enemy hits the player: lose a life, brief invincibility
  → tick explosion particles, remove dead ones
  → add one point every second (survival bonus)

love.draw()
  → dark background
  → scrolling stars
  → (title screen OR game screen OR game-over screen)
```

---

## Your mission

The starter file is the complete game with **five key parts removed**. Fill them back in:

**TODO 1 — Scroll the stars.**
In `love.update`, each star should move downward each frame and wrap back to the top when it falls off the bottom.

**TODO 2 — Move the player left and right.**
Check if the left/right arrow keys (or A/D) are held down and move `player.x` accordingly. Clamp it so the ship can't leave the screen.

**TODO 3 — Shoot bullets.**
When Space is held and `player.shootCooldown` is zero, add two bullet tables to the `bullets` list — one near the left edge of the ship and one near the right. Reset the cooldown to `0.18` seconds.

**TODO 4 — Move bullets upward and remove them when off-screen.**
Loop through `bullets` backwards. Subtract `BULLET_SPEED * dt` from each bullet's `y`. If the bottom edge of the bullet is above the top of the screen (`b.y + b.h < 0`), remove it.

**TODO 5 — Fill in `checkCollision`.**
The placeholder returns `false` for every pair. Replace it with the real AABB overlap formula from Assignment 11.

---

## Hints

<details><summary>Hint 1 — Scrolling stars</summary>

Each star has a `speed` field. Every frame, add `s.speed * dt` to `s.y`. When `s.y` is bigger than `SCREEN_H + 4`, reset it to `-4` and pick a new random `s.x`.

```lua
s.y = s.y + s.speed * dt
if s.y > SCREEN_H + 4 then
    s.y = -4
    s.x = math.random(0, SCREEN_W)
end
```
</details>

<details><summary>Hint 2 — Shooting bullets</summary>

Check the cooldown before adding bullets. Spawn two at once — one on the left side of the ship, one on the right — for a spread effect. Don't forget to reset the cooldown.

```lua
if love.keyboard.isDown("space") and player.shootCooldown <= 0 then
    table.insert(bullets, { x = player.x + 8,             y = player.y, w = 4, h = 14 })
    table.insert(bullets, { x = player.x + player.w - 12, y = player.y, w = 4, h = 14 })
    player.shootCooldown = 0.18
end
```
</details>

<details><summary>Hint 3 — checkCollision formula</summary>

Two rectangles overlap when neither one is fully to the left, right, above, or below the other. All four conditions must be true at the same time:

```lua
function checkCollision(a, b)
    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end
```
</details>

---

## Stretch Goals

1. **Add a high score that survives between games.** The solution already tracks `player.highScore` in memory. Go further: save it to a file using `love.filesystem.write` (from Assignment 21) so it persists even after you close the game.
2. **Give enemies different speeds and colors.** The solution uses a single `hue` field for color variation. Try adding a `type` field — some enemies move in a zigzag, some are faster but worth more points.
3. **Add a power-up.** Occasionally spawn a glowing item that falls like an enemy. If the player touches it, they gain an extra life or a rapid-fire burst for five seconds.
