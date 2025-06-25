level = gideros.class(Sprite)

function level:wall(x, y, width, height)
	local wall = Shape.new()
	wall:beginPath()
	wall:moveTo(x,y)
	wall:lineTo(x + width, y)
	wall:lineTo(x + width, y + height)
	wall:lineTo(x, y + height)
	wall:lineTo(x, y)
	wall:endPath()
	wall:setPosition(x,y)
	physicsAddBody(world, wall, {type = "static", density = 1.0, friction = 0.1, bounce = 0.2})
	wall.body.type = "wall"
	return wall
end

function level:init()
	self.controller = Controller.new(self)
	
	self.bottomBg = Bitmap.new(Texture.new("images/bottom_bg.png", true))
	self.bottomBg:setPosition(0, conf.screenHeight - self.bottomBg:getHeight())
	
	self.hpBar = Shape.new()
	self.hpBar:clear()
	self.hpBar:beginPath()
	self.hpBar:setFillStyle(Shape.SOLID, 0xff0000)
	self.hpBar:setLineStyle(1, 0xff0000)
	self.hpBar:beginPath()
	self.hpBar:moveTo(0, 0)
	self.hpBar:lineTo(100, 0)
	self.hpBar:lineTo(100, 200)
	self.hpBar:lineTo(0, 200)
	self.hpBar:lineTo(0,0)
	self.hpBar:endPath()
	self.hpBar:setPosition(50, conf.screenHeight - self.hpBar:getHeight() / 2 - self.bottomBg:getHeight() / 2)
	
	self.hpBorder = Shape.new()
	self.hpBorder:clear()
	self.hpBorder:beginPath()
	self.hpBorder:setFillStyle(Shape.NONE)
	self.hpBorder:setLineStyle(5, 0x000000)
	self.hpBorder:beginPath()
	self.hpBorder:moveTo(0, 0)
	self.hpBorder:lineTo(100, 0)
	self.hpBorder:lineTo(100, 200)
	self.hpBorder:lineTo(0, 200)
	self.hpBorder:lineTo(0,0)
	self.hpBorder:endPath()
	self.hpBorder:setPosition(50, conf.screenHeight - self.hpBorder:getHeight() / 2 - self.bottomBg:getHeight() / 2)
	
	world:setGravity(0, 0)
	self:addEventListener("enterBegin", self.onEnterBegin, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	
	self:addChild(self:wall(0,0,10,application:getContentHeight()))
	self:addChild(self:wall(0,0,application:getContentWidth(),10))
	self:addChild(self:wall(application:getContentWidth()-10,0,10,application:getContentHeight()))
	self:addChild(self:wall(0,application:getContentHeight()-10,application:getContentWidth(),10))
end

function level:getControl()
	return self.control
end

function level:load(number)
	-- create map
	local mapData = require("level_map/level_map_" .. number)
	self.map = Map.new(mapData)
	self:addChild(self.map)
	
	--- create pools
	-- obstacle pool
	self.obstaclespools = {}
	local obstacles = mapData["obstacles"]
	for i = 1, #obstacles do
		self.obstaclespools[i] = ObstaclePool.new(obstacles[i]["image"],3)
		self:addChild(self.obstaclespools[i])
	end
	
	-- projectile pool
	self.projectilespools = {}
	self.pistols = {}
	local projectiles = mapData["projectiles"]
	for i = 1, #projectiles do
		self.projectilespools[i] = ProjectilePool.new(
			projectiles[i]["image"],
			20,
			Map.speed)
		self:addChild(self.projectilespools[i])
		self.pistols[i] = PistolGun.new(
			self.projectilespools[i],
			projectiles[i]["projectilespeed"],
			projectiles[i]["distance"])
	end
	
	-- police pool
	self.policepools = {}
	local polices = mapData["objects"]
	for i = 1, #projectiles do
		self.policepools[i] = PolicePool.new(
			polices[i]["image"][1],
			polices[i]["image"][2],
			polices[i]["sound"],
			8
			)
		self.policepools[i]:setGun(self.pistols[polices[i]["weapon"]])
		self:addChild(self.policepools[i])
	end
	
	-- add spawn listener
	self.map:addEventListener(Map.EVENT_SPAWN_OBJECT, 
		function(event)
			self.policepools[event.id]:make(event.Xpos,event.firerate,Map.speed)
		end
	)
	self.map:addEventListener(Map.EVENT_SPAWN_OBSTACLE, 
		function(event)
			self.obstaclespools[event.id]:make(event.Xpos,event.direction,Map.speed)
		end
	)
	
end

--removing event
function level:onEnterFrame() 
	world:step(1/60, 8, 3)
	if CONTROLLER_TYPE == 1 then
		self.controller:moveByAnalog()
	elseif CONTROLLER_TYPE == 2 then
		self.controller:moveByAccelerator()
	end
	local xPos, yPos = player.body:getPosition()
	
	if player:getHealth() == 0 then
		sceneManager:changeScene("help", 7.5, transition, easing.outBack)
	end
	
	self.hpBar:setScaleY(player:getHealth() / NICK_MAXHEALTH)
	self.hpBar:setPosition(50,
		conf.screenHeight - self.bottomBg:getHeight() / 2 - player:getHealth() * 2 + 100)
	
	player:checkPosition()
	player:setPosition(player.body:getPosition())
	
	--- update all objects
	self.map:update()
	
	-- update all projectiles
	for i = 1, #self.projectilespools do
		self.projectilespools[i]:update()
	end
	
	-- update all polices
	for i = 1, #self.policepools do
		self.policepools[i]:update(player:getX(), player:getY())
	end
	
	-- update all obstacles
	for i = 1, #self.obstaclespools do
		self.obstaclespools[i]:update()
	end
end

function level:onEnterBegin()
	print("enterrrrrrrr")
	self:load(LEVEL_DIFFICULTY)
	
	player:reset()
	
	self:addChild(player)
	self:addChild(self.bottomBg)
	self:addChild(self.hpBar)
	self:addChild(self.hpBorder)
	
	if CONTROLLER_TYPE == 1 then
		self.controllerBg = Bitmap.new(Texture.new("images/controller_bg.png", true))
		self.controllerBg:setAnchorPoint(0.5, 0.5)
		self.controllerBg:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
		self:addChild(self.controllerBg)
		
		self.control = Bitmap.new(Texture.new("images/controller.png", true))
		self.control:setAnchorPoint(0.5, 0.5)
		self.control:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
		self:addChild(self.control)
		
		self.deltaMaxController = math.pow(((self.controllerBg:getWidth() - self.control:getWidth())) / 2, 2)
	end
	
	self.controller:attachController(CONTROLLER_TYPE)
	world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	--debug drawing
	--local debugDraw = b2.DebugDraw.new()
	--world:setDebugDraw(debugDraw)
	--self:addChild(debugDraw)
end

function level:onExitBegin()
	print("exiiiiiit")
	self:poolsReset()
	world:removeEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function level:poolsReset()
	-- reset all projectiles
	for i = 1, #self.projectilespools do
		self.projectilespools[i]:reset()
	end
	
	-- reset all polices
	for i = 1, #self.policepools do
		self.policepools[i]:reset()
	end
	
	-- reset all obstacles
	for i = 1, #self.obstaclespools do
		self.obstaclespools[i]:reset()
	end
end

function level:moveControl(x, y)
	local xPos, yPos = self.controllerBg:getPosition()
	local delta = math.pow(x - xPos, 2) + math.pow(y - yPos, 2)
	local sin = (y - yPos) / math.sqrt(math.pow(x - xPos, 2) + math.pow(y - yPos, 2))
	local cos = (x - xPos) / math.sqrt(math.pow(x - xPos, 2) + math.pow(y - yPos, 2))
	
	if delta < self.deltaMaxController then
		xPos = x
		yPos = y
	else
		xPos = xPos + math.sqrt(self.deltaMaxController) * cos
		yPos = yPos + math.sqrt(self.deltaMaxController) * sin
	end
	
	self.control:setPosition(xPos, yPos)
	self.controller:movePlayer(player.MAX_SPEED * cos, player.MAX_SPEED * sin)
end

function level:onBeginContact(e)
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if (bodyA.type == "Nick" and bodyB.type == "Police") or (bodyA.type == "Police" and bodyB.type == "Nick") then
		sceneManager:changeScene("start", 3, transition, easing.outBack)
	elseif (bodyA.type == "Nick" and bodyB.type == "Projectile") or (bodyA.type == "Projectile" and bodyB.type == "Nick") then
		sounds.play("grunt")
		player:setHealth(player:getHealth() - 10 + player:getDefense())
	elseif (bodyA.type == "Nick" and bodyB.type == "Obstacle.images/police_line.png") or (bodyA.type == "Obstacle.images/police_line.png" and bodyB.type == "Nick") then
		sounds.play("complete")
		sceneManager:changeScene("help", 3, transition, easing.outBack)
	end
end

function level:resetControl()
	self.control:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
end