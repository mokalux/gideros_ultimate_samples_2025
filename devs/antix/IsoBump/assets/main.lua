--[[
ISO Collision Utilizing Bump.lua Example
by Cliff Earl
Antix Software
March 2016

This example serves to illustrate that you do not need to rotate or 
perform any other hanky  operations to perform collision  detection 
in an isometric game.

The key point is that you don't ever need any isometric to cartesian 
calculations  since  everything  takes  place  in a  grid that  uses 
cartesian  coordinates. You  only need to  convert from cartesian to 
isometric to draw your game world and objects.

This  example draws a small isometric tile map to the screen. As it 
draws the  map it creates a  collision rectangle for any  tile that 
is solid (1 in this example) and adds it to a bump collision world. 
It then creates 5-12 colored squares that move at a random speed at 
a  random  angle. In  the main  loop  the  squares  are  moved  and 
collisions checked  in the bump world. Any square that  hits a wall 
will be bounced off the wall.

As you will see, it does not matter how  you want to draw your game 
objects. They can be drawn in isometric perspective,  topdown, side 
on, etc. As long  as the world you want to  use is based  on a grid 
filled with  AABB's (Axis Aligned Bounding Boxes),  bump will  work
perfectly fine for collision detection and resolution.

NOTES:
This example uses the twoDToIso() code posted by jdbc in his thread 
about his Endless Isometric Racing Game...

http://giderosmobile.com/forum/discussion/6054/isometric-endless-racing#Item_2

--]]

--require("mobdebug").start() -- ONLY REQUIRED FOR ZEROBRANE STUDIO

--stage:setOrientation(Stage.LANDSCAPE_LEFT)

local random, sin, cos, rad = math.random, math.sin, math.cos, math.rad

math.randomseed(os.time()) for i = 1, 4 do random() end -- INIT PRNG

local function vector2(x, y) -- CREATE A NEW 2D VECTOR
	return { x=x, y=y }
end

WIDTH       = application:getContentWidth() -- SOME NASTY CONSTANTS
HEIGHT      = application:getContentHeight()
MIDX        = WIDTH * 0.5 - 32
MIDY        = HEIGHT * 0.5

TILESIZE    = 32

ACTORSIZE  = 16

MAPWIDTH    = 9
MAPHEIGHT   = 9

local bumpWorld = require("bump").newWorld() -- CREATE BUMP COLLISION WORLD

local textureRegions = {
	{  0,  0, 64, 32}, -- 1 WALL TILE
	{ 64,  0, 64, 32}, -- 2 DIRT TILE
	{128,  0, 64, 32}, -- 3 GRASS BUTTON
	{192,  0, 32, 16}, -- 4 BLUE ACTOR
	{192, 16, 32, 16}, -- 5 RED ACTOR
	{224,  0, 32, 16}, -- 6 CYAN ACTOR
	{224, 16, 32, 16}, -- 7 YELLOW ACTOR
}

local textureAtlas = Texture.new("images/isoblocks.png", true)

local function newRegion(r) -- RETURNS A NEW TEXTURE REGION
	local a = textureRegions[r]
	return TextureRegion.new(textureAtlas, a[1], a[2], a[3], a[4])
end

local function setRegion(bitmap, r) -- SETS A BITMAPS TEXTURE REGION
	local region = bitmap.region
	local a = textureRegions[r]
	region:setRegion(a[1], a[2], a[3], a[4])
	bitmap:setTextureRegion(region)
end

function newBitmap(r) -- CREATE NEW BITMAP
	local a = textureRegions[r]
	local region = TextureRegion.new(textureAtlas, a[1], a[2], a[3], a[4])
	local bitmap = Bitmap.new(region)
	bitmap.region = region
--	bitmap:setAnchorPoint(0.5, 0.5)

	return bitmap
end

local function twoDToIso(x, y) -- FROM http://giderosmobile.com/forum/discussion/6054/isometric-endless-racing#Item_2
	local isoX = x - y
	local isoY = (x + y) * 0.5

	return isoX, isoY
end

local function setISOPosition(actor, x, y, w) -- SET BITMAPS X, Y POSITION IN ISOMETRIC SPACE
	local isoX = (x + (w)) - y
	local isoY = (x + y) * 0.5

	actor:setPosition(isoX + MIDX, isoY)
end

local function initMap(group, mapData) -- CREATE GRAPHIC OBJECTS AND COLLISION RECTS FOR TILE MAP
	local n = 1
	for r = 0, MAPHEIGHT - 1 do
		for c = 0, MAPWIDTH - 1 do
			local tile = mapData[n] -- GET NEXT TILE
			if tile == 1 then -- IF ITS A SOLID TILE, CREATE A COLLISION RECT AND ADD IT TO THE BUMP WORLD
				local rect = {isWall = true, x = c * TILESIZE, y = r * TILESIZE, w = TILESIZE, h = TILESIZE}
				bumpWorld:add(rect, rect.x, rect.y, rect.w, rect.h)
			end
			local bitmap = newBitmap(tile)
			local x, y = twoDToIso(c * TILESIZE, r * TILESIZE) -- CONVERT FROM CART TO ISO
			bitmap:setPosition(x + MIDX, y) -- SET ACCORDING TO ISO POSITION
			group:addChild(bitmap)
			n += 1 -- NEXT TILE TO FETCH
		end
	end
end

local function redrawMap(group, mapData) -- REDRAW THE TILE MAP (NOT USED IN EXAMPLE)
	local n = 1
	for r = 1, MAPHEIGHT do
		for c = 1, MAPWIDTH do
			local tile = mapData[n]
			local bitmap = group:getChildAt(n)
			setRegion(bitmap, tile) -- SET BITMAPS NEW REGION
			n += 1
		end
	end
end

local mapData = { -- MOST AWESOME TILE MAP EVER
	1,1,1,1,1,1,1,1,1,
	1,2,2,1,2,2,2,2,1,
	1,2,2,1,2,2,2,2,1,
	1,2,2,2,2,1,2,2,1,
	1,2,2,2,2,2,2,2,1,
	1,1,1,2,3,2,2,2,1,
	1,2,2,2,2,2,2,2,1,
	1,2,2,2,2,2,2,2,1,
	1,1,1,1,1,1,1,1,1,
}

local mapGroup = Sprite.new()
stage:addChild(mapGroup)

initMap(mapGroup, mapData)

local actors = {}

local function createActor()
	local actor = newBitmap(random(4, 7))
	stage:addChild(actor)
	local x = (TILESIZE * 3) + random(0, 16)
	local y = (TILESIZE * 4) + random(0, 16)

	bumpWorld:add(actor, x, y, ACTORSIZE, ACTORSIZE)

	local speed = random(64, 128)
	local angle = random(0, 360)
	actor.velocity = vector2(speed*cos(rad(angle-90)), speed*sin(rad(angle-90)))
	actor.position = vector2(x, y)

	setISOPosition(actor, x , y, ACTORSIZE)
	table.insert(actors, actor)
end

for i = 1, random(12, 24) do -- CREATE A RANDOM NUMBER OF ACTORS
	createActor()
end

local currentTimer = 0
local function onEnterFrame(event) -- MAIN LOOP
--	local timer = os.timer()
--	local dt = timer - currentTimer
--	currentTimer = timer
	local dt = event.deltaTime

	local function updateActor(actor, dt) -- UPDATES ACTOR
		local p, v = actor.position, actor.velocity -- GET POSITION AND VELOCITY

		p.x = p.x + v.x * dt -- MOVE ACTOR TO ITS DESIRED POSITION
		p.y = p.y + v.y * dt

		local filter = function(item, other)
			if other.isWall then return "bounce" end -- ONLY CHECK FOR WALLS IN EXAMPLE
		end

		local actualX, actualY, cols, len = bumpWorld:move(actor, p.x, p.y, filter)
		p.x, p.y = actualX, actualY

		for i=1,len do -- BOUNCE ACTOR OFF WALLS
			local col = cols[1]
			local bounciness = 1
			local nx, ny = col.normal.x, col.normal.y
			local vx, vy = v.x, v.y
			if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
				vx = -vx * bounciness
			end
			if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
				vy = -vy * bounciness
			end
			v.x, v.y = vx, vy
		end
		setISOPosition(actor, p.x, p.y, ACTORSIZE)
	end

	for i = #actors, 1, -1 do -- MOVE ACTORS ABOUT MAP AND BOUNCE THEM OFF WALLS
		updateActor(actors[i], dt)
	end
end
stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
