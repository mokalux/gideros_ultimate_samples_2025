SwapFruit = Core.class(Sprite)

function SwapFruit:init(scene,x,y,speed)

	self.scene = scene
	self.tweens = {}
	
	-- set up atlas if not already created
	
	if(not(self.scene.fruitAtlas)) then
	
		self.scene.fruitAtlas = TexturePack.new("Atlases/Fruit.txt", "Atlases/Fruit.png",true)

	end
	
	-- Set up anim loader
	
	if(not(self.scene.fruitAnimLoader)) then
	
		local animLoader = CTNTAnimatorLoader.new()
		animLoader:loadAnimations("Animations/Fruit.tan", self.scene.fruitAtlas, true)
		self.scene.fruitAnimLoader = animLoader

	end
	

	

	-- make holder sprite than will rotate
	
	local sprite = Sprite.new()
	self:addChild(sprite)
	self.spriteHandle = sprite
	self.spriteHandle:setY(-30)
	self.spriteHandle:setRotation(-6)
	
	local sprite = Sprite.new()
	self.spriteHandle:addChild(sprite)
	self.spriteAnim = sprite
	self.spriteAnim:setY(40)
	
	local anim = CTNTAnimator.new(self.scene.fruitAnimLoader)
	anim:setAnimation("SWAP_FRUIT_NORMAL")
	anim:playAnimation()
	anim:addToParent(self.spriteAnim)
	self.anim = anim
	
	self.status = "happy"
	
	self.scene.rube1:addChild(self)
	
	-- add timer to 'swap'

	local timer = Timer.new(speed*3000, math.huge)
	
	timer:addEventListener(Event.TIMER, self.swap, self)
	timer:start()
	self.timer = timer

	-- Add physics

		local body = self.scene.world:createBody{type = b2.STATIC_BODY, allowSleep = true}
		Timer.delayedCall(1, function()
		body:setPosition(x,y)

		local circle = b2.CircleShape.new(0,3,15)
		local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
		
		fixture.name = "loot"
		self.fixture = fixture
		fixture.parent = self
		self.body = body
		self.body:setLinearDamping(math.huge)

		local filterData = {categoryBits = 4096, maskBits = 8912}
		fixture:setFilterData(filterData)

	end)


	Timer.delayedCall(math.random(0,1000), self.addTweens, self)

	self:makeSafe()
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
end





function SwapFruit:addTweens()

	local tween = GTween.new(self.spriteHandle, 1, {rotation = 6},{reflect=true, repeatCount = math.huge,ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	local tween = GTween.new(self.spriteHandle, .5, {scaleY = 1.05, scaleX = .98},{reflect=true, repeatCount = math.huge, delay=0,ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
		
end




function SwapFruit:swap()

	if(self.status=="happy") then
		self.status = "sad"
		self.anim:setAnimation("SWAP_FRUIT_DECAY")
		self.anim:playAnimation()
		Timer.delayedCall(200, self.makeDangerous, self)

		
	elseif(self.status=="sad") then
		self.type = "happyFruit"
		self.status = "happy"
		self.anim:setAnimation("SWAP_FRUIT_UNDECAY")
		self.anim:playAnimation()
		Timer.delayedCall(200, self.makeSafe, self)
	end
	
end





function SwapFruit:makeSafe()

	self.type = "happy fruit"
	self.value = 40

end



function SwapFruit:makeDangerous()
	
	self.type = "sad fruit"
	self.value = 0

end





function SwapFruit:collected()

	self.timer:stop()
	self.body.destroyed = true
	Timer.delayedCall(10, function()
		self.scene.world:destroyBody(self.body) -- remove physics body
		self:getParent():removeChild(self)
	end)
	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300)

end



function SwapFruit:pause()

end




function SwapFruit:resume()

end


-- cleanup function

function SwapFruit:exit()

		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
	self.timer:stop()
	
end
