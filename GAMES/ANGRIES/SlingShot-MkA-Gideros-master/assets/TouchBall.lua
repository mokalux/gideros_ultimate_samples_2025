TouchBall = Core.class(Sprite)

function TouchBall:init(level, x, y, k)
	self.level = level
	self:setPosition(x,y)
	
	if k == 1 or k == 5 then
		self.bitmap = Bitmap.new(Texture.new("images/threeeyes.png", true))
	elseif k == 2 or k == 6 then
		self.bitmap = Bitmap.new(Texture.new("images/Blue.png", true))
	elseif k == 3 or k == 7 or k == 9 then
		self.bitmap = Bitmap.new(Texture.new("images/AlienY.png", true))
	elseif k == 4 or k == 8 then
		self.bitmap = Bitmap.new(Texture.new("images/touch0.png", true))
	else
		local h = math.random(1,2)
		if h==1 then
			self.bitmap = Bitmap.new(Texture.new("images/ghost.png", true))
		else 
			self.bitmap = Bitmap.new(Texture.new("images/ghostinvert.png", true))
		end
	end
	
	self.bitmap:setAnchorPoint(0.5,0.5)
	self:addChild(self.bitmap)
	self:createBody()
end

function TouchBall:createBody()
	--get radius
	local radius = (self.bitmap:getWidth()/2)
	
	--create box2d physical object
	local body = self.level.world:createBody{type = b2.STATIC_BODY}
	
	--copy all state of object
	body:setPosition(self:getPosition())
	body:setAngle(math.rad(self:getRotation()))

	local circle = b2.CircleShape.new(0, 0, radius)
	
	local fixture = body:createFixture{shape = circle, density = 1, 
	friction = 0.1, restitution = 0.5}
	
	body.type = "touch"
	self.body = body
	body.object = self
	
	table.insert(self.level.bodies, body)
end

