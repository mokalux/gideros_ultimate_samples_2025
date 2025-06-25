TiledMap = Core.class(Sprite)

local function gid2tileset(map, gid)
	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
		if tileset.firstgid <= gid and gid <= tileset.lastgid then
			return tileset
		end
	end
end

function TiledMap:init(filename)


-- Bits on the far end of the 32-bit global tile ID are used for tile flags (flip, rotate)
local FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
local FLIPPED_VERTICALLY_FLAG   = 0x40000000;
local FLIPPED_DIAGONALLY_FLAG   = 0x20000000;

	local map = loadfile(filename)()
	
	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
		tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
		tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))
		tileset.lastgid = tileset.firstgid + (tileset.sizex * tileset.sizey) - 1
		tileset.texture = Texture.new(tileset.image, false, {transparentColor = tonumber(tileset.transparentcolor)})
	end
	
	self.worldmap = {}
	self.mapdetails = {
						width = map.width,
						height = map.height,
						tilewidth = map.tilewidth,
						tileheight = map.tileheight,
					  }
	
	for i=1, #map.layers do
		local layer = map.layers[i]
		local tilemaps = {}
		local group = Sprite.new()
		
		for y=1, layer.height do
			for x=1, layer.width do
				local i = x + (y - 1) * layer.width
				local gid = layer.data[i]
				
						if gid ~= 0 then
							-- Read flipping flags
							flipHor = gid & FLIPPED_HORIZONTALLY_FLAG
							flipVer = gid & FLIPPED_VERTICALLY_FLAG
							flipDia = gid & FLIPPED_DIAGONALLY_FLAG
							
							-- Convert flags to gideros style
							if(flipHor ~= 0) then flipHor = TileMap.FLIP_HORIZONTAL end
							if(flipVer ~= 0) then flipVer = TileMap.FLIP_VERTICAL end
							if(flipDia ~= 0) then flipDia = TileMap.FLIP_DIAGONAL end

							-- Clear the flags from gid so other information is healthy
							gid = gid & ~ ( FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG )
						end

					local tileset = gid2tileset(map, gid)
					
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
							table.insert(self.worldmap, tilemap)
						end
						
		

						
						local tx = (gid - tileset.firstgid) % tileset.sizex + 1
						local ty = math.floor((gid - tileset.firstgid) / tileset.sizex) + 1
						-- Set the tile with flip info
						tilemap:setTile(x, y, tx, ty, flipHor|flipVer|flipDia)
						
					end
				
			end
		end

		group:setAlpha(layer.opacity)
		self:addChild(group)
	end
	
end

function TiledMap:getTileMap(layer) 
	if layer then
		return self.worldmap[layer]
	else
		return self.worldmap
	end
end

function TiledMap:getMapDetails() 
		return self.mapdetails
end
