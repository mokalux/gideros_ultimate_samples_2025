--ScrollView widget

ScrollView = Core.class(Sprite)

function ScrollView:init()
	self.yScroll = 0
	self.ySpeed = 0
	self.yStart = 0
	self.layer = Sprite.new()
	self.layer:setX(50)
	self:addChild(self.layer)
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function ScrollView:onEnterEnd()
	self:addEventListener(Event.MOUSE_MOVE, function(e)
		self:scroll(e.y - self.yScroll)
	end)
 
	self:addEventListener(Event.MOUSE_DOWN,function(e)
		self.yScroll = e.y + self.layer:getY()*-1
		self.ySpeed = 0
		self.yStart = e.y
		self.startTime = os.timer()
	end)
	
	self:addEventListener(Event.MOUSE_UP,function(e)
		self.ySpeed = math.floor((e.y - self.yStart)/9)
	end)
end

function ScrollView:scroll(newY)
	if newY <= 0 and newY*-1 < self.layer:getHeight() - (application:getContentHeight() - 100) then
		self.layer:setY(newY)
	end
end

function ScrollView:onEnterFrame()
	if self.ySpeed ~= 0 then
		if self.ySpeed > 0 then
			self.ySpeed = self.ySpeed - 0.5
		else
			self.ySpeed = self.ySpeed + 0.5
		end
		self:scroll(self.layer:getY() + self.ySpeed)
	end
end
