# Assignment 11: Collision Detection

You've learned how to move things around the screen. Now let's teach the game to notice when two things *touch* each other. That's called **collision detection**, and it's one of the most important ideas in all of game programming!

---

## What you'll learn

How to check whether two rectangles are overlapping — and use that to change what happens in your game.

---

## How it works

Imagine you have two cardboard boxes on a table. How do you know if they're touching?

Simple: if you can't slide a piece of paper between them on the left, right, top, *and* bottom — they're overlapping.

We do the same thing in code. Every object in this program is a rectangle with four numbers: `x` (left edge), `y` (top edge), `w` (width), and `h` (height).

To check if rectangle **A** and rectangle **B** are overlapping, we ask four questions:

1. Is A's left edge to the *left* of B's right edge? (`a.x < b.x + b.w`)
2. Is A's right edge to the *right* of B's left edge? (`a.x + a.w > b.x`)
3. Is A's top edge *above* B's bottom edge? (`a.y < b.y + b.h`)
4. Is A's bottom edge *below* B's top edge? (`a.y + a.h > b.y`)

If the answer to **all four** is yes, the boxes are overlapping. If any one is no, there's a gap somewhere and they're not touching.

This technique has a fancy name — **AABB collision** (Axis-Aligned Bounding Box) — but don't worry about that. It just means "rectangles that aren't tilted."

---

## Your mission

Move a green square around the screen with the arrow keys. Three purple obstacles are placed around the screen. When your square touches any of them, it should turn **red**. When it's in the clear, it stays **green**.

Here's what to fill in:

1. **TODO 1** — Write the body of `checkCollision(a, b)` using the four conditions above. Right now it always returns `false` (never detects anything). Replace that with the real formula.
2. **TODO 2** — In `love.update`, loop through all obstacles and set `isColliding = true` if any overlap is found.
3. **TODO 3** — In `love.draw`, draw the player **red** when `isColliding` is true, and **green** when it's false.

---

## Hints

<details><summary>Hint 1 — What goes inside checkCollision?</summary>

The function takes two rectangles, `a` and `b`. Replace the `return false` line with this:

```lua
return a.x < b.x + b.w and
       a.x + a.w > b.x and
       a.y < b.y + b.h and
       a.y + a.h > b.y
```

Each line checks one side. All four must be true at the same time for a collision.
</details>

<details><summary>Hint 2 — How to check all the obstacles</summary>

In `love.update`, after the movement code, add this loop:

```lua
isColliding = false
for i = 1, #obstacles do
    if checkCollision(player, obstacles[i]) then
        isColliding = true
    end
end
```

We reset to `false` at the start of every frame so that old collisions don't get "stuck."
</details>

<details><summary>Hint 3 — Drawing the player in the right colour</summary>

In `love.draw`, find the TODO 3 block and replace the plain green draw with this:

```lua
if isColliding then
    love.graphics.setColor(1, 0.2, 0.2)   -- red
else
    love.graphics.setColor(0.2, 1, 0.4)   -- green
end
love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
```
</details>

---

## Stretch Goals

1. **Solid walls** — Instead of just changing colour, stop the player from moving *into* an obstacle. When a collision happens, push the player back to where it was before the move.
2. **More obstacles** — Add five or more obstacles to create a simple maze the player has to navigate without touching the walls.
3. **Collision counter** — Count how many obstacles the player is touching at once (it could be more than one!) and display that number on screen.
