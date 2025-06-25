
--[[

CollisionMaker Example for Gideros
by Cliff Earl
Antix Software
March 2016

Example project that  loads a tiled  map, renders it, and  creates collision 
rectangles from one of its layers (which are then added to a bump world).

bump is a collision detection and resolution library that operates on AABB's 
(Axis Aligned Bounding  Boxes), it can  also be used as  a spatial directory 
complete  with query  functions. You can  read more  about bump.lua  and its 
functionality at https://github.com/kikito/bump.lua

Take the following case where a map is a 3x3 grid where 1 represents a solid 
cell and 0  represents an empty cell. You  want your sprites to  collide and 
not pass through any solid cells. You could create a new collision rectangle 
for each solid  grid cell  which would result in 6 collision  rectangles. It 
would be more efficient (and faster)  to create fewer (but bigger) collision 
rectangles. This  is what  CollisionMaker does.  CollisionMaker first  scans 
each  vertical column of  grid cells in the map  layer and creates collision 
rectangles from  them. It then  makes a  second pass  and creates horizontal 
collision  rectangles  from  the  remaining  solid  grid  cells.  So  in the 
following example CollisionMaker would generate only 3 collision rectangles. 
I hope you can see the benefit of CollisionMaker.

1,1,1
1,0,0
1,1,0

2 classes are provided with this example, RenderLevel, and CollisionMaker... 

RenderLevel.
Loads tiled maps and renders them. RenderLevel is an extension of the Sprite 
class so once  you have called  render() it  can  be directly  added to  the 
stage. When calling render() any previously created resources (sprites, etc) 
will be cleaned up so you can reuse the RenderLevel over and over.

CollisionMaker.
Scans named  layer and creates collision  rectangles  from it. Any  generated 
collision  rectangles are  added to a bump world.  CollisionMakers generation 
technique is explained above. When you call createRectangles() any previously 
created collision rectangles  will be removed from the  bump world so it also 
can be reused over  and over. When adding a  collision rectangle to  the bump 
world, CollisionMaker  sets its isWall bool to true, which can be used during 
collision detection / resolution.

NOTES:

If you examine the  RenderLevel code you will see placeholder  code where you 
can expand its functionality to process objectlayers and imagelayers.

--]]

local cbump = require "cbump"

local RenderLevel = RenderLevel.new() -- CREATE RENDERLEVEL

--local world = require("bump").newWorld() -- CREATE BUMP COLLISION WORLD
local world = cbump.newWorld() -- CREATE BUMP COLLISION WORLD

local func = loadfile("levels/level0000.lua") -- LOAD MAP
local map = func()
func = nil

RenderLevel:render(map)  -- RENDER MAP
stage:addChild(RenderLevel)

local CollisionMaker =  CollisionMaker.new(world) -- GENERATE COLLISION RECTANGLES
CollisionMaker:enableDebug(true)
CollisionMaker:createRectangles(map, "walls")
