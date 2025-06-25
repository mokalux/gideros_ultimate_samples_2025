WormWraith = Core.class(Sprite)

function WormWraith:init(scene,x,y,xSpeed,id)

	self.health = 2
	self.name = "worm wraith" -- used in collisions to see what claw object hit
	
	self.id = id

	self.scene = scene
	self.xSpeed = xSpeed
	
	-- set up atlas if not already created

	if(not(self.scene.wormWraithAtlas)) then
	
		self.scene.wormWraithAtlas = TexturePack.new("Atlases/Worm Wraith.txt", "Atlases/worm wraith.png",true)

	end


-- setup the animation

	self:createAnim()

	self.scene.rube1:addChild(self)

	-- Add physics
	
	-- Hitbox - hits player and objects

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	self.body = body
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,22,0,10,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0}
	
	local filterData = {categoryBits = 128, maskBits = 4+8}
	fixture:setFilterData(filterData)
	
	fixture.parent = self
	fixture.name = "enemy"
	
	-- The 'wheels' that he runs on
	
	local circle = b2.CircleShape.new(-15,24,14)
	local fixture = body:createFixture{shape = circle, density = 9999, friction = 0, restitution = 0}
	local filterData = {categoryBits = 128, maskBits = 2+16}
	fixture:setFilterData(filterData)
	
	local circle = b2.CircleShape.new(25,24,14)
	local fixture = body:createFixture{shape = circle, density = 9999, friction = 0, restitution = 0}
	local filterData = {categoryBits = 128, maskBits = 2+16}
	fixture:setFilterData(filterData)


	
	-- turn frame
	
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("turn.png"))
	img:setPosition(-40,-48)
	self:addChild(img)
	self.turnSprite = img
	self.turnSprite:setVisible(false)

	-- Add timer to move me
	
	Timer.delayedCall(100,self.startMove,self)
	

	
	table.insert(self.scene.spritesOnScreen, self)
	table.insert(self.scene.enemies, self)
	table.insert(self.scene.pauseResumeExitSprites, self)
	
	-- set up sounds
	
	if(not(self.scene.hitSound)) then
	
		self.scene.hitSound = Sound.new("Sounds/monster hit.wav")

	end
	
	if(not(self.scene.successChimeSound)) then
	
		self.scene.successChimeSound = Sound.new("Sounds/success-chime.mp3")

	end




end




function WormWraith:startMove()

	self.point1 = self.scene.path[self.id].vertices.x[1]
	self.point2 = self.scene.path[self.id].vertices.x[2]
	self.newXSpeed = -self.xSpeed
	
	self.direction = "left"
	self:setScaleX(-1)
		
	self:addEventListener(Event.ENTER_FRAME, self.makeMeMove, self)
	

end








function WormWraith:makeMeMove()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self.xVel,self.yVel = self.body:getLinearVelocity()
		
		if(self.yVel > 3) then
			self.yVel = 3
		end
		
		-- Going left, passed point1

		if(self.direction=="left" and self:getX() <= self.point1) then
			local x,y = self.body:getPosition()
			self.body:setPosition(self.point1,y)
			self.newXSpeed = self.xSpeed
			self:turn()
			self.direction = "right"
			
		-- Going right, passed point 2
		
		elseif(self.direction=="right" and self:getX() >= self.point2) then
			local x,y = self.body:getPosition()
			self.body:setPosition(self.point2,y)
			self.newXSpeed = -self.xSpeed
			self:turn()
			self.direction = "left"
		
		end


		if(self.yVel > 2.5) then
		self.yVel = 2.5
		end
		
		self.body:setLinearVelocity(self.newXSpeed,self.yVel)
		
		if(self.body:getAngularVelocity() > .1) then
			self.body:setAngularVelocity(.1)
		end
		
		if(self.body:getAngularVelocity()<- .1) then
			self.body:setAngularVelocity(-.1)
		end
	
	end

end




-- This function shows the turn anim


function WormWraith:turn()

	self.mainSprite:setVisible(false)
	self.turnSprite:setVisible(true)

	Timer.delayedCall(100, function()
		
		if(not(self.dead)) then
			self.mainSprite:setVisible(true)
			self.turnSprite:setVisible(false)
		end

		if(self.direction=="left") then
			self:setScaleX(-1)
		else
			self:setScaleX(1)
		end

	end)

end






function WormWraith:hit(dmg,hitBy)

	if(not(self.invincible)) then
	
		local channel1 = self.scene.hitSound:play()
		channel1:setVolume(.3*self.scene.soundVol)
	
		local testTween = GTween.new(self, .08, { redMultiplier=255, greenMultiplier=0, blueMultiplier=0 },{reflect=true, repeatCount=12})
	
		self.invincible = true
	
		if(hitBy:getX() < self:getX()) then
			self.body:setLinearVelocity(-6,0)
		else
			self.body:setLinearVelocity(6,0)
	
		end
		
		self.health = self.health - 1

		-- play hit anim
		
		self.mc:gotoAndPlay(101)
		self.mc:setStopAction(138)
		
		self.mc:addEventListener(Event.COMPLETE, self.finishHit, self)
		self:stopMoving()

	end


	
end




function WormWraith:finishHit()

	self.mc:removeEventListener(Event.COMPLETE, self.finishHit, self)
	

	-- If I am out of health, die

	if(self.health <= 0) then
	
		self.dead = true
		self:die()
	
	-- Otherwise, restart walking
	
	else
	
		self.invincible = false
		self:walkingAnim()
		self.body:setLinearDamping(0)
	
	end

end



function WormWraith:walkingAnim()

	--self.body:setLinearDamping(0)
	self.mc:gotoAndPlay(1)

end



function WormWraith:stopMoving()

	self.body:setLinearDamping(99999)

end






function WormWraith:die()

	-- spawn health pickup
	
	if(math.random(1,2)==2 or self.scene.levelNumber==1) then
		local x,y = self:getPosition()
		local health = HealthPickup.new(self.scene,x,y)
		health:setPosition(x,y)
		local tween = GTween.new(health, .3, {y = y-40},{ease = easing.inOutQuadratic, reflect = true, repeatCount = 2})
		
		local channel2 = self.scene.successChimeSound:play()
		channel2:setVolume(.2*self.scene.soundVol)
		
	end

	-- play die anim
	
	self.mc:setStopAction(168)
	self.mc:gotoAndPlay(140)
	
	self:stopMoving()

	self.body.destroyed = true
	self.scene.world:destroyBody(self.body) -- remove physics body
	self:removeEventListener(Event.ENTER_FRAME, self.makeMeMove, self)
	

	for i,v in pairs(self.scene.enemies) do
		if(v==self) then
			table.remove(self.scene.enemies, i)
		end
	end

	Timer.delayedCall(100, function()
		self.head1:setVisible(false)
		self.head2:setVisible(true)
	end)
	
	Timer.delayedCall(1400, function()
		local tween = GTween.new(self, .3, {alpha=0})
	end)
	
	Timer.delayedCall(2000, function()
		self:getParent():removeChild(self)
	end)

	

end






function WormWraith:pause()

	self.mc:stop()

end




function WormWraith:resume()

	self.mc:play()

end



-- cleanup function

function WormWraith:exit()

	self.mc:stop()
	
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.makeMeMove, self)
	end
	
	--self:getParent():removeChild(self)
	
	
end





function WormWraith:createAnim()

	local mainSprite = Sprite.new()
	self:addChild(mainSprite)
	mainSprite:setPosition(-74, -60)
	self.mainSprite = mainSprite
	
	local bones = {}

	-- Setup bones

	-- bone_000

	local sprite = Sprite.new()
	mainSprite:addChild(sprite)
	bones[0] = {}
	bones[0].sprite = sprite

	-- Rear hand bone

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[1] = {}
	bones[1].sprite = sprite

	-- bone_006

	local sprite = Sprite.new()
	bones[1].sprite:addChild(sprite)
	bones[2] = {}
	bones[2].sprite = sprite

	-- bone_007

	local sprite = Sprite.new()
	bones[1].sprite:addChild(sprite)
	bones[3] = {}
	bones[3].sprite = sprite

	-- bone_015

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[4] = {}
	bones[4].sprite = sprite

	-- bone_016

	local sprite = Sprite.new()
	bones[4].sprite:addChild(sprite)
	bones[5] = {}
	bones[5].sprite = sprite

	-- bone_017

	local sprite = Sprite.new()
	bones[5].sprite:addChild(sprite)
	bones[6] = {}
	bones[6].sprite = sprite

	-- bone_018

	local sprite = Sprite.new()
	bones[6].sprite:addChild(sprite)
	bones[7] = {}
	bones[7].sprite = sprite

	-- bone_019

	local sprite = Sprite.new()
	bones[7].sprite:addChild(sprite)
	bones[8] = {}
	bones[8].sprite = sprite

	-- bone_020

	local sprite = Sprite.new()
	bones[8].sprite:addChild(sprite)
	bones[9] = {}
	bones[9].sprite = sprite

	-- bone_021

	local sprite = Sprite.new()
	bones[9].sprite:addChild(sprite)
	bones[10] = {}
	bones[10].sprite = sprite

	-- bone_001

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[11] = {}
	bones[11].sprite = sprite

	-- bone_004

	local sprite = Sprite.new()
	bones[11].sprite:addChild(sprite)
	bones[12] = {}
	bones[12].sprite = sprite

	-- bone_009

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[13] = {}
	bones[13].sprite = sprite

	-- Forearm bone

	local sprite = Sprite.new()
	bones[13].sprite:addChild(sprite)
	bones[14] = {}
	bones[14].sprite = sprite

	-- Hand Bone

	local sprite = Sprite.new()
	bones[14].sprite:addChild(sprite)
	bones[15] = {}
	bones[15].sprite = sprite

	-- Top finger bone

	local sprite = Sprite.new()
	bones[15].sprite:addChild(sprite)
	bones[16] = {}
	bones[16].sprite = sprite

	-- bone_014

	local sprite = Sprite.new()
	bones[15].sprite:addChild(sprite)
	bones[17] = {}
	bones[17].sprite = sprite

	-- Finger bone 1

	local sprite = Sprite.new()
	bones[15].sprite:addChild(sprite)
	bones[18] = {}
	bones[18].sprite = sprite

	-- Shell Bone

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[19] = {}
	bones[19].sprite = sprite

	-- Setup image sprites

	local sprites = {}

	-- rear hand fingers

	sprites[0] = {}
	local sprite = Sprite.new()
	bones[2].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("rear hand fingers.png"))
	sprite:addChild(img)
	sprites[0].sprite = sprite

	-- rear hand thumb

	sprites[1] = {}
	local sprite = Sprite.new()
	bones[3].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("rear hand thumb.png"))
	sprite:addChild(img)
	sprites[1].sprite = sprite

	-- head

	sprites[2] = {}
	local sprite = Sprite.new()
	bones[12].sprite:addChild(sprite)
	self.head1 = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("head.png"))
	self.head2 = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("head dead.png"))
	self.head2:setVisible(false)
	sprite:addChild(self.head1)
	sprite:addChild(self.head2)
	sprites[2].sprite = sprite


	-- finger_001

	sprites[3] = {}
	local sprite = Sprite.new()
	bones[16].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("finger.png"))
	sprite:addChild(img)
	sprites[3].sprite = sprite

	-- finger_000

	sprites[4] = {}
	local sprite = Sprite.new()
	bones[17].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("finger.png"))
	sprite:addChild(img)
	sprites[4].sprite = sprite

	-- finger

	sprites[5] = {}
	local sprite = Sprite.new()
	bones[18].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("finger.png"))
	sprite:addChild(img)
	sprites[5].sprite = sprite

	-- palm

	sprites[6] = {}
	local sprite = Sprite.new()
	bones[15].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("palm.png"))
	sprite:addChild(img)
	sprites[6].sprite = sprite

	-- tail2

	sprites[7] = {}
	local sprite = Sprite.new()
	bones[5].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail2.png"))
	sprite:addChild(img)
	sprites[7].sprite = sprite

	-- tail3

	sprites[8] = {}
	local sprite = Sprite.new()
	bones[6].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail3.png"))
	sprite:addChild(img)
	sprites[8].sprite = sprite

	-- tail4

	sprites[9] = {}
	local sprite = Sprite.new()
	bones[7].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail4.png"))
	sprite:addChild(img)
	sprites[9].sprite = sprite

	-- tail5

	sprites[10] = {}
	local sprite = Sprite.new()
	bones[8].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail5.png"))
	sprite:addChild(img)
	sprites[10].sprite = sprite

	-- tail6

	sprites[11] = {}
	local sprite = Sprite.new()
	bones[9].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail6.png"))
	sprite:addChild(img)
	sprites[11].sprite = sprite

	-- tail7

	sprites[12] = {}
	local sprite = Sprite.new()
	bones[10].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail7.png"))
	sprite:addChild(img)
	sprites[12].sprite = sprite

	-- tail1

	sprites[13] = {}
	local sprite = Sprite.new()
	bones[4].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("tail1.png"))
	sprite:addChild(img)
	sprites[13].sprite = sprite

	-- forearm_000

	sprites[14] = {}
	local sprite = Sprite.new()
	bones[14].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("forearm.png"))
	sprite:addChild(img)
	sprites[14].sprite = sprite

	-- forearm

	sprites[15] = {}
	local sprite = Sprite.new()
	bones[13].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("forearm.png"))
	sprite:addChild(img)
	sprites[15].sprite = sprite

	-- shell

	sprites[16] = {}
	local sprite = Sprite.new()
	bones[19].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.wormWraithAtlas:getTextureRegion("shell.png"))
	sprite:addChild(img)
	sprites[16].sprite = sprite

	-- Adjust the sprites (from first frame of timelines)

	-- head

	sprites[2].sprite:setX(-5.82)
	sprites[2].sprite:setY(-69.5)
	sprites[2].sprite:setScaleX(1.55)
	sprites[2].sprite:setScaleY(1.55)


	-- bone_000

	bones[0].sprite:setX(30.36)
	bones[0].sprite:setY(21.53)
	bones[0].sprite:setRotation(358.11)


	-- bone_001

	bones[11].sprite:setX(29.63)
	bones[11].sprite:setY(43.39)
	bones[11].sprite:setRotation(12.21)


	-- bone_004

	bones[12].sprite:setX(3.38)
	bones[12].sprite:setY(-2.86)
	bones[12].sprite:setScaleX(0.65)
	bones[12].sprite:setScaleY(0.65)
	bones[12].sprite:setRotation(0.75)


	-- shell

	sprites[16].sprite:setX(-45.01)
	sprites[16].sprite:setY(-39.44)
	sprites[16].sprite:setScaleX(1.46)
	sprites[16].sprite:setScaleY(1.47)


	-- Shell Bone

	bones[19].sprite:setX(25.29)
	bones[19].sprite:setY(35.15)
	bones[19].sprite:setScaleX(0.68)
	bones[19].sprite:setScaleY(0.68)
	bones[19].sprite:setRotation(93.09)


	-- rear hand thumb

	sprites[1].sprite:setX(-9.81)
	sprites[1].sprite:setY(-19.07)
	sprites[1].sprite:setScaleX(1.86)
	sprites[1].sprite:setScaleY(1.86)


	-- rear hand fingers

	sprites[0].sprite:setX(-1.82)
	sprites[0].sprite:setY(-22.88)
	sprites[0].sprite:setScaleX(1.68)
	sprites[0].sprite:setScaleY(1.68)


	-- bone_006

	bones[2].sprite:setX(12.60)
	bones[2].sprite:setY(-2.12)
	bones[2].sprite:setScaleX(1.05)
	bones[2].sprite:setScaleY(1.05)
	bones[2].sprite:setRotation(350.66)


	-- bone_007

	bones[3].sprite:setX(14.00)
	bones[3].sprite:setY(-0.92)
	bones[3].sprite:setScaleX(0.95)
	bones[3].sprite:setScaleY(0.95)
	bones[3].sprite:setRotation(7.12)


	-- Rear hand bone

	bones[1].sprite:setX(49.60)
	bones[1].sprite:setY(46.27)
	bones[1].sprite:setScaleX(0.57)
	bones[1].sprite:setScaleY(0.57)
	bones[1].sprite:setRotation(44.54)


	-- forearm

	sprites[15].sprite:setX(-38.92)
	sprites[15].sprite:setY(-51.65)
	sprites[15].sprite:setScaleX(2.08)
	sprites[15].sprite:setScaleY(2.09)


	-- bone_009

	bones[13].sprite:setX(30.71)
	bones[13].sprite:setY(47.72)
	bones[13].sprite:setScaleX(0.48)
	bones[13].sprite:setScaleY(0.48)
	bones[13].sprite:setRotation(93.78)


	-- forearm_000

	sprites[14].sprite:setX(-55.29)
	sprites[14].sprite:setY(-69.09)
	sprites[14].sprite:setScaleX(2.81)
	sprites[14].sprite:setScaleY(2.82)


	-- Forearm bone

	bones[14].sprite:setX(28.10)
	bones[14].sprite:setY(1.04)
	bones[14].sprite:setScaleX(0.74)
	bones[14].sprite:setScaleY(0.74)
	bones[14].sprite:setRotation(241.49)


	-- palm

	sprites[6].sprite:setX(-4.92)
	sprites[6].sprite:setY(-16.02)
	sprites[6].sprite:setScaleX(2.20)
	sprites[6].sprite:setScaleY(2.21)


	-- Hand Bone

	bones[15].sprite:setX(32.63)
	bones[15].sprite:setY(1.3)
	bones[15].sprite:setScaleX(1.28)
	bones[15].sprite:setScaleY(1.28)
	bones[15].sprite:setRotation(34.66)


	-- finger

	sprites[5].sprite:setX(-5.42)
	sprites[5].sprite:setY(-3.23)
	sprites[5].sprite:setScaleX(4.64)


	-- Finger bone 1

	bones[18].sprite:setX(30.38)
	bones[18].sprite:setY(10.43)
	bones[18].sprite:setScaleX(0.47)
	bones[18].sprite:setScaleY(2.21)
	bones[18].sprite:setRotation(5.54)


	-- finger_000

	sprites[4].sprite:setX(-2.46)
	sprites[4].sprite:setY(-2.76)
	sprites[4].sprite:setScaleX(3.56)


	-- finger_001

	sprites[3].sprite:setX(-2.32)
	sprites[3].sprite:setY(-3)
	sprites[3].sprite:setScaleX(3.47)
	sprites[3].sprite:setRotation(0.46)


	-- Top finger bone

	bones[16].sprite:setX(30.08)
	bones[16].sprite:setY(-5.34)
	bones[16].sprite:setScaleX(0.63)
	bones[16].sprite:setScaleY(2.21)
	bones[16].sprite:setRotation(313.86)


	-- bone_014

	bones[17].sprite:setX(33.64)
	bones[17].sprite:setY(-0.25)
	bones[17].sprite:setScaleX(0.62)
	bones[17].sprite:setScaleY(2.21)
	bones[17].sprite:setRotation(342.07)


	-- tail1

	sprites[13].sprite:setX(-30.59)
	sprites[13].sprite:setY(-32.93)
	sprites[13].sprite:setScaleX(4.73)
	sprites[13].sprite:setScaleY(4.75)


	-- tail2

	sprites[7].sprite:setX(-43.64)
	sprites[7].sprite:setY(-52.39)
	sprites[7].sprite:setScaleX(6.59)
	sprites[7].sprite:setScaleY(6.63)


	-- tail3

	sprites[8].sprite:setX(-15.63)
	sprites[8].sprite:setY(-36.51)
	sprites[8].sprite:setScaleX(4.96)
	sprites[8].sprite:setScaleY(5.62)


	-- tail4

	sprites[9].sprite:setX(-23.48)
	sprites[9].sprite:setY(-32.72)
	sprites[9].sprite:setScaleX(5.66)
	sprites[9].sprite:setScaleY(5.69)


	-- tail5

	sprites[10].sprite:setX(-22.97)
	sprites[10].sprite:setY(-26.23)
	sprites[10].sprite:setScaleX(5.22)
	sprites[10].sprite:setScaleY(5.25)


	-- tail6

	sprites[11].sprite:setX(-21.19)
	sprites[11].sprite:setY(-26.76)
	sprites[11].sprite:setScaleX(5.66)
	sprites[11].sprite:setScaleY(5.69)


	-- tail7

	sprites[12].sprite:setX(-12.80)
	sprites[12].sprite:setY(-3.82)
	sprites[12].sprite:setScaleX(4.62)


	-- bone_015

	bones[4].sprite:setX(22.85)
	bones[4].sprite:setY(47.9)
	bones[4].sprite:setScaleX(0.21)
	bones[4].sprite:setScaleY(0.21)
	bones[4].sprite:setRotation(65.81)


	-- bone_016

	bones[5].sprite:setX(48.62)
	bones[5].sprite:setY(4.37)
	bones[5].sprite:setScaleX(0.72)
	bones[5].sprite:setScaleY(0.72)
	bones[5].sprite:setRotation(12.43)


	-- bone_017

	bones[6].sprite:setX(42.90)
	bones[6].sprite:setY(-2.45)
	bones[6].sprite:setScaleX(1.33)
	bones[6].sprite:setScaleY(1.18)
	bones[6].sprite:setRotation(52.04)


	-- bone_018

	bones[7].sprite:setX(40.95)
	bones[7].sprite:setY(2.72)
	bones[7].sprite:setScaleX(0.88)
	bones[7].sprite:setScaleY(0.99)
	bones[7].sprite:setRotation(39.74)


	-- bone_019

	bones[8].sprite:setX(36.72)
	bones[8].sprite:setY(-3.8)
	bones[8].sprite:setScaleX(1.08)
	bones[8].sprite:setScaleY(1.08)
	bones[8].sprite:setRotation(0.83)


	-- bone_020

	bones[9].sprite:setX(27.49)
	bones[9].sprite:setY(3.97)
	bones[9].sprite:setScaleX(0.92)
	bones[9].sprite:setScaleY(0.92)
	bones[9].sprite:setRotation(1.82)


	-- bone_021

	bones[10].sprite:setX(18.65)
	bones[10].sprite:setY(1.31)
	bones[10].sprite:setScaleX(1.23)
	bones[10].sprite:setScaleY(5.69)
	bones[10].sprite:setRotation(29.70)


	-- head

	sprites[2].sprite:setX(-5.82)
	sprites[2].sprite:setY(-69.5)
	sprites[2].sprite:setScaleX(1.55)
	sprites[2].sprite:setScaleY(1.55)


	-- bone_000

	bones[0].sprite:setX(30.36)
	bones[0].sprite:setY(21.53)
	bones[0].sprite:setRotation(358.11)


	-- bone_001

	bones[11].sprite:setX(29.63)
	bones[11].sprite:setY(43.39)
	bones[11].sprite:setRotation(12.21)


	-- bone_004

	bones[12].sprite:setX(3.38)
	bones[12].sprite:setY(-2.86)
	bones[12].sprite:setScaleX(0.65)
	bones[12].sprite:setScaleY(0.65)
	bones[12].sprite:setRotation(0.75)


	-- shell

	sprites[16].sprite:setX(-45.01)
	sprites[16].sprite:setY(-39.44)
	sprites[16].sprite:setScaleX(1.46)
	sprites[16].sprite:setScaleY(1.47)


	-- Shell Bone

	bones[19].sprite:setX(25.29)
	bones[19].sprite:setY(35.15)
	bones[19].sprite:setScaleX(0.68)
	bones[19].sprite:setScaleY(0.68)
	bones[19].sprite:setRotation(93.09)


	-- rear hand thumb

	sprites[1].sprite:setX(-9.81)
	sprites[1].sprite:setY(-19.07)
	sprites[1].sprite:setScaleX(1.86)
	sprites[1].sprite:setScaleY(1.86)


	-- rear hand fingers

	sprites[0].sprite:setX(-1.82)
	sprites[0].sprite:setY(-22.88)
	sprites[0].sprite:setScaleX(1.68)
	sprites[0].sprite:setScaleY(1.68)


	-- bone_006

	bones[2].sprite:setX(12.60)
	bones[2].sprite:setY(-2.12)
	bones[2].sprite:setScaleX(1.05)
	bones[2].sprite:setScaleY(1.05)
	bones[2].sprite:setRotation(350.66)


	-- bone_007

	bones[3].sprite:setX(14.00)
	bones[3].sprite:setY(-0.92)
	bones[3].sprite:setScaleX(0.95)
	bones[3].sprite:setScaleY(0.95)
	bones[3].sprite:setRotation(7.12)


	-- Rear hand bone

	bones[1].sprite:setX(49.60)
	bones[1].sprite:setY(46.27)
	bones[1].sprite:setScaleX(0.57)
	bones[1].sprite:setScaleY(0.57)
	bones[1].sprite:setRotation(44.54)


	-- forearm

	sprites[15].sprite:setX(-38.92)
	sprites[15].sprite:setY(-51.65)
	sprites[15].sprite:setScaleX(2.08)
	sprites[15].sprite:setScaleY(2.09)


	-- bone_009

	bones[13].sprite:setX(30.71)
	bones[13].sprite:setY(47.72)
	bones[13].sprite:setScaleX(0.48)
	bones[13].sprite:setScaleY(0.48)
	bones[13].sprite:setRotation(93.78)


	-- forearm_000

	sprites[14].sprite:setX(-55.29)
	sprites[14].sprite:setY(-69.09)
	sprites[14].sprite:setScaleX(2.81)
	sprites[14].sprite:setScaleY(2.82)


	-- Forearm bone

	bones[14].sprite:setX(28.10)
	bones[14].sprite:setY(1.04)
	bones[14].sprite:setScaleX(0.74)
	bones[14].sprite:setScaleY(0.74)
	bones[14].sprite:setRotation(241.49)


	-- palm

	sprites[6].sprite:setX(-4.92)
	sprites[6].sprite:setY(-16.02)
	sprites[6].sprite:setScaleX(2.20)
	sprites[6].sprite:setScaleY(2.21)


	-- Hand Bone

	bones[15].sprite:setX(32.63)
	bones[15].sprite:setY(1.3)
	bones[15].sprite:setScaleX(1.28)
	bones[15].sprite:setScaleY(1.28)
	bones[15].sprite:setRotation(34.66)


	-- finger

	sprites[5].sprite:setX(-5.42)
	sprites[5].sprite:setY(-3.23)
	sprites[5].sprite:setScaleX(4.64)


	-- Finger bone 1

	bones[18].sprite:setX(30.38)
	bones[18].sprite:setY(10.43)
	bones[18].sprite:setScaleX(0.47)
	bones[18].sprite:setScaleY(2.21)
	bones[18].sprite:setRotation(5.54)


	-- finger_000

	sprites[4].sprite:setX(-2.46)
	sprites[4].sprite:setY(-2.76)
	sprites[4].sprite:setScaleX(3.56)


	-- finger_001

	sprites[3].sprite:setX(-2.32)
	sprites[3].sprite:setY(-3)
	sprites[3].sprite:setScaleX(3.47)
	sprites[3].sprite:setRotation(0.46)


	-- Top finger bone

	bones[16].sprite:setX(30.08)
	bones[16].sprite:setY(-5.34)
	bones[16].sprite:setScaleX(0.63)
	bones[16].sprite:setScaleY(2.21)
	bones[16].sprite:setRotation(313.86)


	-- bone_014

	bones[17].sprite:setX(33.64)
	bones[17].sprite:setY(-0.25)
	bones[17].sprite:setScaleX(0.62)
	bones[17].sprite:setScaleY(2.21)
	bones[17].sprite:setRotation(342.07)


	-- tail1

	sprites[13].sprite:setX(-30.59)
	sprites[13].sprite:setY(-32.93)
	sprites[13].sprite:setScaleX(4.73)
	sprites[13].sprite:setScaleY(4.75)


	-- tail2

	sprites[7].sprite:setX(-43.64)
	sprites[7].sprite:setY(-52.39)
	sprites[7].sprite:setScaleX(6.59)
	sprites[7].sprite:setScaleY(6.63)


	-- tail3

	sprites[8].sprite:setX(-15.63)
	sprites[8].sprite:setY(-36.51)
	sprites[8].sprite:setScaleX(4.96)
	sprites[8].sprite:setScaleY(5.62)


	-- tail4

	sprites[9].sprite:setX(-23.48)
	sprites[9].sprite:setY(-32.72)
	sprites[9].sprite:setScaleX(5.66)
	sprites[9].sprite:setScaleY(5.69)


	-- tail5

	sprites[10].sprite:setX(-22.97)
	sprites[10].sprite:setY(-26.23)
	sprites[10].sprite:setScaleX(5.22)
	sprites[10].sprite:setScaleY(5.25)


	-- tail6

	sprites[11].sprite:setX(-21.19)
	sprites[11].sprite:setY(-26.76)
	sprites[11].sprite:setScaleX(5.66)
	sprites[11].sprite:setScaleY(5.69)


	-- tail7

	sprites[12].sprite:setX(-12.80)
	sprites[12].sprite:setY(-3.82)
	sprites[12].sprite:setScaleX(4.62)


	-- bone_015

	bones[4].sprite:setX(22.85)
	bones[4].sprite:setY(47.9)
	bones[4].sprite:setScaleX(0.21)
	bones[4].sprite:setScaleY(0.21)
	bones[4].sprite:setRotation(65.81)


	-- bone_016

	bones[5].sprite:setX(48.62)
	bones[5].sprite:setY(4.37)
	bones[5].sprite:setScaleX(0.72)
	bones[5].sprite:setScaleY(0.72)
	bones[5].sprite:setRotation(12.43)


	-- bone_017

	bones[6].sprite:setX(42.90)
	bones[6].sprite:setY(-2.45)
	bones[6].sprite:setScaleX(1.33)
	bones[6].sprite:setScaleY(1.18)
	bones[6].sprite:setRotation(52.04)


	-- bone_018

	bones[7].sprite:setX(40.95)
	bones[7].sprite:setY(2.72)
	bones[7].sprite:setScaleX(0.88)
	bones[7].sprite:setScaleY(0.99)
	bones[7].sprite:setRotation(39.74)


	-- bone_019

	bones[8].sprite:setX(36.72)
	bones[8].sprite:setY(-3.8)
	bones[8].sprite:setScaleX(1.08)
	bones[8].sprite:setScaleY(1.08)
	bones[8].sprite:setRotation(0.83)


	-- bone_020

	bones[9].sprite:setX(27.49)
	bones[9].sprite:setY(3.97)
	bones[9].sprite:setScaleX(0.92)
	bones[9].sprite:setScaleY(0.92)
	bones[9].sprite:setRotation(1.82)


	-- bone_021

	bones[10].sprite:setX(18.65)
	bones[10].sprite:setY(1.31)
	bones[10].sprite:setScaleX(1.23)
	bones[10].sprite:setScaleY(5.69)
	bones[10].sprite:setRotation(29.70)

	local timeLine = {}

	-- Walking 

	timeLine[1] = {1,49,bones[0].sprite,{x={30.36,30.11,"linear"},y={21.53,22.03,"linear"}}}
	timeLine[2] = {50,100,bones[0].sprite,{x={30.11,30.36,"linear"},y={22.03,21.53,"linear"}}}
	timeLine[3] = {1,24,bones[11].sprite,{x={29.63,30.39,"linear"},y={43.39,43.16,"linear"},rotation={12.21,12.21-8.39,"linear"}}}
	timeLine[4] = {25,49,bones[11].sprite,{x={30.39,29.63,"linear"},y={43.16,43.39,"linear"},rotation={3.82,3.82+8.54,"linear"}}}
	timeLine[5] = {50,73,bones[11].sprite,{x={29.63,30.14,"linear"},y={43.39,43.16,"linear"},rotation={12.36,12.36-5.29,"linear"}}}
	timeLine[6] = {74,100,bones[11].sprite,{x={30.14,29.63,"linear"},y={43.16,43.39,"linear"},rotation={7.07,7.07+5.14,"linear"}}}
	timeLine[7] = {1,24,bones[19].sprite,{x={25.29,24.09,"linear"},y={35.15,33.86,"linear"},rotation={93.09,93.09-3.44,"linear"}}}
	timeLine[8] = {25,49,bones[19].sprite,{x={24.09,22.32,"linear"},y={33.86,34.16,"linear"},rotation={89.65,89.65-5.18,"linear"}}}
	timeLine[9] = {50,73,bones[19].sprite,{x={22.32,24.35,"linear"},y={34.16,33.34,"linear"},rotation={84.47,84.47+3.8,"linear"}}}
	timeLine[10] = {74,100,bones[19].sprite,{x={24.35,25.29,"linear"},y={33.34,35.15,"linear"},rotation={88.27,88.27+4.82,"linear"}}}
	timeLine[11] = {1,73,bones[2].sprite,{rotation={350.66,350.66-30.28,"linear"}}}
	timeLine[12] = {74,100,bones[2].sprite,{rotation={320.38,320.38+30.28,"linear"}}}
	timeLine[13] = {1,24,bones[1].sprite,{x={49.60,41.81,"linear"},y={46.27,48.26,"linear"}}}
	timeLine[14] = {25,49,bones[1].sprite,{x={41.81,32.61,"linear"},y={48.26,45.71,"linear"}}}
	timeLine[15] = {50,80,bones[1].sprite,{x={32.61,41.07,"linear"},y={45.71,43.48,"linear"}}}
	timeLine[16] = {81,100,bones[1].sprite,{x={41.07,49.60,"linear"},y={43.48,46.27,"linear"}}}
	timeLine[17] = {1,24,bones[13].sprite,{x={30.71,31.26,"linear"},y={47.72,46.24,"linear"},rotation={93.78,93.78-7.55,"linear"}}}
	timeLine[18] = {25,49,bones[13].sprite,{x={31.26,30.71,"linear"},y={46.24,47.72,"linear"},rotation={86.23,86.23-7.61,"linear"}}}
	timeLine[19] = {50,100,bones[13].sprite,{rotation={78.62,78.62+15.16,"linear"}}}
	timeLine[20] = {1,49,bones[14].sprite,{rotation={241.49,241.49+20.29,"linear"}}}
	timeLine[21] = {50,100,bones[14].sprite,{rotation={261.78,261.78-20.29,"linear"}}}
	timeLine[22] = {1,24,bones[15].sprite,{x={32.63,31.99,"linear"},y={1.3,1.01,"linear"},rotation={34.66,34.66-11.67,"linear"}}}
	timeLine[23] = {25,49,bones[15].sprite,{x={31.99,32.63,"linear"},y={1.01,1.3,"linear"},rotation={22.99,22.99+7.17,"linear"}}}
	timeLine[24] = {50,100,bones[15].sprite,{rotation={30.16,30.16+4.5,"linear"}}}
	timeLine[25] = {25,44,bones[18].sprite,{rotation={5.54,5.54+11.22,"linear"}}}
	timeLine[26] = {45,53,bones[18].sprite,{rotation={16.76,16.76+19.27,"linear"}}}
	timeLine[27] = {54,100,bones[18].sprite,{rotation={36.03,36.03-30.49,"linear"}}}
	timeLine[28] = {1,48,bones[16].sprite,{rotation={313.86,313.86-39.93,"linear"}}}
	timeLine[29] = {49,57,bones[16].sprite,{rotation={273.93,273.93+51.72,"linear"}}}
	timeLine[30] = {58,100,bones[16].sprite,{rotation={325.65,325.65-11.79,"linear"}}}
	timeLine[31] = {25,49,bones[17].sprite,{rotation={342.07,342.07+10.39,"linear"}}}
	timeLine[32] = {50,61,bones[17].sprite,{rotation={352.46,352.46+13.44,"linear"}}}
	timeLine[33] = {62,100,bones[17].sprite,{rotation={5.90,5.90-23.83,"linear"}}}
	timeLine[34] = {1,49,bones[4].sprite,{rotation={65.81,65.81+14.09,"linear"}}}
	timeLine[35] = {50,100,bones[4].sprite,{rotation={79.90,79.90-14.09,"linear"}}}
	timeLine[36] = {1,49,bones[5].sprite,{rotation={12.43,12.43-0.9,"linear"}}}
	timeLine[37] = {50,100,bones[5].sprite,{rotation={11.53,11.53+0.9,"linear"}}}
	timeLine[38] = {1,49,bones[6].sprite,{rotation={52.04,52.04-3.21,"linear"}}}
	timeLine[39] = {50,100,bones[6].sprite,{rotation={48.83,48.83+3.21,"linear"}}}
	timeLine[40] = {1,49,bones[7].sprite,{rotation={39.74,39.74-2.56,"linear"}}}
	timeLine[41] = {50,100,bones[7].sprite,{rotation={37.18,37.18+2.56,"linear"}}}
	timeLine[42] = {1,49,bones[8].sprite,{rotation={0.83,0.83-6.81,"linear"}}}
	timeLine[43] = {50,100,bones[8].sprite,{rotation={354.02,354.02+6.81,"linear"}}}
	timeLine[44] = {1,49,bones[9].sprite,{x={27.49,32.06,"linear"},y={3.97,3.15,"linear"},scaleX={0.92,1.05,"linear"},rotation={1.82,1.82-4.73,"linear"}}}
	timeLine[45] = {50,100,bones[9].sprite,{x={32.06,27.49,"linear"},y={3.15,3.97,"linear"},scaleX={1.05,0.92,"linear"},rotation={357.09,357.09+4.73,"linear"}}}
	timeLine[46] = {1,49,bones[10].sprite,{x={18.65,25.55,"linear"},y={1.31,2.96,"linear"},scaleX={1.23,1.38,"linear"},rotation={29.70,29.70-12.79,"linear"}}}
	timeLine[47] = {50,100,bones[10].sprite,{x={25.55,18.65,"linear"},y={2.96,1.31,"linear"},scaleX={1.38,1.23,"linear"},rotation={16.91,16.91+12.79,"linear"}}}


	-- Hit 

	timeLine[48] = {100,110,bones[11].sprite,{x={29.63,28.89,"linear"},y={43.39,43.11,"linear"},rotation={12.21,12.21-35.86,"linear"}}}
	timeLine[49] = {111,113,bones[11].sprite,{x={28.89,28.98,"linear"},y={43.11,43.15,"linear"},rotation={336.35,336.35-2.7,"linear"}}}
	timeLine[50] = {114,139,bones[11].sprite,{x={28.98,29.63,"linear"},y={43.15,43.39,"linear"},rotation={333.65,333.65+38.56,"linear"}}}
	timeLine[51] = {100,114,bones[19].sprite,{x={25.29,14.02,"linear"},y={35.15,34.2,"linear"},rotation={93.09,93.09-39.65,"linear"}}}
	timeLine[52] = {115,139,bones[19].sprite,{x={14.02,25.29,"linear"},y={34.2,35.15,"linear"},rotation={53.44,53.44+39.65,"linear"}}}
	timeLine[53] = {100,113,bones[3].sprite,{x={14.00,13.81,"linear"},y={-0.92,-3.88,"linear"},rotation={7.12,7.12+46.65,"linear"}}}
	timeLine[54] = {114,114,bones[3].sprite,{x={13.81,13.79,"linear"},y={-3.88,-4.12,"linear"},rotation={53.77,53.77+3.83,"linear"}}}
	timeLine[55] = {115,139,bones[3].sprite,{x={13.79,14.00,"linear"},y={-4.12,-0.92,"linear"},rotation={57.60,57.60-50.48,"linear"}}}
	timeLine[56] = {100,117,bones[1].sprite,{x={49.60,47.13,"linear"},y={46.27,37.68,"linear"},rotation={44.54,44.54-94.56,"linear"}}}
	timeLine[57] = {118,139,bones[1].sprite,{x={47.13,49.60,"linear"},y={37.68,46.27,"linear"},rotation={309.98,309.98+94.56,"linear"}}}
	timeLine[58] = {100,113,bones[13].sprite,{rotation={93.78,93.78-71.36,"linear"}}}
	timeLine[59] = {114,139,bones[13].sprite,{rotation={22.42,22.42+71.36,"linear"}}}
	timeLine[60] = {100,113,bones[14].sprite,{rotation={241.49,241.49-35.57,"linear"}}}
	timeLine[61] = {114,139,bones[14].sprite,{rotation={205.92,205.92+35.57,"linear"}}}
	timeLine[62] = {100,113,bones[15].sprite,{rotation={34.66,34.66+10.87,"linear"}}}
	timeLine[63] = {114,139,bones[15].sprite,{rotation={45.53,45.53-10.87,"linear"}}}
	timeLine[64] = {100,113,bones[18].sprite,{rotation={5.54,5.54+30.63,"linear"}}}
	timeLine[65] = {114,139,bones[18].sprite,{rotation={36.17,36.17-30.63,"linear"}}}
	timeLine[66] = {100,113,bones[17].sprite,{rotation={342.07,342.07+16.77,"linear"}}}
	timeLine[67] = {114,139,bones[17].sprite,{rotation={358.84,358.84-16.77,"linear"}}}
	timeLine[68] = {100,113,bones[4].sprite,{x={22.85,22.08,"linear"},y={47.9,47.88,"linear"},rotation={65.81,65.81-7.22,"linear"}}}
	timeLine[69] = {114,139,bones[4].sprite,{x={22.08,22.85,"linear"},y={47.88,47.9,"linear"},rotation={58.59,58.59+7.22,"linear"}}}
	timeLine[70] = {100,113,bones[5].sprite,{rotation={12.43,12.43+6.25,"linear"}}}
	timeLine[71] = {114,139,bones[5].sprite,{rotation={18.68,18.68-6.25,"linear"}}}
	timeLine[72] = {100,113,bones[6].sprite,{rotation={52.04,52.04+1.53,"linear"}}}
	timeLine[73] = {114,139,bones[6].sprite,{rotation={53.57,53.57-1.53,"linear"}}}
	timeLine[74] = {100,113,bones[7].sprite,{rotation={39.74,39.74-0.29,"linear"}}}
	timeLine[75] = {114,139,bones[7].sprite,{rotation={39.45,39.45+0.29,"linear"}}}
	timeLine[76] = {100,113,bones[8].sprite,{rotation={0.83,0.83-3.83,"linear"}}}
	timeLine[77] = {114,139,bones[8].sprite,{rotation={357.00,357.00+3.83,"linear"}}}
	timeLine[78] = {100,113,bones[9].sprite,{rotation={1.82,1.82-9.84,"linear"}}}
	timeLine[79] = {114,139,bones[9].sprite,{rotation={351.98,351.98+9.84,"linear"}}}
	timeLine[80] = {100,113,bones[10].sprite,{rotation={29.70,29.70-10.18,"linear"}}}
	timeLine[81] = {114,139,bones[10].sprite,{rotation={19.52,19.52+10.18,"linear"}}}


-- Die 

timeLine[82] = {139,152,bones[0].sprite,{x={30.36,31.71,"linear"},y={21.53,18.5,"linear"}}}
timeLine[83] = {153,155,bones[0].sprite,{x={31.71,31.38,"linear"},y={18.5,18.5,"linear"}}}
timeLine[84] = {156,156,bones[0].sprite,{x={31.38,31.25,"linear"},y={18.5,18.5,"linear"}}}
timeLine[85] = {139,152,bones[11].sprite,{x={28.99,42.25,"linear"},y={43.15,62.57,"linear"},rotation={1.90,1.90+16.76,"linear"}}}
timeLine[86] = {153,156,bones[11].sprite,{x={42.25,42.90,"linear"},y={62.57,59.36,"linear"}}}
timeLine[87] = {157,160,bones[11].sprite,{x={42.90,42.67,"linear"},y={59.36,60.93,"linear"}}}
timeLine[88] = {161,168,bones[11].sprite,{x={42.67,42.25,"linear"},y={60.93,62.57,"linear"}}}
timeLine[89] = {139,152,bones[19].sprite,{x={14.65,34.28,"linear"},y={34.26,52.36,"linear"},rotation={75.41,75.41+6.02,"linear"}}}
timeLine[90] = {153,156,bones[19].sprite,{x={34.28,34.06,"linear"},y={52.36,51.01,"linear"}}}
timeLine[91] = {157,168,bones[19].sprite,{x={34.06,34.28,"linear"},y={51.01,52.36,"linear"}}}
timeLine[92] = {139,152,bones[3].sprite,{x={13.80,14.00,"linear"},y={-4.01,-0.92,"linear"},rotation={55.84,55.84-48.72,"linear"}}}
timeLine[93] = {139,152,bones[1].sprite,{x={47.63,49.60,"linear"},y={39.43,46.27,"linear"},rotation={5.14,5.14+39.4,"linear"}}}
timeLine[94] = {139,152,bones[13].sprite,{x={30.71,43.41,"linear"},y={47.72,65.6,"linear"},rotation={22.42,22.42+40.37,"linear"}}}
timeLine[95] = {153,155,bones[13].sprite,{x={43.41,44.75,"linear"},y={65.6,65.64,"linear"},rotation={62.79,62.79-4.41,"linear"}}}
timeLine[96] = {156,168,bones[13].sprite,{x={44.75,45.06,"linear"},y={65.64,67.11,"linear"},rotation={58.38,58.38-1.89,"linear"}}}
timeLine[97] = {139,152,bones[14].sprite,{rotation={283.11,283.11-27.5,"linear"}}}
timeLine[98] = {153,155,bones[14].sprite,{x={28.10,29.34,"linear"},y={1.04,-0.83,"linear"},rotation={255.61,255.61+47.44,"linear"}}}
timeLine[99] = {139,152,bones[15].sprite,{rotation={47.42,47.42-54.46,"linear"}}}
timeLine[100] = {153,155,bones[15].sprite,{x={32.63,37.92,"linear"},y={1.3,1.34,"linear"},rotation={352.96,352.96+8.64,"linear"}}}
timeLine[101] = {139,152,bones[18].sprite,{rotation={36.17,36.17-7.13,"linear"}}}
timeLine[102] = {153,155,bones[16].sprite,{rotation={313.86,313.86+57.51,"linear"}}}
timeLine[103] = {139,152,bones[17].sprite,{rotation={358.84,358.84+33.07,"linear"}}}
timeLine[104] = {139,145,bones[4].sprite,{x={22.08,31.57,"linear"},y={47.88,53.84,"linear"},rotation={58.59,58.59+29.97,"linear"}}}
timeLine[105] = {146,152,bones[4].sprite,{x={31.57,41.04,"linear"},y={53.84,61.39,"linear"},rotation={88.56,88.56+30.08,"linear"}}}
timeLine[106] = {153,155,bones[4].sprite,{x={41.04,41.36,"linear"},y={61.39,61.59,"linear"}}}
timeLine[107] = {156,156,bones[4].sprite,{x={41.36,41.50,"linear"},y={61.59,61.4,"linear"}}}
timeLine[108] = {139,152,bones[5].sprite,{rotation={18.68,18.68+18.41,"linear"}}}
timeLine[109] = {139,152,bones[6].sprite,{rotation={53.57,53.57-31.2,"linear"}}}
timeLine[110] = {139,152,bones[7].sprite,{x={40.95,41.04,"linear"},y={2.72,1.22,"linear"},rotation={39.45,39.45-36.85,"linear"}}}
timeLine[111] = {153,168,bones[7].sprite,{x={41.04,40.95,"linear"},y={1.22,2.72,"linear"}}}
timeLine[112] = {139,152,bones[8].sprite,{x={36.72,36.75,"linear"},y={-3.8,-5.32,"linear"},rotation={357.00,357.00-6.19,"linear"}}}
timeLine[113] = {153,168,bones[8].sprite,{x={36.75,36.72,"linear"},y={-5.32,-3.8,"linear"}}}
timeLine[114] = {139,152,bones[9].sprite,{rotation={351.98,351.98+6.98,"linear"}}}
timeLine[115] = {139,152,bones[10].sprite,{x={18.65,15.48,"linear"},y={1.31,3.43,"linear"},rotation={19.52,19.52-11.11,"linear"}}}

	self.mc = MovieClip.new(timeLine)
	self.mc:setGotoAction(100,1)

end

--]]