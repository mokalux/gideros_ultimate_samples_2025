	--function Landscape:init(
	--	heightfield_image_path,
	--	vertices_per_side,
	--	world_size,
	--	min_elevation,
	--	max_elevation,
	--	texture_file,
	--	clean_edges
	--)
--[[
	Input parameters:
	heightfield_image_path -
		Image of heightfield, with light shades for high elevaltions, dark for lowest_loc_x
	vertices_per_side -
		Number of vertices in each row and column of the mesh. 128 is reasonable. The resulting mesh
		will have a total vertex count of the square of this number.
	world_size -
		In world units, which could be treated as feet, meters, cm, etc. 10000 is managed, representing
		close to 4 square miles, if a unit is a foot.  Mesh will be centered around 0X and 0Z,
		with 1/2 world_size extending from the origin on each horizontal axis.
	min_elevation, max_elevation -
		The elevation, in world units, of the lowest and highest points.
	texture_file -
		Path to the texture to apply to the landscape
	clean_edges (boolean) -
		If set, lower vertices on edges to the lowest elevation, to prevent exposing edges.
--]]

local landscape = Landscape.new(
--	"gfx/Ridge Through Terrain Height Map.png",
	"gfx/Badlands Range Sharp 1.png",
	64,
	1000,
	-100, 100, -- min_elevation, max_elevation
	"gfx/Ridge Through Terrain.png",
	false -- true, false, boolean
)

print("")
print("***")
print("ready, look in your folder:")
print("C:\\Users\\xxx\\AppData\\Local\\Temp\\gideros\\Landscape_To_Obj_file\\documents\\landscape_temp")
print("***")
