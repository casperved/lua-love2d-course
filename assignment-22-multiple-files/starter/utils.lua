-- utils.lua
-- Shared helper functions used by the rest of the game.
-- Any module can load these with:  local utils = require("utils")

local M = {}

-- ---------------------------------------------------------------
-- TODO 1: Replace the stub below with the real distance formula.
-- The straight-line distance between two points is:
--   sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
-- In Lua that looks like:
--   local dx = x2 - x1
--   local dy = y2 - y1
--   return math.sqrt(dx * dx + dy * dy)
-- ---------------------------------------------------------------
function M.distance(x1, y1, x2, y2)
    -- Stub: always returns a huge number so collisions never fire.
    -- Delete this line and replace it with the real formula!
    return 999
    -- local dx = x2 - x1
    -- local dy = y2 - y1
    -- return math.sqrt(dx * dx + dy * dy)
end

-- Returns 1 or -1 at random — handy for putting things on either side.
function M.randomSign()
    return math.random(2) == 1 and 1 or -1
end

return M
