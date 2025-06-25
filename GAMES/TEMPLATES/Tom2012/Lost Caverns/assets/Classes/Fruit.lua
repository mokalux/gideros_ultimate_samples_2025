Fruit = Core.class(Sprite)

function Fruit:init(scene,x,y)

	self.scene = scene
	
	-- set up atlas if not already created
	
	if(not(self.scene.fruitAtlas)) then
	
		self.scene.fruitAtlas = TexturePack.new("Atlases/Fruit.txt", "Atlases/Fruit.png",true)

	end
	
	local img = Bitmap.new(self.scene.fruitAtlas:getTextureRegion("plain fruit.png"))
	img:setAnchorPoint(.5,.15)
	self:addChild(img)
	self.fruit = img
	self.fruit:setRotation(-6)
	img:setY(-35)
	self.value = 40
	
	self.scene.rube1:addChild(self)
	self.type = "plain fruit"

	-- Add physics

	Timer.delayedCall(1, function()
		local body = self.scene.world:createBody{type = b2.STATIC_BODY, allowSleep = true}
		body:setPosition(x,y)

		local circle = b2.CircleShape.new(0,3,15)
		local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
		
		fixture.name = "loot"
		self.fixture = fixture
		fixture.parent = self
		self.body = body
		body:setGravityScale(0)

		local filterData = {categoryBits = 4096, maskBits = 8912}
		fixture:setFilterData(filterData)

	end)
	
	Timer.delayedCall(math.random(0,1000), self.addTweens, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end





function Fruit:addTweens()

	local repeatNum = math.huge
	self.tween1 = GTween.new(self.fruit, 1, {rotation = 11},{reflect=true, repeatCount = repeatNum,ease = easing.inOutQuadratic})
	self.tween2 = GTween.new(self.fruit, .5, {scaleY = 1.05, scaleX = .98},{reflect=true, repeatCount = repeatNum, delay=0,ease = easing.inOutQuadratic})
		
end





function Fruit:collected()

	self.body.destroyed = true
	Timer.delayedCall(10, function()
		self.scene.world:destroyBody(self.body) -- remove physics body
		self:getParent():removeChild(self)
	end)
	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(0)

end




function Fruit:pause()

end




function Fruit:resume()

end


-- cleanup function

function Fruit:exit()

	self.tween1:setPaused(true)
	self.tween2:setPaused(true)
	
end




