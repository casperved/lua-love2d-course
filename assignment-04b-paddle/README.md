# Assignment 04b: Paddle Alignment

You already know how to move something with the keyboard from assignment 04. This time you only need **two directions** — UP and DOWN — but there is a purpose: a glowing green target zone is waiting on the right side of the screen, and your job is to line your paddle up with it.

---

## What you'll learn

How to use `love.keyboard.isDown` for precise up/down positioning — and why controlling *where* something stops is just as important as making it move at all.

---

## How it works

You already know the basics from assignment 04, so this will feel familiar. A quick recap:

- `love.keyboard.isDown("up")` returns `true` every frame the up arrow is held down.
- You multiply movement by `dt` so the speed is the same on every computer.
- On screen, **y = 0 is the top**. Going up means `y` gets *smaller*. Going down means `y` gets *larger*. Yes, it feels backwards — you will get used to it!

Think of the paddle like an **elevator**. It only goes up or down, and you decide exactly when it stops. The goal is to park it in just the right spot.

The new idea in this assignment is **alignment checking**. After you move the paddle, you check whether the paddle's centre is inside the target band. If it is, you set `aligned = true` and the screen flashes green. It is not a score system — just instant visual feedback that you nailed it.

The paddle's centre Y is:

```lua
paddleY + paddleH / 2
```

The target band runs from `targetY` at the top to `targetY + targetH` at the bottom. So the paddle is aligned when:

```lua
paddleCentre >= targetY  and  paddleCentre <= targetY + targetH
```

Press **R** at any time to jump the target to a new random position — the `love.keypressed` function is already written for you.

---

## Your mission

Open `starter/main.lua`. The visuals and the R-key handler are already working — run it with `love starter/` to see what you start with. Your job is to fill in the three TODOs inside `love.update(dt)`:

1. **TODO 1** — Move UP when the up arrow is held. The `if` header is given; write the one line inside it that decreases `paddleY`.
2. **TODO 2** — Move DOWN when the down arrow is held. Write the full `if` block yourself — same shape as TODO 1, but increasing `paddleY`.
3. **TODO 3** — Check alignment. Calculate the paddle's centre Y and compare it to the target band. Set `aligned = true` or `false` depending on whether they overlap.

Once all three are done, run the program and try to park your paddle inside the green zone. Press R to challenge yourself with a new target position.

---

## Hints

<details><summary>Hint 1 — Remind me how isDown works</summary>

It works exactly like assignment 04. Inside `love.update(dt)`, wrap your movement in an `if` statement:

```lua
if love.keyboard.isDown("up") then
    -- movement code goes here
end
```

`love.keyboard.isDown` is checked every frame, so the paddle moves smoothly as long as the key is held.
</details>

<details><summary>Hint 2 — Which way does paddleY change for up vs down?</summary>

Y on screen increases downward (top of screen is y = 0). So:

- Moving **up** → `paddleY` gets **smaller** → use `-`
- Moving **down** → `paddleY` gets **larger** → use `+`

The amount to move each frame is `paddleSpeed * dt`.

For TODO 3, work out the paddle's centre:
```lua
local paddleCentre = paddleY + paddleH / 2
```
Then check if it falls inside `targetY` to `targetY + targetH`.
</details>

<details><summary>Hint 3 — Show me TODO 1 written out (and the alignment check)</summary>

TODO 1 — moving up:
```lua
if love.keyboard.isDown("up") then
    paddleY = paddleY - paddleSpeed * dt
end
```

TODO 3 — alignment check:
```lua
local paddleCentre = paddleY + paddleH / 2
if paddleCentre >= targetY and paddleCentre <= targetY + targetH then
    aligned = true
else
    aligned = false
end
```

TODO 2 follows the exact same shape as TODO 1 — just flip the direction.
</details>

---

## Stretch Goals

1. **Add left and right too.** Give the paddle full four-direction movement (back to assignment 04 territory). You will need to add `paddleX` movement and update the clamping lines at the bottom of `love.update`.

2. **Make the target drift.** In `love.update`, add a small `targetSpeed` variable and move `targetY` up or down a little each frame. Reverse direction when it hits the top or bottom edge — now the player has to chase a moving target!

3. **Count your alignment time.** Add a `score` variable that increases by `dt` every frame the paddle is aligned (`if aligned then score = score + dt end`). Display it in the HUD with `string.format("Time aligned: %.1f s", score)`. How long can you stay on target after pressing R?
