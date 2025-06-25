--[[
	This class will handle a parallax background as a sprite that is 
	self contained and should be useful to the game designers.
	
	The original code is from: http://giderosmobile.com/forum/discussion/387/parallax-background
	and all credit should go to Adnaan, I just cleaned it up a little and made a Sprite class out of it :)
]]
ParaBG = Core.class(Sprite)

function ParaBG:init(bgs, bgspeed)

	-- Far Background Images--repeat 
	self.bg1 = Bitmap.new(Texture.new(bgs.bg1),true)
	self.bg2 = Bitmap.new(Texture.new(bgs.bg1),true)

	-- Closer Background Images--repeat
	self.bg3 = Bitmap.new(Texture.new(bgs.bg2),true)
	self.bg4 = Bitmap.new(Texture.new(bgs.bg2),true)
 
	-- Set the starting points.
	self.bgFarY=0
	self.bgNearY=0
	self.bgspeed = bgspeed
		
	-- Add sprites.
	self:addChild(self.bg1)
	self:addChild(self.bg2)
	self:addChild(self.bg3)
	self:addChild(self.bg4)

	--Event--
	self:addEventListener(Event.ENTER_FRAME, self.DrawParaBG, self)
end

-- Do the actual drawing of the backgrounds and update based on speed.
function ParaBG:DrawParaBG(event, container)

	self.bgFarY = (self.bgFarY or 0) - ((self.bgspeed or 4.0) / 4)
	self.bgNearY = (self.bgNearY or 0) - ((self.bgspeed or 4.0))
 
	self.newFarY = self.bg1:getWidth() -(-self.bgFarY)
	if self.newFarY <=0 then
		self.bgFarY = 0
		self.bg1:setX(self.bgFarY)
	else
		self.bg1:setX(self.bgFarY)
		self.bg2:setX(self.newFarY)
	end
 
	self.newNearY = self.bg3:getWidth() -(-self.bgNearY)
	if self.newNearY <=0 then
		self.bgNearY = 0
		self.bg3:setX(self.bgNearY)
	else
		self.bg3:setX(self.bgNearY)
		self.bg4:setX(self.newNearY)
	end

end

-- Allows game to dynamically change the background speed--useful for say power ups.
function ParaBG:setSpeed(bgspeed)
	self.bgspeed = bgspeed
end

-- Get the current speed, useful if you need to store the speed and reset it later in the game.
function ParaBG:getSpeed()
	return self.bgspeed
end
