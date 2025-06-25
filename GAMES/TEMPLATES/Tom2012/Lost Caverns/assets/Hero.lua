Hero = Core.class(Sprite)

function Hero:init(scene,startX,startY)

	self.name = "hero"
	


	self.canMove = true -- used to stop moving when scrolling
	self.tweens = {}

	--self.direction = "right"
	self.xSpeed = 0;
	self.groundBraking = .2;
	self.xSpeed = 5

	self.scene = scene
	
	table.insert(self.scene.pauseResumeExitSprites, self)
	
	self.falling = true
	--self.direction = "right"
	--self.hideHeroArt = true -- hide hero graphics so can see physics
	

	-- Rear arm
	local rearArmSprite = Sprite.new()
	self:addChild(rearArmSprite)
	self.rearArmSprite = rearArmSprite
	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("HERO_REAR_ARM_STANDING")
	anim:addToParent(anim)
	rearArmSprite:addChild(anim)
	self.rearArm = anim
	self.rearArm:setPosition(0,0)

	self.rearArmSpriteBob = GTween.new(self.rearArmSprite, .5, {y = self.rearArmSprite:getY()+1}, {repeatCount=9999, reflect=true})
	table.insert(self.tweens, self.rearArmSpriteBob)
	

	-- Ears
	local earsSprite = Sprite.new()
	self:addChild(earsSprite)
	self.earsSprite = earsSprite
	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("HERO_EARS_STANDING")
	anim:addToParent(anim)
	earsSprite:addChild(anim)
	self.ears = anim;
	self.ears:setPosition(-33,-24);


	-- Legs
	local legsSprite = Sprite.new()
	self:addChild(legsSprite)
	self.legsSprite = legsSprite
	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("HERO_LEGS_STANDING")
	anim:addToParent(anim)
	legsSprite:addChild(anim)
	self.legs = anim;
	self.legs:setPosition(-2,13);

	self.earsBob = GTween.new(self.ears, .5, {y = self.ears:getY()+2}, {repeatCount=9999, reflect=true})
	table.insert(self.tweens, self.earsBob)
	
	self.earsWalkBob = GTween.new(self.ears, .2, {y = self.ears:getY()+3}, {repeatCount=9999, reflect=true, autoPlay = false})
	table.insert(self.tweens, self.earsWalkBob)
	
	

	-- Body Layer

	local heroBody = Sprite.new()
	self:addChild(heroBody)
	self.heroBody = heroBody

	-- back claw
	local backClaw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("back claw.png"))
	self.heroBody:addChild(backClaw)
	self.backClaw = backClaw
	backClaw:setPosition(-23,-18)

	-- Body sprite

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("hero body.png"))
	self.heroBody:addChild(img)
	img:setPosition(-25,-49)
	self.bodyImage = img

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("hero body hit.png"))
	self.heroBody:addChild(img)
	img:setPosition(-25,-49)
	self.bodyImageHit1 = img
	self.bodyImageHit1:setVisible(false)
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("hero body hit 2.png"))
	self.heroBody:addChild(img)
	img:setPosition(-25,-49)
	self.bodyImageHit2 = img
	self.bodyImageHit2:setVisible(false)
	
	-- Body with mite
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("hero body mite.png"))
	self.heroBody:addChild(img)
	img:setPosition(-25,-49)
	self.bodyImageMite = img
	self.bodyImageMite:setAlpha(0)

	-- Eyes

	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("HERO_EYES")
	anim:addToParent(anim)
	self.heroBody:addChild(anim)
	self.eyes = anim

	self.eyes:setPosition(0,-36);
	self.eyes:playAnimation()

	self.bodyBob = GTween.new(self.heroBody, .5, {y = self.heroBody:getY()+2}, {repeatCount=9999, reflect=true})
	table.insert(self.tweens, self.bodyBob)
	self.bodyWalkBob = GTween.new(self.heroBody, .2, {y = self.heroBody:getY()-1}, {repeatCount=9999, reflect=true,autoPlay = false})
	table.insert(self.tweens, self.bodyWalkBob)
	
	-- Front arm

	local frontArm = Sprite.new()
	self:addChild(frontArm)
	self.frontArm = frontArm
	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("HERO_FRONT_ARM_STANDING")
	anim:addToParent(anim)
	frontArm:addChild(anim)
	self.frontArmAnimation = anim
	self.frontArmAnimation:setPosition(-2,-1);
	self.frontArmAnimation:setAnimAnchorPoint(.48,.5)


	self.frontArmBob = GTween.new(self.frontArmAnimation, .5, {y = self.frontArmAnimation:getY()+2}, {repeatCount=9999, reflect=true})
	table.insert(self.tweens, self.frontArmBob)


	-- Add physics to him

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY, fixedRotation = true, allowSleep = false}
	body:setPosition(self:getX(), self:getY())
	body:setAngle(self:getRotation() * math.pi/180)


	-- Set up fixtures

	-- Physics body - Top

	local circle = b2.CircleShape.new(0,-26,16)
	local fixture = body:createFixture{shape = circle, density = 1, friction = 0, restitution = 0}

	local filterData = {categoryBits = 1, maskBits = 2+64+256+512+1024}
	fixture:setFilterData(filterData)
	fixture.name = "physics"

	-- Physics body - middle

	local poly = b2.PolygonShape.new()
	poly:setAsBox(16,18,0,-6,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0}
	fixture.name = "physics"

	local filterData = {categoryBits = 1, maskBits = 2+64+256+512+1024}
	fixture:setFilterData(filterData)

	-- Physics body - Bottom

	local circle = b2.CircleShape.new(0,10,16)
	local fixture = body:createFixture{shape = circle, density = 1, friction = 0, restitution = 0}
	local filterData = {categoryBits = 1, maskBits = 2+64+256+512+1024}
	fixture:setFilterData(filterData)
	fixture.name = "physics"

	-- Hit box for hero

	local poly = b2.PolygonShape.new()
	poly:setAsBox(15,25,3,-10,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0, isSensor=true}
	fixture.name = "hitbox"

	local filterData = {categoryBits = 8, maskBits = 32+128+2048+4096}
	fixture:setFilterData(filterData)

	-- Ground / feet sensor

	local poly = b2.PolygonShape.new()
	poly:setAsBox(13,10,0,20,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0, isSensor=true}
	fixture.name = "feet"

	local filterData = {categoryBits = 1, maskBits = 2+64+256+512+1024}
	fixture:setFilterData(filterData)



	-- Jump through sensor

	local circle = b2.CircleShape.new(0,25,2)
	local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0}
	local filterData = {categoryBits = 32768, maskBits = 16384}
	fixture:setFilterData(filterData)
	fixture.name = "jSensor"

	
	-- Key sensor
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(55,10,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0, isSensor=true}
	fixture.name = "key"

	local filterData = {categoryBits = 1, maskBits = 512}
	fixture:setFilterData(filterData)


	--self.fixture = fixture
	self.body = body
	body.name = "Hero"

	self.body:setPosition(startX-(self.scene.rube1:getX()),startY-(self.scene.rube1:getY()))




	--- temp

	self.alpha = 1

	if(self.hideHeroArt) then
		self.alpha = 0
	end

	
	
	--self:setAlpha(.5)
	
	--self.body:setActive(false)
	self.heroBody:setAlpha(self.alpha)
	self.rearArmSprite:setAlpha(self.alpha)
	self.earsSprite:setAlpha(self.alpha)
	self.legsSprite:setAlpha(self.alpha)
	self.frontArm:setAlpha(self.alpha)



	local particles = LootParticles.new(self.scene)
	self:addChild(particles)
	particles:setY(-5)
	self.scene.lootParticles = particles

	--self.scene.lootParticles.emitter:start()
	
	
	-- sounds
	
	self.painSounds = {}
	
	self.painSounds[1] = Sound.new("Sounds/hero pain 1.wav")
	self.painSounds[2] = Sound.new("Sounds/hero pain 2.wav")
	self.painSounds[3] = Sound.new("Sounds/hero pain 3.wav")
	self.painSounds[4] = Sound.new("Sounds/hero pain 4.wav")	
	self.painSounds[5] = Sound.new("Sounds/hero pain 5.wav")
	self.soundCounter = 1

		-- flashing 
	
	self.flashingTween = GTween.new(self, .1, { redMultiplier=1.5, greenMultiplier=.01, blueMultiplier=.01 },{reflect=true, repeatCount=12, autoPlay=false})
	self.flashingTween:addEventListener("complete", self.endInvincible, self)
	self.flashingTween.dispatchEvents = true
	
end





function Hero:die()

	self.dead = true

	self.scene.playerMovement.xSpeed = 0

	Timer.delayedCall(10, function() self.body:setActive(false) end)

	self.heroBody:setAlpha(0)
	self.rearArmSprite:setAlpha(0)
	self.earsSprite:setAlpha(0)
	self.legsSprite:setAlpha(0)
	self.frontArm:setAlpha(0)

	if(self.scene.claw) then

		if(self.scene.claw.clawLine) then
		self.scene.claw.clawLine:setAlpha(0)
		end

		if(self.scene.clawSprite) then
		self.scene.clawSprite:setAlpha(0)
		end

	end

	-- temp test - hero die anim

	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("HERO_DIE")
	anim:setAnimAnchorPoint(.5,.5)
	anim:addToParent(anim)
	anim:playAnimation()
	self.scene.frontLayer:addChild(anim)
	self.dieAnim = anim

	self.dieAnim:setPosition(self.scene.hero.body:getPosition())

	self.dieTween1 = GTween.new(self.dieAnim, .5, {y = self.dieAnim:getY()-100}, {ease = easing.outQuadratic})
	--table.insert(self.tweens, self.dieTween1)
	self.dieTween2 = GTween.new(self.dieAnim, 1, {y = self.dieAnim:getY()+320}, {autoPlay = false, ease = easing.inQuadratic})
	--table.insert(self.tweens, self.dieTween2)

	self.dieTween1.nextTween = self.dieTween2

	Timer.delayedCall(1400, function() fadeToBlack() end)
	Timer.delayedCall(2000, function()
	
	-- clear out atlasHolder
	
	collectgarbage()
	collectgarbage()
	
	sceneManager:changeScene("Game Over", 0, SceneManager.flipWithFade, easing.outBack) end)

end





function Hero:endInvincible()

	self.invincible = false
	
end










function Hero:makeSad(staySad)

	self.scene.hero.bodyImage:setVisible(false)
	self.scene.hero.bodyImageHit2:setVisible(true)

	Timer.delayedCall(100, function()
		self.scene.hero.bodyImageHit2:setVisible(false)
		self.scene.hero.bodyImageHit1:setVisible(true)
	end)


	if(not(staySad)) then
	
	--tomtom
	
		-- Show happy face
		
		Timer.delayedCall(1300, function()
			self.scene.hero.bodyImageHit1:setVisible(false)
			self.scene.hero.bodyImageHit2:setVisible(true)
		end)
		
			Timer.delayedCall(1400, function()
			self.scene.hero.bodyImage:setVisible(true)
			self.scene.hero.bodyImageHit2:setVisible(false)
		end)
	end
	
end




function Hero:miteFace()

	self.flashingTween:setPaused(false)
	self.scene.hero.bodyImage:setAlpha(0)
	self.scene.hero.eyes:setAlpha(0)
	self.scene.hero.bodyImageMite:setAlpha(1)
		
	-- Show happy face
	
	Timer.delayedCall(1300, function()
		self.scene.hero.bodyImage:setAlpha(1)
		self.scene.hero.eyes:setAlpha(1)
		self.scene.hero.bodyImageMite:setAlpha(0)
	end)

end






function Hero:makeInvincible()

	self.invincible = true

end


function Hero:gotHit(damage)

	self:hitSound()
	self.scene.health:reduceHealth(damage)
	self:makeInvincible()
	self:makeSad()
	self.flashingTween:setPaused(false)

end



function Hero:hitSound()
	
	local channel1 = self.painSounds[self.soundCounter]:play()
	channel1:setVolume(.4*self.scene.soundVol)
	self.soundCounter = self.soundCounter + 1
	
	if(self.soundCounter==6) then
		self.soundCounter = 1
	end

end




function Hero:pause()

print("hero pause");
	--self.mc:stop()
	
end



function Hero:resume()

	if(not(self.scene.gameEnded)) then
		--self.mc:play()
	end

end




function Hero:exit()

	print("hero exit");


end


