# Assignment 16: Sound Effects 🔊

Great work making it this far! Games feel so much more alive with sound. A jump, a collision, a background tune — audio transforms a game from a moving picture into an *experience*. In this assignment you'll learn how to load and play sounds in LÖVE2D.

---

## How Sound Works in LÖVE2D

LÖVE2D can play **OGG Vorbis** (`.ogg`) files. That's the format you'll use for everything — short blips and full music tracks alike.

### Loading a Sound

```lua
local sound = love.audio.newSource("explosion.ogg", "static")
```

The second argument is the **source type**:

| Type | When to use it |
|------|----------------|
| `"static"` | Short sound effects (under ~10 seconds). The whole file is loaded into memory at once, so it plays instantly. |
| `"stream"` | Background music or long audio. The file is read a little at a time, saving memory. |

### Playing, Stopping, and Volume

```lua
sound:play()           -- start playing
sound:stop()           -- stop immediately
sound:setVolume(0.5)   -- 0.0 = silent, 1.0 = full volume
sound:setLooping(true) -- loop forever (great for music)
sound:seek(0)          -- rewind to the beginning
```

To replay a short sound effect from the start (without overlapping), do:

```lua
sound:stop()
sound:play()
```

### Where do the files go?

Put your `.ogg` files **in the same folder as `main.lua`**. LÖVE2D looks there automatically.

---

## Getting Free Sound Files

You need real audio files to hear anything. Here are two excellent free sources:

- **freesound.org** — huge library, free accounts, download OGG directly. Search for "pop", "beep", "space music", etc.
- **opengameart.org** — game-focused audio packs, often ready to use.

For this assignment you want three files:
- `hit.ogg` — a short pop or thud (played when an asteroid hits you)
- `dodge.ogg` — a small beep or ding (played when an asteroid safely passes)
- `music.ogg` — a looping background track (stream type)

Download them, rename them to match, and drop them in the `starter/` folder next to `main.lua`.

---

## Safety First: pcall()

What if someone runs your game without the sound files? It would crash! That's why we use `pcall()` (protected call) to try loading sounds safely:

```lua
local function tryLoadSound(filename, soundType)
    local ok, result = pcall(love.audio.newSource, filename, soundType or "static")
    if ok then
        return result   -- loading worked!
    else
        return nil      -- file not found — that's okay, keep going
    end
end
```

If the file is missing, `ok` is `false` and the game keeps running with `nil` instead of a sound source. Later, before playing, check `if sound then sound:play() end`.

---

## Your Mission

The asteroid dodger from earlier assignments is back! Your job is to add audio to it:

1. Download three `.ogg` files (hit, dodge, music) and place them in the `starter/` folder.
2. Uncomment the `tryLoadSound` lines to load them.
3. Uncomment the music loop so background music plays immediately.
4. Uncomment `playSound(dodgeSound)` where an asteroid passes off screen.
5. Uncomment `playSound(hitSound)` where the player gets hit.
6. Stop the music when the game ends, and restart it when pressing R.

Even without sound files, the game shows **colour flashes** — green when you dodge, red when you're hit — so you can still test the logic works before you have audio.

---

## Hints

<details><summary>Hint 1 — Where to uncomment</summary>

Search for every line that starts with `-- TODO`. Each one has a commented-out code block right below it. Uncomment that block (remove the `--`) and it should work once you have the `.ogg` file in the folder.

</details>

<details><summary>Hint 2 — Restarting music on R</summary>

When the player presses R, call `music:seek(0)` to go back to the beginning, then `music:play()`. Wrap both in `if music then ... end` so it's safe if the file isn't loaded.

</details>

<details><summary>Hint 3 — Sound not playing?</summary>

Check three things:
1. Is the `.ogg` file in the **same folder** as `main.lua`? Not in a sub-folder.
2. Is the filename spelled exactly right, including lowercase? Filenames are case-sensitive on Mac and Linux.
3. Run the game from the terminal and look for error output.

</details>

---

## Stretch Goals

1. **Volume control** — Press `+` and `-` to increase/decrease the music volume in real time using `music:setVolume(v)`.
2. **Pitch variation** — `hitSound:setPitch(math.random(80, 120) / 100)` before playing gives each hit a slightly different pitch, making it feel less repetitive.
3. **Sound on game over** — Load a fourth file `gameover.ogg` and play it when lives reach zero.
