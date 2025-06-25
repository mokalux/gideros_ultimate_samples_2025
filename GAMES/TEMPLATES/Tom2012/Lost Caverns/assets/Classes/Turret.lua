Turret = Core.class(Sprite)

function Turret:init(scene,x,y,angle,atlas)

	self.atlas = atlas
	self.angle = angle
	self.scene = scene
	self.x = x
	self.y = y
	self.tweens = {}
	
	self.value = 50

	-- Add the leaf base
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("turret leaves.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)

	-- create sprite to hold the mouth
	
	local sprite = Sprite.new()
	self:addChild(sprite)
	self.mouthSprite = sprite
	self.mouthSprite:setRotation(70)
	self.type = "turret gold"
	
	-- create collectible
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("turret pearl.png"))
	img:setAnchorPoint(.5,.5)
	self.mouthSprite:addChild(img)
	img:setY(img:getY()-30)
	self.pearl = img
	self.pearl:setVisible(false)
	
	
	-- left mouth

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("turret mouth left.png"))
	img:setAnchorPoint(.5,.8)
	img:setPosition(-10,-5)
	self.mouthSprite:addChild(img)
	self.mouthLeft = img
	
	-- right mouth

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("turret mouth right.png"))
	img:setAnchorPoint(.5,.8)
	img:setPosition(10,-5)
	self.mouthSprite:addChild(img)
	self.mouthRight = img

	self.parent = self:getParent()
	
	self.rotation = -1

	self.fireEveryDegrees = 26
	self.degreeCounter = 0
	self.phase = "rotate"
	
	self.scene.frontLayer:addChild(self)
	
	Timer.delayedCall(100, self.cannotCollect, self)
	
	
	-- add physics
	
	local body = self.scene.world:createBody{type = b2.STATIC_BODY, allowSleep = true}


	local circle = b2.CircleShape.new(0,0,2)
	local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
	
	
	local circle = b2.CircleShape.new(0,-30,15)
	local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
	
	body:setPosition(x,y)
	
	local angleNew = angle

	self.body = body
	
		Timer.delayedCall(100, function()
		self.body:setAngle(math.rad(self:getRotation()+70))
	end)


	fixture.name = "loot"
	self.fixture = fixture
	fixture.parent = self

	local filterData = {categoryBits = 4096, maskBits = 8912}
	fixture:setFilterData(filterData)
		
	-- Set up particles

	local particles = TurretParticles.new(self.scene)
	self.scene.frontLayer:addChild(particles)
	self.particles = particles


	
	-- sounds
	
	self.maxVolume = .3
	self.volume = 0
		
	if(not(self.scene.spitSound)) then
	
		self.scene.spitSound = Sound.new("Sounds/spit.wav")
		
	end
	
	if(not(self.scene.popSound)) then
	
		self.scene.popSound = Sound.new("Sounds/pop.wav")

	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end




function Turret:pause()

--	self.mc:stop()

end




function Turret:resume()

--	self.mc:play()

end






function Turret:showLoot()

	Timer.delayedCall(500, self.rotate(), self)

end


function Turret:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		if(self.phase=="rotate") then
			
			self:rotate()

		end
		
		
		-- Check if body gone (loot collected)
		
		if(self.body.destroyed) then
			self:killSelf()
		end
	
	end
	
end





function Turret:rotate()

	self.mouthSprite:setRotation(self.mouthSprite:getRotation()+self.rotation)

	
	-- moving anti-CW, now go CW
	
	if(self.rotation==-1 and self.mouthSprite:getRotation() <= -70) then
	
		self.rotation = 1
		self.phase = "wait"
		self.mouthSprite:setRotation(-70)
		self:openMouth()
		
	end
		
	-- Moving CW, change to anti-CW
	
	if(self.rotation==1 and self.mouthSprite:getRotation() >= 70) then
		self.rotation = -1
		self.phase = "wait"
		self.mouthSprite:setRotation(70)
		self:openMouth()

	end

	self.degreeCounter = self.degreeCounter + 1
	
	if(self.degreeCounter >= self.fireEveryDegrees and self.phase=="rotate") then
	
		self.degreeCounter = 0
		self:fire()
	
	end

end



function Turret:collected()

	self:startParticles()
	self:killSelf()
	
	local channel = self.scene.popSound:play()
	channel:setVolume(self.volume*self.scene.soundVol)

	self.scene.loot = self.scene.loot + self.value
	self.scene.interface:updateLoot()
	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300)

end




function Turret:fire()

	self.channel1 = self.scene.spitSound:play()
	self.channel1:setVolume(self.volume*self.scene.soundVol)
			
	-- Work out the angle of the bullet
	
	local tween = GTween.new(self.mouthSprite, .3, {scaleY = 1.06, scaleX = .9},{reflect=true, repeatCount = 2, delay=0,ease = easing.inOutQuadratic})
	
	self.phase = "shoot"
	Timer.delayedCall(400, self.restartRotation, self)
	local angle = self.mouthSprite:getRotation()-math.deg(self.angle)
	
	-- add bullet
	
	-- Use trig to move bullet out a bit
	
	local angle = math.rad(self.mouthSprite:getRotation()-90)-self.angle
	
	local bulletX = self.x + (math.cos(angle) * 20)
	local bulletY = self.y + (math.sin(angle) * 20)
	
	local bullet = Bullet.new(self.scene,bulletX, bulletY,math.deg(angle)+90,false,false,self.atlas)
	
	local tween = GTween.new(self.mouthLeft, .15, {rotation = -10},{reflect=true, repeatCount = 2,ease = easing.inOutQuadratic})
	local tween = GTween.new(self.mouthRight, .15, {rotation = 10},{reflect=true, repeatCount = 2,ease = easing.inOutQuadratic})
	local tween = GTween.new(self.mouthSprite, .15, {y = 5},{reflect=true, repeatCount = 2,ease = easing.inOutQuadratic})

end






function Turret:openMouth()

	self.body:setAngle(math.rad(self.mouthSprite:getRotation())-self.angle)
	self.body:setActive(true)
	self.pearl:setVisible(true)

	-- do jaw rotation
	
	local tween = GTween.new(self.mouthLeft, .8, {rotation = -65},{repeatCount = 1,ease = easing.inOutQuadratic})
	local tween = GTween.new(self.mouthRight, .8, {rotation = 65},{repeatCount = 1,ease = easing.inOutQuadratic})
	
	Timer.delayedCall(200, self.canCollect, self)
	Timer.delayedCall(2000, self.closeMouth, self)
	
	
	
end



function Turret:closeMouth()

	-- do jaw rotation
	
	local tween = GTween.new(self.mouthLeft, .8, {rotation = 0},{repeatCount = 1,ease = easing.inOutQuadratic})
	local tween = GTween.new(self.mouthRight, .8, {rotation = 0},{repeatCount = 1,ease = easing.inOutQuadratic})
	
	Timer.delayedCall(700, self.cannotCollect, self)
	Timer.delayedCall(1000, self.restartRotation, self)
	
	
end




function Turret:restartRotation()

	self.phase = "rotate"
	self.pearl:setVisible(false)
	
end




function Turret:cannotCollect()

	if(not(self.body.destroyed)) then
		self.body:setActive(false)
	end

end


function Turret:canCollect()

	if(not(self.body.destroyed)) then
		self.body:setActive(true)
	end

end



function Turret:dieAnim()
	
	-- close mouth
	
	-- do jaw rotation
	
	local tween = GTween.new(self.mouthLeft, .8, {rotation = 10},{repeatCount = 1,ease = easing.inOutQuadratic})
	local tween = GTween.new(self.mouthRight, .8, {rotation = -10},{repeatCount = 1,ease = easing.inOutQuadratic})
	
	local tween = GTween.new(self, 1.5, {scaleX = 0,scaleY = 0},{delay=.5, ease = easing.inOutQuadratic})
	
end





function Turret:startParticles()


	local angle = math.rad(self.mouthSprite:getRotation()-90)-self.angle
	
	local x = self.x + (math.cos(angle) * 25)
	local y = self.y + (math.sin(angle) * 25)
	
	self.particles:setPosition(x,y)
	self.particles.emitter:start()

end






function Turret:killSelf()

	self.mouthSprite:removeChild(self.pearl)
	self.body.destroyed = true

	Timer.delayedCall(10, self.removeBody, self)
	
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

	self:dieAnim()
	
	Timer.delayedCall(2000, self.removeFromVolume, self)
	Timer.delayedCall(3000, self.removeSprite, self)
	
	--Turret:dieanim

end


function Turret:removeSprite()

	self:getParent():removeChild(self)

end


function Turret:removeBody()

	self.scene.world:destroyBody(self.body) -- remove physics body

end



function Turret:removeFromVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do
		if(v==self) then
			table.remove(self.scene.spritesWithVolume, i)
		end
	end

end






-- cleanup function

function Turret:exit()

		--[[
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	--]]

	--self.upTween:setPaused(true)
	--self.downTween:setPaused(true)
	
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
	

end

