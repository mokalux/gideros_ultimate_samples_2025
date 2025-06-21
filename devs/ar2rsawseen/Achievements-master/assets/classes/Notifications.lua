Notifications = Core.class(Sprite)

function Notifications:init(title, text, delay)
	local title = TextField.new(nil, title, true)
	title:setScale(1.5)
	title:setTextColor(0xffffff)
	title:setPosition(10, 10)
	self:addChild(title)
	
	local text = TextField.new(nil, text, true)
	text:setScale(1.5)
	text:setTextColor(0xffffff)
	text:setPosition(10, 30)
	self:addChild(text)
	
	local width = self:getWidth() + 40
	local height = self:getHeight() + 20
	
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0x000000, 0.6)
	shape:setLineStyle(2, 0x8b9d9b)
	shape:beginPath()
	shape:moveTo(0,0)
	shape:lineTo(width, 0)
	shape:lineTo(width, height)
	shape:lineTo(0, height)
	shape:lineTo(0, 0)
	shape:endPath()
	shape:setPosition(-10, -10)
	self:addChildAt(shape, 1)
	
	if not stage.notifications then
		stage.notifications = Sprite.new()
		stage:addChild(stage.notifications)
	else
		stage:addChild(stage.notifications)
	end
	
	local currentHeight = stage.notifications:getNumChildren()
	stage.notifications:addChild(self)
	self:setPosition(application:getContentWidth() - self:getWidth(), currentHeight*self:getHeight()+20)
	Timer.delayedCall(delay, function()
		stage.notifications:removeChild(self)
		self = nil
	end)
end