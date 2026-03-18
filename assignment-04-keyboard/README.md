# Assignment 04: Keyboard Input

A game where nothing moves isn't much of a game! In this assignment you'll learn how to read keyboard input and use it to move a square around the screen. Your first interactive program — let's go!

---

## `love.update(dt)` — The Heartbeat of Your Game

Remember how `love.update(dt)` runs about 60 times per second? That's where we handle **everything that changes over time**: movement, physics, timers, game logic.

The `dt` parameter stands for **delta time** — it's the number of seconds that passed since the last frame. On a smooth 60 FPS game, `dt` is roughly `0.016` (one sixtieth of a second).

Why does `dt` matter? Imagine you move the player 5 pixels every frame. On a fast computer running at 120 FPS, the player moves **600 pixels per second**. On a slow computer at 30 FPS, the player moves only **150 pixels per second**. That's unfair and inconsistent!

The fix: multiply your speed by `dt`. Now movement is measured in **pixels per second** regardless of how fast the computer runs.

```lua
playerX = playerX + speed * dt    -- move at "speed" pixels per second, always
```

---

## Checking for Key Presses

```lua
love.keyboard.isDown("key")
```

This returns `true` if the key is currently being held down, or `false` if it's not. You call this inside `love.update` to check every frame.

Common key names: `"left"`, `"right"`, `"up"`, `"down"`, `"a"`, `"b"`, `"space"`, `"return"`, `"escape"`

---

## If Statements

An **if statement** lets your code make decisions:

```lua
if someCondition then
    -- this code runs only when the condition is true
end
```

You can also check two conditions at once using `or` and `and`:

```lua
if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    -- runs if EITHER "left" OR "a" is held
end
```

---

## Putting It Together

```lua
function love.update(dt)
    if love.keyboard.isDown("right") then
        playerX = playerX + playerSpeed * dt
    end
end
```

This says: "Every frame, if the right arrow is held, move the player to the right by `playerSpeed` pixels per second."

---

## Your Mission

Open `starter/main.lua`. The player square and speed variables are already set up. Fill in the TODOs to:

1. Move **left** when the left arrow or `A` key is held
2. Move **right** when the right arrow or `D` key is held
3. Move **up** when the up arrow or `W` key is held
4. Move **down** when the down arrow or `S` key is held

Run it and zoom your square around the screen!

---

## Hints

<details>
<summary>Hint 1 — Moving left</summary>

Moving left means *decreasing* x (remember, x goes right). Use `or` to check both keys at once:

```lua
if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    playerX = playerX - playerSpeed * dt
end
```
</details>

<details>
<summary>Hint 2 — Moving right and down</summary>

Moving right increases x. Moving down increases y (remember, y goes down on screen!):

```lua
if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    playerX = playerX + playerSpeed * dt
end

if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    playerY = playerY + playerSpeed * dt
end
```
</details>

<details>
<summary>Hint 3 — All four directions together</summary>

All four `if` blocks go inside `love.update(dt)`, one after another. They're independent — you can even hold two keys at once to move diagonally!

```lua
function love.update(dt)
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        playerX = playerX - playerSpeed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        playerX = playerX + playerSpeed * dt
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        playerY = playerY - playerSpeed * dt
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        playerY = playerY + playerSpeed * dt
    end
end
```
</details>

---

## Stretch Goals

1. **Stop at the edges!** After moving, add checks to prevent the player from going off-screen. For example: `if playerX < 0 then playerX = 0 end`. Do this for all four edges. (Remember to account for the player's size!)

2. **Speed boost!** Make the player move faster when the `"lshift"` key (left shift) is held. Hint: inside each if block, check `love.keyboard.isDown("lshift")` and use a bigger speed value.

3. **Leave a trail!** Create a variable `trailAlpha` starting at `0.3`. In `love.draw`, before drawing the player square, draw a slightly bigger, slightly transparent square in a different color at the same position. It'll look like a glow effect!
