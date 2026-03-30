# CLAUDE.md — Context for generating new assignments

This file gives Claude (or any AI assistant) enough context to extend this course by generating additional assignments that match the existing style and difficulty progression.

---

## What this course is

A beginner Lua + LÖVE2D coding course. Each assignment teaches one or two programming concepts through a visual, interactive program. The learner reads a guide, fills in strategic gaps in a starter file, and checks their work against a solution.

## Tech stack

- **Language:** Lua (standard, no quirks)
- **Framework:** LÖVE2D 11.x — [love2d.org](https://love2d.org)
- **Libraries:** None — built-in LÖVE2D APIs only
- **Runtime:** `love <folder>` in terminal, or drag the folder onto the LÖVE app

## File structure per assignment

```
assignment-XX-name/
  README.md          ← Concept explanation + mission + hints + stretch goals
  starter/main.lua   ← Syntactically valid; TODOs are commented out
  solution/main.lua  ← Complete, working, polished
```

## README.md format

Each README should contain these sections in order:

1. **What you'll learn** — one-sentence summary
2. **How it works** — plain-English concept explanation with analogies (variables = labeled boxes, functions = recipes, etc.)
3. **Your mission** — what the finished program should do; which TODOs to fill in
4. **Hints** — exactly 3, using HTML collapsible blocks:
   ```html
   <details><summary>Hint 1</summary>
   ...gentle nudge...
   </details>
   <details><summary>Hint 2</summary>
   ...more specific...
   </details>
   <details><summary>Hint 3</summary>
   ...nearly the answer...
   </details>
   ```
5. **Stretch Goals** — 2–3 optional extras for learners who want more

**Tone:** Friendly, encouraging, never condescending. Treat the reader as smart but new to programming.

## starter/main.lua rules

- Must be **syntactically valid** — no bare TODO stubs that cause parse errors
- Must **not crash on load** — all globals referenced in `love.draw` must be initialised before `love.draw` runs
- TODOs are **commented out**, with the correct code shown but commented, e.g.:
  ```lua
  -- TODO 1: Move the ball right by adding speed * dt to ballX
  -- ballX = ballX + speed * dt
  ```
- The program should produce *something* visual even before TODOs are filled in (a background, a placeholder shape, a hint message)
- If a TODO requires a helper function, provide a **safe placeholder** that returns a harmless default:
  ```lua
  function checkCollision(a, b)
      return false  -- replace this with the real formula!
  end
  ```

## solution/main.lua rules

- Fully working, runnable with `love solution/`
- Includes a few **visual extras** beyond the bare minimum (e.g. a glow effect, particle burst, colour variation) — these serve as inspiration for stretch goals
- Well commented — the solution should still be readable and educational

## Concepts taught in assignments 01–31

After completing all 31 assignments the learner knows:

| Concept | Where taught |
|---------|-------------|
| love.load / update / draw lifecycle | 01 |
| setColor, print, drawing text | 01 |
| rectangle, circle, line; x/y coordinates | 02 |
| Variables, arithmetic operators | 03 |
| Tables as colour values `{r, g, b}` | 03 |
| love.keyboard.isDown, delta time (dt) | 04 |
| if / elseif / else | 04, 05 |
| Velocity and wall bouncing | 05 |
| for loops, nested loops | 06 |
| Defining and calling functions, parameters | 07 |
| math.sin / math.cos for circular motion | 07, 09 |
| Tables as arrays, table.insert, #table | 08 |
| Iterating backwards for safe removal | 08, 10 |
| Delta time for frame-rate independence | 09 |
| love.mousepressed, distance formula | 10 |
| AABB collision detection | 11 |
| State machine (title / playing / gameover) | 12 |
| love.graphics.newCanvas, draw with rotation | 13 |
| Accumulator timer pattern | 14 |
| string.format for zero-padded numbers | 15 |
| HUD design, life hearts as shapes | 15 |
| love.audio.newSource, pcall safety | 16 |
| math.random, math.randomseed, procedural gen | 17 |
| Putting it all together (mini projects) | 18, 19 |
| Open-ended game design | 20 |
| love.filesystem.write / read, tostring / tonumber | 21 |
| require, module pattern (`local M = {} … return M`) | 22 |
| Metatables, __index, : method syntax, constructors | 23 |
| love.graphics.newQuad, Canvas-as-spritesheet, frame animation | 24 |
| Gravity, jumping, AABB platform landing, onGround flag | 25 |
| love.graphics.push/pop/translate, world vs screen coords, camera clamping | 26 |
| love.graphics.newParticleSystem, emitter settings, one-shot emit | 27 |
| love.graphics.newShader, GLSL fragment shaders, uniforms | 28 |
| Vertical scrolling camera (one-way), procedural level generation, particle burst power-ups, persistent score | 29 |
| Multiple enemy types (chaser/bouncer/patroller), data-driven behavior branching, invincibility timer | 30 |
| Waypoint pathfinding, direction normalization, advancing through a path array | 31 |
| Tower defense: tower placement, range detection, priority targeting, homing bullets, enemy health | 32 |

## Ideas for post-assignment-32 topics

When the learner has finished all 31 assignments and is ready for more, these are natural next steps:

1. **Tiled maps** — load `.lua` maps from the Tiled map editor using the Simple-Tiled-Implementation library
2. **LÖVE2D physics** — `love.physics` (Box2D wrapper): bodies, shapes, joints, collision callbacks
3. **Top-down RPG** — grid-based movement, interaction with objects, simple dialogue system
4. **Networking** — `lua-socket` for simple two-player games over LAN
5. **Mobile / gamepad input** — `love.joystick`, touch input, on-screen buttons

## How to generate a new assignment

To generate a new assignment that fits this course, provide:
- The **concept** to teach
- The **visual output** (what will appear on screen)
- The **gaps** (which parts the learner fills in)

Then follow the file structure and rules above. The assignment number should continue from 21 onwards (`assignment-21-name/`).

### Example prompt to continue this course

> "Generate assignment 32 for this course. Topic: Tiled maps. The learner will load a `.lua` map exported from the Tiled editor and render it tile by tile. Follow the format in CLAUDE.md."
