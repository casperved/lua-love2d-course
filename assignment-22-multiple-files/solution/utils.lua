-- utils.lua  (solution)
-- Shared helper functions.

local M = {}

-- SOLUTION: Euclidean distance between two 2-D points.
function M.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- Returns 1 or -1 at random.
function M.randomSign()
    return math.random(2) == 1 and 1 or -1
end

-- Clamps value between lo and hi (handy bonus helper).
function M.clamp(value, lo, hi)
    return math.max(lo, math.min(hi, value))
end

return M
