---------------------------
-- math functions
---------------------------
local floor = math.floor
---------------------------

local TileMapMultiple = Core.class(Sprite)

local function gid2tileset(map, gid)
	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
	
		if tileset.firstgid <= gid and gid <= tileset.lastgid then
			return tileset
		end
	end
end


function TileMapMultiple:init(filename, directory)
	--[[
		Consideration
		----------------------------------------
		--	FIX DIMENSION DEVICE
		----------------------------------------
		application:setOrientation(Application.LANDSCAPE_LEFT)  

		--all change
		_W = application:getContentWidth()
		_H  = application:getContentHeight()		
		print(_W,_H)
		application:setLogicalDimensions(_W, _H)	--reverse

		Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
		Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()
		_WD,_HD  = application:getDeviceWidth(), application:getDeviceHeight()		-- reverse
		_Diag, _DiagD = _W/_H, _WD/_HD
	]]
		----------------------------------------
		self.dx, self.dy = -Wdx, -Hdy
		----------------------------------------
	--[[
		------------------------------------------------------------------------------------
		--http://giderosmobile.com/forum/discussion/6948/tilemap-object-and-tiled-tile-flip
		--in Tilemap studio you must use Shift+Z
		--http://discourse.mapeditor.org/t/rotating-square-tiles-by-90-180-270/230/4
		------------------------------------------------------------------------------------
	]]
--	pcall(function() require "bit" end)

	-- Bits on the far end of the 32-bit global tile ID are used for tile flags (flip, rotate)
	local FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
	local FLIPPED_VERTICALLY_FLAG   = 0x40000000;
	local FLIPPED_DIAGONALLY_FLAG   = 0x20000000;


	if string.len(directory)~="Canvas/Worlds/" then
		--error load level
		--print("")
		--print("==========================================================")
		--print(" in class Tilemap: there isn't level:", directory,"...",filename)
		--print("==========================================================")
		--print("")
	end
	self.map = loadfile(filename)()
	-- specify directory stored your files *.png
	local directory = directory or ""
	local tilesetImage 
	for _, tileset in pairs(self.map.tilesets) do
		tileset.sizex = floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
		tileset.sizey = floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))
		tileset.lastgid = tileset.firstgid + (tileset.sizex * tileset.sizey) - 1
		tilesetImage = directory .. tileset.image;
		tileset.texture = Texture.new(tilesetImage,true)	-- add filter by hubert ronald
	end
	
	local tilemaps, tilemap, group, gid, i, tileset, tx, ty
	local flipHor, flipVer, flipDia
	for i, layer in pairs(self.map.layers) do
		tilemaps = {}
		----------------
		group = Sprite.new()
		----------------

		-- Exclude objects from this routine
		if(layer.type ~= 'objectgroup') then
			for y=1,layer.height do
				for x=1,layer.width do
					
					i = x + (y - 1) * layer.width
					gid = layer.data[i]
						
						--http://giderosmobile.com/forum/discussion/6948/tilemap-object-and-tiled-tile-flip
						if gid ~= 0 then
							-- Read flipping flags
							flipHor = (gid & FLIPPED_HORIZONTALLY_FLAG)
							flipVer = (gid & FLIPPED_VERTICALLY_FLAG)
							flipDia = (gid & FLIPPED_DIAGONALLY_FLAG)
							
							-- Convert flags to gideros style
							if(flipHor ~= 0) then flipHor = TileMap.FLIP_HORIZONTAL end
							if(flipVer ~= 0) then flipVer = TileMap.FLIP_VERTICAL end
							if(flipDia ~= 0) then flipDia = TileMap.FLIP_DIAGONAL end
							
							-- Clear the flags from gid so other information is healthy
--							gid = bit.band(gid, bit.bnot(bit.bor(FLIPPED_HORIZONTALLY_FLAG, FLIPPED_VERTICALLY_FLAG, FLIPPED_DIAGONALLY_FLAG)))
							gid = (gid & ~(FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG))
						end
						
					tileset = gid2tileset(self.map, gid)
					
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
												  self.map.tilewidth,
												  self.map.tileheight)
							tilemaps[tileset] = tilemap
							group:addChild(tilemap)
						end
						
						tx = (gid - tileset.firstgid) % tileset.sizex + 1 
						ty = floor((gid - tileset.firstgid) / tileset.sizex) + 1
						------------------------------------------------------------------
						-- Set the tile with flip info
						tilemap:setTile(x, y, tx, ty, (flipHor | flipVer | flipDia))
						------------------------------------------------------------------
					end
				end
			end
			
		end
	
		group:setAlpha(layer.opacity)
		self:addChild(group)
		----------------------------------------
		self:setPosition(self.dx, self.dy)	--correct position	--add by hubert ronald
		----------------------------------------
	end
end

function TileMapMultiple:getLayer(name)
	-- if we have a name parameter and it's a string
	if name and type(name) == 'string' then
		-- search for name
		for _, layer in pairs(self.map.layers) do
			-- if found
			if layer.name == name then return layer end
		end
	end
end

function TileMapMultiple:getProperty(item, name)
	-- if we have an item and 
	if item and name and type(item) == 'table' and type(name) == 'string' then
		for k, v in pairs(item.properties) do 
			if k == name then return v end	
		end
	end
end

-- dimension of map
-- by hubert ronald
function TileMapMultiple:getWH()
	return self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight
end

function TileMapMultiple:getObjectNames()
	local names, layer = {}
	for _, layer in pairs(self.map.layers) do
		if (layer.type == "objectgroup") then
			table.insert(names,layer.name)
		end
	end
	return names
end

function TileMapMultiple:getObject(name)
	local layer
	for _, layer in pairs(self.map.layers) do
		if(layer.type == "objectgroup") then
			if layer.name == name then
				return layer.objects, layer.properties
			end
		end
	end
end

function TileMapMultiple:getInfo() return self.map end

return TileMapMultiple