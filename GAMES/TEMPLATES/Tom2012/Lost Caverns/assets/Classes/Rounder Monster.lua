RounderMonster = Core.class(Sprite);

function RounderMonster:init(scene,x,y,radius,rotationSpeed)

	self.scene = scene
	self.rotationSpeed = tonumber(rotationSpeed)
	
	-- set up atlas if not already created
		

	if(not(self.scene.rounderMonsterAtlas)) then
		self.scene.rounderMonsterAtlas = TexturePack.new("Atlases/Rounder Monster.txt", "Atlases/Rounder Monster.png",true)
	end
	
	-- setup the animation

--	Timer.delayedCall(math.random(100,1000), function()
		self:createAnim()
		self.scene.behindRube:addChild(self)
--	end)

	-- Hitbox stuff
	

--	self.damage = 2 -- how much hurts hero

	table.insert(self.scene.enemies, self)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(50,16,0,15,0)
	local fixture = body:createFixture{shape = poly, density = .01, friction = 0, restitution = 0}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,10,5,-10,0)
	local fixture = body:createFixture{shape = poly, density = .01, friction = 0, restitution = 0}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	self.body = body
	self.body.name = "enemy"

	body:setGravityScale(0)

	table.insert(self.scene.spritesOnScreen, self)
	
	Timer.delayedCall(10, function()
		--create empty box2d body for joint
		local ground = self.scene.world:createBody({})
		local bodyX, bodyY = self.body:getPosition()
		local jointDef = b2.createRevoluteJointDef(self.body, ground,bodyX,bodyY+radius)
		self.revoluteJoint = self.scene.world:createJoint(jointDef)
		self.revoluteJoint:enableMotor(true)
		self.revoluteJoint:setMotorSpeed(math.rad(self.rotationSpeed))
		
		self.revoluteJoint:setMaxMotorTorque(6)

	end)

	-- sounds
	
	self.maxVolume = .40
	self.volume = 0
	
	if(not(self.scene.chompSound)) then
	
		self.scene.chompSound = Sound.new("Sounds/chomp.wav")
		self.scene.chompSound2 = Sound.new("Sounds/chomp2.wav")
	
	end
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)

end






function RounderMonster:pause()

	self.mc:stop()

end




function RounderMonster:resume()

	self.mc:play()

end







function RounderMonster:createAnim()

	local mainSprite = Sprite.new()
	self:addChild(mainSprite)
	self.mainSprite = mainSprite

	if(self.rotationSpeed < 0) then
		self.mainSprite:setScaleX(-1)
		mainSprite:setPosition(90,-50)
	else
		mainSprite:setPosition(-90,-50)
	end


	local bones = {}

	-- Setup bones

	-- bone_024

	local sprite = Sprite.new()
	mainSprite:addChild(sprite)
	bones[0] = {}
	bones[0].sprite = sprite

	-- bone_000

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[1] = {}
	bones[1].sprite = sprite

	-- bone_015

	local sprite = Sprite.new()
	bones[1].sprite:addChild(sprite)
	bones[2] = {}
	bones[2].sprite = sprite

	-- bone_016

	local sprite = Sprite.new()
	bones[2].sprite:addChild(sprite)
	bones[3] = {}
	bones[3].sprite = sprite

	-- bone_017

	local sprite = Sprite.new()
	bones[3].sprite:addChild(sprite)
	bones[4] = {}
	bones[4].sprite = sprite

	-- bone_018

	local sprite = Sprite.new()
	bones[4].sprite:addChild(sprite)
	bones[5] = {}
	bones[5].sprite = sprite

	-- bone_019

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[6] = {}
	bones[6].sprite = sprite

	-- bone_020

	local sprite = Sprite.new()
	bones[6].sprite:addChild(sprite)
	bones[7] = {}
	bones[7].sprite = sprite

	-- bone_021

	local sprite = Sprite.new()
	bones[7].sprite:addChild(sprite)
	bones[8] = {}
	bones[8].sprite = sprite

	-- bone_022

	local sprite = Sprite.new()
	bones[8].sprite:addChild(sprite)
	bones[9] = {}
	bones[9].sprite = sprite

	-- bone_023

	local sprite = Sprite.new()
	bones[9].sprite:addChild(sprite)
	bones[10] = {}
	bones[10].sprite = sprite

	-- bone_007

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[11] = {}
	bones[11].sprite = sprite

	-- bone_008

	local sprite = Sprite.new()
	bones[11].sprite:addChild(sprite)
	bones[12] = {}
	bones[12].sprite = sprite

	-- bone_009

	local sprite = Sprite.new()
	bones[12].sprite:addChild(sprite)
	bones[13] = {}
	bones[13].sprite = sprite

	-- bone_010

	local sprite = Sprite.new()
	bones[13].sprite:addChild(sprite)
	bones[14] = {}
	bones[14].sprite = sprite

	-- bone_011

	local sprite = Sprite.new()
	bones[14].sprite:addChild(sprite)
	bones[15] = {}
	bones[15].sprite = sprite

	-- bone_002

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[16] = {}
	bones[16].sprite = sprite

	-- bone_003

	local sprite = Sprite.new()
	bones[16].sprite:addChild(sprite)
	bones[17] = {}
	bones[17].sprite = sprite

	-- bone_004

	local sprite = Sprite.new()
	bones[17].sprite:addChild(sprite)
	bones[18] = {}
	bones[18].sprite = sprite

	-- bone_005

	local sprite = Sprite.new()
	bones[18].sprite:addChild(sprite)
	bones[19] = {}
	bones[19].sprite = sprite

	-- bone_006

	local sprite = Sprite.new()
	bones[19].sprite:addChild(sprite)
	bones[20] = {}
	bones[20].sprite = sprite

	-- Head Bone

	local sprite = Sprite.new()
	bones[0].sprite:addChild(sprite)
	bones[21] = {}
	bones[21].sprite = sprite

	-- Leaf 2 Bone

	local sprite = Sprite.new()
	bones[21].sprite:addChild(sprite)
	bones[22] = {}
	bones[22].sprite = sprite

	-- Leaf 1 Bone

	local sprite = Sprite.new()
	bones[21].sprite:addChild(sprite)
	bones[23] = {}
	bones[23].sprite = sprite

	-- Leaf 3 Bone

	local sprite = Sprite.new()
	bones[21].sprite:addChild(sprite)
	bones[24] = {}
	bones[24].sprite = sprite

	-- Setup image sprites

	local sprites = {}

	-- rounder head ---------

	sprites[0] = {}
	local sprite = Sprite.new()
	bones[21].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("rounder head.png"))
	sprite:addChild(img)
	sprites[0].sprite = sprite

	-- thick leg 5 ---------

	sprites[2] = {}
	local sprite = Sprite.new()
	bones[20].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 5.png"))
	sprite:addChild(img)
	sprites[2].sprite = sprite

	-- thick leg 4 ---------

	sprites[3] = {}
	local sprite = Sprite.new()
	bones[19].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 4.png"))
	sprite:addChild(img)
	sprites[3].sprite = sprite

	-- thick leg 3 ---------

	sprites[4] = {}
	local sprite = Sprite.new()
	bones[18].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 3.png"))
	sprite:addChild(img)
	sprites[4].sprite = sprite

	-- thick leg 2 ---------

	sprites[5] = {}
	local sprite = Sprite.new()
	bones[17].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 2.png"))
	sprite:addChild(img)
	sprites[5].sprite = sprite

	-- thick leg 1 ---------

	sprites[6] = {}
	local sprite = Sprite.new()
	bones[16].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 1.png"))
	sprite:addChild(img)
	sprites[6].sprite = sprite

	-- thick leg 5_000 ---------

	sprites[12] = {}
	local sprite = Sprite.new()
	bones[15].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 5.png"))
	sprite:addChild(img)
	sprites[12].sprite = sprite

	-- thick leg 4_000 ---------

	sprites[13] = {}
	local sprite = Sprite.new()
	bones[14].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 4.png"))
	sprite:addChild(img)
	sprites[13].sprite = sprite

	-- thick leg 3_000 ---------

	sprites[14] = {}
	local sprite = Sprite.new()
	bones[13].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 3.png"))
	sprite:addChild(img)
	sprites[14].sprite = sprite

	-- thick leg 2_000 ---------

	sprites[15] = {}
	local sprite = Sprite.new()
	bones[12].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 2.png"))
	sprite:addChild(img)
	sprites[15].sprite = sprite

	-- thick leg 1_000 ---------

	sprites[16] = {}
	local sprite = Sprite.new()
	bones[11].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thick leg 1.png"))
	sprite:addChild(img)
	sprites[16].sprite = sprite

	-- twig2 ---------

	sprites[22] = {}
	local sprite = Sprite.new()
	bones[22].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("twig2.png"))
	sprite:addChild(img)
	sprites[22].sprite = sprite

	-- twig1 ---------

	sprites[23] = {}
	local sprite = Sprite.new()
	bones[23].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("twig1.png"))
	sprite:addChild(img)
	sprites[23].sprite = sprite

	-- twig3 ---------

	sprites[24] = {}
	local sprite = Sprite.new()
	bones[24].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("twig3.png"))
	sprite:addChild(img)
	sprites[24].sprite = sprite

	-- thin leg 5 ---------

	sprites[28] = {}
	local sprite = Sprite.new()
	bones[5].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 5.png"))
	sprite:addChild(img)
	sprites[28].sprite = sprite

	-- thin leg 4 ---------

	sprites[29] = {}
	local sprite = Sprite.new()
	bones[4].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 4.png"))
	sprite:addChild(img)
	sprites[29].sprite = sprite

	-- thin leg 3 ---------

	sprites[30] = {}
	local sprite = Sprite.new()
	bones[3].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 3.png"))
	sprite:addChild(img)
	sprites[30].sprite = sprite

	-- thin leg 2 ---------

	sprites[31] = {}
	local sprite = Sprite.new()
	bones[2].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 2.png"))
	sprite:addChild(img)
	sprites[31].sprite = sprite

	-- thin leg 1 ---------

	sprites[32] = {}
	local sprite = Sprite.new()
	bones[1].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 1.png"))
	sprite:addChild(img)
	sprites[32].sprite = sprite

	-- thin leg 5_000 ---------

	sprites[33] = {}
	local sprite = Sprite.new()
	bones[10].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 5.png"))
	sprite:addChild(img)
	sprites[33].sprite = sprite

	-- thin leg 4_000 ---------

	sprites[34] = {}
	local sprite = Sprite.new()
	bones[9].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 4.png"))
	sprite:addChild(img)
	sprites[34].sprite = sprite

	-- thin leg 3_000 ---------

	sprites[35] = {}
	local sprite = Sprite.new()
	bones[8].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 3.png"))
	sprite:addChild(img)
	sprites[35].sprite = sprite

	-- thin leg 2_000 ---------

	sprites[36] = {}
	local sprite = Sprite.new()
	bones[7].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 2.png"))
	sprite:addChild(img)
	sprites[36].sprite = sprite

	-- thin leg 1_000 ---------

	sprites[37] = {}
	local sprite = Sprite.new()
	bones[6].sprite:addChild(sprite)
	local img = Bitmap.new(self.scene.rounderMonsterAtlas:getTextureRegion("thin leg 1.png"))
	sprite:addChild(img)
	sprites[37].sprite = sprite

	-- Adjust the sprites (from first frame of timelines)

	-- rounder head

	sprites[0].sprite:setX(-11.37)
	sprites[0].sprite:setY(-39.27)


	-- Head Bone

	bones[21].sprite:setX(31.88)
	bones[21].sprite:setY(81.13)
	bones[21].sprite:setScaleX(0.91)
	bones[21].sprite:setRotation(265.40)


	-- thick leg 5

	sprites[2].sprite:setX(-2.51)
	sprites[2].sprite:setY(-3.24)
	sprites[2].sprite:setScaleX(3.50)
	sprites[2].sprite:setRotation(359.61)


	-- thick leg 4

	sprites[3].sprite:setX(-11.05)
	sprites[3].sprite:setY(-16.66)
	sprites[3].sprite:setScaleX(3.50)
	sprites[3].sprite:setScaleY(3.51)


	-- thick leg 3

	sprites[4].sprite:setX(-10.21)
	sprites[4].sprite:setY(-15.12)
	sprites[4].sprite:setScaleX(2.53)
	sprites[4].sprite:setScaleY(2.53)


	-- thick leg 2

	sprites[5].sprite:setX(-12.85)
	sprites[5].sprite:setY(-18.33)
	sprites[5].sprite:setScaleX(3.07)
	sprites[5].sprite:setScaleY(3.08)
	sprites[5].sprite:setRotation(359.41)


	-- thick leg 1

	sprites[6].sprite:setX(-8.20)
	sprites[6].sprite:setY(-16.18)
	sprites[6].sprite:setScaleX(2.08)
	sprites[6].sprite:setScaleY(2.09)


	-- bone_002

	bones[16].sprite:setX(41.74)
	bones[16].sprite:setY(84.3)
	bones[16].sprite:setScaleX(0.48)
	bones[16].sprite:setScaleY(0.48)
	bones[16].sprite:setRotation(301.25)


	-- bone_003

	bones[17].sprite:setX(49.00)
	bones[17].sprite:setY(-0.52)
	bones[17].sprite:setScaleX(0.68)
	bones[17].sprite:setScaleY(0.68)
	bones[17].sprite:setRotation(60.76)


	-- bone_004

	bones[18].sprite:setX(47.72)
	bones[18].sprite:setY(-4.19)
	bones[18].sprite:setScaleX(1.21)
	bones[18].sprite:setScaleY(1.21)
	bones[18].sprite:setRotation(27.36)


	-- bone_005

	bones[19].sprite:setX(51.65)
	bones[19].sprite:setY(1.05)
	bones[19].sprite:setScaleX(0.72)
	bones[19].sprite:setScaleY(0.72)
	bones[19].sprite:setRotation(48.17)


	-- bone_006

	bones[20].sprite:setX(49.64)
	bones[20].sprite:setY(6.22)
	bones[20].sprite:setScaleY(3.51)
	bones[20].sprite:setRotation(312.70)


	-- thick leg 5_000

	sprites[12].sprite:setX(-1.94)
	sprites[12].sprite:setY(-3.48)
	sprites[12].sprite:setScaleX(3.76)
	sprites[12].sprite:setRotation(359.32)


	-- thick leg 4_000

	sprites[13].sprite:setX(-8.79)
	sprites[13].sprite:setY(-15.66)
	sprites[13].sprite:setScaleX(3.18)
	sprites[13].sprite:setScaleY(3.19)


	-- thick leg 3_000

	sprites[14].sprite:setX(-10.64)
	sprites[14].sprite:setY(-13.45)
	sprites[14].sprite:setScaleX(2.36)
	sprites[14].sprite:setScaleY(2.36)


	-- thick leg 2_000

	sprites[15].sprite:setX(-7.74)
	sprites[15].sprite:setY(-15.49)
	sprites[15].sprite:setScaleX(2.50)
	sprites[15].sprite:setScaleY(2.51)


	-- thick leg 1_000

	sprites[16].sprite:setX(-4.63)
	sprites[16].sprite:setY(-14.53)
	sprites[16].sprite:setScaleX(1.87)
	sprites[16].sprite:setScaleY(1.87)


	-- bone_007

	bones[11].sprite:setX(0.54)
	bones[11].sprite:setY(85.32)
	bones[11].sprite:setScaleX(-0.53)
	bones[11].sprite:setScaleY(0.53)
	bones[11].sprite:setRotation(60.73)


	-- bone_008

	bones[12].sprite:setX(46.15)
	bones[12].sprite:setY(-3.44)
	bones[12].sprite:setScaleX(0.75)
	bones[12].sprite:setScaleY(0.75)
	bones[12].sprite:setRotation(61.00)


	-- bone_009

	bones[13].sprite:setX(40.94)
	bones[13].sprite:setY(-3.23)
	bones[13].sprite:setScaleX(1.06)
	bones[13].sprite:setScaleY(1.06)
	bones[13].sprite:setRotation(22.67)


	-- bone_010

	bones[14].sprite:setX(43.21)
	bones[14].sprite:setY(-4.31)
	bones[14].sprite:setScaleX(0.74)
	bones[14].sprite:setScaleY(0.74)
	bones[14].sprite:setRotation(65.91)


	-- bone_011

	bones[15].sprite:setX(47.04)
	bones[15].sprite:setY(6.46)
	bones[15].sprite:setScaleX(0.85)
	bones[15].sprite:setScaleY(3.19)
	bones[15].sprite:setRotation(312.10)


	-- twig2

	sprites[22].sprite:setX(-2.85)
	sprites[22].sprite:setY(-22.16)
	sprites[22].sprite:setScaleX(1.50)
	sprites[22].sprite:setScaleY(1.50)


	-- twig1

	sprites[23].sprite:setX(-1.84)
	sprites[23].sprite:setY(-9.07)
	sprites[23].sprite:setScaleX(2.52)


	-- twig3

	sprites[24].sprite:setX(-3.29)
	sprites[24].sprite:setY(-19.93)
	sprites[24].sprite:setScaleX(1.88)


	-- Leaf 2 Bone

	bones[22].sprite:setX(41.68)
	bones[22].sprite:setY(-20.64)
	bones[22].sprite:setScaleX(0.74)
	bones[22].sprite:setScaleY(0.67)
	bones[22].sprite:setRotation(334.10)


	-- Leaf 1 Bone

	bones[23].sprite:setX(35.44)
	bones[23].sprite:setY(-33.88)
	bones[23].sprite:setScaleX(0.44)
	bones[23].sprite:setRotation(288.51)


	-- Leaf 3 Bone

	bones[24].sprite:setX(33.03)
	bones[24].sprite:setY(11.06)
	bones[24].sprite:setScaleX(0.59)
	bones[24].sprite:setRotation(37.55)


	-- thin leg 5

	sprites[28].sprite:setX(-8.76)
	sprites[28].sprite:setY(-2.5)
	sprites[28].sprite:setScaleX(4.47)


	-- thin leg 4

	sprites[29].sprite:setX(-4.62)
	sprites[29].sprite:setY(-12.88)
	sprites[29].sprite:setScaleX(3.99)
	sprites[29].sprite:setScaleY(4.01)


	-- thin leg 3

	sprites[30].sprite:setX(-5.89)
	sprites[30].sprite:setY(-10.74)
	sprites[30].sprite:setScaleX(2.86)
	sprites[30].sprite:setScaleY(2.86)


	-- thin leg 2

	sprites[31].sprite:setX(-9.13)
	sprites[31].sprite:setY(-14.79)
	sprites[31].sprite:setScaleX(3.39)
	sprites[31].sprite:setScaleY(3.40)


	-- thin leg 1

	sprites[32].sprite:setX(-5.67)
	sprites[32].sprite:setY(-12.81)
	sprites[32].sprite:setScaleX(2.40)
	sprites[32].sprite:setScaleY(2.40)


	-- thin leg 5_000

	sprites[33].sprite:setX(-8.51)
	sprites[33].sprite:setY(-2.56)
	sprites[33].sprite:setScaleX(4.73)


	-- thin leg 4_000

	sprites[34].sprite:setX(-9.92)
	sprites[34].sprite:setY(-13.02)
	sprites[34].sprite:setScaleX(4.10)
	sprites[34].sprite:setScaleY(4.12)


	-- thin leg 3_000

	sprites[35].sprite:setX(-9.22)
	sprites[35].sprite:setY(-10.29)
	sprites[35].sprite:setScaleX(2.87)
	sprites[35].sprite:setScaleY(2.88)


	-- thin leg 2_000

	sprites[36].sprite:setX(-8.66)
	sprites[36].sprite:setY(-14.79)
	sprites[36].sprite:setScaleX(3.63)
	sprites[36].sprite:setScaleY(3.65)


	-- thin leg 1_000

	sprites[37].sprite:setX(-6.37)
	sprites[37].sprite:setY(-14.66)
	sprites[37].sprite:setScaleX(2.72)
	sprites[37].sprite:setScaleY(2.72)


	-- bone_000

	bones[1].sprite:setX(40.66)
	bones[1].sprite:setY(60)
	bones[1].sprite:setScaleX(0.42)
	bones[1].sprite:setScaleY(0.42)
	bones[1].sprite:setRotation(336.31)


	-- bone_015

	bones[2].sprite:setX(42.80)
	bones[2].sprite:setY(-1.74)
	bones[2].sprite:setScaleX(0.71)
	bones[2].sprite:setScaleY(0.71)
	bones[2].sprite:setRotation(64.47)


	-- bone_016

	bones[3].sprite:setX(37.79)
	bones[3].sprite:setY(-4.54)
	bones[3].sprite:setScaleX(1.19)
	bones[3].sprite:setScaleY(1.19)
	bones[3].sprite:setRotation(50.15)


	-- bone_017

	bones[4].sprite:setX(43.76)
	bones[4].sprite:setY(-0.33)
	bones[4].sprite:setScaleX(0.72)
	bones[4].sprite:setScaleY(0.71)
	bones[4].sprite:setRotation(29.88)


	-- bone_018

	bones[5].sprite:setX(48.58)
	bones[5].sprite:setY(1.85)
	bones[5].sprite:setScaleX(0.89)
	bones[5].sprite:setScaleY(4.01)
	bones[5].sprite:setRotation(270.61)


	-- bone_019

	bones[6].sprite:setX(10.25)
	bones[6].sprite:setY(54.5)
	bones[6].sprite:setScaleX(-0.37)
	bones[6].sprite:setScaleY(0.37)
	bones[6].sprite:setRotation(19.09)


	-- bone_020

	bones[7].sprite:setX(47.52)
	bones[7].sprite:setY(-4.8)
	bones[7].sprite:setScaleX(0.75)
	bones[7].sprite:setScaleY(0.75)
	bones[7].sprite:setRotation(67.71)


	-- bone_021

	bones[8].sprite:setX(41.82)
	bones[8].sprite:setY(-0.17)
	bones[8].sprite:setScaleX(1.27)
	bones[8].sprite:setScaleY(1.27)
	bones[8].sprite:setRotation(26.79)


	-- bone_022

	bones[9].sprite:setX(40.55)
	bones[9].sprite:setY(1.2)
	bones[9].sprite:setScaleX(0.70)
	bones[9].sprite:setScaleY(0.70)
	bones[9].sprite:setRotation(343.08)


	-- bone_023

	bones[10].sprite:setX(40.63)
	bones[10].sprite:setY(3.56)
	bones[10].sprite:setScaleX(0.87)
	bones[10].sprite:setScaleY(4.12)
	bones[10].sprite:setRotation(331.99)


	-- bone_024

	bones[0].sprite:setX(72.75)
	bones[0].sprite:setY(6.25)


	-- rounder head

	sprites[0].sprite:setX(-11.37)
	sprites[0].sprite:setY(-39.27)


	-- Head Bone

	bones[21].sprite:setX(31.88)
	bones[21].sprite:setY(81.13)
	bones[21].sprite:setScaleX(0.91)
	bones[21].sprite:setRotation(265.40)


	-- Head Bone

	bones[21].sprite:setRotation(300.18)


	-- Head Bone

	bones[21].sprite:setRotation(266.61)


	-- Head Bone

	bones[21].sprite:setRotation(287.62)


	-- Head Bone

	bones[21].sprite:setRotation(265.40)


	-- thick leg 5

	sprites[2].sprite:setX(-2.51)
	sprites[2].sprite:setY(-3.24)
	sprites[2].sprite:setScaleX(3.50)
	sprites[2].sprite:setRotation(359.61)


	-- thick leg 4

	sprites[3].sprite:setX(-11.05)
	sprites[3].sprite:setY(-16.66)
	sprites[3].sprite:setScaleX(3.50)
	sprites[3].sprite:setScaleY(3.51)


	-- thick leg 3

	sprites[4].sprite:setX(-10.21)
	sprites[4].sprite:setY(-15.12)
	sprites[4].sprite:setScaleX(2.53)
	sprites[4].sprite:setScaleY(2.53)


	-- thick leg 2

	sprites[5].sprite:setX(-12.85)
	sprites[5].sprite:setY(-18.33)
	sprites[5].sprite:setScaleX(3.07)
	sprites[5].sprite:setScaleY(3.08)
	sprites[5].sprite:setRotation(359.41)


	-- thick leg 1

	sprites[6].sprite:setX(-8.20)
	sprites[6].sprite:setY(-16.18)
	sprites[6].sprite:setScaleX(2.08)
	sprites[6].sprite:setScaleY(2.09)


	-- bone_002

	bones[16].sprite:setX(41.74)
	bones[16].sprite:setY(84.3)
	bones[16].sprite:setScaleX(0.48)
	bones[16].sprite:setScaleY(0.48)
	bones[16].sprite:setRotation(301.25)


	-- bone_002

	bones[16].sprite:setRotation(289.07)


	-- bone_002

	bones[16].sprite:setRotation(301.25)


	-- bone_003

	bones[17].sprite:setX(49.00)
	bones[17].sprite:setY(-0.52)
	bones[17].sprite:setScaleX(0.68)
	bones[17].sprite:setScaleY(0.68)
	bones[17].sprite:setRotation(60.76)


	-- bone_003

	bones[17].sprite:setRotation(39.96)


	-- bone_003

	bones[17].sprite:setRotation(60.76)


	-- bone_004

	bones[18].sprite:setX(47.72)
	bones[18].sprite:setY(-4.19)
	bones[18].sprite:setScaleX(1.21)
	bones[18].sprite:setScaleY(1.21)
	bones[18].sprite:setRotation(27.36)


	-- bone_004

	bones[18].sprite:setRotation(82.66)


	-- bone_004

	bones[18].sprite:setRotation(27.36)


	-- bone_005

	bones[19].sprite:setX(51.65)
	bones[19].sprite:setY(1.05)
	bones[19].sprite:setScaleX(0.72)
	bones[19].sprite:setScaleY(0.72)
	bones[19].sprite:setRotation(48.17)


	-- bone_006

	bones[20].sprite:setX(54.14)
	bones[20].sprite:setY(11.33)
	bones[20].sprite:setScaleY(3.51)
	bones[20].sprite:setRotation(282.55)


	-- bone_006

	bones[20].sprite:setRotation(263.95)


	-- bone_006

	bones[20].sprite:setRotation(282.55)


	-- thick leg 5_000

	sprites[12].sprite:setX(-1.94)
	sprites[12].sprite:setY(-3.48)
	sprites[12].sprite:setScaleX(3.76)
	sprites[12].sprite:setRotation(359.32)


	-- thick leg 4_000

	sprites[13].sprite:setX(-8.79)
	sprites[13].sprite:setY(-15.66)
	sprites[13].sprite:setScaleX(3.18)
	sprites[13].sprite:setScaleY(3.19)


	-- thick leg 3_000

	sprites[14].sprite:setX(-10.64)
	sprites[14].sprite:setY(-13.45)
	sprites[14].sprite:setScaleX(2.36)
	sprites[14].sprite:setScaleY(2.36)


	-- thick leg 2_000

	sprites[15].sprite:setX(-7.74)
	sprites[15].sprite:setY(-15.49)
	sprites[15].sprite:setScaleX(2.50)
	sprites[15].sprite:setScaleY(2.51)


	-- thick leg 1_000

	sprites[16].sprite:setX(-4.63)
	sprites[16].sprite:setY(-14.53)
	sprites[16].sprite:setScaleX(1.87)
	sprites[16].sprite:setScaleY(1.87)


	-- bone_007

	bones[11].sprite:setX(0.54)
	bones[11].sprite:setY(85.32)
	bones[11].sprite:setScaleX(-0.53)
	bones[11].sprite:setScaleY(0.53)
	bones[11].sprite:setRotation(60.73)


	-- bone_007

	bones[11].sprite:setRotation(76.06)


	-- bone_007

	bones[11].sprite:setRotation(67.73)


	-- bone_007

	bones[11].sprite:setRotation(60.73)


	-- bone_008

	bones[12].sprite:setX(46.15)
	bones[12].sprite:setY(-3.44)
	bones[12].sprite:setScaleX(0.75)
	bones[12].sprite:setScaleY(0.75)
	bones[12].sprite:setRotation(61.00)


	-- bone_008

	bones[12].sprite:setRotation(72.16)


	-- bone_008

	bones[12].sprite:setRotation(43.40)


	-- bone_008

	bones[12].sprite:setRotation(61.00)


	-- bone_009

	bones[13].sprite:setX(40.94)
	bones[13].sprite:setY(-3.23)
	bones[13].sprite:setScaleX(1.06)
	bones[13].sprite:setScaleY(1.06)
	bones[13].sprite:setRotation(22.67)


	-- bone_009

	bones[13].sprite:setRotation(64.77)


	-- bone_009

	bones[13].sprite:setRotation(32.72)


	-- bone_009

	bones[13].sprite:setRotation(22.67)


	-- bone_010

	bones[14].sprite:setX(47.56)
	bones[14].sprite:setY(0.81)
	bones[14].sprite:setScaleX(0.74)
	bones[14].sprite:setScaleY(0.74)
	bones[14].sprite:setRotation(65.91)


	-- bone_011

	bones[15].sprite:setX(47.04)
	bones[15].sprite:setY(6.46)
	bones[15].sprite:setScaleX(0.85)
	bones[15].sprite:setScaleY(3.19)
	bones[15].sprite:setRotation(281.16)


	-- bone_011

	bones[15].sprite:setRotation(235.15)


	-- bone_011

	bones[15].sprite:setRotation(260.14)


	-- bone_011

	bones[15].sprite:setRotation(281.16)


	-- twig2

	sprites[22].sprite:setX(-2.85)
	sprites[22].sprite:setY(-22.16)
	sprites[22].sprite:setScaleX(1.50)
	sprites[22].sprite:setScaleY(1.50)


	-- twig1

	sprites[23].sprite:setX(-1.84)
	sprites[23].sprite:setY(-9.07)
	sprites[23].sprite:setScaleX(2.52)


	-- twig3

	sprites[24].sprite:setX(-3.29)
	sprites[24].sprite:setY(-19.93)
	sprites[24].sprite:setScaleX(1.88)


	-- Leaf 2 Bone

	bones[22].sprite:setX(41.68)
	bones[22].sprite:setY(-20.64)
	bones[22].sprite:setScaleX(0.74)
	bones[22].sprite:setScaleY(0.67)
	bones[22].sprite:setRotation(334.10)


	-- Leaf 2 Bone

	bones[22].sprite:setRotation(304.36)


	-- Leaf 2 Bone

	bones[22].sprite:setRotation(334.10)


	-- Leaf 1 Bone

	bones[23].sprite:setX(35.44)
	bones[23].sprite:setY(-33.88)
	bones[23].sprite:setScaleX(0.44)
	bones[23].sprite:setRotation(288.51)


	-- Leaf 1 Bone

	bones[23].sprite:setRotation(257.75)


	-- Leaf 1 Bone

	bones[23].sprite:setRotation(332.34)


	-- Leaf 1 Bone

	bones[23].sprite:setRotation(288.51)


	-- Leaf 3 Bone

	bones[24].sprite:setX(33.03)
	bones[24].sprite:setY(11.06)
	bones[24].sprite:setScaleX(0.59)
	bones[24].sprite:setRotation(37.55)


	-- Leaf 3 Bone

	bones[24].sprite:setRotation(62.48)


	-- Leaf 3 Bone

	bones[24].sprite:setRotation(37.55)


	-- thin leg 5

	sprites[28].sprite:setX(-8.76)
	sprites[28].sprite:setY(-2.5)
	sprites[28].sprite:setScaleX(4.47)


	-- thin leg 4

	sprites[29].sprite:setX(-4.62)
	sprites[29].sprite:setY(-12.88)
	sprites[29].sprite:setScaleX(3.99)
	sprites[29].sprite:setScaleY(4.01)


	-- thin leg 3

	sprites[30].sprite:setX(-5.89)
	sprites[30].sprite:setY(-10.74)
	sprites[30].sprite:setScaleX(2.86)
	sprites[30].sprite:setScaleY(2.86)


	-- thin leg 2

	sprites[31].sprite:setX(-9.13)
	sprites[31].sprite:setY(-14.79)
	sprites[31].sprite:setScaleX(3.39)
	sprites[31].sprite:setScaleY(3.40)


	-- thin leg 1

	sprites[32].sprite:setX(-5.67)
	sprites[32].sprite:setY(-12.81)
	sprites[32].sprite:setScaleX(2.40)
	sprites[32].sprite:setScaleY(2.40)


	-- thin leg 5_000

	sprites[33].sprite:setX(-8.51)
	sprites[33].sprite:setY(-2.56)
	sprites[33].sprite:setScaleX(4.73)


	-- thin leg 4_000

	sprites[34].sprite:setX(-9.92)
	sprites[34].sprite:setY(-13.02)
	sprites[34].sprite:setScaleX(4.10)
	sprites[34].sprite:setScaleY(4.12)


	-- thin leg 3_000

	sprites[35].sprite:setX(-9.22)
	sprites[35].sprite:setY(-10.29)
	sprites[35].sprite:setScaleX(2.87)
	sprites[35].sprite:setScaleY(2.88)


	-- thin leg 2_000

	sprites[36].sprite:setX(-8.66)
	sprites[36].sprite:setY(-14.79)
	sprites[36].sprite:setScaleX(3.63)
	sprites[36].sprite:setScaleY(3.65)


	-- thin leg 1_000

	sprites[37].sprite:setX(-6.37)
	sprites[37].sprite:setY(-14.66)
	sprites[37].sprite:setScaleX(2.72)
	sprites[37].sprite:setScaleY(2.72)


	-- bone_000

	bones[1].sprite:setX(40.66)
	bones[1].sprite:setY(60)
	bones[1].sprite:setScaleX(0.42)
	bones[1].sprite:setScaleY(0.42)
	bones[1].sprite:setRotation(336.31)


	-- bone_000

	bones[1].sprite:setRotation(328.41)


	-- bone_000

	bones[1].sprite:setRotation(336.31)


	-- bone_000



	-- bone_015

	bones[2].sprite:setX(42.80)
	bones[2].sprite:setY(-1.74)
	bones[2].sprite:setScaleX(0.71)
	bones[2].sprite:setScaleY(0.71)
	bones[2].sprite:setRotation(64.47)


	-- bone_015

	bones[2].sprite:setRotation(44.19)


	-- bone_015

	bones[2].sprite:setRotation(56.13)


	-- bone_015

	bones[2].sprite:setRotation(64.47)


	-- bone_016

	bones[3].sprite:setX(37.79)
	bones[3].sprite:setY(-4.54)
	bones[3].sprite:setScaleX(1.19)
	bones[3].sprite:setScaleY(1.19)
	bones[3].sprite:setRotation(50.15)


	-- bone_016

	bones[3].sprite:setRotation(70.34)


	-- bone_016

	bones[3].sprite:setRotation(24.12)


	-- bone_016

	bones[3].sprite:setRotation(50.15)


	-- bone_017

	bones[4].sprite:setX(43.76)
	bones[4].sprite:setY(-0.33)
	bones[4].sprite:setScaleX(0.72)
	bones[4].sprite:setScaleY(0.71)
	bones[4].sprite:setRotation(29.88)


	-- bone_018

	bones[5].sprite:setX(48.58)
	bones[5].sprite:setY(1.85)
	bones[5].sprite:setScaleX(0.89)
	bones[5].sprite:setScaleY(4.01)
	bones[5].sprite:setRotation(242.55)


	-- bone_018

	bones[5].sprite:setRotation(258.46)


	-- bone_018

	bones[5].sprite:setRotation(277.20)


	-- bone_018

	bones[5].sprite:setRotation(242.55)


	-- bone_019

	bones[6].sprite:setX(10.25)
	bones[6].sprite:setY(54.5)
	bones[6].sprite:setScaleX(-0.37)
	bones[6].sprite:setScaleY(0.37)
	bones[6].sprite:setRotation(19.09)


	-- bone_019

	bones[6].sprite:setRotation(1.84)


	-- bone_019

	bones[6].sprite:setRotation(19.09)


	-- bone_020

	bones[7].sprite:setX(47.52)
	bones[7].sprite:setY(-4.8)
	bones[7].sprite:setScaleX(0.75)
	bones[7].sprite:setScaleY(0.75)
	bones[7].sprite:setRotation(67.71)


	-- bone_020

	bones[7].sprite:setRotation(5.64)


	-- bone_020

	bones[7].sprite:setRotation(33.42)


	-- bone_020

	bones[7].sprite:setRotation(67.71)


	-- bone_021

	bones[8].sprite:setX(41.82)
	bones[8].sprite:setY(-0.17)
	bones[8].sprite:setScaleX(1.27)
	bones[8].sprite:setScaleY(1.27)
	bones[8].sprite:setRotation(26.79)


	-- bone_021

	bones[8].sprite:setRotation(54.08)


	-- bone_021

	bones[8].sprite:setRotation(26.79)


	-- bone_022

	bones[9].sprite:setX(40.55)
	bones[9].sprite:setY(1.2)
	bones[9].sprite:setScaleX(0.70)
	bones[9].sprite:setScaleY(0.70)
	bones[9].sprite:setRotation(343.08)


	-- bone_022

	bones[9].sprite:setRotation(65.93)


	-- bone_022

	bones[9].sprite:setRotation(6.91)


	-- bone_022

	bones[9].sprite:setRotation(343.08)


	-- bone_023

	bones[10].sprite:setX(40.63)
	bones[10].sprite:setY(3.56)
	bones[10].sprite:setScaleX(0.87)
	bones[10].sprite:setScaleY(4.12)
	bones[10].sprite:setRotation(314.46)


	-- bone_023

	bones[10].sprite:setRotation(306.68)


	-- bone_023

	bones[10].sprite:setRotation(297.51)


	-- bone_023

	bones[10].sprite:setRotation(314.46)


	-- bone_024

	bones[0].sprite:setX(72.75)
	bones[0].sprite:setY(6.25)



	local timeLine = {}

	-- NewAnimation 

	timeLine[1] = {1,27,bones[21].sprite,{x={31.88,33.74,"outQuadratic"},y={81.13,71.27,"outQuadratic"},rotation={265.40,265.40+34.78,"outQuadratic"}}} -- Head Bone
	timeLine[2] = {28,49,bones[21].sprite,{x={33.74,31.39,"outBounce"},y={71.27,83.64,"outBounce"},rotation={300.18,300.18-33.57,"outBounce"}}} -- Head Bone
	timeLine[3] = {50,76,bones[21].sprite,{x={31.39,29.80,"outQuadratic"},y={83.64,64.56,"outQuadratic"},rotation={266.61,266.61+21.01,"outQuadratic"}}} -- Head Bone
	timeLine[4] = {77,100,bones[21].sprite,{x={29.80,31.88,"outBounce"},y={64.56,81.13,"outBounce"},rotation={287.62,287.62-22.22,"outBounce"}}} -- Head Bone
	timeLine[5] = {1,49,bones[16].sprite,{x={41.74,36.74},y={84.3,86.41},rotation={301.25,301.25-12.18}}} -- bone_002
	timeLine[6] = {50,100,bones[16].sprite,{x={36.74,41.74},y={86.41,84.3},rotation={289.07,289.07+12.18}}} -- bone_002
	timeLine[7] = {1,49,bones[17].sprite,{rotation={60.76,60.76-20.8}}} -- bone_003
	timeLine[8] = {50,100,bones[17].sprite,{rotation={39.96,39.96+20.8}}} -- bone_003
	timeLine[9] = {1,49,bones[18].sprite,{rotation={27.36,27.36+55.3}}} -- bone_004
	timeLine[10] = {50,100,bones[18].sprite,{rotation={82.66,82.66-55.3}}} -- bone_004
	timeLine[11] = {1,27,bones[20].sprite,{x={49.64,52.09},y={6.22,9.53},rotation={312.70,312.70-10.8}}} -- bone_006
	timeLine[12] = {28,49,bones[20].sprite,{x={52.09,52.41},y={9.53,10.1},rotation={301.90,301.90-6.41}}} -- bone_006
	timeLine[13] = {50,76,bones[20].sprite,{x={52.41,53.35},y={10.1,10.77},rotation={295.49,295.49+12.9}}} -- bone_006
	timeLine[14] = {77,100,bones[20].sprite,{x={53.35,50.72},y={10.77,5.95},rotation={308.39,308.39+3.04}}} -- bone_006
	timeLine[15] = {1,49,bones[11].sprite,{x={0.54,3.04},y={85.32,85.82},rotation={60.73,60.73+15.33}}} -- bone_007
	timeLine[16] = {50,76,bones[11].sprite,{x={3.04,2.26},y={85.82,83.55},rotation={76.06,76.06-8.33}}} -- bone_007
	timeLine[17] = {77,100,bones[11].sprite,{x={2.26,0.54},y={83.55,85.32},rotation={67.73,67.73-7}}} -- bone_007
	timeLine[18] = {1,49,bones[12].sprite,{rotation={61.00,61.00+11.16}}} -- bone_008
	timeLine[19] = {50,76,bones[12].sprite,{rotation={72.16,72.16-28.76}}} -- bone_008
	timeLine[20] = {77,100,bones[12].sprite,{rotation={43.40,43.40+17.6}}} -- bone_008
	timeLine[21] = {1,49,bones[13].sprite,{rotation={22.67,22.67+42.1}}} -- bone_009
	timeLine[22] = {50,76,bones[13].sprite,{rotation={64.77,64.77-32.05}}} -- bone_009
	timeLine[23] = {77,100,bones[13].sprite,{rotation={32.72,32.72-10.36}}} -- bone_009
	timeLine[24] = {1,22,bones[14].sprite,{x={43.21,42.29},y={-4.31,-4.89}}} -- bone_010
	timeLine[25] = {23,49,bones[14].sprite,{x={42.29,44.40},y={-4.89,-2.51}}} -- bone_010
	timeLine[26] = {50,76,bones[14].sprite,{x={44.40,47.56},y={-2.51,0.81}}} -- bone_010
	timeLine[27] = {77,100,bones[14].sprite,{x={47.56,43.68},y={0.81,-4.15}}} -- bone_010
	timeLine[28] = {1,22,bones[15].sprite,{x={47.04,50.88},y={6.46,7.77},rotation={312.10,312.10-17.1}}} -- bone_011
	timeLine[29] = {23,49,bones[15].sprite,{x={50.88,52.94},y={7.77,10.58},rotation={295.00,295.00-25.93}}} -- bone_011
	timeLine[30] = {50,76,bones[15].sprite,{x={52.94,47.04},y={10.58,6.46},rotation={269.07,269.07+27.35}}} -- bone_011
	timeLine[31] = {77,100,bones[15].sprite,{rotation={296.42,296.42+17.16}}} -- bone_011
	timeLine[32] = {28,49,bones[22].sprite,{rotation={334.10,334.10-29.74,"outBounce"}}} -- Leaf 2 Bone
	timeLine[33] = {50,76,bones[22].sprite,{rotation={304.36,304.36+29.74}}} -- Leaf 2 Bone
	timeLine[34] = {28,49,bones[23].sprite,{rotation={288.51,288.51-30.76,"outBounce"}}} -- Leaf 1 Bone
	timeLine[35] = {50,76,bones[23].sprite,{x={35.44,34.25},y={-33.88,-34.89},rotation={257.75,257.75+74.59}}} -- Leaf 1 Bone
	timeLine[36] = {77,100,bones[23].sprite,{x={34.25,35.44},y={-34.89,-33.88},rotation={332.34,332.34-43.83}}} -- Leaf 1 Bone
	timeLine[37] = {28,49,bones[24].sprite,{x={33.03,32.82,"outBounce"},y={11.06,9.47,"outBounce"},rotation={37.55,37.55+24.93,"outBounce"}}} -- Leaf 3 Bone
	timeLine[38] = {50,76,bones[24].sprite,{x={32.82,33.03},y={9.47,11.06},rotation={62.48,62.48-24.93}}} -- Leaf 3 Bone
	timeLine[39] = {1,22,bones[1].sprite,{x={40.66,42.23},y={60,59.56},rotation={336.31,336.31-7.9}}} -- bone_000
	timeLine[40] = {23,49,bones[1].sprite,{x={42.23,44.09},y={59.56,62.15},rotation={328.41,328.41+7.9}}} -- bone_000
	timeLine[41] = {50,100,bones[1].sprite,{x={44.09,40.66},y={62.15,60}}} -- bone_000
	timeLine[42] = {1,22,bones[2].sprite,{x={42.80,42.29},y={-1.74,-1.55},rotation={64.47,64.47-20.28}}} -- bone_015
	timeLine[43] = {23,49,bones[2].sprite,{x={42.29,41.69},y={-1.55,-1.31},rotation={44.19,44.19+11.94}}} -- bone_015
	timeLine[44] = {50,100,bones[2].sprite,{x={41.69,42.80},y={-1.31,-1.74},rotation={56.13,56.13+8.34}}} -- bone_015
	timeLine[45] = {1,22,bones[3].sprite,{rotation={50.15,50.15+20.19}}} -- bone_016
	timeLine[46] = {23,49,bones[3].sprite,{rotation={70.34,70.34-46.22}}} -- bone_016
	timeLine[47] = {50,100,bones[3].sprite,{rotation={24.12,24.12+26.03}}} -- bone_016
	timeLine[48] = {1,22,bones[5].sprite,{rotation={270.61,270.61-12.15}}} -- bone_018
	timeLine[49] = {23,49,bones[5].sprite,{x={48.58,46.73},y={1.85,4.03},rotation={258.46,258.46+49.87}}} -- bone_018
	timeLine[50] = {50,76,bones[5].sprite,{x={46.73,47.74},y={4.03,2.85},rotation={308.33,308.33-15.9}}} -- bone_018
	timeLine[51] = {77,100,bones[5].sprite,{x={47.74,48.58},y={2.85,1.85},rotation={292.43,292.43-20.72}}} -- bone_018
	timeLine[52] = {1,49,bones[6].sprite,{x={10.25,3.96},y={54.5,54.93},rotation={19.09,19.09-17.25}}} -- bone_019
	timeLine[53] = {50,100,bones[6].sprite,{x={3.96,10.25},y={54.93,54.5},rotation={1.84,1.84+17.25}}} -- bone_019
	timeLine[54] = {1,22,bones[7].sprite,{x={47.52,44.15},y={-4.8,-2},rotation={67.71,67.71-62.07}}} -- bone_020
	timeLine[55] = {23,49,bones[7].sprite,{x={44.15,42.55},y={-2,0.06},rotation={5.64,5.64+27.78}}} -- bone_020
	timeLine[56] = {50,100,bones[7].sprite,{x={42.55,47.52},y={0.06,-4.8},rotation={33.42,33.42+34.29}}} -- bone_020
	timeLine[57] = {1,22,bones[8].sprite,{rotation={26.79,26.79+27.29}}} -- bone_021
	timeLine[58] = {23,49,bones[8].sprite,{rotation={54.08,54.08-27.29}}} -- bone_021
	timeLine[59] = {1,22,bones[9].sprite,{rotation={343.08,343.08+82.85}}} -- bone_022
	timeLine[60] = {23,49,bones[9].sprite,{rotation={65.93,65.93-59.02}}} -- bone_022
	timeLine[61] = {50,100,bones[9].sprite,{rotation={6.91,6.91-23.83}}} -- bone_022
	timeLine[62] = {1,22,bones[10].sprite,{rotation={331.99,331.99-25.31}}} -- bone_023
	timeLine[63] = {23,49,bones[10].sprite,{rotation={306.68,306.68+25.14}}} -- bone_023
	timeLine[64] = {50,76,bones[10].sprite,{rotation={331.82,331.82-3.89}}} -- bone_023
	timeLine[65] = {77,100,bones[10].sprite,{rotation={327.93,327.93+4.7}}} -- bone_023

	self.mc = MovieClip.new(timeLine)

	--self.mc:setGotoAction(100,1)
	self.mc:addEventListener(Event.COMPLETE, self.complete, self)


end


function RounderMonster:complete()

	Timer.delayedCall(500, self.playSound1, self)
	Timer.delayedCall(1400, self.playSound2, self)

	self.mc:gotoAndPlay(1)

end




function RounderMonster:playSound1()
	if(not(self.scene.gameEnded)) then
		self.channel1 = self.scene.chompSound:play()
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	end

end



function RounderMonster:playSound2()

	if(not(self.scene.gameEnded)) then
		self.channel2 = self.scene.chompSound2:play()
		self.channel2:setVolume(self.volume*self.scene.soundVol)
	end

end



function RounderMonster:pause()

	self.mc:stop()
	
end



function RounderMonster:resume()

	if(not(self.scene.gameEnded)) then
		self.mc:play()
	end

end





function RounderMonster:exit()

	if(self.channel1) then
		self.channel1:setPaused(true)
		self.channel1:setVolume(0)
	end
	
	if(self.channel2) then
		self.channel2:setPaused(true)
		self.channel2:setVolume(0)
	end

	self.mc:stop()
	self.mc:removeEventListener(Event.COMPLETE, self.complete, self)

end