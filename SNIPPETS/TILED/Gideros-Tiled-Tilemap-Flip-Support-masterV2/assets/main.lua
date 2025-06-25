--[[
Tile Map example with flip support.
bit tile transformations copied from TiledAsWorldEditor - https://github.com/1dot44mb/gideros/tree/master/tools/TiledAsWorldEditor

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 
]]

local map = TiledMap.new("test.lua")

stage:addChild(map)

local dragging, startx, starty

local function onMouseDown(event)
	dragging = true
	startx = event.x
	starty = event.y
end

local function onMouseMove(event)
	if dragging then
		local dx = event.x - startx
		local dy = event.y - starty
		map:setX(map:getX() + dx)
		map:setY(map:getY() + dy)
		startx = event.x
		starty = event.y
	end
end

local function onMouseUp(event)
	dragging = false
end

stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)
stage:addEventListener(Event.MOUSE_UP, onMouseUp)

local info1 = TextField.new(nil, "explore the tilemap by dragging")
local info2 = TextField.new(nil, "your mouse/finger across the screen")
info1:setTextColor(0xffffff)
info2:setTextColor(0xffffff)
info1:setPosition(70, 50)
info2:setPosition(60, 60)
stage:addChild(info1)
stage:addChild(info2)
