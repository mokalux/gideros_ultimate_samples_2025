TileMapSingle = Core.class(Sprite)

function TileMapSingle:init(filename)
	local map = loadfile(filename)()
	
	local tileset = map.tilesets[1]
	tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
	tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))	
	tileset.texture = Texture.new(tileset.image)

	local layer = map.layers[1]
	
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
	
	self:addChild(tilemap)
end
