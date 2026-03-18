# Assignment 20: Final Project — Your Game!

# You made it. This is huge.

Seriously — you started with a blank screen and `print("Hello")`, and now you know how to move players, detect collisions, spawn enemies, generate worlds procedurally, play sounds, track scores, and build complete games with title screens and game-over states. That's a real skill set. Be proud of that.

Now it's time to use everything you've learned to build **your own game**. There are no TODOs this time. No template to fill in. This is your project, your idea, your creative vision.

---

## Your Mission

Build a game. Any game. It just needs to:

- Have a player the user can control
- Have a goal (something to achieve or survive)
- Have a way to win or lose (or a score to beat)
- Run without crashing

That's it. The rest is up to you.

---

## How to Start: A Proven Plan

Don't try to build everything at once. Follow these steps, one at a time:

### Step 1 — Choose your game type

Pick one idea from the list below (or invent your own!). The simpler, the better for your first solo project.

### Step 2 — Plan it on paper (5 minutes)

Grab a piece of paper and answer:
- What does the player do every frame? (move, shoot, jump?)
- What is the win condition? Or is it a survival score game?
- What objects does the game have? (player, enemies, bullets, platforms?)
- How does the player lose?

### Step 3 — Start with just the player

Open `starter/main.lua` and get a character moving on screen. Don't add anything else until that feels right. Run the game every few minutes — small steps!

### Step 4 — Add one mechanic at a time

Add enemies. Run it. Add collision. Run it. Add scoring. Run it. Never add two big things at the same time — if something breaks, you won't know which change caused it.

### Step 5 — Playtest constantly

Every time you add something, play the game and ask: *is this fun? is this fair? does it feel good?*

### Step 6 — Add polish last

Title screen, game-over screen, colours, a high score, visual effects, sounds. Do all of this *after* the core game works.

---

## Game Type Ideas

### Platformer
The player jumps between platforms, collecting items or reaching a goal.

**Key hints:**
- Add a `vy` (vertical velocity) field to your player.
- Each frame: `player.vy = player.vy + gravity * dt` (gravity ≈ 600).
- Move the player: `player.y = player.y + player.vy * dt`.
- When the player lands on a platform: set `vy = 0` and clamp the y position.
- Jump: if the player is on the ground and Space is pressed, set `player.vy = -400`.

### Space Shooter
The player is at the bottom, firing bullets upward at descending enemies.

**Key hints:**
- `bullets` table, spawn one when Space is pressed.
- Each bullet: `b.y = b.y - bulletSpeed * dt`. Remove when `b.y < 0`.
- Enemies: spawn at the top, move downward. Remove when off-screen.
- Check collision between every bullet and every enemy (nested loops).

### Box Puzzle (Sokoban-style)
The player pushes boxes onto marked target squares on a grid.

**Key hints:**
- Use a 2D grid: `grid[row][col]` = "wall", "floor", "box", "target".
- Move one tile per key press (not continuous — check once in `keypressed`).
- Win when every target cell has a box on it.

### Top-Down Racer
A car (seen from above) drives around a track, avoiding obstacles.

**Key hints:**
- The car has a `rotation` angle and moves in the direction it's facing.
- Turn left/right: `car.rotation = car.rotation - turnSpeed * dt`.
- Move forward: `car.x = car.x + math.cos(car.rotation) * speed * dt`.
- `math.sin` / `math.cos` give the x and y components of a direction.

---

## Tips for When Things Go Wrong

- **Read the error message carefully** — LÖVE2D tells you the line number and a description. Go to that line first.
- **Use `print()` to check values** — if something isn't working, add `print(player.x, player.y)` and watch the output in the terminal.
- **Comment things out** — if you're not sure which part is broken, comment out half your code and see if the problem disappears.
- **Save a copy before making big changes** — just duplicate your `main.lua` as `main_backup.lua` before trying something risky.
- **Take breaks** — seriously. When you're stuck, step away for 10 minutes. Fresh eyes spot bugs immediately.

---

## Stretch: Share Your Game!

Once you have something working, find a friend or family member and watch them play it — without helping them. Notice:
- Where do they get confused?
- What do they try to do that doesn't work?
- What do they enjoy?

Then fix the confusing parts and lean into what they liked. This is exactly how real game developers improve their games. It's called **playtesting**, and it's one of the most valuable skills you can develop.

---

## The Solution File

Check out `solution/main.lua` for a complete working mini-shooter built using the same template. It's there as **inspiration and reference**, not to copy. See how all the pieces — state machine, bullets table, enemy spawning, collision, HUD — fit together in a real game. Then go build yours.

---

You've got this. Have fun!
