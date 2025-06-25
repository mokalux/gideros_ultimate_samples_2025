require "box2d"

Box2d = Core.class(Sprite)

function Box2d:init(scene,debug)



-- temp
self.num = 0

	-- Show all collision detect messages
	--local printCollisions = true;

	-- Store the scene in this instance's table
	self.scene = scene;

	--create world instance
	self.scene.world = b2.World.new(0, 20, true)
	
	if debug then
		
		--set up debug drawing
		local debugDraw = b2.DebugDraw.new()
		self.scene.world:setDebugDraw(debugDraw)
		self:addChild(debugDraw)
		
	end
	
	local function onBeginContact(event)
		-- you can get the fixtures and bodies in this contact like:
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()
		
		if(printCollisions) then
			print("begin contact: ", bodyA.name, "<->", bodyB.name)
		end
		if bodyA.type == "Collectable" then print(bodyA.score, "POINTS!!!") end
		if bodyA.type == "Nasty" then print("OUCH!!!") end
		if bodyA.name == "bottom" then print("Rock Bottom!!!") end
		
		-- Hero hit ground
		
		if bodyA.name == "Hero" and bodyB.name == "Ground" and not self.scene.hero.onGround then
		
			print("Hero hit ground") end
			self.scene.hero.onGround = true;
		
		
		
	end

	local function onEndContact(event)
		-- you can get the fixtures and bodies in this contact like:
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()
		
		if(printCollisions) then
			print("end contact: ", bodyA.name, "<->", bodyB.name)
		end
	end

	local function onPreSolve(event)
		-- you can get the fixtures and bodies in this contact like:
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()
		
		if(printCollisions) then
			print("pre solve: ", bodyA.name, "<->", bodyB.name)
		end
	end

	local function onPostSolve(event)
		-- you can get the fixtures and bodies in this contact like:
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()

		if(printCollisions) then
			print("post solve: ", bodyA.name, "<->", bodyB.name)
		end
	end

	-- register 4 physics events with the world object
	self.scene.world:addEventListener(Event.BEGIN_CONTACT, onBeginContact)
	--self.world:addEventListener(Event.END_CONTACT, onEndContact)
	--self.world:addEventListener(Event.PRE_SOLVE, onPreSolve)
	--self.world:addEventListener(Event.POST_SOLVE, onPostSolve)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
	
end

-- for creating objects using shape
-- as example - bounding walls
function Box2d:object(x, y, width, height, name, type, score)
	
	local object = Shape.new()
	
	--define object shape
	object:beginPath()
	
	--we make use (0, 0) as center of shape,
	--thus we have half of width and half of height in each direction
	object:moveTo(-width/2, -height/2)
	object:lineTo(width/2, -height/2)
	object:lineTo(width/2, height/2)
	object:lineTo(-width/2, height/2)
	object:closePath()
	object:endPath()
	object:setPosition(x,y)
	
	--create box2d physical object
	local body = self.scene.world:createBody{type = b2.STATIC_BODY}
	
	body:setPosition(object:getX(), object:getY())
	body:setAngle(object:getRotation() * math.pi/180)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(object:getWidth()/2, object:getHeight()/2)
	
	local fixture = body:createFixture{shape = poly, density = 1.0, friction = 0, restitution = .3}
	
	object.body = body
	object.body.name = name
	object.body.type = type
	object.body.score = score
	
	--add to scene
	self.scene.physicsLayer:addChild(object)
	
	--return created object
	return object
	
end

-- for creating objects using image
-- as example - ball
function Box2d:ball(x, y)

	--create ball bitmap object from ball graphic
	local ball = Bitmap.new(Texture.new("./ball.png"))
	
	--reference center of the ball for positioning
	ball:setAnchorPoint(0.5, 0.5)
	
	ball:setPosition(x,y)
	
	--get radius
	local radius = ball:getWidth()/2
	
	--create box2d physical object
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY}
	
	body:setPosition(ball:getX(), ball:getY())
	body:setAngle(ball:getRotation() * math.pi/180)
	
	local circle = b2.CircleShape.new(0, 0, radius)
	
	local fixture = body:createFixture{shape = circle, density = 1.0, friction = 0, restitution = .3}
	
	ball.body = body
	ball.body.type = "ball"
	ball.body.name = "ball"
	
	--add to scene
	self:addChild(ball)
	
	
	--return created object
	return ball
	
end




function Box2d:onEnterFrame() 

-- edit the step values if required. These are good defaults!
self.scene.world:step(1/60, 8, 3)

--print("#self.scene.spritesOnScreen: ", #self.scene.spritesOnScreen)

for i,v in pairs(self.scene.spritesOnScreen) do

	local sprite = v;

	local body = sprite.body
	
		if(not body.destroyed) then

			local bodyX, bodyY = body:getPosition()
			sprite:setPosition(bodyX, bodyY)
			sprite:setRotation(body:getAngle() * 180 / math.pi)
		else
			-- the body has been removed, we dont need this sprite in the table any more
			table.remove(spritesOnScreen,i)
		end

	end

end




















--removing event on exiting scene
--just in case you're using SceneManager
function Box2d:onExitBegin()

  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
  
end
