TileMapMultiple = Core.class(Sprite)


local function gid2tileset(map, gid)
	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
	
	
		if tileset.firstgid <= gid and gid <= tileset.lastgid then
			return tileset
		end
	end
end



function TileMapMultiple:init(filename)
	map = loadfile(filename)()

	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
		
		tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
		tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))
		tileset.lastgid = tileset.firstgid + (tileset.sizex * tileset.sizey) - 1

	local tilesetImage = "Tilemaps/" .. tileset.image;
	
	tileset.texture = Texture.new(tilesetImage)

	end

	for i=1, #map.layers do
		local layer = map.layers[i]

		local tilemaps = {}
		local group = Sprite.new()

-- Exclude objects from this routine

if(layer.type ~= 'objectgroup') then


		for y=1,layer.height do
			for x=1,layer.width do
				local i = x + (y - 1) * layer.width
				local gid = layer.data[i]
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
					end
					
					local tx = (gid - tileset.firstgid) % tileset.sizex + 1
					local ty = math.floor((gid - tileset.firstgid) / tileset.sizex) + 1
					
					tilemap:setTile(x, y, tx, ty)
					
					if(layer.name=="Acid") then
						self.animatedLayer = tilemap;
					end
				end
			end
		end
		
		
		end

		group:setAlpha(layer.opacity)
		
		self:addChild(group)
	end
end




function TileMapMultiple:getLayer(name)

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

function TileMapMultiple:getProperty(item, name)
	
	-- if we have an item and 
	if item and name and type(item) == 'table' and type(name) == 'string' then
		
		for k, v in pairs(item.properties) do 
			
			if k == name then  
				
				return v
				
			end	
			
		end
		
	end
	

	
end


