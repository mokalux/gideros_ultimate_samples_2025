BallPressurePlate = Core.class(Sprite)

function BallPressurePlate:init(scene,x,y,spawnEveryXSecs,id,hurtHero,linearDamping,restitution,angle,atlas,lifeSpan)

	self.atlas = atlas
	self.scene = scene
	self.id = id
	self.canPress = true
	self.numBallsOnScreen = 0
	self.lifeSpan = lifeSpan
	
	self.hurtHero = hurtHero
	self.linearDamping = linearDamping
	self.restitution = restitution

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("pressure plate button.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	img:setY(-5)
	self.button = img
	self.scene.layer0:addChild(self)
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("pressure plate skirt.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	img:setY(3)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x,y)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(25,5,0,-3,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor=true}
	
	


	local poly = b2.PolygonShape.new()
	poly:set(-32,10,-29,-4,34,-5,37,8)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}

	fixture.name = "pressure plate"
	fixture.parent = self
	self.body = body
	self.body:setLinearDamping(math.huge)

	local filterData = {categoryBits = 256, maskBits = 1}
	fixture:setFilterData(filterData)
	body.name = "Ground"
	
	Timer.delayedCall(10, self.disableSpawner, self) -- need to stop spawner doing auto spawn
	
	-- sounds
	
	self.volume = .5
		
	if(not(self.scene.pressurePlateSound)) then
	
		self.scene.pressurePlateSound = Sound.new("Sounds/pressure plate.wav")
		self.scene.pressurePlateSound2 = Sound.new("Sounds/pressure plate 2.wav")
		
	end

end



function BallPressurePlate:disableSpawner()

	--print(self.scene.idList[50])
	self.scene.idList[self.id].stopped = true


end




function BallPressurePlate:press()

	if(self.canPress) then
	
		local channel = self.scene.pressurePlateSound:play()
		channel:setVolume(self.volume*self.scene.soundVol)
	
		self.canPress = false
		
		if(self.numBallsOnScreen < 20) then
			self.numBallsOnScreen = self.numBallsOnScreen +1
			Timer.delayedCall(100, self.spawnBall, self)
		end
	end

end




function BallPressurePlate:spawnBall()


	self.button:setY(self.button:getY()+7)
	local startX,startY = self.scene.idList[self.id]:getPosition()

	local ball = Ball.new(self.scene,startX,startY,self.hurtHero,self.linearDamping,self.restitution,self.atlas,self.lifeSpan)

	self.scene.rube1:addChild(ball)

end



function BallPressurePlate:depress()


	local channel = self.scene.pressurePlateSound2:play()
	channel:setVolume(self.volume*self.scene.soundVol)

	local tween = GTween.new(self.button, 1, {y = -7})
	
	Timer.delayedCall(1000, function() self.canPress = true end)

end
