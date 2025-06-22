Vehicle = Core.class(Sprite)

local width = application:getContentWidth()
local tile_width = 64
local tile_height = 64

local textures_south, textures_north

local random = math.random

function Vehicle.setup()
	textures_south = {
						Texture.new("gfx/cars/garbage_SE.png", true),
						Texture.new("gfx/cars/ambulance_SE.png", true),
						Texture.new("gfx/cars/taxi_SE.png", true),
						Texture.new("gfx/cars/carBlue_SE.png", true),
						Texture.new("gfx/cars/police_SE.png", true)
					}
	textures_north = {
						Texture.new("gfx/cars/garbage_NW.png", true),
						Texture.new("gfx/cars/ambulance_NW.png", true),
						Texture.new("gfx/cars/taxi_NW.png", true),
						Texture.new("gfx/cars/carBlue_NW.png", true),
						Texture.new("gfx/cars/police_NW.png", true)
					}
end

-- Constructor	
function Vehicle:init(index, direction, speed)
		
	self.index = index 
	self.direction = direction
	self.speed = speed
	
	--self:setAnchorPoint(0.5, 0.5)
	
	local x, y = self.index * tile_width, -25 -- + width * 0.5, - 25
	self:initPosition(twoDToIso(x,y))
		
	local textures
	if (direction == 0) then
		textures = textures_south
	else
		textures = textures_north
	end
	
	local image = Bitmap.new(textures[random(1,#textures)])
	self:addChild(image)
	self.image = image
end

-- Set up position (x,y)
function Vehicle:initPosition(x,y)
	self.startX = x
	self.startY = y
	
	self:setPosition(x,y)
end

-- Back to starting point
function Vehicle:starting()
	self:setPosition(self.startX, self.startY)
end

-- Vehicle is moving
function Vehicle:update()
	
	local speed = self.speed
	
	if (self.direction == 0) then
		self:setPosition(self:getX() + speed, self:getY() + speed * 0.5)
	else
		self:setPosition(self:getX() -speed, self:getY() - speed * 0.5)
	end
end

function Vehicle:collide()
	self.image:setColorTransform(1, 0, 0)
end