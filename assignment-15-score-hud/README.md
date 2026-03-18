# Assignment 15: Score & HUD 🖥️❤️🏆

You've got a working game — now let's make it *look* like a real game! A **HUD** (Heads-Up Display) is the layer of information drawn on top of the game: your score, health, ammo, time remaining, and so on. In this assignment you'll build a proper HUD complete with a formatted score, life hearts, and a persistent high score.

---

## What is a HUD?

In almost every game you've ever played, information is drawn *on top of* the game world — health bars in an RPG, ammo count in a shooter, lap times in a racing game. That overlay is the HUD.

In LÖVE, you draw the HUD last in `love.draw()`, after all the game world objects. This way it always appears on top.

---

## Formatting Numbers with `string.format`

Raw numbers can look sloppy. `string.format` gives you precise control:

```lua
string.format("%d", 42)       -- "42"           (plain integer)
string.format("%05d", 42)     -- "00042"         (5 digits, zero-padded)
string.format("%06d", 1234)   -- "001234"        (6 digits, zero-padded)
string.format("%.2f", 3.14159) -- "3.14"         (2 decimal places)
```

The `%05d` format is the classic arcade-style score display. That's what we'll use!

---

## Persisting a High Score

A high score lives in a variable that is **never reset** between rounds:

```lua
highScore = 0    -- only reset when the whole program starts

-- When a round ends:
if score > highScore then
    highScore = score
end
-- Now start a new round — score resets, but highScore stays!
```

---

## Drawing Heart Icons with Shapes

You can approximate a heart with two circles (the bumps) and a downward triangle (the point):

```lua
function drawHeart(x, y, size, filled)
    if filled then
        love.graphics.setColor(1, 0.2, 0.2)
    else
        love.graphics.setColor(0.35, 0.35, 0.35)
    end
    -- Left bump
    love.graphics.circle("fill", x - size*0.25, y, size*0.35)
    -- Right bump
    love.graphics.circle("fill", x + size*0.25, y, size*0.35)
    -- Bottom point
    love.graphics.polygon("fill",
        x - size*0.6, y + size*0.15,
        x + size*0.6, y + size*0.15,
        x,            y + size*0.75)
end
```

Then to draw 3 hearts (filled based on remaining lives):
```lua
for i = 1, 3 do
    drawHeart(700 + i * 35, 25, 20, i <= lives)
end
```

---

## Your Mission

Build on the asteroid dodger from Assignment 14 and add:
- A **zero-padded score** in arcade style
- **Heart icons** representing remaining lives (filled = alive, grey = lost)
- A **high score** that survives between rounds

---

## TODOs in the Starter File

1. **TODO 1** — Implement `drawHeart(x, y, size, filled)` using two circles and a triangle polygon.
2. **TODO 2** — When an asteroid hits the player, subtract a life. If lives reach 0, set `gameOver = true` and update `highScore`.
3. **TODO 3** — Draw a proper HUD: formatted score, high score, and the 3 heart icons.

---

## Hints

<details><summary>Hint 1 — Building the heart shape</summary>

```lua
function drawHeart(x, y, size, filled)
    local r, g, b = 1, 0.2, 0.2
    if not filled then r, g, b = 0.35, 0.35, 0.35 end
    love.graphics.setColor(r, g, b)
    love.graphics.circle("fill", x - size*0.25, y, size*0.35)
    love.graphics.circle("fill", x + size*0.25, y, size*0.35)
    love.graphics.polygon("fill",
        x - size*0.6, y + size*0.15,
        x + size*0.6, y + size*0.15,
        x,            y + size*0.75)
end
```
</details>

<details><summary>Hint 2 — Life subtraction and high score update</summary>

Inside the asteroid collision branch:

```lua
table.remove(asteroids, i)
lives = lives - 1
if lives <= 0 then
    gameOver  = true
    highScore = math.max(highScore, score)
end
```

`math.max` picks the bigger of the two — so `highScore` only ever goes up!
</details>

<details><summary>Hint 3 — Drawing the full HUD</summary>

At the top of `love.draw()`, after drawing the background and game objects:

```lua
-- Score (zero-padded to 6 digits)
love.graphics.setColor(1, 1, 1)
love.graphics.print("SCORE  " .. string.format("%06d", score),     10, 10)
love.graphics.print("BEST   " .. string.format("%06d", highScore), 10, 30)

-- Hearts on the right side
for i = 1, 3 do
    drawHeart(700 + i * 35, 25, 20, i <= lives)
end
```
</details>

---

## Stretch Goals

1. **Animated hearts** — When a life is lost, make the corresponding heart briefly flash white before turning grey (use a small timer).
2. **Score pop-up** — Each time an asteroid is dodged (falls off screen), show a little "+10" floating text that rises and fades over 1 second.
3. **Save the high score to a file** — Use `love.filesystem.write("highscore.txt", tostring(highScore))` to save it between game sessions, and `love.filesystem.read` to load it at startup.
