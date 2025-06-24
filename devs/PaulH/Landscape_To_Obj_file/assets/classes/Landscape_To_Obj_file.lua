--https://forum.gideros.rocks/discussion/comment/65919/#Comment_65919
--[[
landscape.lua by PaulH
Implements a 3D landscape as defined by a heightfield texture and scale parameters.
Note: This module requires the LUA file system (LFS) plugin.
--]]

require 'lfs'

Landscape = gideros.class(Sprite)

local function interpolate(low, high, high_ratio) return low + (high - low) * high_ratio end

function Landscape:init(
	heightfield_image_path,
	vertices_per_side,
	world_size,
	min_elevation, max_elevation,
	texture_file,
	clean_edges
)
	--[[
	Input parameters:
	heightfield_image_path - Image of heightfield, with light shades for high elevaltions, dark for lowest_loc_x
	vertices_per_side - Number of vertices in each row and column of the mesh. 128 is reasonable. The resulting mesh
		will have a total vertex count of the square of this number.
	world_size - In world units, which could be treated as feet, meters, cm, etc. 10000 is managed, representing
		close to 4 square miles, if a unit is a foot.  Mesh will be centered around 0X and 0Z,
		with 1/2 world_size extending from the origin on each horizontal axis.
	min_elevation, max_elevation - The elevation, in world units, of the lowest and highest points.
	texture_file - Path to the texture to apply to the landscape
	clean_edges - If set, lower vertices on edges to the lowest elevation, to prevent exposing edges.
	--]]
	-- Store input parameters:
	self.world_size = world_size
	self.vertices_per_side = vertices_per_side
	self.texture_file = texture_file
	-- Create a folder for temporary files:
	local temp_obj_folder = "|D|landscape_temp"
	lfs.mkdir(temp_obj_folder)
	-- Make a copy of the texture in the temp folder:
	self.landscape_texture = Texture.new(texture_file)
	local rt = RenderTarget.new(self.landscape_texture:getWidth(), self.landscape_texture:getHeight())
	local bmp = Bitmap.new(self.landscape_texture)
	rt:draw(bmp)
	local temp_texture_file_name = "temp_texture.png"
	rt:save(temp_obj_folder .. "/" .. temp_texture_file_name)
	-- Load the heightmap texture:
	local heightmap_texture = Texture.new(heightfield_image_path)
	-- Store the dimensions:
	local map_w = heightmap_texture:getWidth()
	local map_h = heightmap_texture:getHeight()
	-- Create a render target so we can access the heightfield pixel data:
	local rt = RenderTarget.new(self.vertices_per_side, self.vertices_per_side)
	local bmp = Bitmap.new(heightmap_texture)
	-- Scale the heightfield if necessary to fit the render target:
	if map_w ~= self.vertices_per_side or map_h ~= self.vertices_per_side then
		bmp:setScaleX(self.vertices_per_side / bmp:getWidth())
		bmp:setScaleY(self.vertices_per_side / bmp:getHeight())
	end
	-- Populate the render target with the map:
	rt:draw(bmp)
	-- Build a height table with an entry for each pixel in the height map:
	self.height_table = {}
	local buffer = rt:getPixels()
	-- Keep track of the darkest and lightest pixels we find so we can
	-- calculate the range between them and scale vertically to the
	-- desired range:
	local max_shade = -999;
	local min_shade = 999;
	self.lowest_loc_x = 0;
	self.lowest_loc_z = 0;
	self.highest_loc_x = 0;
	self.highest_loc_z = 0;
	-- Make one pass through the pixels to find the lightest and darkest:
	for x = 0, self.vertices_per_side - 1 do
		-- Note: Y coordinate in texture will correspond to Z coordinate in resulting model, with the
		-- Y axis representing elevation.
		for y = 0, self.vertices_per_side - 1 do
			-- Index assumes 4 bytes per pixel. Index is for red component, all we need for height
			local index = (y * self.vertices_per_side + x) * 4 + 1
			local color = string.byte(buffer, index) -- (x, y)
			if color < min_shade then
				min_shade = color
				self.lowest_loc_x = x;
				self.lowest_loc_z = y;
			end
			if color > max_shade then
				max_shade = color
				self.highest_loc_x = x;
				self.highest_loc_z = y;
			end
		end
	end -- of loop through x coordinates

	local shade_range = max_shade - min_shade 

	-- Make another pass through the pixels, computing the height each represents.
	for x = 0, self.vertices_per_side - 1 do
		self.height_table[x] = {}
		-- Note: Y coordinate in texture will correspond to Z coordinate in resulting model, with the
		-- Y axis representing elevation.
		for y = 0, self.vertices_per_side - 1 do
			-- Index assumes 4 bytes per pixel. Index is for red component, all we need for height
			local index = (y * self.vertices_per_side + x) * 4 + 1
			local color = string.byte(buffer, index)
			self.height_table[x][y] = (color - min_shade) / shade_range * (max_elevation - min_elevation) + min_elevation
			if clean_edges then
				if x == 0 or y == 0 or x == self.vertices_per_side - 1 or y == self.vertices_per_side - 1 then
					self.height_table[x][y] = min_elevation
				end
			end
		end
	end -- of loop through x coordinates

	-- We have a table of heights from the heightfield map.  Now creat an .obj
	-- file defining a mesh of the landscape:
	local temp_obj_file_name = "landscape_generated_model.obj"
	file = io.open(temp_obj_folder .. "/" .. temp_obj_file_name, "w")
	file:write("mtllib landscape.mtl\n")
	file:write("o Cube\n")
	-- Create vertexes:
	for x = 0, self.vertices_per_side - 1 do
		for z = 0, self.vertices_per_side - 1 do
			local vy = self.height_table[x][z]
			local vx = ((x / (self.vertices_per_side - 1)) - 0.5) * self.world_size
			local vz = ((z / (self.vertices_per_side - 1)) - 0.5) * self.world_size
			file:write("v "
				.. string.format("%1.06f", vx) .. " "
				.. string.format("%1.06f", vy) .. " "
				.. string.format("%1.06f", vz) .. "\n")
		end
	end -- of loop through x coordinates
	-- Create vertex texture coordinates:
	for x = 0, self.vertices_per_side - 1 do
		for z = 0, self.vertices_per_side - 1 do
			local vu, vv = -- vertex u and v, coordinates into the texture:
				-- Normal, works:
				x / (self.vertices_per_side - 1),  -- assumes texture of same size as map.
				z / (self.vertices_per_side - 1)
			-- vu = (x % 2) --  % 2 * n repeats the whole texture N times per face
			-- vv = (z % 2) -- well, %2 works, but %2 * n does the texture once, and stripes at edges beyond that.
 
			file:write("vt "
				.. string.format("%1.06f", vu) .. " "
				.. string.format("%1.06f", vv) .. "\n")
		end
	end -- of loop through x coordinates
	-- Create normals, one for each vertex:
	for x = 0, self.vertices_per_side - 1 do
		for z = 0, self.vertices_per_side - 1 do
			local vx, vy, vz = 0, 1, 0  -- Default normal to facing straight up
 
			local y1 = self.height_table[x][z]
			local y2 = y1 -- Default to same value
			local y3 = y1 -- Default to same value
			if self.height_table[x + 1] and self.height_table[x + 1][z] then
				y2 = self.height_table[x + 1][z]
			end
			if self.height_table[x] and self.height_table[x][z + 1] then
				y3 = self.height_table[x][z + 1]
			end
			local anglex = 0
			if y1 and y2 and y3 then
				anglex = math.atan(y2 - y1)
				vx = math.sin(anglex)
				local anglez = math.atan(y3 - y1)
				vz = math.sin(anglez)
				vy = math.cos(anglex * anglez)
			end
			-- Convert the normal to a unit vector:
			local length = math.sqrt(vx * vx + vy * vy + vz * vz)
			vx = vx / length
			vy = vy / length
			vz = vz / length
			-- Write the vertex normal:
			file:write("vn "
				.. string.format("%1.06f", vx) .. " "
				.. string.format("%1.06f", vy) .. " "
				.. string.format("%1.06f", vz) .. "\n")
		end
	end -- of loop through x coordinates
	file:write("usemtl Material\n")
	file:write("s off\n") -- smoothing across polygons, 1 or off.
	-- Create faces, one fewer than vertices in each row and column::
	for x = 1, self.vertices_per_side - 1 do
		for z = 1, self.vertices_per_side - 1 do
			-- Starting vertex index
			local v1 = x + (z - 1) * (self.vertices_per_side) -- herenow findmenow  - still in synch w/ vertices?
			-- Link to the vertex to the right, x+1
			-- Don't have to worry about edges - we have one more vertex than face in each row
			local v2 = v1 + 1
			-- Next is one down, at X+1, Z+1
			local v3 = (x + 1) + ((z + 1) - 1) * (self.vertices_per_side)
			-- Next is back to X, down at Z+1
			local v4 = x + ((z + 1) - 1) * (self.vertices_per_side)
			-- second and third value for each face is the same - UV coordinates and normals listed in same order as vertexes.
			file:write("f "
			.. v1 .. "/" .. v1 .. "/" .. v1 .. " "
			.. v2 .. "/" .. v2 .. "/" .. v2 .. " "
			.. v3 .. "/" .. v3 .. "/" .. v3 .. " "
			.. v4 .. "/" .. v4 .. "/" .. v4 .. "\n")
		end
	end -- of loop through x coordinates
	file:close()
	local material_file_contents =
[[
newmtl Material
Ns 1000
Ka 1.000000 1.000000 1.000000
Kd 0.640000 0.640000 0.640000
Ks 0.500000 0.500000 0.500000
Ke 0.000000 0.000000 0.000000
Ni 1.000000
d 1.000000
illum 2
map_Kd ]]
.. temp_texture_file_name ..
[[

]]
	file = io.open(temp_obj_folder .. "/" .."landscape.mtl", "w")
	file:write(material_file_contents)
	file:close()
	-- We now have a .obj file.  Create the mesh:
--	self.sprite = loadObj(temp_obj_folder, temp_obj_file_name)
	-- This class extends Sprite, so add the model as a child of this instance:
--	self:addChild(self.sprite)
	-- Store a reference to the object in an objs table for compatibility with shaders based on lighting.lua
--	self.objs = {}
--	table.insert(self.objs, self.sprite)
end -- of :init()

function Landscape:getElevation(x, z)
	-- Return the elevation in world units at specified world coordinates, interpolating between
	-- points defined by the heightfield as appropriate.

	-- Get the relative position in the height table represented by the coordinates:
	local rx = math.max(math.min((x - (0 - self.world_size / 2)) / self.world_size, 1), 0)
	local rz = math.max(math.min((z - (0 - self.world_size / 2)) / self.world_size, 1), 0)
	-- Coords would be indexes into table, but are not integer. Floor will be low idx, floor + 1 will be high idx
	local x_coord = rx * (self.vertices_per_side - 1)
	local z_coord = rz * (self.vertices_per_side - 1)
	-- Get indexes for the height table entries that surround the point in question
	local low_x_idx = math.max(0, math.floor(x_coord))
	local high_x_idx = math.min(low_x_idx + 1, self.vertices_per_side - 1)
	local low_z_idx = math.max(0, math.floor(z_coord))
	local high_z_idx = math.min(low_z_idx + 1, self.vertices_per_side - 1) 
	-- Determine how far we'll interpolate between on X and Z axis
	local x_interp = x_coord % 1
	local z_interp = z_coord % 1
	-- Get the height at those four points, starting with safe defaults:
	local height00 = 0
	local height01 = 0
	local height10 = 0
	local height11 = 0
	if self.height_table[low_x_idx] then
		height00 = self.height_table[low_x_idx][low_z_idx]
		height01 = self.height_table[low_x_idx][high_z_idx]
		if not height00 then height00 = 0 end
		if not height01 then height01 = 0 end
	end
	if self.height_table[high_x_idx] then
		height10 = self.height_table[high_x_idx][low_z_idx]
		height11 = self.height_table[high_x_idx][high_z_idx]
		if not height10 then height10 = 0 end
		if not height11 then height11 = 0 end
	end
	-- Interpolate across the top row (min y, from low to high x)
	local height_top = interpolate(height00, height10, x_interp)
	-- And on the bottom row:
	local height_bottom = interpolate(height01, height11, x_interp)
	-- And between them by y interp:
	local val = interpolate(height_top, height_bottom, z_interp)
 
	return val
end

function Landscape:getSlope(x, z, relative_direction)
	local offset_x1 = 1
	local offset_z1 = 0
	local offset_x2 = 0
	local offset_z2 = 1

	if relative_direction then
		offset_x = 0 - math.cos(math.rad(relative_direction))
		offset_z = math.sin(math.rad(relative_direction))
		offset_x1 = offset_x
		offset_z1 = offset_z
		offset_x2 = -offset_z
		offset_z2 = offset_x
	end
	local h = self:getElevation(x, z)
	local hx1 = self:getElevation(x + offset_x1, z + offset_z1)
	local hz1 = self:getElevation(x + offset_x2, z + offset_z2)

	local slope_x = math.deg(math.atan(hx1 - h))
	local slope_z = math.deg(math.atan(hz1 - h))

	return slope_x, slope_z
end
