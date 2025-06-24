local map = {
  {0,0,0,1,0},
  {0,1,0,1,0},
  {0,1,0,1,0},
  {0,1,0,1,0},
  {0,1,0,1,0},
  {0,1,0,1,0},
  {0,1,0,1,0},
  {0,0,0,1,0},
  {0,1,0,1,0},
  {0,1,0,0,0},
}
local walkable = 0

local Grid = require "Jumper/grid"
local Pathfinder = require "Jumper/pathfinder"

local grid = Grid(map)
--local postProcess = false
local myFinder = Pathfinder(grid, "JPS", walkable)
local startx, starty = 1,1
local endx, endy = 5,1

local path = myFinder:getPath(startx, starty, endx, endy)
if path then
  print(('Path found! Length: %.2f'):format(path:getLength()))
	for node, count in path:nodes() do
	  print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
	end
end
