prismaticJoint = gideros.class(Sprite)

function prismaticJoint:init()
	--create world instance
	self.world = b2.World.new(0, 10, true)
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT + b2.DebugDraw.JOINT_BIT)
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	-- some vars
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	--create bounding walls outside the scene
	self:wall(0,screenH/2,10,screenH)
	self:wall(screenW/2,0,screenW,10)
	self:wall(screenW,screenH/2,10,screenH)
	self:wall(screenW/2,screenH,screenW,10)
	--create empty box2d body for joint
	local ground = self.world:createBody({})
	ground:setPosition(screenW / 2, screenH / 2)
	--create ball
	self.ball1 = self:ball(screenW / 2, screenH / 2)
	self.ball1.body:setGravityScale(0)
	--axisx, 	axisy	values usually between 0 and 1
	--0			0		moves freely
	--0			1		moves on y axis
	--1			0		moves on x axis
	--1			1		moves on diagonal
	local jointDef = b2.createPrismaticJointDef(self.ball1.body, ground, screenW / 2, screenH / 2, 0.3, 1)
--	local jointDef = b2.createPrismaticJointDef(ground, self.ball1.body, screenW / 2, screenH / 2, 0, 1)
--	local jointDef = b2.createPrismaticJointDef(ground, self.ball1.body, screenW / 2, screenH / 2, 1, 0)
	self.pj = self.world:createJoint(jointDef)
--	self.pj:setLimits(-screenW / 4, screenW / 4)
	self.pj:setLimits(-screenH / 3, screenH / 4)
	self.pj:enableLimit(true)
	self.pj:setMaxMotorForce(4)
	self.pj:setMotorSpeed(8)
	self.pj:enableMotor(true)
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function prismaticJoint:onEnterFrame() 
	self.world:step(1/60, 8, 3)
	for i = 1, self:getNumChildren() do
		local sprite = self:getChildAt(i)
		if sprite.body then
			local body = sprite.body
			local bodyX, bodyY = body:getPosition()
			sprite:setPosition(bodyX, bodyY)
			sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end
	local pjll, pjhl = self.pj:getLimits()
	if self.pj:getJointTranslation() <= pjll then
		self.pj:setMotorSpeed(8)
--		self.ball1.body:setGravityScale(1)
--		print("x1", self.pj:getJointTranslation(), pjll, self.pj:getMotorSpeed())
	end
	if self.pj:getJointTranslation() >= pjhl then
		self.pj:setMotorSpeed(-8)
--		self.ball1.body:setGravityScale(-1)
--		print("x2", self.pj:getJointTranslation(), pjhl, self.pj:getMotorSpeed())
	end
end

function prismaticJoint:ball(x, y)
	local ball = Bitmap.new(Texture.new("./ball.png"))
	ball:setAnchorPoint(0.5,0.5)
	ball:setPosition(x,y)
	local radius = ball:getWidth()/2
	--create box2d physical object
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(ball:getX(), ball:getY())
	body:setAngle(ball:getRotation() * math.pi/180)
	local circle = b2.CircleShape.new(0, 0, radius)
	local fixture = body:createFixture{shape = circle, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	ball.body = body
	ball.body.type = "ball"
	self:addChild(ball)
	return ball
end

function prismaticJoint:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function prismaticJoint:wall(x, y, width, height)
	local wall = Shape.new()
	wall:beginPath()
	wall:moveTo(-width/2,-height/2)
	wall:lineTo(width/2, -height/2)
	wall:lineTo(width/2, height/2)
	wall:lineTo(-width/2, height/2)
	wall:closePath()
	wall:endPath()
	wall:setPosition(x,y)
	--create box2d physical object
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(wall:getX(), wall:getY())
	body:setAngle(wall:getRotation() * math.pi/180)
	local poly = b2.PolygonShape.new()
	poly:setAsBox(wall:getWidth()/2, wall:getHeight()/2)
	local fixture = body:createFixture{shape = poly, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	wall.body = body
	wall.body.type = "wall"
	self:addChild(wall)
	return wall
end
