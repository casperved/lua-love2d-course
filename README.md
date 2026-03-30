# Welcome to Your Lua Coding Adventure!

Hey there! You're about to learn how to make real, actual games using a programming language called **Lua** and a free game-making tool called **LÖVE2D**. By the end of this course, you'll have built multiple games *from scratch* — and you'll understand exactly how every line of code works.

This isn't just clicking buttons in a game-maker app. You're going to write real code, like a real game developer. That's pretty awesome. Let's get started!

---

## What Is LÖVE2D?

**LÖVE2D** (often written as LÖVE or Love2D) is a free, open-source tool that lets you make 2D games and animations using Lua. Tons of indie games have been made with it. It handles the tricky stuff (like opening a window and drawing to the screen) so you can focus on the fun part: writing game logic.

- It's completely free — forever
- It works on Windows, macOS, and Linux
- It's used by real game developers all over the world
- Website: **https://love2d.org**

---

## Setup Instructions

### Step 1: Download LÖVE2D

Go to **https://love2d.org** and download version **11.x** (the stable version). Pick the right one for your computer:

- **macOS**: download the `.zip`, open it, and drag the `love.app` file into your **Applications** folder
- **Windows**: download the installer `.exe` and run it — make sure to tick **"Add to PATH"** during install

### Step 2: Set Up Visual Studio Code (recommended)

VS Code is a free code editor that makes working through this course much easier. It gives you syntax highlighting, autocomplete for LÖVE2D, and a one-keystroke way to run your code.

1. **Download VS Code** from [https://code.visualstudio.com](https://code.visualstudio.com) and install it
2. **Open this course folder** in VS Code: `File → Open Folder` → select the `lua-love2d-course` folder
3. **Install recommended extensions** — VS Code will show a popup saying *"This workspace has extension recommendations"*. Click **Install All**. This installs:
   - **Lua** — syntax highlighting and error checking for Lua code
   - **Love2D Support** — autocomplete for all `love.*` functions

4. **Set your LÖVE2D path** — open `.vscode/settings.json` in this folder and update `love2d.executablePath`:

   | Platform | Default path |
   |----------|-------------|
   | macOS | `/Applications/love.app/Contents/MacOS/love` (already set) |
   | Windows | `C:\\Program Files\\LOVE\\love.exe` |
   | Linux | `/usr/bin/love` |

### Step 3: Run an Assignment

**The fast way — keyboard shortcut:**

1. Open `starter/main.lua` inside any assignment folder
2. Press **`Ctrl+Shift+B`** (Windows/Linux) or **`Cmd+Shift+B`** (macOS)
3. The LÖVE2D window opens immediately!

> This shortcut runs whichever folder the file you're looking at lives in. Open `starter/main.lua` → runs the starter. Open `solution/main.lua` → runs the solution.

**More run options via the Terminal menu:**

Go to **Terminal → Run Task…** to see all options:
- **`love: run current folder`** — same as the keyboard shortcut
- **`love: run starter`** — runs the starter from any file in that assignment folder
- **`love: run solution`** — runs the solution to check what it should look like

**Without VS Code (drag-and-drop):**

- **macOS**: Drag the `starter/` or `solution/` folder onto the `love.app` icon in Applications
- **Windows**: Drag the folder onto `love.exe`

> **Tip:** Always drag the folder that *directly contains* `main.lua` — either `starter/` or `solution/`, not the assignment folder itself.

---

## How Each Assignment Works

Every assignment has the same structure:

```
assignment-XX-name/
  README.md          ← Read this first! It explains the concepts.
  starter/
    main.lua         ← Open this and fill in the TODOs.
  solution/
    main.lua         ← Peek here ONLY if you're stuck after trying!
```

**The process:**
1. Read the assignment's `README.md` to understand what you're building
2. Open `starter/main.lua` in VS Code
3. Fill in the `TODO` sections one by one
4. Press **`Cmd+Shift+B`** (macOS) or **`Ctrl+Shift+B`** (Windows/Linux) to run it
5. If you're stuck, use the hints in the README before peeking at the solution

> **Remember:** Figuring something out yourself — even after struggling — teaches you WAY more than just copying the answer. The hints are there to help you think, not to give it all away.

---

## Course Map

Here's everything you'll learn. Each assignment builds on the last one, so go in order!

| # | Assignment | What You'll Learn |
|---|-----------|-------------------|
| 01 | Hello World | Print text and draw colors on screen |
| 02 | Shapes & Colors | Draw a scene using circles, rectangles, and lines |
| 03 | Variables & Math | Make a ball appear using variables and arithmetic |
| 04 | Keyboard Input | Move a square with the arrow keys |
| 05 | Bouncing Ball | A ball that bounces off all four walls |
| 06 | Patterns with Loops | Draw grids and patterns using for loops |
| 07 | Functions | Write reusable code to draw a starfield |
| 08 | Tables | Store and draw multiple objects using lists |
| 09 | Smooth Animation | Make a planet orbit a sun using delta time |
| 10 | Mouse Input | Pop balloons by clicking on them |
| 11 | Collision Detection | Detect when objects touch each other |
| 12 | Game States | Build a title screen, game, and game over screen |
| 13 | Sprites & Images | Load and draw image files |
| 14 | Timers & Spawning | Spawn falling asteroids with a timer |
| 15 | Score & HUD | Display score, lives, and a high score |
| 16 | Sound Effects | Add sounds and music to your game |
| 17 | Procedural Generation | Create randomly generated worlds |
| 18 | Mini Project: Catch the Drops | A complete game to finish |
| 19 | Mini Project: Dodge! | Another complete game to finish |
| 20 | Final Project: Your Game | Build your own game from scratch |
| 21 | Saving & Loading Data | Persist high scores with love.filesystem |
| 22 | Multiple Files | Split code into modules with require |
| 23 | Object-Oriented Lua | Classes, metatables, and method syntax |
| 24 | Spritesheet Animation | Animate frames with newQuad |
| 25 | Platformer Physics | Gravity, jumping, and platform landing |
| 26 | Camera & Scrolling World | Translate the view to follow the player |
| 27 | Particle Systems | Fire, smoke, and burst effects |
| 28 | GLSL Shaders | Grayscale, scanlines, and color effects |
| 29 | Vertical Climber | One-way camera, procedural levels, power-up particles, saved score |
| 30 | Enemy Variety | Three enemy types with different movement behaviors |
| 31 | Waypoint Pathfinding | Enemies follow a winding path of waypoints |
| 32 | Tower Defense | Place towers that auto-target and shoot enemies |

---

## A Few Encouragements Before You Begin

- **It's okay to be confused.** Every programmer — even experienced ones — gets confused. That's normal. Take a breath, re-read the explanation, and try again.
- **Errors are not failures.** An error message is the computer telling you exactly what it needs you to fix. Learn to read them — they're actually helpful!
- **Experiment!** After you finish an assignment, change some numbers, try something wild. Breaking things on purpose is a great way to learn.
- **You belong here.** Game development is for anyone willing to learn. Go make something cool.

Now open Assignment 01 and let's write some code!
