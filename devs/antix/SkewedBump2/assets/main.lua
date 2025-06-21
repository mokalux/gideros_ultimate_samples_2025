--require("mobdebug").start() -- ONLY REQUIRED FOR ZEROBRANE STUDIO

--stage:setOrientation(Stage.PORTRAIT)
application:setBackgroundColor(0x7350ff)
local random, insert, sin, cos, rad = math.random, table.insert, math.sin, math.cos, math.rad
math.randomseed(os.time()) for i = 1, 4 do random() end -- INIT PRNG

local function vector2(x, y) -- CREATE A NEW 2D VECTOR
  return { x=x, y=y }
end

local cbump = require "cbump"
--local bumpWorld = require("bump").newWorld() -- CREATE BUMP COLLISION WORLD
local bumpWorld = cbump.newWorld() -- CREATE BUMP COLLISION WORLD

local shapes = {
	{texture = Texture.new("images/big.png", false), w = 32, h = 32},
	{texture = Texture.new("images/med.png", false), w = 16, h = 16},
	{texture = Texture.new("images/sml.png", false), w =  8, h =  8},
}

local function setSkewedPosition(actor, x, y) -- SET BITMAPS X, Y POSITION IN SKEWED ISOMETRIC SPACE
	local skewedX = x + (y / 2)
	actor:setPosition(skewedX, y)
--	actor:setPosition(x, y)
end

local walls = {
	{isWall = true, x =   0, y =   0, w = 192, h =   8}, -- TOP
	{isWall = true, x =   0, y = 184, w = 192, h =   8}, -- BOTTOM
	{isWall = true, x =   0, y =   8, w =   8, h = 176}, -- LEFT
	{isWall = true, x = 184, y =   8, w =   8, h = 176}, -- RIGHT
}
for i = 1, #walls do
	bumpWorld:add(walls[i], walls[i].x, walls[i].y, walls[i].w, walls[i].h) -- ADD WALLS TO BUMP AS COLLISION RECTANGLES
end
stage:addChild(Bitmap.new(Texture.new("images/walls.png", false))) -- LETS JUST SHOW AN IMAGE INSTEAD OF DRAWING ;)

local actors = {}
local function createActor(x, y)
	local shape = shapes[random(#shapes)] -- GET A RANDOM SHAPE
	local actor = Bitmap.new(shape.texture)
	stage:addChild(actor)
	actor:setColorTransform(random(), random(), random(), 1) -- RANDOMIZE ITS COLOR
	bumpWorld:add(actor, x, y, shape.w, shape.h)

	local speed = random(20, 40) -- SET ACTOR IN MOTION
	local angle = random(0, 360)
	actor.velocity = vector2(speed * cos(rad(angle - 90)), speed * sin(rad(angle - 90)))
	actor.position = vector2(x, y)
	actor.isShape = true

	setSkewedPosition(actor, x , y) -- MAGIC
	insert(actors, actor)
end

createActor(  32, 32) -- CREATE 9 ACTORS OF RANDOM SIZES
createActor(  32, 64)
createActor(  64, 64)
createActor(  24, 80)
createActor(  80, 80)
createActor( 136, 80)
createActor(  24, 136)
createActor(  80, 136)
createActor( 136, 136)

local function onEnterFrame(e) -- MAIN LOOP
	local function updateActor(actor, dt) -- UPDATES ACTOR
		local p, v = actor.position, actor.velocity -- GET POSITION AND VELOCITY
		p.x = p.x + v.x * dt -- MOVE ACTOR TO ITS DESIRED POSITION
		p.y = p.y + v.y * dt
		local filter = function(item, other)
			if other.isWall or other.isShape then return "bounce" end -- ONLY CHECK FOR WALLS IN EXAMPLE
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
		setSkewedPosition(actor, p.x, p.y)
	end
	for i = #actors, 1, -1 do -- MOVE ACTORS ABOUT MAP AND BOUNCE THEM OFF WALLS
		updateActor(actors[i], e.deltaTime)
	end
end
stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
