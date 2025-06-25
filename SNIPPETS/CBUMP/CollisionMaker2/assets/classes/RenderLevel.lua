
--[[

name:   Antix RenderLevel
vers:   1.0.1
desc:   Simple tilemap renderer based on Gideros Desert example
auth:   by Cliff Earl
date:   March 2016
legal:  (c) 2016 Antix Software

histo:  v1.0.1 26/3/2016
        there is now no need to manually edit the tileset names in lua maps, 
        the leading "../" characters are  stripped when  attemtping to  laod 
        the tileset.
        
--]]

RenderLevel = Core.class(Sprite)

function RenderLevel:init()
  self.rendered = false
  self.debug = true
end

function RenderLevel:render(map)
  
  --
  -- DESTROY ANY PREVIOUSLY CREATED TILESETS AND TILEMAPS
  --
  
  if self.rendered then
    local group = self:getChildAt(1) -- DESTROY TILEMAPS
    for i = group:getNumChildren(), 1 do
      local tilemap = group:getChildAt(i)
      group:removeChildAt(i)
      tilemap = nil
    end
    self:removeChildAt(1)
    group = nil
    
    for i = 1, #self.map.tilesets do -- DELETE TEXTURE REFERENCES
      map.tilesets[i].texture = nil
    end
    
    -- DESTROY OTHER STUFF HERE..
    
    self.rendered = false
  end

  local function gid2tileset(gid)
    for i=1, #map.tilesets do
      local tileset = map.tilesets[i]
      if tileset.firstgid <= gid and gid <= tileset.lastgid then
        return tileset
      end
    end
  end

  --
  -- RENDER TILED MAP
  --

  for i=1, #map.layers do
    local layer = map.layers[i]
	
	if layer.type == "tilelayer" then

	  for i=1, #map.tilesets do -- CREATE TILESETS
		local tileset = map.tilesets[i]
		tileset.sizex = math.floor((tileset.imagewidth - tileset.margin + tileset.spacing) / (tileset.tilewidth + tileset.spacing))
		tileset.sizey = math.floor((tileset.imageheight - tileset.margin + tileset.spacing) / (tileset.tileheight + tileset.spacing))
		tileset.lastgid = tileset.firstgid + (tileset.sizex * tileset.sizey) - 1
    tileset.texture = Texture.new(string.sub(tileset.image, 4), false, {transparentColor = 0xff00ff}) -- V1.0.1
	  end
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
				tilemap = TileMap.new(layer.width, layer.height, tileset.texture, tileset.tilewidth, tileset.tileheight, tileset.spacing, tileset.spacing, tileset.margin, tileset.margin, map.tilewidth, map.tileheight)
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
		self:addChild(group)
		
   --
	 -- PROCESS OBJECT LAYER HERE
   --
    
    elseif layer.type == "objectgroup" then
    
   --
	 -- PROCESS IMAGE LAYER HERE
   --
    
    elseif layer.type == "imagelayer" then
    self:addChild(Sprite.new())
    
    else
      if self.debug then print("RenderLevel: found unknown layer type '"..layer.type.."'") end
	  end
	end
  self.rendered = true
end
