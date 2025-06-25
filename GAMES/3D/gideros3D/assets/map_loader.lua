local maploader = {}
maploader.cubes = require("cubes")

function maploader:load_file(filename)
   local map = {}
--   local level = dofile(filename)
   local level = loadfile(filename)()
   -- I want to support many types of maps: txt, lua, png, etc
   -- so... if level is a table, I can check for "layers" field 
   -- to determine whether it is possible to use a Tiled-exported map       	  
   if type(level)=="table" then
      if level.layers then
	     -- regardless of the name, always load 1stlayer as a map.
		 -- it's good to know that Tiled uses indicies to represent placed tiles
		 -- and that "0" is "no tile at all"
		 local data = level.layers[1]
		 map.width = data.width
		 map.height = data.height
		 for i=1, data.height do -- we take 1 row at a time
			 map[i] = {}
		     for j=1, data.width do -- and traverse colums
			     map[i,j]= data.data[j+(i-1)*data.width]
		     end		 
		 end		 
	  end
   end   
   return map
end

function maploader:cuboid_level_create(map, cellsize, initpos)
     local map3d = {}
	 map3d.root = Mesh.new()
	 for i=1, map.height do -- we take 1 row at a time
	     map3d[i] = {}
		 for j=1, map.width do -- and traverse colums		 
		     -- 1 means wall
			 local cell
		     if map[i,j] == 1 then 			    
			    cell = {size=cellsize, x=j*cellsize, z=i*cellsize, textures={"box.png"}, sides={true,true,true,true,true,true}}
			    map3d[i,j] = cell
				map3d[i,j].cell = self.cubes:new(cell) 
			 -- 2 means corridor, needs checks
			 elseif map[i,j] == 2 then 
			    cell = {size=cellsize, x=j*cellsize, z=i*cellsize, textures={"box.png"}, sides={nil,nil,nil,nil,true,true}}
			    map3d[i,j] = cell
				map3d[i,j].cell = self.cubes:new(cell) 
			 end			 
			 
			 if cell then map3d.root:addChild(map3d[i,j].cell.mesh) end
		 end		 
	 end
	 return map3d
end

return maploader
