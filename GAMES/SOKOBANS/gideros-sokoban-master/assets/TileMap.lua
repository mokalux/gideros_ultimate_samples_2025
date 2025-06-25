TiledMap = Core.class(Sprite)

local map

local tiles = {}
local current = 1

function TiledMap:unload()
	tiles = {}
	current = 1
	map = nil
end

function TiledMap:getMap(i)
	if (tiles ~= nil) then
		if (i ~= nil) then
			return tiles[i]
		else 
			return tiles
		end
	else
		return nil
	end
end

function TiledMap:getTile(x, y)
	local result = nil
	for i = 1, #tiles do
		local tile = tiles[i]
		if (tile:getTile(x, y) ~= nil) then
			result = tile:getTile(x, y)
		end
	end
	return result
end

function TiledMap:getProperty(name)
	for k, v in pairs(map.properties) do
		if (k == name) then
			return v
		end
	end
	return nil
end

function TiledMap:init(filename)

	map = loadfile(filename)()

	local tileset = map.tilesets[1]
	tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
	tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))	
	tileset.texture = Texture.new(tileset.image, true)

	local layers = map.layers
	
	for i = 1, #layers do
		layer = layers[i]
		local tilemap = TileMap.new(layer.width, 
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

		for y=1,layer.height do
			for x=1,layer.width do
				local i = x + (y - 1) * layer.width
				local gid = layer.data[i]
				if gid ~= 0 then
					local tx = (gid - tileset.firstgid) % tileset.sizex + 1
					local ty = math.floor((gid - tileset.firstgid) / tileset.sizex) + 1
					tilemap:setTile(x, y, tx, ty)
				end
			end
		end
		
		tilemap:setAlpha(layer.opacity)
		self:addChild(tilemap)
		tiles[current] = tilemap
		current = current + 1
	end
	
end

function TiledMap:getLayer(name)

	-- if we have a name parameter and it's a string
	if name and type(name) == 'string' then
		-- search for name
		for index = 1, #map.layers do
			-- if found
			if map.layers[index].name == name then
				-- return it
				return map.layers[index]
				
			end
			
		end
		
	end

end

--[[function TiledMap:getProperty(item, name)
	
	-- if we have an item and 
	if item and name and type(item) == 'table' and type(name) == 'string' then
		
		for k, v in pairs(item.properties) do 
			
			if k == name then  
				
				return v
				
			end	
			
		end
		
	end
	
end]]
