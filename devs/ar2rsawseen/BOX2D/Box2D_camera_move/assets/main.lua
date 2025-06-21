--include box2d library
require "box2d"

--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class
scene = gideros.class(Sprite)

function scene:init()
	--set up background to see it's moving
	local bg = Bitmap.new(Texture.new("Background.jpg", true))
	bg:setPosition(0,0)
	self:addChild(bg)
	
	--create world instance
	self.world = b2.World.new(0, 10, true)
	
	--get screen dimensions
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	
	--set world dimensions 
	--x2 for this example
	self.worldW = screenW*2
	self.worldH = screenH*2
	
	--create bounding walls to surround world
	--and not screen
	self:wall(0,self.worldH/2,10,self.worldH/2*2)
	self:wall(self.worldW/2,0,self.worldW,10)
	self:wall(self.worldW,self.worldH/2,10,self.worldH)
	self:wall(self.worldW/2,self.worldH,self.worldW,10)
	
	--create and store refrence to ball
	self.ball = self:ball(100, 100)
	
	-- create a mouse joint on mouse down
	function self:onMouseDown(event)
		if self:hitTestPoint(event.x, event.y) then
			local x, y = self.ball:getPosition()
			local xVect = (math.random(0,200)-100)*100
			local yVect = (math.random(0,200)-100)*100
			self.ball.body:applyForce(xVect, yVect, x, y)
		end
	end
	
	-- register for mouse events
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
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
	--get screen dimensions
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	
	--define offsets
	local offsetX = 0;
	local offsetY = 0;
	
	--check if we are not too close to left or right wall
	--so we won't go further that wall
	if((self.worldW - self.ball:getX()) < screenW/2) then
		offsetX = -self.worldW + screenW 
	elseif(self.ball:getX() >= screenW/2) then
		offsetX = -(self.ball:getX() - screenW/2)
	end
	
	--apply offset so scene
	self:setX(offsetX)
	
	--check if we are not too close to upper or bottom wall
	--so we won't go further that wall
	if((self.worldH - self.ball:getY()) < screenH/2) then
		offsetY = -self.worldH + screenH 
	elseif(self.ball:getY()>= screenH/2) then
		offsetY = -(self.ball:getY() - screenH/2)
	end
	
	--apply offset so scene
	self:setY(offsetY)
	
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
