Germ = Core.class(Sprite)

function Germ:init(scene,x,y,id,timeBetweenPoints,delayBetween,easing,followHero,speed,followConstantly)

	self.scene = scene

	self.scene.frontLayer:addChild(self)

	self.id = tonumber(id)
	self.timeBetweenPoints = timeBetweenPoints -- time taken to move between points
	self.delayBetween = delayBetween
	self.easing = easing
	self.speed = speed
	self.followHero = followHero
	self.followConstantly = followConstantly
	
		-- set up atlas if not already created
	
	if(not(self.scene.germAtlas)) then
	
		self.scene.germAtlas = TexturePack.new("Atlases/Germ.txt", "Atlases/Germ.png",true)

	end

	-- setup the animation

	self:createAnim()
	
	
	--table.insert(self.scene.enemies, self) -- used for transitions
	
	Timer.delayedCall(10, self.createTweens, self) -- need a delay so that everything is set up
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	
	body:setLinearDamping(math.huge)
	self.body = body
	
	self:createFixture(-15,-100,90)
	self:createFixture(-110,-100,60)
	self:createFixture(75,-105,60)
	self:createFixture(-180,-95,30)
	self:createFixture(150,-95,30)
	
	-- sounds
	
	self.maxVolume = .15
	self.volume = 0
		
	if(not(self.scene.germSound)) then
	
		self.scene.germSound = Sound.new("Sounds/slime.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.germSound:play(0,math.huge)
	self.channel1:setVolume(0)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
end



function Germ:createFixture(x,y,r)

	local fixtureShape = b2.CircleShape.new(x,y,r)
	local fixture = self.body:createFixture{shape = fixtureShape, density = 1, friction = .2, restitution = 0, isSensor = true}
	fixture.parent = self
	fixture.name = "enemy"
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)

end



function Germ:createTweens()

self.tweenCount = 0

	self.tweens = {} -- create table to store tweens
	
	-- Set up the Transitions

	for i = #self.scene.path[self.id].vertices.x,1,-1 do
	
		local nextX = self.scene.path[self.id].vertices.x[i]
		local nextY = self.scene.path[self.id].vertices.y[i]
		
		self.tweenCount = self.tweenCount + 1
		
		if(i == #self.scene.path[self.id].vertices.x) then
		
			if(self.easing=="outQuadratic") then
				self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.outQuadratic})
			else
				self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.none})
			end
		else
			if(self.easing=="outQuadratic") then
				self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.outQuadratic,autoPlay = false})
			else
				self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.none,autoPlay = false})
			end
			
		end
		
	end


	-- Set up the next tweens
	
	for i = 1,#self.tweens do

		local nextTweenNum = i+1
		
		-- if there are no more tweens
		
		if(i == #self.tweens) then

			self.tweens[i].nextTween = self.tweens[1]
		
		else
		
			self.tweens[i].nextTween = self.tweens[nextTweenNum]
			
		end

	end


end




function Germ:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
	
		self:updateSensor()
	
	end

end





function Germ:updateSensor()
	
	self.body:setPosition(self:getPosition())

end






function Germ:pause()

end




function Germ:resume()

end



-- cleanup function

function Germ:exit()

	--print("Germ cleanup")
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end






function Germ:createAnim()

	local mainSprite = Sprite.new()
	self:addChild(mainSprite)
	mainSprite:setPosition(0, 0)
	self.mainSprite = mainSprite
	
	
local bones = {}

-- Setup bones

-- bone_011

local sprite = Sprite.new()
mainSprite:addChild(sprite)
bones[0] = {}
bones[0].sprite = sprite

-- bone_012

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[1] = {}
bones[1].sprite = sprite

-- bone_021

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[2] = {}
bones[2].sprite = sprite

-- bone_013

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[3] = {}
bones[3].sprite = sprite

-- bone_025

local sprite = Sprite.new()
bones[3].sprite:addChild(sprite)
bones[4] = {}
bones[4].sprite = sprite

-- bone_014

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[5] = {}
bones[5].sprite = sprite

-- bone_023

local sprite = Sprite.new()
bones[5].sprite:addChild(sprite)
bones[6] = {}
bones[6].sprite = sprite

-- bone_015

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[7] = {}
bones[7].sprite = sprite

-- bone_010

local sprite = Sprite.new()
bones[7].sprite:addChild(sprite)
bones[8] = {}
bones[8].sprite = sprite

-- bone_019

local sprite = Sprite.new()
bones[7].sprite:addChild(sprite)
bones[9] = {}
bones[9].sprite = sprite

-- bone_016

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[10] = {}
bones[10].sprite = sprite

-- bone_024

local sprite = Sprite.new()
bones[10].sprite:addChild(sprite)
bones[11] = {}
bones[11].sprite = sprite

-- bone_017

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[12] = {}
bones[12].sprite = sprite

-- bone_022

local sprite = Sprite.new()
bones[12].sprite:addChild(sprite)
bones[13] = {}
bones[13].sprite = sprite

-- bone_018

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[14] = {}
bones[14].sprite = sprite

-- bone_000

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[15] = {}
bones[15].sprite = sprite

-- bone_001

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[16] = {}
bones[16].sprite = sprite

-- bone_002

local sprite = Sprite.new()
bones[16].sprite:addChild(sprite)
bones[17] = {}
bones[17].sprite = sprite

-- bone_003

local sprite = Sprite.new()
bones[16].sprite:addChild(sprite)
bones[18] = {}
bones[18].sprite = sprite

-- bone_008

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[19] = {}
bones[19].sprite = sprite

-- bone_009

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[20] = {}
bones[20].sprite = sprite

-- bone_020

local sprite = Sprite.new()
bones[20].sprite:addChild(sprite)
bones[21] = {}
bones[21].sprite = sprite

-- Setup image sprites

local sprites = {}

-- mouth1 ---------

sprites[0] = {}
local sprite = Sprite.new()
bones[15].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("mouth1.png"))
sprite:addChild(img)
sprites[0].sprite = sprite

-- tongue1 ---------

sprites[1] = {}
local sprite = Sprite.new()
bones[17].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("tongue1.png"))
sprite:addChild(img)
sprites[1].sprite = sprite

-- tongue2 ---------

sprites[2] = {}
local sprite = Sprite.new()
bones[18].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("tongue2.png"))
sprite:addChild(img)
sprites[2].sprite = sprite

-- mouth2 ---------

sprites[3] = {}
local sprite = Sprite.new()
bones[19].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("mouth2.png"))
sprite:addChild(img)
sprites[3].sprite = sprite

-- body4_000 ---------

sprites[5] = {}
local sprite = Sprite.new()
bones[3].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body4.png"))
sprite:addChild(img)
sprites[5].sprite = sprite

-- body3_000 ---------

sprites[6] = {}
local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body3.png"))
sprite:addChild(img)
sprites[6].sprite = sprite

-- body2_000 ---------

sprites[7] = {}
local sprite = Sprite.new()
bones[10].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body2.png"))
sprite:addChild(img)
sprites[7].sprite = sprite

-- body1_000 ---------

sprites[8] = {}
local sprite = Sprite.new()
bones[14].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body1.png"))
sprite:addChild(img)
sprites[8].sprite = sprite

-- body5_000 ---------

sprites[9] = {}
local sprite = Sprite.new()
bones[5].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body5.png"))
sprite:addChild(img)
sprites[9].sprite = sprite

-- body6_000 ---------

sprites[10] = {}
local sprite = Sprite.new()
bones[7].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body6.png"))
sprite:addChild(img)
sprites[10].sprite = sprite

-- body7_000 ---------

sprites[11] = {}
local sprite = Sprite.new()
bones[12].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body7.png"))
sprite:addChild(img)
sprites[11].sprite = sprite

-- eye3 ---------

sprites[19] = {}
local sprite = Sprite.new()
bones[14].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("eye3.png"))
sprite:addChild(img)
sprites[19].sprite = sprite

-- eye1 ---------

sprites[20] = {}
local sprite = Sprite.new()
bones[14].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("eye1.png"))
sprite:addChild(img)
sprites[20].sprite = sprite

-- body8 ---------

sprites[26] = {}
local sprite = Sprite.new()
bones[20].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("body8.png"))
sprite:addChild(img)
sprites[26].sprite = sprite

-- arm2 ---------

sprites[28] = {}
local sprite = Sprite.new()
bones[8].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm2.png"))
sprite:addChild(img)
sprites[28].sprite = sprite

-- arm3 ---------

sprites[29] = {}
local sprite = Sprite.new()
bones[9].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm3.png"))
sprite:addChild(img)
sprites[29].sprite = sprite

-- arm4 ---------

sprites[30] = {}
local sprite = Sprite.new()
bones[6].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm4.png"))
sprite:addChild(img)
sprites[30].sprite = sprite

-- arm1 ---------

sprites[31] = {}
local sprite = Sprite.new()
bones[13].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm1.png"))
sprite:addChild(img)
sprites[31].sprite = sprite

-- arm2_000 ---------

sprites[32] = {}
local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm2.png"))
sprite:addChild(img)
sprites[32].sprite = sprite

-- arm1_000 ---------

sprites[33] = {}
local sprite = Sprite.new()
bones[4].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm1.png"))
sprite:addChild(img)
sprites[33].sprite = sprite

-- arm3_000 ---------

sprites[34] = {}
local sprite = Sprite.new()
bones[21].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm3.png"))
sprite:addChild(img)
sprites[34].sprite = sprite

-- arm4_000 ---------

sprites[35] = {}
local sprite = Sprite.new()
bones[11].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.germAtlas:getTextureRegion("arm4.png"))
sprite:addChild(img)
sprites[35].sprite = sprite

-- Adjust the sprites (from first frame of timelines)

-- mouth1

sprites[0].sprite:setX(-7.00)
sprites[0].sprite:setY(-21.5)


-- tongue1

sprites[1].sprite:setX(-13.44)
sprites[1].sprite:setY(-21.47)
sprites[1].sprite:setRotation(1.75)


-- tongue2

sprites[2].sprite:setX(-3.50)
sprites[2].sprite:setY(-10.5)


-- mouth2

sprites[3].sprite:setX(-5.00)
sprites[3].sprite:setY(-12)


-- bone_011

bones[0].sprite:setX(-227.00)
bones[0].sprite:setY(-215)


-- body4_000

sprites[5].sprite:setX(-3.50)
sprites[5].sprite:setY(-36.5)


-- body3_000

sprites[6].sprite:setX(-9.50)
sprites[6].sprite:setY(-30.15)


-- body2_000

sprites[7].sprite:setX(-3.09)
sprites[7].sprite:setY(-62.12)
sprites[7].sprite:setRotation(1.76)


-- body1_000

sprites[8].sprite:setX(-35.50)
sprites[8].sprite:setY(-62.5)


-- body5_000

sprites[9].sprite:setX(-3.50)
sprites[9].sprite:setY(-30)


-- body6_000

sprites[10].sprite:setX(-39.31)
sprites[10].sprite:setY(-34.8)
sprites[10].sprite:setRotation(1.15)


-- body7_000

sprites[11].sprite:setX(-7.50)
sprites[11].sprite:setY(-47.5)


-- bone_012

bones[1].sprite:setX(359.50)
bones[1].sprite:setY(126)
bones[1].sprite:setScaleX(-1.00)
bones[1].sprite:setRotation(348.25)


-- bone_013

bones[3].sprite:setX(22.50)
bones[3].sprite:setY(110)
bones[3].sprite:setRotation(8.13)


-- bone_014

bones[5].sprite:setX(64.00)
bones[5].sprite:setY(81)
bones[5].sprite:setRotation(354.19)


-- bone_015

bones[7].sprite:setX(281.00)
bones[7].sprite:setY(77)
bones[7].sprite:setRotation(9.98)


-- bone_016

bones[10].sprite:setX(69.50)
bones[10].sprite:setY(141.5)
bones[10].sprite:setRotation(3.48)


-- bone_017

bones[12].sprite:setX(133.50)
bones[12].sprite:setY(66)
bones[12].sprite:setRotation(359.12)


-- bone_018

bones[14].sprite:setX(142.50)
bones[14].sprite:setY(139)
bones[14].sprite:setRotation(0.19)


-- eye3

sprites[19].sprite:setX(117.95)
sprites[19].sprite:setY(-14.4)
sprites[19].sprite:setRotation(359.81)


-- bone_000

bones[15].sprite:setX(175.50)
bones[15].sprite:setY(197)


-- bone_001

bones[16].sprite:setX(197.00)
bones[16].sprite:setY(179)


-- bone_002

bones[17].sprite:setX(-4.00)
bones[17].sprite:setY(9)
bones[17].sprite:setRotation(359.00)


-- bone_003

bones[18].sprite:setX(-22.00)
bones[18].sprite:setY(35.5)


-- bone_008

bones[19].sprite:setX(179.50)
bones[19].sprite:setY(166)
bones[19].sprite:setRotation(2.35)


-- body8

sprites[26].sprite:setX(-5.22)
sprites[26].sprite:setY(-32.63)
sprites[26].sprite:setRotation(1.37)


-- bone_009

bones[20].sprite:setX(345.50)
bones[20].sprite:setY(111.5)
bones[20].sprite:setRotation(359.48)


-- arm2

sprites[28].sprite:setX(-2.13)
sprites[28].sprite:setY(-16.05)
sprites[28].sprite:setRotation(1.32)


-- arm3

sprites[29].sprite:setX(-1.07)
sprites[29].sprite:setY(-7.49)
sprites[29].sprite:setRotation(359.48)


-- arm4

sprites[30].sprite:setX(-1.66)
sprites[30].sprite:setY(-15.98)
sprites[30].sprite:setRotation(359.44)


-- arm1

sprites[31].sprite:setX(-2.00)
sprites[31].sprite:setY(-7.5)


-- arm2_000

sprites[32].sprite:setX(-1.00)
sprites[32].sprite:setY(-14.5)


-- arm1_000

sprites[33].sprite:setX(-3.28)
sprites[33].sprite:setY(-8.09)
sprites[33].sprite:setRotation(1.56)


-- arm3_000

sprites[34].sprite:setX(-0.75)
sprites[34].sprite:setY(-9.02)
sprites[34].sprite:setRotation(1.58)


-- arm4_000

sprites[35].sprite:setX(1.14)
sprites[35].sprite:setY(-15.49)
sprites[35].sprite:setRotation(0.54)


-- bone_010

bones[8].sprite:setX(1.26)
bones[8].sprite:setY(-24.59)
bones[8].sprite:setRotation(278.45)


-- bone_019

bones[9].sprite:setX(52.03)
bones[9].sprite:setY(-18.81)
bones[9].sprite:setRotation(310.87)


-- bone_020

bones[21].sprite:setX(51.00)
bones[21].sprite:setY(0.46)
bones[21].sprite:setRotation(333.34)


-- bone_021

bones[2].sprite:setX(13.74)
bones[2].sprite:setY(26.76)
bones[2].sprite:setScaleX(-1.00)
bones[2].sprite:setRotation(294.97)


-- bone_022

bones[13].sprite:setX(62.07)
bones[13].sprite:setY(-36.55)
bones[13].sprite:setRotation(261.50)


-- bone_023

bones[6].sprite:setX(16.88)
bones[6].sprite:setY(-7.83)
bones[6].sprite:setRotation(226.11)


-- bone_024

bones[11].sprite:setX(29.32)
bones[11].sprite:setY(20.76)
bones[11].sprite:setRotation(111.77)


-- bone_025

bones[4].sprite:setX(6.08)
bones[4].sprite:setY(10.75)
bones[4].sprite:setRotation(165.30)


-- mouth1

sprites[0].sprite:setX(-7.00)
sprites[0].sprite:setY(-21.5)


-- tongue1

sprites[1].sprite:setX(-13.44)
sprites[1].sprite:setY(-21.47)
sprites[1].sprite:setRotation(1.75)


-- tongue2

sprites[2].sprite:setX(-3.50)
sprites[2].sprite:setY(-10.5)


-- mouth2

sprites[3].sprite:setX(-5.00)
sprites[3].sprite:setY(-12)


-- bone_011

bones[0].sprite:setX(-227.00)
bones[0].sprite:setY(-215)


-- body4_000

sprites[5].sprite:setX(-3.50)
sprites[5].sprite:setY(-36.5)


-- body3_000

sprites[6].sprite:setX(-9.50)
sprites[6].sprite:setY(-30.15)


-- body2_000

sprites[7].sprite:setX(-3.09)
sprites[7].sprite:setY(-62.12)
sprites[7].sprite:setRotation(1.76)


-- body1_000

sprites[8].sprite:setX(-35.50)
sprites[8].sprite:setY(-62.5)


-- body5_000

sprites[9].sprite:setX(-3.50)
sprites[9].sprite:setY(-30)


-- body6_000

sprites[10].sprite:setX(-39.31)
sprites[10].sprite:setY(-34.8)
sprites[10].sprite:setRotation(1.15)


-- body7_000

sprites[11].sprite:setX(-7.50)
sprites[11].sprite:setY(-47.5)


-- bone_012

bones[1].sprite:setX(359.50)
bones[1].sprite:setY(126)
bones[1].sprite:setScaleX(-1.00)
bones[1].sprite:setRotation(348.25)


-- bone_013

bones[3].sprite:setX(22.50)
bones[3].sprite:setY(109.5)
bones[3].sprite:setRotation(8.13)


-- bone_014

bones[5].sprite:setX(64.00)
bones[5].sprite:setY(81)
bones[5].sprite:setRotation(354.19)


-- bone_015

bones[7].sprite:setX(281.00)
bones[7].sprite:setY(77)
bones[7].sprite:setRotation(9.98)


-- bone_016

bones[10].sprite:setX(69.50)
bones[10].sprite:setY(141.5)
bones[10].sprite:setRotation(3.48)


-- bone_017

bones[12].sprite:setX(133.50)
bones[12].sprite:setY(66)
bones[12].sprite:setRotation(359.12)


-- bone_018

bones[14].sprite:setX(142.50)
bones[14].sprite:setY(139)
bones[14].sprite:setRotation(0.19)


-- eye3

sprites[19].sprite:setX(117.95)
sprites[19].sprite:setY(-14.4)
sprites[19].sprite:setRotation(359.81)


-- bone_000

bones[15].sprite:setX(175.50)
bones[15].sprite:setY(197)


-- bone_001

bones[16].sprite:setX(197.00)
bones[16].sprite:setY(179)


-- bone_002

bones[17].sprite:setX(-4.00)
bones[17].sprite:setY(9)
bones[17].sprite:setRotation(359.00)


-- bone_003

bones[18].sprite:setX(-22.00)
bones[18].sprite:setY(35.5)


-- bone_008

bones[19].sprite:setX(179.50)
bones[19].sprite:setY(166)
bones[19].sprite:setRotation(2.35)


-- body8

sprites[26].sprite:setX(-5.22)
sprites[26].sprite:setY(-32.63)
sprites[26].sprite:setRotation(1.37)


-- bone_009

bones[20].sprite:setX(345.50)
bones[20].sprite:setY(111.5)
bones[20].sprite:setRotation(359.48)


-- mouth1

sprites[0].sprite:setX(-7.00)
sprites[0].sprite:setY(-32.5)


-- tongue1

sprites[1].sprite:setX(-14.50)
sprites[1].sprite:setY(-26.5)


-- tongue2

sprites[2].sprite:setX(-5.00)
sprites[2].sprite:setY(-10.5)


-- mouth2

sprites[3].sprite:setX(-10.00)
sprites[3].sprite:setY(-18)


-- bone_011

bones[0].sprite:setX(-228.00)
bones[0].sprite:setY(-213.5)


-- body4_000

sprites[5].sprite:setX(-3.50)
sprites[5].sprite:setY(-35)


-- body3_000

sprites[6].sprite:setX(-9.50)
sprites[6].sprite:setY(-30.15)


-- body2_000

sprites[7].sprite:setX(-3.09)
sprites[7].sprite:setY(-62.12)
sprites[7].sprite:setRotation(1.76)


-- body1_000

sprites[8].sprite:setX(-35.50)
sprites[8].sprite:setY(-62.5)


-- body5_000

sprites[9].sprite:setX(-3.50)
sprites[9].sprite:setY(-30)


-- body6_000

sprites[10].sprite:setX(-39.31)
sprites[10].sprite:setY(-34.8)
sprites[10].sprite:setRotation(1.15)


-- body7_000

sprites[11].sprite:setX(-7.50)
sprites[11].sprite:setY(-47.5)


-- bone_012

bones[1].sprite:setX(365.50)
bones[1].sprite:setY(124.5)
bones[1].sprite:setScaleX(-1.00)
bones[1].sprite:setRotation(1.01)


-- bone_013

bones[3].sprite:setX(15.00)
bones[3].sprite:setY(117.5)


-- bone_014

bones[5].sprite:setX(66.50)
bones[5].sprite:setY(76.5)
bones[5].sprite:setRotation(358.01)


-- bone_015

bones[7].sprite:setX(278.00)
bones[7].sprite:setY(75.5)
bones[7].sprite:setRotation(4.90)


-- bone_016

bones[10].sprite:setX(69.50)
bones[10].sprite:setY(141.5)
bones[10].sprite:setRotation(358.24)


-- bone_017

bones[12].sprite:setX(133.50)
bones[12].sprite:setY(66)


-- bone_018

bones[14].sprite:setX(142.50)
bones[14].sprite:setY(139)
bones[14].sprite:setRotation(0.19)


-- eye3

sprites[19].sprite:setX(117.95)
sprites[19].sprite:setY(-14.4)
sprites[19].sprite:setRotation(359.81)






local timeLine = {}

-- NewAnimation 

timeLine[1] = {1,50,bones[1].sprite,{x={359.50,360.61},y={126,130.44}}} -- bone_012
timeLine[2] = {51,100,bones[1].sprite,{x={360.61,359.50},y={130.44,126}}} -- bone_012
timeLine[3] = {1,49,bones[3].sprite,{x={22.50,19.96},y={110,105.48},rotation={8.13,8.13+7.16}}} -- bone_013
timeLine[4] = {50,100,bones[3].sprite,{x={19.96,22.50},y={105.48,110},rotation={15.29,15.29-7.16}}} -- bone_013
timeLine[5] = {1,48,bones[5].sprite,{x={64.00,64.56},y={81,78.22},rotation={354.19,354.19+1.69}}} -- bone_014
timeLine[6] = {49,100,bones[5].sprite,{x={64.56,64.00},y={78.22,81},rotation={355.88,355.88-1.69}}} -- bone_014
timeLine[7] = {1,49,bones[7].sprite,{x={281.00,283.22},y={77,74.78}}} -- bone_015
timeLine[8] = {50,100,bones[7].sprite,{x={283.22,281.00},y={74.78,77}}} -- bone_015
timeLine[9] = {1,47,bones[10].sprite,{x={69.50,65.69},y={141.5,143.48},rotation={3.48,3.48-4.37}}} -- bone_016
timeLine[10] = {48,100,bones[10].sprite,{x={65.69,69.50},y={143.48,141.5},rotation={359.11,359.11+4.37}}} -- bone_016
timeLine[11] = {1,46,bones[14].sprite,{x={142.50,146.39},y={139,144},rotation={0.19,0.19+2.64}}} -- bone_018
timeLine[12] = {47,100,bones[14].sprite,{x={146.39,142.50},y={144,139},rotation={2.83,2.83-2.64}}} -- bone_018
timeLine[13] = {1,46,sprites[19].sprite,{x={117.95,117.36},y={-14.4,-13.81}}} -- eye3
timeLine[14] = {47,87,sprites[19].sprite,{x={117.36,116.84},y={-13.81,-13.28}}} -- eye3
timeLine[15] = {88,100,sprites[19].sprite,{x={116.84,117.95},y={-13.28,-14.4}}} -- eye3
timeLine[16] = {1,46,sprites[20].sprite,{x={0.00,-4.99},y={3,0.59}}} -- eye1
timeLine[17] = {47,100,sprites[20].sprite,{x={-4.99,0.00},y={0.59,3}}} -- eye1
timeLine[18] = {1,50,bones[15].sprite,{x={175.50,177.39},y={182.33,191.47}}} -- bone_000
timeLine[19] = {51,100,bones[15].sprite,{x={177.39,175.50},y={191.47,182.33}}} -- bone_000
timeLine[20] = {1,49,bones[16].sprite,{x={197.00,202.18},y={174.75,183.47}}} -- bone_001
timeLine[21] = {50,100,bones[16].sprite,{x={202.18,197.00,"inQuadratic"},y={183.47,174.75,"inQuadratic"}}} -- bone_001
timeLine[22] = {1,60,bones[18].sprite,{x={-22.00,-21.24},y={35.5,39.95},rotation={0,0-5.78}}} -- bone_003
timeLine[23] = {61,100,bones[18].sprite,{x={-21.24,-22.00},y={39.95,35.5},rotation={354.22,354.22+5.78}}} -- bone_003
timeLine[24] = {1,49,bones[19].sprite,{x={172.56,173.50},y={145.37,158.51},rotation={2.35,2.35+0.78}}} -- bone_008
timeLine[25] = {50,100,bones[19].sprite,{x={173.50,172.56},y={158.51,145.37},rotation={3.13,3.13-0.78}}} -- bone_008
timeLine[26] = {1,50,bones[8].sprite,{scaleX={1.16,0.72,""},scaleX={1.16,0.72}}} -- bone_010
timeLine[27] = {51,100,bones[8].sprite,{scaleX={0.72,1.16,""},scaleX={0.72,1.16}}} -- bone_010
timeLine[28] = {1,45,bones[9].sprite,{scaleX={0.63,0.92,""},scaleX={0.63,0.92}}} -- bone_019
timeLine[29] = {46,100,bones[9].sprite,{scaleX={0.92,0.63,""},scaleX={0.92,0.63}}} -- bone_019
timeLine[30] = {1,47,bones[21].sprite,{scaleX={1,0.71,""},scaleX={1,0.71},rotation={333.34,333.34-13.7}}} -- bone_020
timeLine[31] = {48,100,bones[21].sprite,{scaleX={0.71,1.00,""},scaleX={0.71,1.00},rotation={319.64,319.64+13.7}}} -- bone_020
timeLine[32] = {1,49,bones[2].sprite,{scaleX={-0.57,-0.97,""},scaleX={-0.57,-0.97},rotation={294.97,294.97+2.77}}} -- bone_021
timeLine[33] = {50,100,bones[2].sprite,{scaleX={-0.97,-0.57,""},scaleX={-0.97,-0.57},rotation={297.74,297.74-2.77}}} -- bone_021
timeLine[34] = {1,47,bones[13].sprite,{scaleX={0.59,0.83,""},scaleX={0.59,0.83}}} -- bone_022
timeLine[35] = {48,100,bones[13].sprite,{scaleX={0.83,0.59,""},scaleX={0.83,0.59}}} -- bone_022
timeLine[36] = {1,50,bones[6].sprite,{scaleX={1,0.73,""},scaleX={1,0.73}}} -- bone_023
timeLine[37] = {51,100,bones[6].sprite,{scaleX={0.73,1.00,""},scaleX={0.73,1.00}}} -- bone_023
timeLine[38] = {1,49,bones[11].sprite,{scaleX={1,0.69,""},scaleX={1,0.69},rotation={111.77,111.77-15.38}}} -- bone_024
timeLine[39] = {50,100,bones[11].sprite,{scaleX={0.69,1.00,""},scaleX={0.69,1.00},rotation={96.39,96.39+15.38}}} -- bone_024
timeLine[40] = {1,54,bones[4].sprite,{scaleX={0.69,0.77,""},scaleX={0.69,0.77},rotation={165.30,165.30-18.54}}} -- bone_025
timeLine[41] = {55,100,bones[4].sprite,{scaleX={0.77,0.69,""},scaleX={0.77,0.69},rotation={146.76,146.76+18.54}}} -- bone_025

self.mc = MovieClip.new(timeLine)
self.mc:setGotoAction(100,1)








end