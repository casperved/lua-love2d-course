# Assignment 12: Game States 🎮

You've built moving objects, handled input, and detected collisions. Now it's time to make something that feels like a *real game*. The secret ingredient? **Game states!**

---

## What is a Game State?

Almost every game has different "screens" or "modes":

- A **title screen** where you see the game's name and press a button to start
- The **gameplay** itself
- A **game over screen** showing your final score

We handle this with a single variable — usually called `gameState` — that holds a string like `"title"`, `"playing"`, or `"gameover"`. Then we use `if/elseif` to run different code depending on which state we're in.

This idea is called a **state machine** and it's used in nearly every game ever made!

---

## How It Works

```lua
gameState = "title"

function love.update(dt)
    if gameState == "title" then
        -- only run title logic here
    elseif gameState == "playing" then
        -- only run game logic here
    elseif gameState == "gameover" then
        -- only run game over logic here
    end
end

function love.draw()
    if gameState == "title" then
        -- draw the title screen
    elseif gameState == "playing" then
        -- draw the game
    elseif gameState == "gameover" then
        -- draw the game over screen
    end
end
```

To switch states, just assign a new value:
```lua
gameState = "playing"   -- transitions from title to game
gameState = "gameover"  -- player just died!
```

---

## Your Mission

Build a 3-state mini-game:

1. **Title screen** — shows the game name and "Press Enter to start"
2. **Playing** — a box falls from the top, player moves left/right to dodge, loses a life if hit, earns a point if it falls off the bottom
3. **Game Over** — shows final score and "Press R to restart"

---

## TODOs in the Starter File

1. **TODO 1** — Wrap the game logic in `if gameState == "playing" then ... end`
2. **TODO 2** — When lives reach 0, switch `gameState` to `"gameover"`
3. **TODO 3** — In `love.draw`, use if/elseif to draw the right screen for each state
4. **TODO 4** — In `love.keypressed`, handle Enter to start and R to restart

---

## Hints

<details><summary>Hint 1 — Wrapping game logic in a state check</summary>

In `love.update`, wrap all the game logic like this:

```lua
function love.update(dt)
    if gameState == "playing" then
        -- all your movement, enemy, collision code goes here
    end
end
```

This way nothing moves while you're on the title screen or game over screen.
</details>

<details><summary>Hint 2 — Switching to game over</summary>

After subtracting a life, check if the player has run out:

```lua
if lives <= 0 then
    gameState = "gameover"
end
```
</details>

<details><summary>Hint 3 — Drawing each state and handling key presses</summary>

For drawing:
```lua
if gameState == "title" then
    love.graphics.print("DODGE!", 340, 200)
    love.graphics.print("Press Enter to start", 300, 280)
elseif gameState == "playing" then
    -- draw player, enemy, score, lives
elseif gameState == "gameover" then
    love.graphics.print("Game Over!", 330, 250)
    love.graphics.print("Score: " .. score, 350, 290)
    love.graphics.print("Press R to restart", 310, 330)
end
```

For key presses:
```lua
function love.keypressed(key)
    if gameState == "title" and key == "return" then
        gameState = "playing"
    elseif gameState == "gameover" and key == "r" then
        gameState = "title"
        lives = 3
        score = 0
        resetEnemy()
        player.x = 375
    end
end
```
</details>

---

## Stretch Goals

1. **Pause state** — Press Escape during gameplay to enter a `"paused"` state. Press Escape again to resume.
2. **Speed up the enemy** — Each time the player dodges successfully, increase `enemy.speed` by a little bit.
3. **Multiple enemies** — Add a second falling enemy that starts appearing after the player has scored 5 points.
