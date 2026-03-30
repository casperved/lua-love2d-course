# Assignment 28: GLSL Shaders

## What you'll learn

How to write tiny GPU programs (shaders) that change the colour of every pixel on screen — and how to swap between different visual effects with a keypress.

---

## How it works

### What is a shader?

Imagine your screen is a giant colouring-book page. Every single dot (pixel) has to be painted some colour. Normally LÖVE2D does this for you automatically. A **shader** lets you step in and say *"before you paint that dot, run my little program first."*

Your little program runs on the **GPU** (the graphics chip). It runs once for every pixel, hundreds of thousands of times per frame, all at the same time. That is why it is so fast.

### A new mini-language: GLSL

Shaders are not written in Lua. They use a language called **GLSL**. It looks a bit like C or JavaScript. You write it as a string inside your Lua file and hand it to LÖVE2D:

```lua
myShader = love.graphics.newShader([[
    -- GLSL code goes in here
]])
```

The double brackets `[[` and `]]` are Lua's way of writing a long string that can span many lines. Everything inside is the shader program.

### The effect function

Every LÖVE2D shader must have one function called `effect`. LÖVE2D calls it once per pixel:

```glsl
vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    vec4 pixel = Texel(tex, texCoord) * color;
    return pixel;   -- return the final colour of this pixel
}
```

Breaking that down:

| Part | Plain English |
|---|---|
| `vec4` | a group of 4 numbers — red, green, blue, alpha |
| `vec2` | a group of 2 numbers — like an x, y pair |
| `texCoord` | where on the picture this pixel comes from (0.0 to 1.0) |
| `Texel(tex, texCoord)` | "look up this pixel on the picture" |
| `* color` | multiply by the current `love.graphics.setColor` so tinting still works |
| `return` | hand back the final colour — this is what actually appears on screen |

### The grayscale trick

To turn a colour into grey, you take a weighted average of its red, green, and blue channels. Human eyes are most sensitive to green and least sensitive to blue, so the weights are not equal:

```glsl
float g = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
return vec4(g, g, g, pixel.a);
```

`dot` multiplies matching pairs and adds them up: `r*0.299 + g*0.587 + b*0.114`. Then you use that single number for all three colour channels, which makes grey.

### The scanlines trick

Old CRT televisions had faint dark horizontal lines across the screen. You can fake this by darkening every other few rows of pixels. `love_PixelCoord.y` is a built-in LÖVE2D variable that gives you the actual screen row (0, 1, 2, 3 …). `mod` gives you the remainder after dividing, so `mod(y, 6.0)` cycles through 0, 1, 2, 3, 4, 5, 0, 1, 2 … — perfect for making stripes:

```glsl
if (mod(love_PixelCoord.y, 6.0) < 3.0) {
    pixel.rgb *= 0.5;   -- half brightness = darker row
}
```

### Sending data from Lua into a shader

Sometimes you want the shader to use a value that changes while the game is running — like a tint colour. You declare a `uniform` in GLSL and send a value from Lua:

```glsl
uniform vec3 tint;   -- declared in the shader
```

```lua
myShader:send("tint", {1.0, 0.4, 0.8})   -- sent from Lua
```

Think of a `uniform` as a little mailbox that Lua can drop values into, and the shader reads from.

### Applying a shader to the whole screen

You cannot apply a shader to things you have already drawn. The trick is to draw your whole scene into an invisible picture (a **Canvas**) first, and then draw that canvas through the shader:

```lua
-- Step 1: draw everything into the offscreen canvas
love.graphics.setCanvas(sceneCanvas)
love.graphics.clear()
drawScene()
love.graphics.setCanvas()   -- stop drawing to the canvas

-- Step 2: show that canvas through the shader
love.graphics.setShader(activeShader)
love.graphics.draw(sceneCanvas, 0, 0)
love.graphics.setShader()   -- ALWAYS reset when done!
```

Forgetting `setShader()` at the end means everything drawn after (like your HUD text) will also go through the shader. Usually that is not what you want.

---

## Your mission

Open `starter/main.lua`. There are three TODOs to fill in:

1. **TODO 1** — Write the GLSL code for the **grayscale** shader. Use `dot` with the luminance weights `vec3(0.299, 0.587, 0.114)`.
2. **TODO 2** — Write the GLSL code for the **scanlines** shader. Use `love_PixelCoord.y` and `mod(..., 6.0) < 3.0` to find the dark rows.
3. **TODO 3** — In `love.draw`, turn the shader on before drawing `sceneCanvas`, then turn it off again straight after.

When everything works, press **1** for no effect, **2** for grayscale, **3** for scanlines, **4** for a pulsing rainbow tint (already written for you as a reference), and **5** for a vignette that darkens the corners.

Run with `love .` from inside the `starter/` folder.

---

## Hints

<details><summary>Hint 1 — Grayscale shader</summary>

A shader is just a string passed to `love.graphics.newShader`. The full thing looks like this:

```lua
grayscaleShader = love.graphics.newShader([[
    vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
        vec4 pixel = Texel(tex, texCoord) * color;
        float g = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
        return vec4(g, g, g, pixel.a);
    }
]])
```

`dot(a, b)` is the dot product: it multiplies each matching pair of numbers and sums the results. Here it gives you one brightness value that represents the whole colour.

</details>

<details><summary>Hint 2 — Scanlines shader</summary>

Same structure as the grayscale shader. Inside `effect`, check `love_PixelCoord.y` to decide whether this pixel is on a dark row:

```lua
scanlinesShader = love.graphics.newShader([[
    vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
        vec4 pixel = Texel(tex, texCoord) * color;
        if (mod(love_PixelCoord.y, 6.0) < 3.0) {
            pixel.rgb *= 0.5;
        }
        return pixel;
    }
]])
```

`mod(y, 6.0)` gives a number from 0 up to (but not including) 6. When it is less than 3 you are in the darker half of the stripe.

</details>

<details><summary>Hint 3 — Applying the shader in love.draw</summary>

After `love.graphics.setCanvas()` has reset the render target back to the screen, add two lines around the draw call:

```lua
love.graphics.setShader(activeShader)   -- turn shader on (nil = passthrough)
love.graphics.setColor(1, 1, 1)
love.graphics.draw(sceneCanvas, 0, 0)
love.graphics.setShader()               -- turn shader off — important!
```

When `activeShader` is `nil` (mode 1), `setShader(nil)` is the same as `setShader()` — no effect applied.

</details>

---

## Stretch Goals

- **Invert shader** — Return `vec4(1.0 - pixel.rgb, pixel.a)` for a negative-film look. Wire it up on key **6**.
- **Pixel-art shader** — Before sampling the texture, round `texCoord` to a coarse grid (steps of `1.0/80.0`) to make the whole scene look blocky and low-resolution.
- **Transition wipe** — Send a `uniform float progress` (0 → 1 over half a second) and use it to reveal the new shader with a horizontal wipe, making mode switches feel cinematic.
