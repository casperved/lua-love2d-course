# Assignment 16: Sound Effects

Sound turns a game from a silent movie into something that *feels* real. A little "pop" when you get hit, a cheerful "ding" when you dodge — those tiny sounds make a huge difference. In this assignment you'll load audio files and play them at exactly the right moments.

---

## What you'll learn

How to load sound files and play them in LÖVE2D — including looping background music and short one-shot effects.

---

## How it works

Think of a sound file like a CD sitting on a shelf. Before you can hear anything, you have to:

1. **Pick it up** — load the file into memory.
2. **Put it in a CD player** — LÖVE2D calls this a *source*.
3. **Press play** — call `:play()`.

In code that looks like this:

```lua
local boom = love.audio.newSource("explosion.ogg", "static")
boom:play()
```

### The two sound types

| Type | Think of it as… | Use it for… |
|------|-----------------|-------------|
| `"static"` | Loading the whole CD into your hand right now | Short sound effects (under ~10 seconds) |
| `"stream"` | Reading the CD one track at a time while it plays | Long background music |

### Useful controls

```lua
sound:play()            -- start playing
sound:stop()            -- stop immediately
sound:setVolume(0.5)    -- 0.0 = silent, 1.0 = full blast
sound:setLooping(true)  -- keep looping forever (great for music)
sound:seek(0)           -- rewind to the very beginning
```

To replay a short effect cleanly (so two fast hits don't overlap weirdly), stop it first, then play:

```lua
sound:stop()
sound:play()
```

### Where do the files go?

Put your `.ogg` files in the **same folder as `main.lua`**. LÖVE2D looks there automatically.

LÖVE2D uses the `.ogg` format for audio. You can get free `.ogg` files from:

- **freesound.org** — massive library, free account, download OGG directly. Search "pop", "beep", "space ambient", etc.
- **opengameart.org** — game-focused packs, often ready to drop in.

For this assignment you need three files:

- `hit.ogg` — a short thud or zap (played when an asteroid hits you)
- `dodge.ogg` — a little beep or ding (played when an asteroid safely passes)
- `music.ogg` — a looping background track

Download them, rename them to match exactly, and drop them in the `starter/` folder next to `main.lua`.

### What if the file is missing?

If `love.audio.newSource` can't find the file it will **crash**. That's annoying when someone else runs your game on their computer without the right files.

The fix is `pcall()` — short for "protected call". It tries to run a function, and instead of crashing it just tells you whether it worked:

```lua
local ok, result = pcall(love.audio.newSource, "hit.ogg", "static")
if ok then
    hitSound = result   -- it worked!
else
    hitSound = nil      -- file missing — keep going without it
end
```

The starter wraps this in a handy helper called `tryLoadSound` so you don't have to write that pattern every time.

---

## Your mission

You're adding sound to an asteroid-dodger game. The gameplay already works — your job is to wire up the audio.

**Before you start:** download `hit.ogg`, `dodge.ogg`, and `music.ogg` from freesound.org and drop them in the `starter/` folder.

**Then fill in these TODOs:**

1. **TODO 1** — Call `tryLoadSound` three times to load your sound files.
2. **TODO 2** — Set the music to loop and start playing it.
3. **TODO 3** — Play `dodgeSound` when an asteroid exits the bottom of the screen.
4. **TODO 4** — Play `hitSound` when an asteroid collides with the player.
5. **TODO 5** — Stop the music when the game ends.
6. **TODO 6** — Rewind and restart the music when the player presses R.

Even without any `.ogg` files the game still works — it shows a **green flash** when you dodge and a **red flash** when you're hit. So you can check the logic is right before you add audio.

---

## Hints

<details><summary>Hint 1 — Loading the sounds (TODO 1)</summary>

Find the three lines that say `hitSound = nil`, `dodgeSound = nil`, and `music = nil`. Replace them with calls to `tryLoadSound`, like this:

```lua
hitSound   = tryLoadSound("hit.ogg",   "static")
dodgeSound = tryLoadSound("dodge.ogg", "static")
music      = tryLoadSound("music.ogg", "stream")
```

Notice that music uses `"stream"` because it's a long file.

</details>

<details><summary>Hint 2 — Starting the music (TODO 2)</summary>

Right after loading, check whether music loaded successfully, then set it looping and press play:

```lua
if music then
    music:setLooping(true)
    music:setVolume(0.6)
    music:play()
end
```

The `if music then` guard means the game won't crash even if `music.ogg` is missing.

</details>

<details><summary>Hint 3 — Sound not playing at all?</summary>

Check these things one by one:

1. Is the `.ogg` file in the **same folder** as `main.lua`? Not in a sub-folder.
2. Is the filename spelled exactly right, including lowercase? File names are case-sensitive on Mac and Linux — `Hit.ogg` and `hit.ogg` are different files.
3. Run the game from the terminal (`love starter/`) and look for any warning messages printed there.
4. The green/red screen flashes still show the game logic is working even when audio is missing — so if you see the flash but hear nothing, it's a file path issue, not a code issue.

</details>

---

## Stretch Goals

1. **Volume control** — Press `+` and `-` to raise and lower the music volume in real time. Use `music:setVolume(v)` and clamp `v` between 0 and 1.
2. **Pitch variation** — Before playing `hitSound`, call `hitSound:setPitch(math.random(80, 120) / 100)`. Each hit will sound slightly different so it never gets repetitive.
3. **Mute toggle** — Press M to mute or unmute everything at once. Use `love.audio.setVolume(0)` to silence all audio, and `love.audio.setVolume(1)` to bring it back. Show a small "MUTED" label on the HUD when active.
