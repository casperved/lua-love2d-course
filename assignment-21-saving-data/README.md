# Assignment 21: Saving & Loading Data

Imagine playing a game, getting a great score — then closing the game and losing it forever. Not fun! In this assignment you'll learn how to **save data to a file** so your best time is remembered even after the game closes.

---

## What you'll learn

How to write a number to a file on disk and read it back when the game starts up again.

---

## How it works

Think of your computer's hard drive like a notebook. Your game can write things in the notebook, close, and when it opens again it can read what it wrote before.

LÖVE gives every game its own private page in that notebook. You use `love.filesystem` to write and read from it.

### Writing to the notebook

When you want to save something, you call `love.filesystem.write`. You give it two things: a filename (like `"best_time.txt"`) and the text to save.

There's one catch: **files store text, not numbers**. So you have to turn your number into text first. That's what `tostring` does.

```lua
-- 42.5 becomes the text "42.5"
love.filesystem.write("best_time.txt", tostring(42.5))
```

### Reading from the notebook

When you want to load something back, you call `love.filesystem.read`. It gives you the text that was saved.

Now you need to go the other way: turn text back into a number. That's what `tonumber` does.

```lua
local data = love.filesystem.read("best_time.txt")
local myNumber = tonumber(data)   -- "42.5" becomes 42.5
```

But what if the file doesn't exist yet? (First time the player ever runs the game.) You check first with `love.filesystem.getInfo`. If it says the file doesn't exist, just return `0` as a safe default.

```lua
function loadScore()
    if love.filesystem.getInfo("best_time.txt") then
        local data = love.filesystem.read("best_time.txt")
        return tonumber(data) or 0
    end
    return 0   -- file doesn't exist yet, that's fine
end
```

> **Where does the file go?** LÖVE saves it in a special folder it controls. You can find out exactly where by running `print(love.filesystem.getSaveDirectory())` — but you don't need to worry about it. LÖVE handles the messy details.

---

## Your mission

Open `starter/main.lua`. The survival game is already working — you move the blue dot, the red enemy chases you, and the timer ticks up. Your job is to make the **best time stick around between runs**.

There are three TODOs:

1. **`saveScore(time)`** — write the time to `"best_time.txt"`. Convert the number to a string first with `tostring`.
2. **`loadScore()`** — read `"best_time.txt"` and return the number inside. Return `0` if the file doesn't exist yet.
3. **Wire it up** — in `love.load`, call `loadScore()` and put the result in `bestTime`. In the game-over collision block inside `love.update`, check if the current `timer` beats `bestTime` — if it does, save it and set `newRecord = true`.

---

## Hints

<details>
<summary>Hint 1 — saveScore</summary>

`love.filesystem.write` only accepts text (a string), not a number. Wrap your time value in `tostring(...)` to convert it.

```lua
function saveScore(time)
    love.filesystem.write("best_time.txt", tostring(time))
end
```
</details>

<details>
<summary>Hint 2 — loadScore</summary>

First check if the file exists. If it does, read it and convert the text back to a number with `tonumber`. The `or 0` part is a safety net in case something goes wrong.

```lua
function loadScore()
    if love.filesystem.getInfo("best_time.txt") then
        local data = love.filesystem.read("best_time.txt")
        return tonumber(data) or 0
    end
    return 0
end
```
</details>

<details>
<summary>Hint 3 — Wiring it up</summary>

In `love.load`, add this one line (just before or after `resetGame()`):

```lua
bestTime = loadScore()
```

In `love.update`, inside the collision block, add this before `state = "gameover"`:

```lua
if timer > bestTime then
    bestTime  = timer
    saveScore(bestTime)
    newRecord = true
end
```
</details>

---

## Stretch Goals

- **Reset button** — on the game-over screen, let the player press `R` to wipe the save file with `love.filesystem.remove` and reset `bestTime` to `0`.
- **Top 5 leaderboard** — instead of saving one number, save all times (one per line). On load, split the text by `"\n"`, convert each line, sort the list, and show the top 5 on the title screen.
- **Save file inspector** — press `Tab` on any screen to show a small overlay that prints the raw text inside `best_time.txt`. Great for seeing exactly what's on disk and understanding how it works.
