local random = math.random

local plane = Plane.new()
local state

for r = -100, 100 do
	for c = -100, 100 do
		state = random(5)
		plane:set(c, r, state)
	end
end

print(plane:get(-50, -50))
print(plane:get(-20, -20))
print(plane:get(0, 0))
print(plane:get(10, -10))
print(plane:get(20, 20))
print(plane:get(50, 50))
print("")
