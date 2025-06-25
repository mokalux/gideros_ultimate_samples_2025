ExplodingFruit = Core.class(Sprite)

function ExplodingFruit:init(scene,x,y)

	self.scene = scene
	self.x = x
	self.y = y
	self.value = 50
	
	-- set up atlas if not already created
	
	if(not(self.scene.fruitAtlas)) then
	
		self.scene.fruitAtlas = TexturePack.new("Atlases/Fruit.txt", "Atlases/Fruit.png",true)

	end

	
	local img = Bitmap.new(self.scene.fruitAtlas:getTextureRegion("exploding fruit.png"))
	img:setAnchorPoint(.5,.15)
	self:addChild(img)
	self.fruit = img
	self.fruit:setRotation(-6)
	img:setY(-35)
	
	self.scene.rube1:addChild(self)
	self.type = "exploding fruit"

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
		self.body:setLinearDamping(math.huge)

		local filterData = {categoryBits = 4096, maskBits = 8912}
		fixture:setFilterData(filterData)

	end)


		
	Timer.delayedCall(math.random(0,1000), self.addTweens, self)
	
	
	-- set up sounds
	
	if(not(self.scene.explosionSound)) then
	
		self.scene.explosionSound = Sound.new("Sounds/explosion.wav")

	end
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end




function ExplodingFruit:addTweens()

		local repeatNum = math.huge
		self.tween1 = GTween.new(self.fruit, 1, {rotation = 11},{reflect=true, repeatCount = repeatNum,ease = easing.inOutQuadratic})
		self.tween2 = GTween.new(self.fruit, .5, {scaleY = 1.05, scaleX = .98},{reflect=true, repeatCount = repeatNum, delay=0,ease = easing.inOutQuadratic})
		
end




function ExplodingFruit:collected()

	self.channel1 = self.scene.explosionSound:play(1)
	self.channel1:setVolume(.2*self.scene.soundVol)

	--self.angle = math.random(0,45)
	self.angle = 0

	for i=1,6 do
		
		Timer.delayedCall(10, self.addBullet, self)
	
	end

	self.body.destroyed = true
	Timer.delayedCall(10, function()
		self.scene.world:destroyBody(self.body) -- remove physics body
		self:getParent():removeChild(self)
	end)
	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300)

end




function ExplodingFruit:addBullet()

	local bullet = Bullet.new(self.scene,self.x,self.y,self.angle,nil,"exploding fruit")
	self.angle = self.angle + 60

end


function ExplodingFruit:pause()

end




function ExplodingFruit:resume()

end



-- cleanup function

function ExplodingFruit:exit()
	
	if(self.tween1) then
		self.tween1:setPaused(true)
		self.tween2:setPaused(true)
	end
	
end




