local map = {
  {1,1,1,1,1,1,1,1,},
  {1,0,0,0,0,0,0,1,},
  {1,0,0,0,0,0,0,1,},
  {1,0,0,0,0,0,0,1,},
  {1,0,0,0,0,0,0,1,},
  {1,0,0,0,0,0,0,1,},
  {1,0,0,2,0,0,0,1,},
  {1,0,0,0,0,0,0,1,},
  {1,1,0,1,0,0,0,1,},
  {1,1,1,1,1,1,1,1,},
}

for j = 1, #map do
	for i = 1, #map[1] do
		local pix = Pixel.new(0x5555aa, 1, 16, 16)
		if map[j][i] == 0 then pix:setColor(0x999999)
		elseif map[j][i] == 1 then pix:setColor(0x333333)
		end
		pix:setPosition(i*16, j*16)
		stage:addChild(pix)
	end
end

local walkable = 0
local Grid = require "Jumper/grid"
local Pathfinder = require "Jumper/pathfinder"

local grid = Grid(map)
--local postProcess = false
--local myFinder = Pathfinder(grid, "ASTAR", walkable)
--local myFinder = Pathfinder(grid, "DIJKSTRA", walkable)
--local myFinder = Pathfinder(grid, "THETASTAR", walkable)
--local myFinder = Pathfinder(grid, "BFS", walkable)
local myFinder = Pathfinder(grid, "DFS", walkable)
--local myFinder = Pathfinder(grid, "JPS", walkable)
local startx, starty = 3,2
local endx, endy = 6,7

local path = myFinder:getPath(startx, starty, endx, endy)
if path then
	print(('Path found! Length: %.2f'):format(path:getLength()))
	for node, count in path:nodes() do
		print(('Step: %d -> x: %d -> y: %d'):format(count, node:getX(), node:getY()))
		local pix = Pixel.new(0xff0000, 1, 16, 16)
		pix:setPosition(node:getX()*16, node:getY()*16)
		stage:addChild(pix)
	end
end
