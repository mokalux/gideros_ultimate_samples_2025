--[[

Tile Map example - Trying to show how to access tilemap data from gideros 
sewers_2 and tmx file made with Tiled

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 


]]


local map = require("sewers_3")

for i=1, #map.tilesets do
	local tileset = map.tilesets[i]
	
	tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
	tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))
	tileset.lastgid = tileset.firstgid + (tileset.sizex * tileset.sizey) - 1

	tileset.texture = Texture.new(tileset.image, false, {transparentColor = 0xff00ff})
end

local function gid2tileset(gid)
	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
	
		if tileset.firstgid <= gid and gid <= tileset.lastgid then
			return tileset
		end
	end
end

local allLayers = Sprite.new()

for i=1, #map.layers do
	local layer = map.layers[i]
	
	--get name of layer
	local layername = map.layers[i].name
	
	--get type of layer - to act differently if you find an object layer
	local layerType = map.layers[i].type
	
	if layerType == "objectgroup" then
		--do something different...
		for i,k in pairs(map.layers[i].objects) do
			print("NAME:", k.name, "TYPE:", k.type, "testObjectProperty:", k.properties.testObjectProperty)
		end
		
	else --should be a tilelayer
	
		local tilemaps = {}
		local group = Sprite.new()

		for y=1,layer.height do
			for x=1,layer.width do
				local i = x + (y - 1) * layer.width
				local gid = layer.data[i]
				local tileset = gid2tileset(gid)
				
				if tileset then
					local tilemap = nil
					if tilemaps[tileset] then
						tilemap = tilemaps[tileset]
					else
						tilemap = TileMap.new(layer.width, 
											  layer.height,
											  tileset.texture,
											  tileset.tilewidth,
											  tileset.tileheight,
											  tileset.spacing,
											  tileset.spacing,
											  tileset.margin,
											  tileset.margin,
											  map.tilewidth,
											  map.tileheight)
						tilemaps[tileset] = tilemap
						group:addChild(tilemap)
					end
					
					local tx = (gid - tileset.firstgid) % tileset.sizex + 1
					local ty = math.floor((gid - tileset.firstgid) / tileset.sizex) + 1
					
					tilemap:setTile(x, y, tx, ty)
				end
			end
		end

		group:setAlpha(layer.opacity)
		
		allLayers[layername] = group
		allLayers:addChild(allLayers[layername])
	end
end

stage:addChild(allLayers)

local dragging, startx, starty

local currentLayer = 1 -- set default (first) "selected" layer

local function onMouseDown(event)
	dragging = true
	startx = event.x
	starty = event.y
	
	--cycle currentLayer
	if currentLayer<3 then
		currentLayer= currentLayer+1
	else
		currentLayer = 1
	end
	--set selected color
		allLayers["test"..currentLayer]:setColorTransform(1,0,0)
	print("test"..currentLayer, "SELECTED")
end

local function onMouseMove(event)
	if dragging then
		print("DRAGGING", "test"..currentLayer)
		local dx = event.x - startx
		local dy = event.y - starty
		allLayers["test"..currentLayer]:setX(allLayers["test"..currentLayer]:getX() + dx)
		allLayers["test"..currentLayer]:setY(allLayers["test"..currentLayer]:getY() + dy)
		startx = event.x
		starty = event.y
	end
end

local function onMouseUp(event)
	dragging = false
	allLayers["test"..currentLayer]:setColorTransform(1,1,1) --restore r,g,b values to layer
end

stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)
stage:addEventListener(Event.MOUSE_UP, onMouseUp)

local info1 = TextField.new(nil, "drag the tilemap layers around with")
local info2 = TextField.new(nil, "your mouse/finger across the screen")
info1:setTextColor(0xffffff)
info2:setTextColor(0xffffff)
info1:setPosition(70, 50)
info2:setPosition(60, 60)
stage:addChild(info1)
stage:addChild(info2)
