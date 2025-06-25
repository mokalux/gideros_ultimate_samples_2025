local cube = {type="cuboid"}

cube.texture_cache = {}

function cube:set_visible(stage)
   stage:addChild(self.mesh)
end


function cube:set_position(x,y,z)
   self.mesh:setPosition(x,y,z)
end

function cube:set_size(size)
   if not size then error("Say what size?","warning") end
   local halfl, halfw, halfh
   if type(size) == 'table' then
      self.length, self.width, self.height = size.l, size.w, size.h
	  halfl, halfw, halfh = self.length/2, self.width/2, self.height/2
   else  
      self.length, self.width, self.height = size, size, size
	  halfl, halfw, halfh = size/2, size/2, size/2
   end
   -- left
   self.left:setVertex(1,-halfw,-halfh,-halfl)
   self.left:setVertex(2,-halfw,-halfh, halfl)
   self.left:setVertex(3,-halfw, halfh, halfl)
   self.left:setVertex(4,-halfw, halfh,-halfl)   
   -- right
   self.right:setVertex(1, halfw,-halfh, halfl)
   self.right:setVertex(2, halfw,-halfh,-halfl)
   self.right:setVertex(3, halfw, halfh,-halfl)
   self.right:setVertex(4, halfw, halfh, halfl)   
   -- front
   self.front:setVertex(1,-halfw,-halfh, halfl)
   self.front:setVertex(2, halfw,-halfh, halfl)
   self.front:setVertex(3, halfw, halfh, halfl)
   self.front:setVertex(4,-halfw, halfh, halfl)
   -- back
   self.back:setVertex(1,-halfw,-halfh,-halfl)
   self.back:setVertex(2, halfw,-halfh,-halfl)
   self.back:setVertex(3, halfw, halfh,-halfl)
   self.back:setVertex(4,-halfw, halfh,-halfl)
   -- top
   self.top:setVertex(1,-halfw,-halfh,-halfl)
   self.top:setVertex(2, halfw,-halfh,-halfl)
   self.top:setVertex(3, halfw,-halfh, halfl)
   self.top:setVertex(4,-halfw,-halfh, halfl)
   -- bottom
   self.bottom:setVertex(1,-halfw, halfh,-halfl)
   self.bottom:setVertex(2, halfw, halfh,-halfl)
   self.bottom:setVertex(3, halfw, halfh, halfl)
   self.bottom:setVertex(4,-halfw, halfh, halfl)
end

function cube:set_color(colors)
   if not colors then error("Say what color?",2) end
   if type(colors) == "table" then
      local color = colors[1]
      -- 1st color
	  color = colors[1] or color
	  self.left:setColor(2,color)
	  self.front:setColor(1,color)
	  self.top:setColor(4,color)
      -- 2nd color
	  color = colors[2] or color
	  self.right:setColor(1,color)
	  self.front:setColor(2,color)
	  self.top:setColor(3,color)
      -- 3rd color
	  color = colors[3] or color
	  self.right:setColor(4,color)
	  self.front:setColor(3,color)
	  self.bottom:setColor(3,color)
      -- 4th color
	  color = colors[4] or color
	  self.left:setColor(3,color)
	  self.front:setColor(4,color)
	  self.bottom:setColor(4,color)
      -- 5th color
	  color = colors[5] or color
	  self.left:setColor(1,color)
	  self.back:setColor(1,color)
	  self.top:setColor(1,color)
      -- 6th color
	  color = colors[6] or color
	  self.right:setColor(2,color)
	  self.back:setColor(2,color)
	  self.top:setColor(2,color)
      -- 7th color
	  color = colors[7] or color
	  self.right:setColor(3,color)
	  self.back:setColor(3,color)
	  self.bottom:setColor(2,color)
      -- 8th color
	  color = colors[8] or color
	  self.left:setColor(4,color)
	  self.back:setColor(4,color)
	  self.bottom:setColor(1,color)
	  
   else
      local color = colors
      for i=1, 8 do
	      for j=1,6 do 
		      self.meshes[j]:setColor(i,color)
		  end	  
	  end      
   end   
end

function cube:toggle_sides(sides)
   -- 1,     2,    3,    4,     5,   6
   -- front, back, left, right, top, bottom

--  5  6
-- 1--2
-- |8 |7
-- 4--3
   if sides then
      if type(sides)~="table" then
	     sides = {true, true, true, true, true, true}
	  end
	  
	  local index = 1
	  if sides[1] then
		 self.left:setIndex(1,1)
		 self.left:setIndex(2,2)
		 self.left:setIndex(3,3)
		 self.left:setIndex(4,1)
		 self.left:setIndex(5,3)
		 self.left:setIndex(6,4)
	  end
	  if sides[2] then
		 self.right:setIndex(1,1)
		 self.right:setIndex(2,2)
		 self.right:setIndex(3,3)
		 self.right:setIndex(4,1)
		 self.right:setIndex(5,3)
		 self.right:setIndex(6,4)
	  end
	  if sides[3] then
		 self.front:setIndex(1,1)
		 self.front:setIndex(2,2)
		 self.front:setIndex(3,3)
		 self.front:setIndex(4,1)
		 self.front:setIndex(5,3)
		 self.front:setIndex(6,4)
	  end
	  if sides[4] then
		 self.back:setIndex(1,1)
		 self.back:setIndex(2,2)
		 self.back:setIndex(3,3)
		 self.back:setIndex(4,1)
		 self.back:setIndex(5,3)
		 self.back:setIndex(6,4)
	  end
	  if sides[5] then
		 self.top:setIndex(1,1)
		 self.top:setIndex(2,2)
		 self.top:setIndex(3,3)
		 self.top:setIndex(4,1)
		 self.top:setIndex(5,3)
		 self.top:setIndex(6,4)
	  end
	  if sides[6] then
		 self.bottom:setIndex(1,1)
		 self.bottom:setIndex(2,2)
		 self.bottom:setIndex(3,3)
		 self.bottom:setIndex(4,1)
		 self.bottom:setIndex(5,3)
		 self.bottom:setIndex(6,4)
	  end
   end
end


function cube:set_textures(textures)
  local textures = textures
  if textures and type(textures)~="table" then 
     textures = {textures, textures, textures, textures, textures, textures}
  end
  if textures[1] == nil then error("IDK where I should get textures") end
  for i = 1, 6 do
      -- create or load texture (all loaded ones are stored inside the cube.texture_cache)
	  -- if there's no filename, then fallback to the 1st texture which should be present at this time
	  local texture, texturename	  
	  -- decide what texturename we should use
	  -- it's ith or 1st
	  if textures[i] then texturename = textures[i] else texturename = textures[1] end
	  -- load from cache or create a new texture
      texture = cube.texture_cache[texturename] or Texture.new(texturename)
      -- regardles of preexistence, store texture address in cache (should be faster than any checks)
	  cube.texture_cache[texturename] = texture
	  -- set the texture
      self.meshes[i]:setTexture(texture)
	  -- get texture's dimensions
	  local twidth, theight = texture:getWidth(), texture:getHeight()
	  -- set texture's coordinates	  
	  self.meshes[i]:setTextureCoordinate(1, 0,      0)
      self.meshes[i]:setTextureCoordinate(2, twidth, 0)
      self.meshes[i]:setTextureCoordinate(3, twidth, theight)
      self.meshes[i]:setTextureCoordinate(4, 0,      theight)
  end
end 

function cube:new(args)
   -- local var to contain all data, will be returned in the end
   local c = {}
   -- inherit new cuboid's methods from the default ones
   setmetatable (c, self)
   self.__index = self
   -- parent mesh to contain all 6 sides of a future cuboid
   c.mesh   = Mesh.new(true) 
   -- 6 sides of a new cuboid
   c.left   = Mesh.new(true) 
   c.right  = Mesh.new(true) 
   c.front  = Mesh.new(true) 
   c.back   = Mesh.new(true) 
   c.top    = Mesh.new(true) 
   c.bottom = Mesh.new(true) 
   -- a table for easy access to the sides
   c.meshes = {c.left, c.right, c.front, c.back, c.top, c.bottom}   
   -- this makes it easier to set position and rotation (NOT scale)
   for i=1, 6 do c.mesh:addChild(c.meshes[i]) end   
   -- return if there's no arguments passed (meshes are  created, but are totally unconfigured)
   if not args then return c end
   -- set size of a cuboid
   c:set_size(args.size or {args.l, args.w, args.h})
   -- set position of a cuboid   
   c.mesh:setPosition(args.x or 0, args.y or 0, args.z or 0)
   -- if were told to disable some faces - do it now
   if args.sides then
		c:toggle_sides(args.sides)
   else
      c:toggle_sides(true)
   end
   -- apply color(s) to vertexes
   if args.colors then
      c:set_color(args.colors)
   end
   -- apply textures (automatically stretches texture of any size)
   if args.textures then
      c:set_textures(args.textures)
   end   
   
   return c
end

-------
return cube