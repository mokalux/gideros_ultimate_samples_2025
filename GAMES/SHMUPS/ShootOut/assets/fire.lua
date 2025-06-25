Fire = Core.class(Sprite)

function Fire:init(filename, speed, target, x, y)
	self.fire = Bitmap.new(Texture.new(filename))
	stage:addChild(self.fire)
	
	self:setScale(0.8)
	self.x = x-(self.fire:getWidth()/2)
	self.y = y
	self.counter = y
	self.target = self.x
	self.speed = speed
	self.targetValue = target

	stage:addEventListener(Event.ENTER_FRAME, self.onFire, self)
end

function Fire:onFire()

	--self.target = origem
	--self.targetValue = destino
	
	self.target += self.targetValue
	self.counter += self.speed

	self.fire:setPosition(self.x, self.y)
	self.fire:setY(self.counter)
	self.fire:setX(self.target)
	
	if self.counter < 0 or self:getX() < 0 or self.counter >= 480 or self:getX() >= 320 then
		self.fire:removeFromParent()
		self.counter = 0
		stage:removeEventListener(Event.ENTER_FRAME, self.onFire, self)
	end
end

function Fire.collidesWith(self, sprite2)
 
	local x,y,w,h = self.fire:getBounds(stage)
	local x2,y2,w2,h2 = sprite2:getBounds(stage)
	x2 = x2-4
	y2 = y2+10
	--print(x2, y2)
	-- self bottom < other sprite top
	if y + h < y2 then
		return false
	end
	-- self top > other sprite bottom
	if y > y2 + h2 then
		return false
	end
	-- self left > other sprite right
	if x > x2 + w2 then
		return false
	end
	-- self right < other sprite left
	if x + w < x2 then
		return false
	end
	
	--print('self bounds:',x,y,w,h,' sprite2 bounds:',x2,y2,w2,h2)
	return true
end