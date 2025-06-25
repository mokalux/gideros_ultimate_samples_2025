bg = Core.class(Sprite)
local pos = 0

function bg:init(img)
	self.bgUp1 = Bitmap.new(Texture.new(img))
	self.bgUp2 = Bitmap.new(Texture.new(img))
	
	self.bgUp2:setX(self.bgUp1:getWidth())
	
	self:addChild(self.bgUp1);
	self:addChild(self.bgUp2);
	
	self.speed = 40
	
	--self:addEventListener(Event.ENTER_FRAME, self.update, self)
end

function bg:update()
	pos = self.bgUp1:getX()
	if(pos - self.speed <= -self.bgUp1:getWidth()) then
		self.bgUp1:setPosition(0, 0)
		self.bgUp2:setPosition(self.bgUp1:getWidth(), 0)
	else
		self.bgUp1:setX(self.bgUp1:getX() - self.speed)
		self.bgUp2:setX(self.bgUp2:getX() - self.speed)
	end
end

function bg:setSpeed(speed)
	self.speed = speed
end