-- @antix
Plane = Core.class()

local N = 1000000000

-- we add N to every coordinate so we can supply negative 
-- coordinates, some thing that Lua tables do not like
-- this imposes a limitation of planes sized -N to +N in size

function Plane:init() end

function Plane:set(x, y, state) -- set the state of the cell at x, y
	if not self[y + N] then
		self[y + N] = {} -- create a new row
	end
	self[y + N][x + N] = state
end

function Plane:get(x, y) -- get the state of the cell at x, y
	if self[y + N] then
		if self[y + N][x + N] then
			return self[y + N][x + N] -- return cell state
		end
	end

	return false -- return false because no cell exists
end
