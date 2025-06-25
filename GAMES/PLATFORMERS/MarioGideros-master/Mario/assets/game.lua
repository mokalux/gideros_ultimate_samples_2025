Game = Core.class(Sprite)

function Game:init()
	self.map = TiledMap.new("maps/map01")
	self.hero = Hero.new()

	self.hero:setX(200)
	self.hero:setY(290)
	
	local font = Font.new("fonts/DroidSerif-Bold.txt", "fonts/DroidSerif-Bold.png")
	self.text = TextField.new(font, "Tap to start!")
	
	self.text:setX(260)
	self.text:setY(240)
	
	self:addChild(self.map)
	self:addChild(self.hero)
	self:addChild(self.text)

	self.frame = 0
	self.started = false
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_UP, self.onKeyUp, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	
	world:addEventListener(Event.PRE_SOLVE, self.onBeginContact, self)
	world:addEventListener(Event.END_CONTACT, self.onEndContact, self)	
end

function Game:onKeyDown(event)
	print("Game---event keydown", event.keyCode)
	self.hero.body:setActive(true)
	self.hero.body:setAwake(true)
	if not self.started then
		self.started = true	
		self:removeChild(self.text)
	end
	
	if event.keyCode == KeyCode.LEFT then
		self.hero.moving = true	
		self.hero.direction = false
	elseif event.keyCode == KeyCode.RIGHT then
		print("right")
		self.hero.moving = true	
		self.hero.direction = true
	end

end

function Game:onKeyUp(event)
print("game event keyup")
	--if not self.started then
		--self.started = true		
		self.hero.moving = false	
		--self:removeChild(self.text)
	--end
end

function Game:onEnterFrame()
	if self.started then
		if self.hero.moving then
			if self.hero.direction then
				self.map:move(-5, 0)
			else
				self.map:move(5, 0)
			end
			self.frame = 0
		end
		
		self.frame = self.frame + 1
		world:step(1.5/60, 8, 3)	
	end
end

function Game:onBeginContact(event)
	local bodyA = event.fixtureA:getBody()
	local bodyB = event.fixtureB:getBody()
	local ground = self.map:getObjectByName("Ground")
	self.hero.jumping = false
	if (bodyA == self.hero.body or bodyB == self.hero.body) and
		(bodyA == ground.body or bodyB == ground.body) then		
		--print("contact ground")
	else
		--self.hero.moving = false
		--print("contact other")	
	end		
end

function Game:onEndContact(event)
	local bodyA = event.fixtureA:getBody()
	local bodyB = event.fixtureB:getBody()
	local ground = self.map:getObjectByName("Ground")
	--self.hero.moving = false
	self.hero.jumping = true
	if (bodyA == self.hero.body or bodyB == self.hero.body) and
		(bodyA == ground.body or bodyB == ground.body) then		
		print("end contact ground", bodyB.tostring,  bodyA.tostring)
		self.hero.jumping = true
	else
		--self.hero.moving = false
		print("end contact other",  bodyB.tostring, bodyA.tostring)	
		
	end
end