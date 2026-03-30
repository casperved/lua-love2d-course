# Assignment 15: Score & HUD

You know how every arcade game shows your score in big glowing digits at the top of the screen? And how little hearts show how many lives you have left? That's called a **HUD**. Today you're going to build one.

---

## What you'll learn

How to display a formatted score, draw heart-shaped life icons, and keep track of a high score that survives between rounds.

---

## How it works

### What even is a HUD?

HUD stands for **Heads-Up Display**. It's the info layer drawn on top of the game — score, health, ammo, timer. Think of it like the dashboard of a car: the road is the game world, and the speedometer is the HUD.

In LÖVE you draw the HUD **last** inside `love.draw()`, after everything else. That way it always sits on top.

### Fancy score numbers with `string.format`

A raw number looks boring: `42`. Arcade games show something like `000042`. That leading-zero style is called **zero-padding**.

`string.format` is like a fill-in-the-blanks template for text:

```lua
string.format("%06d", 42)    -- "000042"  (6 digits, pad with zeros)
string.format("%06d", 1234)  -- "001234"
```

The `%06d` means: *"give me a whole number (`d`), at least 6 characters wide (`6`), padded with zeros (`0`)."*

### A high score that sticks around

The trick to a high score is simple: **never reset it**. Everything else (score, lives, asteroids) resets when you press R to play again — but `highScore` stays put the whole time the program is running.

```lua
-- When the game ends:
highScore = math.max(highScore, score)
-- math.max picks whichever is bigger, so highScore only ever goes up.
```

### Drawing a heart with shapes

You can fake a heart shape using things LÖVE already knows how to draw:

- Two circles side by side → the bumpy top of the heart
- A triangle pointing down → the pointy bottom

```
  ●  ●       ← two circles
   ▼          ← triangle
```

When a life is **filled** (still alive) the heart is red. When it's **empty** (used up) it's dark grey.

---

## Your mission

The asteroid-dodger game is already set up. Your job is to fill in three TODOs:

1. **TODO 1** — Write the `drawHeart` function so it draws a proper red or grey heart.
2. **TODO 2** — When an asteroid hits the player, subtract a life. If lives hit zero, end the game and save the high score.
3. **TODO 3** — Replace the plain-text HUD with the real one: a zero-padded score, a best score, and three heart icons.

Run with `love starter/` and you'll see a working game with a basic placeholder HUD. Each TODO you complete makes it look more like a real game.

---

## Hints

<details><summary>Hint 1 — Drawing the heart shape</summary>

A heart is two circles plus one triangle. The `filled` parameter decides the colour.

```lua
function drawHeart(x, y, size, filled)
    local r, g, b = 1, 0.2, 0.2          -- red when filled
    if not filled then r, g, b = 0.35, 0.35, 0.35 end  -- grey when empty
    love.graphics.setColor(r, g, b)
    -- Left bump
    love.graphics.circle("fill", x - size*0.25, y, size*0.35)
    -- Right bump
    love.graphics.circle("fill", x + size*0.25, y, size*0.35)
    -- Bottom point (a triangle using three corners)
    love.graphics.polygon("fill",
        x - size*0.6, y + size*0.15,
        x + size*0.6, y + size*0.15,
        x,            y + size*0.75)
end
```
</details>

<details><summary>Hint 2 — Losing a life and saving the high score</summary>

Inside the asteroid collision block, after removing the asteroid:

```lua
lives = lives - 1
heartFlash = 0.4    -- triggers the flash animation
if lives <= 0 then
    gameOver  = true
    highScore = math.max(highScore, score)
end
```

`math.max(highScore, score)` picks whichever number is bigger — so the high score never shrinks.
</details>

<details><summary>Hint 3 — Drawing the full HUD</summary>

In `love.draw()`, after the background and game objects, draw the HUD panel:

```lua
-- Dark bar across the top
love.graphics.setColor(0, 0, 0, 0.45)
love.graphics.rectangle("fill", 0, 0, 800, 55)

-- Score label + zero-padded number
love.graphics.setColor(0.9, 0.9, 0.3)
love.graphics.print("SCORE", 10, 8)
love.graphics.setColor(1, 1, 1)
love.graphics.print(string.format("%06d", score), 10, 26)

-- Best score
love.graphics.setColor(0.6, 0.8, 1)
love.graphics.print("BEST", 160, 8)
love.graphics.setColor(1, 1, 1)
love.graphics.print(string.format("%06d", highScore), 160, 26)

-- Three hearts on the right
for i = 1, 3 do
    drawHeart(700 + i * 33, 24, 22, i <= lives)
end
```
</details>

---

## Stretch Goals

1. **Animated hearts** — When a life is lost, make the empty heart briefly flash white before turning grey. The starter already has a `heartFlash` timer variable waiting for you to use it.
2. **Score pop-up** — Each time an asteroid flies off the bottom of the screen, show a small `+10` floating upward and fading out over about a second.
3. **Save to a file** — Use `love.filesystem.write("highscore.txt", tostring(highScore))` to save the best score to disk so it survives closing the game. Load it back in `love.load()` with `love.filesystem.read`.
