--include box2d library
require "box2d"

--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class
scene = gideros.class(Sprite)

--on scene initialization
function scene:init()
	--create world instance
	self.world = b2.World.new(0, 10, true)

	local dodebug = false -- true, false

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
	local ground = self.world:createBody({})
	
	--joint with dummy body
	local mouseJoint = nil

	-- create a mouse joint on mouse down
	function self:onMouseDown(event)
		if self.ball:hitTestPoint(event.x, event.y) then
			--stop our animation
			self.ball:stopAnimation()
			local jointDef = b2.createMouseJointDef(ground, self.ball.body, event.x, event.y, 100000)
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
			--resume animation by simply switching it
			self.ball:switchAnimation()
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
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)

	if dodebug then
		local debugDraw = b2.DebugDraw.new()
		debugDraw:setFlags(
			b2.DebugDraw.SHAPE_BIT
			+ b2.DebugDraw.JOINT_BIT
			+ b2.DebugDraw.AABB_BIT
			+ b2.DebugDraw.PAIR_BIT
			+ b2.DebugDraw.CENTER_OF_MASS_BIT
		)
		self.world:setDebugDraw(debugDraw)
		self:addChild(debugDraw)
	end
end

--define begin collision event handler function
function scene:onBeginContact(e)
	--getting contact bodies
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	--check if first colliding body is a ball
	if bodyB.type and bodyB.type == "ball" then
		--switch animation using our created function
		bodyB.object:switchAnimation()
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
	--of course it all can be done through loops or other abstractions
	--but for the sake of demonstration, I'll doo all images one by one
	
	--get eyses animation images
	local eyes1 = Bitmap.new(Texture.new("animation/eyes1.png"))
	local eyes2 = Bitmap.new(Texture.new("animation/eyes2.png"))
	local eyes3 = Bitmap.new(Texture.new("animation/eyes3.png"))
	local eyes4 = Bitmap.new(Texture.new("animation/eyes4.png"))
	local eyes5 = Bitmap.new(Texture.new("animation/eyes5.png"))
	local eyes6 = Bitmap.new(Texture.new("animation/eyes6.png"))
	--get smile animation images
	local smile0 = Bitmap.new(Texture.new("animation/smile0.png"))
	local smile1 = Bitmap.new(Texture.new("animation/smile1.png"))
	local smile2 = Bitmap.new(Texture.new("animation/smile2.png"))
	local smile3 = Bitmap.new(Texture.new("animation/smile3.png"))
	local smile4 = Bitmap.new(Texture.new("animation/smile4.png"))
	
	--setting anchor points
	eyes1:setAnchorPoint(0.5, 0.5)
	eyes2:setAnchorPoint(0.5, 0.5)
	eyes3:setAnchorPoint(0.5, 0.5)
	eyes4:setAnchorPoint(0.5, 0.5)
	eyes5:setAnchorPoint(0.5, 0.5)
	eyes6:setAnchorPoint(0.5, 0.5)
	smile0:setAnchorPoint(0.5, 0.5)
	smile1:setAnchorPoint(0.5, 0.5)
	smile2:setAnchorPoint(0.5, 0.5)
	smile3:setAnchorPoint(0.5, 0.5)
	smile4:setAnchorPoint(0.5, 0.5)
	
	--creating movieclip
	local ball = MovieClip.new{
		{1, 10, eyes1}, 
		{11, 20, eyes2}, 
		{21, 30, eyes3}, 
		{31, 40, eyes4}, 
		{41, 50, eyes5}, 
		{51, 60, eyes6}, 
		{61, 70, smile0}, 
		{71, 80, smile1}, 
		{81, 90, smile2}, 
		{91, 100, smile3}, 
		{101, 110, smile4}
	}
	
	--set looping of first animation
	ball:setGotoAction(60, 1)
	
	--set looping of second animation
	ball:setGotoAction(110, 61)
	
	--goto first image and play
	ball:gotoAndPlay(1)
	
	--mark that first animation is playing
	ball.firstAnimation = true
	
	--function to switch animations
	function ball:switchAnimation()
		if self.firstAnimation then
			--play second animation
			--which starts from frame 61
			self:gotoAndPlay(61)
		else
			--play first animation
			self:gotoAndPlay(1)
		end
		
		--change mark of current animation
		self.firstAnimation = not self.firstAnimation
	end
	
	--example of stopping animation on specific frame
	--in this case frame number 81
	function ball:stopAnimation()
		self:gotoAndStop(81)
	end
	
	--set position
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
	--reference to movieclip object
	body.object = ball
	--reference to box2d body
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
