--include box2d library
require "box2d"

--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class
scene = gideros.class(Sprite)

--on scene initialization
function scene:init()
	--create world instance
	self.world = b2.World.new(0, 10, true)
	
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	--create bounding walls outside the scene
	self:wall(0,screenH/2,10,screenH)
	self:wall(screenW/2,0,screenW,10)
	self:wall(screenW,screenH/2,10,screenH)
	self:wall(screenW/2,screenH,screenW,10)
	
	--create Lshape
	local Lshape = self:Lshape(100, 100)
	
	--create empty box2d body for joint
	--since mouse cursor is not a body
	--we need dummy body to create joint
	local ground = self.world:createBody({})
	
	--joint with dummy body
	local mouseJoint = nil

	-- create a mouse joint on mouse down
	function self:onMouseDown(event)
		if self:hitTestPoint(event.x, event.y) then
			local jointDef = b2.createMouseJointDef(ground, Lshape.body, event.x, event.y, 100000)
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
	
	--add collision event listener
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

--define collision event handler function
function scene:onBeginContact(e)
	--getting contact bodies
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	--check if second colliding body is a Lshape
	--it should be second, because it was created last
	if bodyB.type and bodyB.type == "Lshape" and not bodyB.destroyed then
		--creating timer to delay changing world
		--because by default you can't change world settings 
		--in event callback function
		--delay 1 milisecond for 1 time
		bodyB.destroyed = true
		local timer = Timer.new(1, 1)
		--setting timer callback
		timer:addEventListener(Event.TIMER, function()
			--destroy one fixture for L shape body
			bodyB:destroyFixture(bodyB.fixture2)
			--and now we need to redraw the shape
			--to match fixture that is left
			bodyB.shape:clear()
			bodyB.shape:setFillStyle(Shape.SOLID, 0x0000ff)
			bodyB.shape:beginPath()
			bodyB.shape:moveTo(bodyB.shape.size, -bodyB.shape.size*2)
			bodyB.shape:lineTo(bodyB.shape.size,bodyB.shape.size*2)
			bodyB.shape:lineTo(bodyB.shape.size*2, bodyB.shape.size*2)
			bodyB.shape:lineTo(bodyB.shape.size*2, -bodyB.shape.size*2)
			bodyB.shape:lineTo(bodyB.shape.size, -bodyB.shape.size*2)
			bodyB.shape:endPath()
			
			--create new box2d physical object
			--with same position, etc as L shape was
			local body = self.world:createBody{type = b2.DYNAMIC_BODY}
			--copy existing body's position, etc
			local x, y = bodyB:getPosition()
			body:setPosition(x,y)
			body:setAngle(bodyB:getAngle())
			--add fixture from saved definition
			body:createFixture(bodyB.fixDef)
			
			--create new shape to represent new box2d object
			local shape = Shape.new()
			shape:setFillStyle(Shape.SOLID, 0x0000ff)
			shape:beginPath()
			shape:moveTo(bodyB.shape.size, -bodyB.shape.size)
			shape:lineTo(bodyB.shape.size,-bodyB.shape.size*2)
			shape:lineTo(-bodyB.shape.size*2,-bodyB.shape.size*2)
			shape:lineTo(-bodyB.shape.size*2,-bodyB.shape.size)
			shape:lineTo(bodyB.shape.size,-bodyB.shape.size)
			shape:endPath()
			
			--save reference to new body
			shape.body = body
			
			--add dnew shape to scene
			self:addChild(shape)
		end, self)
		--start timer
		timer:start()
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

-- creating complex objects
-- using multiple fixtures
function scene:Lshape(x, y)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0x0000ff)
	
	--just a reference size of one square for drawing
	shape.size = 30
	
	--let's create L shape
	shape:beginPath()
	shape:moveTo(shape.size, -shape.size)
	shape:lineTo(shape.size,shape.size*2)
	shape:lineTo(shape.size*2, shape.size*2)
	shape:lineTo(shape.size*2, -shape.size*2)
	shape:lineTo(-shape.size*2, -shape.size*2)
	shape:lineTo(-shape.size*2, -shape.size)
	shape:lineTo(-shape.size, -shape.size)
	shape:lineTo(shape.size, -shape.size)
	shape:endPath()
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(x, y)
	body:setAngle(shape:getRotation() * math.pi/180)
	
	--create first shape
	local poly = b2.PolygonShape.new()
	poly:setAsBox(shape.size/2, shape.size*2, shape.size*1.5, 0, 0)
	local fixture = body:createFixture{shape = poly, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	
	--create second shape
	local poly = b2.PolygonShape.new()
	poly:setAsBox(shape.size*1.5, shape.size/2, 
		-shape.size/2, -shape.size*1.5, 0)
	
	--save fixture definition for later use
	local fixtureDef = {shape = poly, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	body.fixDef = fixtureDef
	
	local fixture = body:createFixture(fixtureDef)
	--save reference to fixture so we can destroy it
	body.fixture2 = fixture
	
	--is body destroyed
	--so we won't attempt to destroy this body again
	body.destroyed = false
	
	--save reference to shape object
	body.shape = shape
	
	--and as usuallu reference to body
	shape.body = body
	shape.body.type = "Lshape"
	
	--add to scene
	self:addChild(shape)
	
	--return created object
	return shape
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
