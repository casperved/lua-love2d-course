# Assignment 12: Game States

Every real game has more than one screen. Before you press start, you see a menu. When you die, you see a game over screen. This assignment teaches you how to build all three.

---

## What you'll learn

How to use a single variable to control which "screen" your game is showing — and how to switch between screens when something happens.

---

## How it works

Think about a board game. At any moment, the game is in exactly one situation:

- **Not started yet** — the box is on the table, nobody has set up the pieces
- **In progress** — everyone is playing
- **Game over** — someone won and the game is finished

Your program works the same way. We use one variable called `gameState` to remember which situation we're in right now. It holds a word:

```lua
gameState = "title"     -- sitting at the menu
gameState = "playing"   -- the game is running
gameState = "gameover"  -- the player just lost
```

Then, in `love.update` and `love.draw`, we use `if/elseif` to ask "what state are we in?" and do the right thing:

```lua
function love.update(dt)
    if gameState == "playing" then
        -- only move things while the game is actually running
    end
end

function love.draw()
    if gameState == "title" then
        -- show the title screen
    elseif gameState == "playing" then
        -- show the game
    elseif gameState == "gameover" then
        -- show the game over screen
    end
end
```

To switch screens, just set `gameState` to a new word:

```lua
gameState = "playing"    -- player pressed Enter — start the game!
gameState = "gameover"   -- player ran out of lives — end the game!
```

That one line is all it takes to jump to a completely different screen. This idea is called a **state machine**. It sounds fancy, but it's really just a variable and some `if` checks. Nearly every game ever made uses this pattern.

---

## Your mission

You're building a mini dodge game with three screens:

1. **Title screen** — shows the game name and "Press Enter to start"
2. **Playing** — a red box falls from the top. Move your blue bar left and right to dodge it. Dodge it once and score a point. Get hit and lose a life. Lose all 3 lives and it's game over.
3. **Game over screen** — shows your final score and "Press R to play again"

There are four TODOs to fill in:

- **TODO 1** — Wrap all the game logic inside `if gameState == "playing" then ... end` so nothing moves on the title or game over screens
- **TODO 2** — After the player loses a life, check if lives have hit zero and switch to `"gameover"`
- **TODO 3** — In `love.draw`, use `if/elseif` to draw the right screen for each state
- **TODO 4** — In `love.keypressed`, make Enter start the game and R restart it

---

## Hints

<details><summary>Hint 1 — How to wrap the game logic (TODO 1)</summary>

In `love.update`, put an `if` around everything so it only runs during gameplay:

```lua
function love.update(dt)
    if gameState == "playing" then
        -- all the movement and collision code goes here
    end
end
```

If you skip this, the enemy will keep moving even on the title screen!
</details>

<details><summary>Hint 2 — How to trigger game over (TODO 2)</summary>

Right after `lives = lives - 1`, add a check:

```lua
if lives <= 0 then
    gameState = "gameover"
end
```

That single line is all you need. The next frame, `love.draw` will see the new state and show the game over screen automatically.
</details>

<details><summary>Hint 3 — Drawing each screen and handling key presses (TODOs 3 and 4)</summary>

For drawing, build an `if/elseif` chain inside `love.draw`:

```lua
if gameState == "title" then
    love.graphics.print("DODGE!", 330, 180)
    love.graphics.print("Press ENTER to start!", 300, 370)
elseif gameState == "playing" then
    -- draw the enemy, player, score, and lives here
elseif gameState == "gameover" then
    love.graphics.print("GAME OVER", 330, 230)
    love.graphics.print("Press R to play again.", 305, 320)
end
```

For key presses, check the state *and* the key together:

```lua
function love.keypressed(key)
    if gameState == "title" and key == "return" then
        gameState = "playing"
    elseif gameState == "gameover" and key == "r" then
        gameState = "title"
        lives = 3
        score = 0
        player.x = 375
        resetEnemy()
    end
end
```
</details>

---

## Stretch Goals

1. **Pause state** — Press P during gameplay to freeze everything and show "PAUSED". Press P again to resume. You'll need a new `"paused"` state.
2. **Speed up over time** — The enemy already gets a tiny bit faster with each point scored (look at `resetEnemy`). Try making it faster — double the bonus, or add a multiplier after 10 points.
3. **High score** — Add a `highScore` variable that never resets. Update it when the game ends if `score > highScore`. Show it on the title screen so players always know what to beat.
