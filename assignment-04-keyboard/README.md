# Assignment 04: Keyboard Input

So far your programs just sit there looking pretty. Time to change that! In this assignment you will make a square that **you control** with the keyboard. Press a key — the square moves. That is the heart of every game ever made.

---

## What you'll learn

How to read keyboard input every frame and use it to move something on screen, with smooth speed that works the same on every computer.

---

## How it works

### The game loop — a very fast heartbeat

Your LÖVE2D program has three main functions. Think of them like this:

- `love.load()` — runs **once** when the game starts. Set up your variables here.
- `love.update(dt)` — runs **~60 times every second**. This is where things move and change.
- `love.draw()` — runs right after update, also ~60 times a second. This is where you draw everything.

Every second, update and draw each run about 60 times. That is fast enough that it looks smooth to your eyes — like a flipbook.

### What is `dt`?

`dt` stands for **delta time**. It means "how many seconds passed since the last frame."

On a fast computer, frames happen very quickly, so `dt` is tiny (like `0.008`).
On a slow computer, frames take longer, so `dt` is bigger (like `0.033`).

Here is the problem without `dt`: if you move the player 5 pixels every frame, a fast computer moves the player **300 pixels per second** but a slow computer moves only **150 pixels per second**. That is unfair!

The fix is simple — multiply your speed by `dt`:

```lua
playerX = playerX + playerSpeed * dt
```

Now the player always moves at `playerSpeed` **pixels per second**, no matter how fast or slow the computer is. Fast computer, small `dt`, small nudge each frame. Slow computer, big `dt`, big nudge each frame. It all evens out.

Think of it like a car's speedometer. Whether you check it every second or every minute, the speed in km/h stays the same.

### Checking if a key is held down

```lua
love.keyboard.isDown("right")
```

This returns `true` if that key is being held right now, or `false` if it is not. You call this inside `love.update` so it gets checked every single frame.

Some key names you can use: `"left"`, `"right"`, `"up"`, `"down"`, `"a"`, `"w"`, `"s"`, `"d"`, `"space"`

### If statements — making decisions

An **if statement** runs some code only when a condition is true:

```lua
if love.keyboard.isDown("right") then
    playerX = playerX + playerSpeed * dt
end
```

Think of it like: "IF the right key is held, THEN scoot the player to the right."

You can check two things at once using `or`:

```lua
if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    playerX = playerX + playerSpeed * dt
end
```

This runs if either key is held — so both arrow keys and WASD work at the same time.

### Which direction is which?

The screen's coordinate system might surprise you:

- `x = 0` is the **left** edge. `x` increases going **right**.
- `y = 0` is the **top** edge. `y` increases going **down**.

So moving **up** means making `y` *smaller*, and moving **down** means making `y` *larger*. A bit backwards from what you might expect, but you will get used to it fast!

---

### isDown vs keypressed — two different tools

`love.keyboard.isDown` is **continuous**: it is `true` every single frame the key is held. Perfect for smooth movement.

`love.keypressed(key)` is a special function LÖVE2D calls **once** the moment a key is pressed. It fires a single time, even if you hold the key for five seconds. Perfect for one-time actions like jumping, shooting, or opening a menu.

You will use `love.keypressed` a lot in later assignments (the reset key in assignment 05 uses it already). For movement, always reach for `isDown`.

---

### Cleaner code with elseif

When only one direction can apply at a time, `elseif` avoids checking conditions that can't all be true at once:

```lua
if love.keyboard.isDown("left") then
    playerX = playerX - playerSpeed * dt
elseif love.keyboard.isDown("right") then
    playerX = playerX + playerSpeed * dt
end
```

For this assignment, separate `if` blocks work fine and give you diagonal movement for free. But keep `elseif` in mind for situations where choices are mutually exclusive.

---

## Your mission

Open `starter/main.lua`. The player square, its speed, and `love.draw` are already done. Your job is to fill in `love.update` so the square actually moves.

Fill in the four TODOs:

1. **TODO 1** — Move **left** when the left arrow or `a` is held (if-header is given, write the body)
2. **TODO 2** — Move **right** when the right arrow or `d` is held (write the full if block yourself)
3. **TODO 3** — Move **up** when the up arrow or `w` is held
4. **TODO 4** — Move **down** when the down arrow or `s` is held

Run it with `love starter/` and zoom your square around the screen!

---

## Hints

<details><summary>Hint 1 — What does "move left" mean in code?</summary>

Moving left means the player's x position gets smaller. Smaller x = further left.

Use `playerSpeed * dt` for the amount to move. Use `-` to go left. The `if` header with `or` is already in the starter — you just need the one line inside it:

```lua
playerX = playerX - playerSpeed * dt
```
</details>

<details><summary>Hint 2 — What about right, up, and down?</summary>

Right increases x. Down increases y. Up decreases y (y goes downward on screen!).

Each direction needs its own `if` block. Copy the shape from TODO 1 and adjust the key names and the `+` or `-`.
</details>

<details><summary>Hint 3 — All four directions together</summary>

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

Four separate `if` blocks means holding two keys at once gives diagonal movement for free!
</details>

---

## Stretch Goals

1. **Stop at the edges!** After all four movement checks, add four more `if` statements to clamp the player inside the screen. For example: `if playerX < 0 then playerX = 0 end`. Do all four edges — and remember to account for `playerSize` on the right and bottom edges!

2. **Speed boost!** Make the player move faster when left shift is held. Inside each `if` block, check `love.keyboard.isDown("lshift")` and use a higher speed value if it is true.

3. **Change color while moving!** In `love.draw`, check which key is held and call `love.graphics.setColor` with a different color depending on direction. Go left — turn red. Go right — turn green. Get creative!
