--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class
gearJoint = gideros.class(Sprite)

--on scene initialization
function gearJoint:init()
	local text = TextField.new(TTFont.new("tahoma.ttf", 20), "Gear Joint example")
	text:setPosition(math.floor((application:getContentWidth()-text:getWidth())/2), 100)
	self:addChild(text)
	--create world instance
	self.world = b2.World.new(0, 10, true)
	
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	--create bounding walls outside the scene
	self:wall(0,screenH/2,10,screenH)
	self:wall(screenW/2,0,screenW,10)
	self:wall(screenW,screenH/2,10,screenH)
	self:wall(screenW/2,screenH,screenW,10)
	
	--create empty box2d body for joint
	--since mouse cursor is not a body
	--we need dummy body to create joint
	local ground = self.world:createBody({})
	
	--create ball for revolute join
	self.ball1 = self:ball(300, 300)
	--create revolute joint
	--note that ground should be passed as first parameter here
	local jointDef = b2.createRevoluteJointDef(ground, self.ball1.body, 300, 300)
	local revoluteJoint = self.world:createJoint(jointDef)
	--set motor
	revoluteJoint:setMaxMotorTorque(1)
	revoluteJoint:enableMotor(true)
	
	--create ball for prismatic joint
	self.ball2 = self:ball(350, 100)
	--axisx, 	axisy	values usually between 0 and 1
	--note that ground should be passed as first parameter here
	local jointDef = b2.createPrismaticJointDef(ground, self.ball2.body, 350, 100, 0.3, 1)
	local prismaticJoint = self.world:createJoint(jointDef)
	--set motor
	prismaticJoint:setMaxMotorForce(1)
	prismaticJoint:enableMotor(true)
	
	
	--create gear joint using two already created joints
	local jointDef = b2.createGearJointDef(self.ball1.body, self.ball2.body, revoluteJoint, prismaticJoint, 1)
	local gearJoint = self.world:createJoint(jointDef)
	
	
	
	--joint with dummy body
	local mouseJoint = nil

	-- create a mouse joint on mouse down
	function self:onMouseDown(event)
		if self.ball1:hitTestPoint(event.x, event.y) then
			local jointDef = b2.createMouseJointDef(ground, self.ball1.body, event.x, event.y, 100000)
			mouseJoint = self.world:createJoint(jointDef)
		elseif self.ball2:hitTestPoint(event.x, event.y) then
			local jointDef = b2.createMouseJointDef(ground, self.ball2.body, event.x, event.y, 100000)
			mouseJoint = self.world:createJoint(jointDef)
		end
	end
	
	-- update the target of mouse joint on mouse move
	function self:onMouseMove(event)
		if mouseJoint ~= nil then
			mouseJoint:setTarget(event.x, event.y)
		end
	end
	
	-- destroy the mouse joint on mouse up
	function self:onMouseUp(event)
		if mouseJoint ~= nil then
			self.world:destroyJoint(mouseJoint)
			mouseJoint = nil
		end
	end

	-- register for mouse events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT + b2.DebugDraw.JOINT_BIT)
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

-- for creating objects using shape
-- as example - bounding walls
function gearJoint:wall(x, y, width, height)
	local wall = Shape.new()
	--define wall shape
	wall:beginPath()
	
	--we make use (0;0) as center of shape,
	--thus we have half of width and half of height in each direction
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
	
	--add to scene
	self:addChild(wall)
	
	--return created object
	return wall
end

-- for creating objects using image
-- as example - ball
function gearJoint:ball(x, y)
	--create ball bitmap object from ball graphic
	local ball = Bitmap.new(Texture.new("./ball.png"))
	--reference center of the ball for positioning
	ball:setAnchorPoint(0.5,0.5)
	
	ball:setPosition(x,y)
	
	--get radius
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
	
	--add to scene
	self:addChild(ball)
	
	--return created object
	return ball
end

--running the world
function gearJoint:onEnterFrame() 
	-- edit the step values if required. These are good defaults!
	self.world:step(1/60, 8, 3)
	--iterate through all child sprites
	for i = 1, self:getNumChildren() do
		--get specific sprite
		local sprite = self:getChildAt(i)
		-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body then
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			--apply rotation to sprite
			sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end
end

--removing event on exiting scene
--just in case you're using SceneManager
function gearJoint:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end