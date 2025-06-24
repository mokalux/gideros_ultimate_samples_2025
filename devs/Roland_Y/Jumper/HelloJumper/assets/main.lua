local Jumper = require "Jumper/jumper"

local map = {
  {0,0,0,1,0},
  {0,1,0,1,0},
  {0,1,0,1,0},
  {0,1,0,0,0},
}

local walkable = 0
local postProcess = false
local pather = Jumper(map,walkable,postProcess)
local sx,sy = 1,4
local ex,ey = 5,4

local path = pather:getPath(sx,sy,ex,ey)
if path then
	print(('Path from [%d,%d] to [%d,%d] was : found!'):format(sx,sy,ex,ey))
	for i,node in ipairs(path) do
		print(('Step %d. Node [%d,%d]'):format(i,node.x,node.y))
	end
else
	print(('Path from [%d,%d] to [%d,%d] was : not found!'):format(sx,sy,ex,ey))
end
