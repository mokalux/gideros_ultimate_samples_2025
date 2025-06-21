--include box2d library
require "box2d"

--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class
scene = gideros.class(Sprite)

--on scene initialization
function scene:init()
	--save starting point
	self.startpoint = {}
	--we will draw slingshot using Shape object
	self.slingshot = Shape.new()
	self:addChild(self.slingshot)
	
	--create world instance
	self.world = b2.World.new(0, 10, true)
	
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	--create bounding walls outside the scene
	self:wall(0,screenH/2,10,screenH)
	self:wall(screenW/2,0,screenW,10)
	self:wall(screenW,screenH/2,10,screenH)
	self:wall(screenW/2,screenH,screenW,10)
	
	--create ball
	self.ball = self:ball(100, 100)
	
	--create empty box2d body for joint
	--since mouse cursor is not a body
	--we need dummy body to create joint
	self.ground = self.world:createBody({})
	
	--joint with dummy body
	self.mouseJoint = nil

	-- register for mouse events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

-- create a starting point for slingshot
function scene:onMouseDown(event)
	if(self.ball:hitTestPoint(event.x, event.y)) then
		local jointDef = b2.createMouseJointDef(self.ground, self.ball.body, event.x, event.y, 100000)
		self.mouseJoint = self.world:createJoint(jointDef)
		--save starting point
		self.startpoint.x = event.x;
		self.startpoint.y = event.y;
	end	
end
	
-- update the representation of slingshot
function scene:onMouseMove(event)
	--check if slingshot is pulled up
	if self.mouseJoint ~= nil then
		self.mouseJoint:setTarget(event.x, event.y)
		--clear any previous slingshot
		self.slingshot:clear()
		--set styles
		self.slingshot:setLineStyle(5, 0xff0000, 1)
		--draw line
		self.slingshot:beginPath()
		self.slingshot:moveTo(self.startpoint.x, self.startpoint.y)
		self.slingshot:lineTo(event.x, event.y)
		self.slingshot:endPath()
	end
end
	
-- destroy the mouse joint on mouse up
function scene:onMouseUp(event)
	--check if slingshot is pulled up
	if self.mouseJoint ~= nil then
		self.world:destroyJoint(self.mouseJoint)
		self.mouseJoint = nil
		--clear slingshot respresentation
		self.slingshot:clear()
		--define strength of slingshot
		local strength = 1
		--calculate force vector based on strength 
		--and distance of pull
		local xVect = (self.startpoint.x-event.x)*strength
		local yVect = (self.startpoint.y-event.y)*strength
		--applye impulse to target
		self.ball.body:applyLinearImpulse(xVect, yVect, self.ball:getX(), self.ball:getY())
	end
end

-- for creating objects using shape
-- as example - bounding walls
function scene:wall(x, y, width, height)
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
function scene:ball(x, y)
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
function scene:onEnterFrame() 
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
function scene:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

--add created scene to stage or sceneManager
local mainScene = scene.new()
stage:addChild(mainScene)
