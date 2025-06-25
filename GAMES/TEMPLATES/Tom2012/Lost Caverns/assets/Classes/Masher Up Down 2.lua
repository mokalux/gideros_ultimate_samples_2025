MasherUpDown2 = Core.class(Sprite)

function MasherUpDown2:init(scene,x,y,speed,atlas,flip)

self.num = math.random(1,9999999)

	self.speed = speed
	self.scene = scene
	self.atlas = atlas
	self.tweens = {}

	
	-- make the moving spikes

	self:addSpike(-120,60,-105)
	self:addSpike(-110,-70,-75)
	self:addSpike(-20,-175,-35)
	self:addSpike(-35,175,210)
	self:addSpike(100,210,180)
	self:addSpike(115,-200,0)

-- now add main bit
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("masher up down 2.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.layer0:addChild(self)
	self.img = img
	--img:setAlpha(.4)

	self.scene.layer0:addChild(self)
	--self.img = img
	
	-- cogs (x,y,rotation,scale,time)

	self:addCog(40,-70,1,.7,5)
	self:addCog(66,45,-1,.5,14)
	self:addCog(0,0,1,1,20)
	self:addCog(30,80,-1,.3,14)


	
	-- Masher body

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	if(flip) then
		bodyX = -90
	else
		bodyX = 90
	end
	
	shape = b2.CircleShape.new(bodyX,0,240)
	local fixture = body:createFixture{shape = shape, density = 999999, friction = 0, restitution = 0, isSensor =true}

	fixture.parentSprite = self
	fixture.name = "enemy"
	body:setGravityScale(0)
	body:setLinearVelocity(0,speed)
	body.name = "masherUpDown2"
	body.parent = self
	
	self.body = body

	local filterData = {categoryBits = 128, maskBits = 2+8}
	fixture:setFilterData(filterData)

	table.insert(self.scene.spritesOnScreen, self)
	
	
	
	-- sounds

	self.maxVolume = .2
	self.volume = 0
		
	if(not(self.scene.masherMoveSound)) then
	
		self.scene.masherMoveSound = Sound.new("Sounds/masher move.wav")
		self.scene.masherHitSound = Sound.new("Sounds/masher hit.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.masherMoveSound:play(0,math.huge)
	self.channel1:setVolume(self.volume*self.scene.soundVol)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end





function MasherUpDown2:addSpike(x,y,rotation)

	local sprite = Sprite.new()
	self:addChild(sprite)
	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("knives 1.png"));
	img:setAnchorPoint(.5,.5)
	sprite:addChild(img)
	img:setPosition(0,13)
	local tween = GTween.new(img, .5, {y = 0},{ease=easing.inBounce, reflect = true, repeatCount = math.huge})
	table.insert(self.tweens, tween)

	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("knives 2.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(-15,13)
	sprite:addChild(img)
	local tween = GTween.new(img, .5, {y = 0},{ease=easing.inBounce, delay=.5,reflect = true, repeatCount = math.huge})
	table.insert(self.tweens, tween)
	
	sprite:setRotation(rotation)
	sprite:setPosition(x,y)

end




function MasherUpDown2:addCog(x,y,rotation,scale,time)

	local sprite = Sprite.new()
	self:addChild(sprite)
	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("cog shadow.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(-5,5)
	sprite:addChild(img)
	
	if(rotation==1) then
		self.tween = GTween.new(img, time, {rotation = 0+360},{repeatCount = math.huge})
		table.insert(self.tweens, self.tween)
		
	else
		self.tween = GTween.new(img, time, {rotation = 0-360},{repeatCount = math.huge})
		table.insert(self.tweens, self.tween)
	end
	img:setAlpha(.6)
	

	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("cog.png"))
	img:setAnchorPoint(.5,.5)
	sprite:addChild(img)
	if(rotation==1) then
		self.tween = GTween.new(img, time, {rotation = 0+360},{repeatCount = math.huge})
		table.insert(self.tweens, self.tween)
	else
		self.tween = GTween.new(img, time, {rotation = 0-360},{repeatCount = math.huge})
		table.insert(self.tweens, self.tween)
	end
	

	
	sprite:setScale(scale)
	sprite:setPosition(x,y)

end





function MasherUpDown2:changeDirection()

	self.xVel, self.yVel = self.body:getLinearVelocity()
	self.yVel = self.yVel * -1
	self.body:setLinearVelocity(0,0)
	Timer.delayedCall(700, self.doChangeDirection, self)
	
	if(self.channel2) then
		self.channel2 = self.scene.masherHitSound:play()
		self.channel2:setVolume(self.volume*self.scene.soundVol)
	end
	
end




function MasherUpDown2:doChangeDirection()

	self.body:setLinearVelocity(self.xVel,self.yVel)
	
end


function MasherUpDown2:pause()

end




function MasherUpDown2:resume()

end


-- cleanup function

function MasherUpDown2:exit()
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
end