-- https://github.com/Yonaba/Jumper/tree/master/examples

local Grid = require "GJumper/grid"
local Pathfinder = require "GJumper/pathfinder"

-- bg
application:setBackgroundColor(0x555555)

-- pathfinding map (must be rectangle/square shaped)
local mapping = {
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
	{1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,},
	{1,0,5,0,0,0,0,0,0,0,0,0,0,0,0,1,},
	{1,0,0,3,3,0,0,0,0,0,0,0,0,0,0,1,},
	{1,0,2,2,2,2,0,0,0,2,0,0,0,0,0,1,},
	{1,0,0,0,0,0,2,2,2,0,0,0,0,0,0,1,},
	{1,0,0,0,0,0,2,2,2,0,0,0,0,0,0,1,},
	{1,0,0,0,0,0,2,2,2,0,0,0,0,0,0,1,},
	{1,0,0,2,2,2,2,0,0,0,0,0,0,0,0,1,},
	{1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1,},
	{1,0,0,3,3,0,0,0,0,0,0,0,0,0,0,1,},
	{1,0,3,3,0,0,0,0,0,0,0,0,0,0,0,1,},
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,},
}

-- map settings
local CELL_W, CELL_H = 32, 32

-- a player1
local player1 = Pixel.new(0x550000, 1, 8*2, 8*2)
local p1w, p1h = player1:getDimensions()
player1:setAnchorPosition(-(CELL_W-p1w)/2, -(CELL_H-p1h)/2)
local p1col, p1row -- we set the player1 position when we draw the map
local mc = MovieClip.new({{0,0,player1}}, true) -- movieclip to simulate player1 movement

-- pathfinding walkable
--local walkable = 0 -- for a single value
local function walkable(value) -- for multiple values
--	return value:match("[#.*]") -- for special characters
	return value == 0 or value == 3 -- values 0 and 3 are walkable
end

-- drawing the map
local map = Sprite.new()
for row = 1, #mapping do
	for col = 1, #mapping[1] do
		local pix = Pixel.new(0xaaff00, 1, CELL_W, CELL_H)
		if mapping[row][col] == 0 then pix:setColor(0xaaff00) -- ground
		elseif mapping[row][col] == 1 then pix:setColor(0xff5500) -- walls
		elseif mapping[row][col] == 2 then pix:setColor(0xffaa00) -- sand
		elseif mapping[row][col] == 3 then pix:setColor(0x00aaff) -- water
		elseif mapping[row][col] == 5 then p1col = col; p1row = row -- 5 = player1 starting position
		else pix:setColor(math.random(0xff0000)) -- unknown cell
		end
		pix:setPosition(col*CELL_W, row*CELL_H)
		map:addChild(pix)
	end
end

local grid = Grid(mapping)
local myFinder = Pathfinder(grid, "ASTAR", walkable) -- steps
--local myFinder = Pathfinder(grid, "DIJKSTRA", walkable) -- steps
--local myFinder = Pathfinder(grid, "THETASTAR", walkable) -- straight
--local myFinder = Pathfinder(grid, "BFS", walkable) -- steps
--local myFinder = Pathfinder(grid, "DFS", walkable) -- the longest steps path!!!
--local myFinder = Pathfinder(grid, "JPS", walkable) -- straight, the fastest

-- finder params
--myFinder:setTunnelling(true)

-- position
player1:setPosition(p1col*CELL_W, p1row*CELL_H)
mapping[p1row][p1col] = 0 -- make player1 starting position walkable (row, col)

-- order
stage:addChild(map)
stage:addChild(player1)
stage:addChild(mc)

-- listeners
local anims = {} -- for the movieclip
local timing = 8*1.5 -- for the movieclip
local completed = true -- allows movement only when previous completed
local function pathmove(path)
--	print(('Step: %d -> x: %d -> y: %d'):format(count, node:getX(), node:getY()))
	completed = false -- processing movements
	for node, count in path:nodes() do
		p1col, p1row = node:getX(), node:getY() -- set new player1 position
		anims[count] = {
			(count-1)*timing+1, count*timing, player1,
			{
				x = p1col*CELL_W,
				y = p1row*CELL_H,
			}
		}
	end
	mc = MovieClip.new(anims)
	mc:play() -- play only once
	mc:addEventListener(Event.COMPLETE, function()
		completed = true -- movements complete
		anims = {}
	end)
end

local walls = {} -- create a list of walls we can add/remove

map:addEventListener(Event.MOUSE_UP, function(e)
	if map:hitTestPoint(e.x, e.y) then
		local x, y = map:globalToLocal(e.x, e.y) -- mouse coords on the map
		local button, _modifier = e.button, e.modifiers
		local mapcol, maprow = x//CELL_W, y//CELL_H -- convert mouse coords to map coords
		if button == 2 then -- RMB add/remove walls
--			if mapping[maprow][mapcol] == 0 then -- one walkable
			if walkable(mapping[maprow][mapcol]) then -- multiple walkable
				if not walls[maprow..mapcol] then -- create only one wall per cell
					walls[maprow..mapcol] = {
						index=mapping[maprow][mapcol],
						pixel=Pixel.new(0x000000, 0.5, CELL_W, CELL_H),
					}
				end
				walls[maprow..mapcol].pixel:setPosition(mapcol*CELL_W, maprow*CELL_H)
				map:addChild(walls[maprow..mapcol].pixel)
				mapping[maprow][mapcol] = 1 -- set the cell as being a wall
			else -- wall already exist hide it
				if walls[maprow..mapcol] then
					walls[maprow..mapcol].pixel:setVisible(false)
					mapping[maprow][mapcol] = walls[maprow..mapcol].index -- reset original index
				end
			end
		else -- LMB
			if walkable(mapping[maprow][mapcol]) and completed then -- cell is walkable and player1 has finished moving
				local path = myFinder:getPath(p1col, p1row, mapcol, maprow) -- pathfinding
				if path then pathmove(path) end
			else
				print("UNREACHABLE DESTINATION!")
			end
		end
		e:stopPropagation()
	end
end)
