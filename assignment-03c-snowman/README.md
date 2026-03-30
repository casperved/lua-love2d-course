# Assignment 03c — Snowman

## What you'll learn

How changing a single variable can update an entire drawing — because every position is calculated from a small set of "master" values.

---

## How it works

Imagine the snowman is attached to a stick planted in the ground. You grab the stick and move it left — the whole snowman moves left. You never have to reposition the head, the hat, or the arms separately. The stick is your **master variable**.

In this assignment that stick is called `snowmanX` and `snowmanY`. Every other position — where the middle circle goes, where the head goes, where the hat sits — is calculated from those two values using simple arithmetic.

Here is the key idea:

```
bottom circle   →  centre is exactly at (snowmanX, snowmanY)
middle circle   →  sits on TOP of the bottom circle
head circle     →  sits on TOP of the middle circle
hat             →  sits on TOP of the head
```

To find where "on top" means, you subtract the two radii:

```
middleY = snowmanY - bottomRadius - middleRadius
```

Read it in plain English: *"start at the bottom circle's centre, go up by the bottom radius to reach the surface, then go up again by the middle radius to reach the new circle's centre."*

This idea — one value being **derived** from others — is one of the most useful habits in programming. Change `snowmanY` by 50 and the entire snowman rises 50 pixels. You only edit **one number**.

---

## Your mission

Open `starter/main.lua`. Work through the TODOs in order.

1. **TODO 1** — Set the five master variables to sensible starting values.
   Try: `snowmanX = 400`, `snowmanY = 440`, `bottomRadius = 80`, `middleRadius = 55`, `headRadius = 38`.

2. **TODO 2** — Calculate `middleY` and `headY` using arithmetic on the variables you just set.

3. **TODO 4** — Draw the middle circle using `snowmanX`, `middleY`, and `middleRadius`.

4. **TODO 5** — Draw three small button dots spaced along the middle circle.

5. **TODO 6** — Draw the head circle using `snowmanX`, `headY`, and `headRadius`.

6. **TODO 7** — Draw the top hat: two rectangles (a wide brim and a taller top block), both centred on `snowmanX`.

7. **TODO 8** — Draw two dot eyes on the head.

8. **TODO 9** — Draw an orange carrot nose.

9. **TODO 3** (back to arms) — Add two stick arms using `love.graphics.line()`. Do this last — it is the trickiest part.

Once the snowman looks right, try changing `snowmanX` to `200` and running again. The whole snowman should shift left without you touching anything else.

---

## Hints

<details><summary>Hint 1 — Getting something on screen</summary>

Set all five master variables first (TODO 1), then run the program. You should see the bottom circle appear because that draw call is already written for you. If nothing appears, double-check that `bottomRadius` is greater than zero — a circle with radius 0 is invisible!

After that, fill in the calculated positions (TODO 2) and uncomment the middle circle (TODO 4). Run again. You should now see two circles stacked on top of each other.

Build one piece at a time and run after each change. Small steps catch mistakes early.
</details>

<details><summary>Hint 2 — Calculating middleY and headY</summary>

Picture the snowman from the bottom up. The bottom circle's centre is at `snowmanY`. Its top edge is at `snowmanY - bottomRadius`. The middle circle's centre is one `middleRadius` higher than that:

```lua
middleY = snowmanY - bottomRadius - middleRadius
```

The head works the same way — start at `middleY`, go up by `middleRadius` to reach the top of the middle circle, then go up by `headRadius` to reach the head's centre:

```lua
headY = middleY - middleRadius - headRadius
```

Once these two lines are correct, every other shape will automatically snap into the right place.
</details>

<details><summary>Hint 3 — Drawing the top hat</summary>

The hat is two rectangles. `love.graphics.rectangle("fill", x, y, width, height)` draws from the **top-left corner**, not the centre.

The brim sits just above the top of the head circle. The top of the head is at `headY - headRadius`. Stack the brim directly above that:

```lua
love.graphics.setColor(0.10, 0.10, 0.12)   -- near-black

local brimY = headY - headRadius - hatBrimH

-- Wide flat brim
love.graphics.rectangle("fill",
    snowmanX - hatBrimW / 2,   -- left edge (centred on snowmanX)
    brimY,
    hatBrimW,
    hatBrimH
)

-- Tall narrow top block — sits on top of the brim
love.graphics.rectangle("fill",
    snowmanX - hatTopW / 2,
    brimY - hatTopH,
    hatTopW,
    hatTopH
)
```

The hat variables (`hatBrimW`, `hatBrimH`, `hatTopW`, `hatTopH`) are already set for you in `love.load`.
</details>

---

## Stretch Goals

**1. Animate the snowman sliding across the screen.**
In `love.update(dt)`, add a small amount to `snowmanX` each frame. When `snowmanX` goes past the right edge of the window, reset it to just off the left edge. You will also need to recalculate `middleY` and `headY` inside `love.update` so they follow along.

**2. Add a scarf.**
Draw a coloured rectangle around the join between the middle circle and the head circle. A good y-position is `headY + headRadius`. Make it wide enough to overlap both circles and give it a cheerful colour.

**3. Add falling snowflakes.**
Create variables `flake1X`, `flake1Y`, `flake2X`, `flake2Y` (and so on for as many as you like). In `love.update(dt)`, increase each `Y` variable a little each frame. When a flake falls below the bottom of the window, reset its `Y` back to `0` so it loops. Each flake is just a small white circle in `love.draw`.
