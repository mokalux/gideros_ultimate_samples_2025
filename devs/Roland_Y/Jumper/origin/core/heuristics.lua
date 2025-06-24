local abs = math.abs
local sqrt = math.sqrt
local sqrt2 = sqrt(2)
local max, min = math.max, math.min

local Heuristics = {}
function Heuristics.MANHATTAN(dx,dy) return abs(dx)+abs(dy) end
function Heuristics.EUCLIDIAN(dx,dy) return sqrt(dx*dx+dy*dy) end
function Heuristics.DIAGONAL(dx,dy) return max(abs(dx),abs(dy)) end
function Heuristics.CARDINTCARD(dx,dy) 
	dx, dy = abs(dx), abs(dy)
	return min(dx,dy) * sqrt2 + max(dx,dy) - min(dx,dy)
end

return Heuristics
