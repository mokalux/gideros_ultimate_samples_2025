-- Your Gideros Players resolution needs to be at least 512x512 to see this example fully

application:setBackgroundColor(0x0)
stage:setClip(0, 0, 512, 512)

-- Create a thing
local function newThing(textureName)
	local random = math.random
	local texture = Texture.new(textureName, false, {wrap = Texture.REPEAT})
    local region = TextureRegion.new(texture, 0, 0, 256, 256)
    local bitmap = Bitmap.new(region)
	bitmap:setScale(2)
	bitmap:setAnchorPoint(0.5, 0.5)
	bitmap:setPosition(256, 256)

	local thing = {
		x		= random() * 256,
		y		= random() * 256,
		sx		= random(),
		sy		= random(),
		r		= random() * 0.05,
		bitmap	= bitmap,
		region	= region,
	}
	return thing
end

-- Update a thing
local function updateThing(thing, dt)
	local floor = math.floor
	local x = thing.x - thing.sx
	local y = thing.y - thing.sy
	local bitmap = thing.bitmap
	local region = thing.region
	region:setRegion(floor(x % 256), floor(y % 256), 256, 256)
	bitmap:setTextureRegion(region)
	bitmap:setRotation(bitmap:getRotation() + thing.r)
	thing.x, thing.y = x, y
end

-- Create 3 things to represent the plasma
local things = {}
table.insert(things, newThing("red.png"))
table.insert(things, newThing("green.png"))
table.insert(things, newThing("blue.png"))

for i = 1, #things do
	stage:addChild(things[i].bitmap)
end

-- Create our middle layer. It has a hole (in the shape of the logo) so we can see the things below it
local middle = Bitmap.new( Texture.new("middle.png", true) )
stage:addChild(middle)

-- Create the top layer which is our fake bevel
local top = Bitmap.new( Texture.new("top.png", true) )
top:setAlpha(0.5)
stage:addChild(top)
	
local function update(event)
	for i = 1, #things do
		updateThing(things[i], dt)
	end
end
	
currentTimer = os.timer()
stage:addEventListener(Event.ENTER_FRAME, update)