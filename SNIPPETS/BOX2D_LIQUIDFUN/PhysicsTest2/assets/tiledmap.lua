TiledMap = Core.class(Sprite)

local function getVertices(polygon)
	local vertices = {}
	for i=1, #polygon do
		local v = polygon[i]
		table.insert(vertices, v.x)
		table.insert(vertices, v.y)
	end
	return vertices
end

function TiledMap:init(filename)
	local directory = "."
	if string.find(filename, "/") then
		directory = string.gsub(filename, "/%w*$", "")
	end
	local map = require(filename)
	for i=1, #map.tilesets do
		local tileset = map.tilesets[i]
		tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
		tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))
		tileset.lastgid = tileset.firstgid + (tileset.sizex * tileset.sizey) - 1
		tileset.texture = Texture.new(directory.."/"..tileset.image, false, {transparentColor = 0xff00ff})
	end
	local function gid2tileset(gid)
		for i=1, #map.tilesets do
			local tileset = map.tilesets[i]
			if tileset.firstgid <= gid and gid <= tileset.lastgid then
				return tileset
			end
		end
	end
	self.tileLayers = {}
	self.objectLayers = {}
	for i=1, #map.layers do
		local layer = map.layers[i]
		if layer.type == "tilelayer" then table.insert(self.tileLayers, layer)
		else table.insert(self.objectLayers, layer)
		end
	end

	for i=1, #self.tileLayers do
		local layer = map.layers[i]
		local tilemaps = {}
		local group = Sprite.new()
		for y=1,layer.height do
			for x=1,layer.width do
				local i = x + (y - 1) * layer.width
				local gid = layer.data[i]
				local tileset = gid2tileset(gid)
				if tileset then
					local tilemap = nil
					if tilemaps[tileset] then tilemap = tilemaps[tileset]
					else tilemap = TileMap.new(layer.width, 
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
		group.name = layer.name
		self:addChild(group)
	end
	for i=1, #self.objectLayers do
		local layer = self.objectLayers[i]
		for j=1, #layer.objects do
			local object = layer.objects[j]
			if object.properties.hasBody == "true" then
				object.body = world:createBody {type = b2.STATIC_BODY, fixedRotation = true, position={x=object.x, y=object.y}}
				object.body.name = object.name
				local shape
				if object.polyline then
					shape = b2.ChainShape.new()
					shape:createChain(unpack(getVertices(object.polyline)))
				elseif object.polygon then
					shape = b2.PolygonShape.new()
					shape:set(unpack(getVertices(object.polygon)))
				else				
					shape = b2.PolygonShape.new()
--					shape:setAsBox(32,32,32,32,0)
					local hx = object.width / 2
					local hy = object.height / 2
					shape:setAsBox(hx, hy, hx, hy, 0)
				end
				object.body:createFixture {shape = shape, density = 1, restitution = 0.2, friction = 0.3}
			end
		end
	end
end

function TiledMap:getTileLayer(name)
	for i=1, self:getNumChildren() do
		local child = self:getChildAt(i)
		if child.name == name then return child end
	end
	return nil
end

function TiledMap:getObjectLayer(name)
	for i=1, #self.objectLayers do
		local layer = self.objectLayers[i]
		if layer.name == name then return layer end
	end
	return nil
end

function TiledMap:getObjectByName(name)
	for i=1, #self.objectLayers do
		local layer = self.objectLayers[i]
		for j=1, #layer.objects do
			local object = layer.objects[j]
			if object.name == name then return object end
		end
	end
	return nil
end

function TiledMap:getObjectsByType(type)
	local objects = {}
	for i=1, #self.objectLayers do
		local layer = self.objectLayers[i]
		for j=1, #layer.objects do
			local object = layer.objects[j]
			if object.type == type then table.insert(objects, object) end
		end
	end	
	return objects
end

function TiledMap:move(speedX, speedY)
	self:setX(self:getX() + speedX)
	self:setY(self:getY() + speedY)
	for i=1, #self.objectLayers do
		local layer = self.objectLayers[i]
		for j=1, #layer.objects do
			local object = layer.objects[j]
			if object.body then
				local x, y = object.body:getPosition()
				object.body:setPosition(x + speedX, y + speedY)
			end
		end
	end	
end
