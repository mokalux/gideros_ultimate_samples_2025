DropSpider = Core.class(Sprite)

function DropSpider:init(scene,x,y,id)

	self.scene = scene
	self.id = id
	
	-- set up atlas if not already created
	
	if(not(self.scene.dropSpiderAtlas)) then
	
		self.scene.dropSpiderAtlas = TexturePack.new("Atlases/drop spider.txt", "Atlases/drop spider.png",true)

	end

	-- setup the animation

	self:createAnim()

	self.scene.rube1:addChild(self)
	
	self.scene.dropSpiders[id] = self

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local poly = b2.PolygonShape.new()
	poly:setAsBox(40,20,0,40,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	
	fixture.parent = self
	fixture.name = "enemy"
	self.body = body
	self.body:setActive(false)
	
	self.body:setLinearDamping(math.huge)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)

	--table.insert(self.scene.spritesOnScreen, self)

	self.moved = 0
	self.speed = 0
	self.maxSpeed = 5
	self.acceleration = .3
	self.startY = y

	self.mc:stop()
	
	Timer.delayedCall(10, self.createDownTween, self)

	-- sounds
	
	self.maxVolume = .05
	self.volume = 0

	
	if(not(self.scene.spiderDropSound)) then
		self.scene.spiderDropSound = Sound.new("Sounds/spider drop.wav")
		
	end
	
	if(not(self.scene.spiderClimbSound)) then
		self.scene.spiderClimbSound = Sound.new("Sounds/spider climb.wav")
		
	end
	
	-- set up looping sound
	
	self.channel1 = self.scene.spiderClimbSound:play(0,math.huge,false)
	self.channel1:setVolume(0)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end



function DropSpider:createDownTween()

	self.downTween = GTween.new(self, 1.5, {y = self.scene.dropSpiderYs[self.id]-45},{ease = easing.outBounce, autoPlay = false})
	
	self.upTween = GTween.new(self, 3, {y = self.startY},{ease = easing.outBounce, autoPlay = false})
	self.upTween:addEventListener("complete", self.reset, self)
	self.upTween.dispatchEvents = true

end



function DropSpider:pause()

	self.mc:stop()

end




function DropSpider:resume()

	self.mc:play()

end



function DropSpider:drop()

	if(not(self.dropping)) then
	
		self.dropping = true
	
		self.downTween:setPaused(false)
		Timer.delayedCall(100, self.dropSound, self)
		Timer.delayedCall(200, self.pounceAnim, self)
		Timer.delayedCall(10, self.makeDangerous, self)
		Timer.delayedCall(1800, self.upAnim, self)
		Timer.delayedCall(2000, self.goBackUp, self)
		
		-- add event listener to update sensor
		self:addEventListener(Event.ENTER_FRAME, self.updateSensor, self)

	
	end
	

		

	
end



function DropSpider:updateSensor()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self.body:setPosition(self:getPosition())
		
	end

end



function DropSpider:makeDangerous()

	self.body:setActive(true)

end



function DropSpider:makeSafe()

	self.body:setActive(false)

end



function DropSpider:dropSound()

	local channel1 = self.scene.spiderDropSound:play()
	channel1:setVolume(.3*self.scene.soundVol)

end



function DropSpider:pounceAnim()



	self.mc:setStopAction(100)
	self.mc:gotoAndPlay(1)

end





function DropSpider:upAnim()
		
	self.mc:setGotoAction(159,101)
	self.mc:gotoAndPlay(101)
		
end




function DropSpider:resetAnim()

	self.mc:setStopAction(198)
	self.mc:gotoAndPlay(161)
		
end


function DropSpider:goBackUp()

	if(self.channel1) then
		self.channel1:setPaused(false)
	end

	Timer.delayedCall(10, self.makeSafe, self)
	self.moved = 0
	self.upTween:setPaused(false)

end




function DropSpider:reset()

	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self.mc:stop()
	self.dropping = nil
	self.mc:gotoAndStop(1)
	self:resetAnim()

end





-- cleanup function

function DropSpider:exit()

	self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	
end





function DropSpider:createAnim()

	local mainSprite = Sprite.new()
	self:addChild(mainSprite)
	mainSprite:setPosition(-74, -80)
	self.mainSprite = mainSprite
	
	
	
	
local bones = {}

-- Setup bones

-- bone_000

local sprite = Sprite.new()
mainSprite:addChild(sprite)
bones[0] = {}
bones[0].sprite = sprite

-- bone_001

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[1] = {}
bones[1].sprite = sprite

-- bone_023

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[2] = {}
bones[2].sprite = sprite

-- bone_024

local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
bones[3] = {}
bones[3].sprite = sprite

-- bone_025

local sprite = Sprite.new()
bones[3].sprite:addChild(sprite)
bones[4] = {}
bones[4].sprite = sprite

-- bone_026

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[5] = {}
bones[5].sprite = sprite

-- bone_027

local sprite = Sprite.new()
bones[5].sprite:addChild(sprite)
bones[6] = {}
bones[6].sprite = sprite

-- bone_028

local sprite = Sprite.new()
bones[6].sprite:addChild(sprite)
bones[7] = {}
bones[7].sprite = sprite

-- bone_029

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[8] = {}
bones[8].sprite = sprite

-- bone_030

local sprite = Sprite.new()
bones[8].sprite:addChild(sprite)
bones[9] = {}
bones[9].sprite = sprite

-- bone_031

local sprite = Sprite.new()
bones[9].sprite:addChild(sprite)
bones[10] = {}
bones[10].sprite = sprite

-- bone_034

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[11] = {}
bones[11].sprite = sprite

-- bone_035

local sprite = Sprite.new()
bones[11].sprite:addChild(sprite)
bones[12] = {}
bones[12].sprite = sprite

-- bone_036

local sprite = Sprite.new()
bones[12].sprite:addChild(sprite)
bones[13] = {}
bones[13].sprite = sprite

-- bone_037

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[14] = {}
bones[14].sprite = sprite

-- bone_038

local sprite = Sprite.new()
bones[14].sprite:addChild(sprite)
bones[15] = {}
bones[15].sprite = sprite

-- bone_039

local sprite = Sprite.new()
bones[15].sprite:addChild(sprite)
bones[16] = {}
bones[16].sprite = sprite

-- bone_040

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[17] = {}
bones[17].sprite = sprite

-- bone_041

local sprite = Sprite.new()
bones[17].sprite:addChild(sprite)
bones[18] = {}
bones[18].sprite = sprite

-- bone_042

local sprite = Sprite.new()
bones[18].sprite:addChild(sprite)
bones[19] = {}
bones[19].sprite = sprite

-- bone_002

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[20] = {}
bones[20].sprite = sprite

-- bone_032

local sprite = Sprite.new()
bones[20].sprite:addChild(sprite)
bones[21] = {}
bones[21].sprite = sprite

-- bone_033

local sprite = Sprite.new()
bones[20].sprite:addChild(sprite)
bones[22] = {}
bones[22].sprite = sprite

-- Setup image sprites

local sprites = {}

-- bum ---------

sprites[0] = {}
local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("bum.png"))
sprite:addChild(img)
sprites[0].sprite = sprite

-- head ---------

sprites[1] = {}
local sprite = Sprite.new()
bones[20].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("head.png"))
sprite:addChild(img)
sprites[1].sprite = sprite

-- leg1_005 ---------

sprites[5] = {}
local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[5].sprite = sprite

-- leg2_005 ---------

sprites[6] = {}
local sprite = Sprite.new()
bones[3].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[6].sprite = sprite

-- tip 2_001 ---------

sprites[7] = {}
local sprite = Sprite.new()
bones[4].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("tip 2.png"))
sprite:addChild(img)
sprites[7].sprite = sprite

-- leg1_006 ---------

sprites[11] = {}
local sprite = Sprite.new()
bones[5].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[11].sprite = sprite

-- leg2_006 ---------

sprites[12] = {}
local sprite = Sprite.new()
bones[6].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[12].sprite = sprite

-- knife_000 ---------

sprites[13] = {}
local sprite = Sprite.new()
bones[7].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("knife.png"))
sprite:addChild(img)
sprites[13].sprite = sprite

-- leg1_007 ---------

sprites[17] = {}
local sprite = Sprite.new()
bones[8].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[17].sprite = sprite

-- leg2_007 ---------

sprites[18] = {}
local sprite = Sprite.new()
bones[9].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[18].sprite = sprite

-- tip 1_001 ---------

sprites[19] = {}
local sprite = Sprite.new()
bones[10].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("tip 1.png"))
sprite:addChild(img)
sprites[19].sprite = sprite

-- jaw_001 ---------

sprites[23] = {}
local sprite = Sprite.new()
bones[21].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("jaw.png"))
sprite:addChild(img)
sprites[23].sprite = sprite

-- jaw_002 ---------

sprites[25] = {}
local sprite = Sprite.new()
bones[22].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("jaw.png"))
sprite:addChild(img)
sprites[25].sprite = sprite

-- leg1_008 ---------

sprites[27] = {}
local sprite = Sprite.new()
bones[11].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[27].sprite = sprite

-- leg2_008 ---------

sprites[28] = {}
local sprite = Sprite.new()
bones[12].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[28].sprite = sprite

-- tip 2_002 ---------

sprites[29] = {}
local sprite = Sprite.new()
bones[13].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("tip 2.png"))
sprite:addChild(img)
sprites[29].sprite = sprite

-- leg1_009 ---------

sprites[33] = {}
local sprite = Sprite.new()
bones[14].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[33].sprite = sprite

-- leg2_009 ---------

sprites[34] = {}
local sprite = Sprite.new()
bones[15].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[34].sprite = sprite

-- tip 1_002 ---------

sprites[35] = {}
local sprite = Sprite.new()
bones[16].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("tip 1.png"))
sprite:addChild(img)
sprites[35].sprite = sprite

-- leg1_010 ---------

sprites[39] = {}
local sprite = Sprite.new()
bones[17].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[39].sprite = sprite

-- leg2_010 ---------

sprites[40] = {}
local sprite = Sprite.new()
bones[18].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[40].sprite = sprite

-- fork_000 ---------

sprites[41] = {}
local sprite = Sprite.new()
bones[19].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("fork.png"))
sprite:addChild(img)
sprites[41].sprite = sprite

-- Adjust the sprites (from first frame of timelines)

-- bum

sprites[0].sprite:setX(-7.50)
sprites[0].sprite:setY(-16.25)


-- head

sprites[1].sprite:setX(-10.75)
sprites[1].sprite:setY(-23)


-- bone_000

bones[0].sprite:setX(59.00)
bones[0].sprite:setY(22.25)


-- bone_001

bones[1].sprite:setX(32.50)
bones[1].sprite:setY(65.25)
bones[1].sprite:setRotation(273.07)


-- bone_002

bones[20].sprite:setX(31.75)
bones[20].sprite:setY(69.5)
bones[20].sprite:setRotation(85.64)


-- leg1_005

sprites[5].sprite:setX(-1.75)
sprites[5].sprite:setY(-7)


-- leg2_005

sprites[6].sprite:setX(-3.00)
sprites[6].sprite:setY(-7.5)


-- tip 2_001

sprites[7].sprite:setX(-1.50)
sprites[7].sprite:setY(-4.25)


-- bone_023

bones[2].sprite:setX(7.58)
bones[2].sprite:setY(15.18)
bones[2].sprite:setRotation(53.55)


-- bone_024

bones[3].sprite:setX(21.25)
bones[3].sprite:setY(0.5)
bones[3].sprite:setRotation(293.21)


-- bone_025

bones[4].sprite:setX(17.67)
bones[4].sprite:setY(0.34)
bones[4].sprite:setRotation(343.90)


-- leg1_006

sprites[11].sprite:setX(-2.25)
sprites[11].sprite:setY(-7.25)


-- leg2_006

sprites[12].sprite:setX(-1.75)
sprites[12].sprite:setY(-7.25)


-- knife_000

sprites[13].sprite:setX(-0.75)
sprites[13].sprite:setY(-6.5)


-- bone_026

bones[5].sprite:setX(-9.78)
bones[5].sprite:setY(18.3)
bones[5].sprite:setRotation(112.96)


-- bone_027

bones[6].sprite:setX(18.75)
bones[6].sprite:setY(0.5)
bones[6].sprite:setRotation(9.00)


-- bone_028

bones[7].sprite:setX(19.95)
bones[7].sprite:setY(1.52)
bones[7].sprite:setRotation(31.33)


-- leg1_007

sprites[17].sprite:setX(-1.00)
sprites[17].sprite:setY(-7)


-- leg2_007

sprites[18].sprite:setX(-1.00)
sprites[18].sprite:setY(-7)


-- tip 1_001

sprites[19].sprite:setX(-1.50)
sprites[19].sprite:setY(-5.75)


-- bone_029

bones[8].sprite:setX(-1.26)
bones[8].sprite:setY(13.84)
bones[8].sprite:setRotation(66.57)


-- bone_030

bones[9].sprite:setX(20.00)
bones[9].sprite:setY(-0)
bones[9].sprite:setRotation(339.73)


-- bone_031

bones[10].sprite:setX(21.00)
bones[10].sprite:setY(0.5)
bones[10].sprite:setRotation(332.39)


-- jaw_001

sprites[23].sprite:setX(-1.50)
sprites[23].sprite:setY(-3.75)


-- bone_032

bones[21].sprite:setX(22.77)
bones[21].sprite:setY(-8.87)
bones[21].sprite:setRotation(331.49)


-- bone_033

bones[22].sprite:setX(22.02)
bones[22].sprite:setY(9.66)
bones[22].sprite:setScaleY(-1.00)
bones[22].sprite:setRotation(40.54)


-- leg1_008

sprites[27].sprite:setX(-2.00)
sprites[27].sprite:setY(-7)


-- leg2_008

sprites[28].sprite:setX(-1.00)
sprites[28].sprite:setY(-7)


-- tip 2_002

sprites[29].sprite:setX(-1.25)
sprites[29].sprite:setY(-4.5)


-- bone_034

bones[11].sprite:setX(2.08)
bones[11].sprite:setY(-12.63)
bones[11].sprite:setScaleX(-1.00)
bones[11].sprite:setRotation(136.50)


-- bone_035

bones[12].sprite:setX(19.75)
bones[12].sprite:setY(-0.25)
bones[12].sprite:setRotation(307.19)


-- bone_036

bones[13].sprite:setX(21.75)
bones[13].sprite:setY(0.75)
bones[13].sprite:setRotation(333.84)


-- leg1_009

sprites[33].sprite:setX(-1.75)
sprites[33].sprite:setY(-7)


-- leg2_009

sprites[34].sprite:setX(-1.25)
sprites[34].sprite:setY(-7.5)


-- tip 1_002

sprites[35].sprite:setX(-1.25)
sprites[35].sprite:setY(-6.25)


-- bone_037

bones[14].sprite:setX(-5.26)
bones[14].sprite:setY(-13.99)
bones[14].sprite:setScaleX(-1.00)
bones[14].sprite:setRotation(109.55)


-- bone_038

bones[15].sprite:setX(19.25)
bones[15].sprite:setY(0.75)
bones[15].sprite:setRotation(337.31)


-- bone_039

bones[16].sprite:setX(16.00)
bones[16].sprite:setY(0.25)
bones[16].sprite:setRotation(325.47)


-- leg1_010

sprites[39].sprite:setX(-1.50)
sprites[39].sprite:setY(-7.5)


-- leg2_010

sprites[40].sprite:setX(-0.50)
sprites[40].sprite:setY(-7.5)


-- fork_000

sprites[41].sprite:setX(-0.79)
sprites[41].sprite:setY(-7.62)


-- bone_040

bones[17].sprite:setX(-13.10)
bones[17].sprite:setY(-15.57)
bones[17].sprite:setScaleX(-1.00)
bones[17].sprite:setRotation(68.49)


-- bone_041

bones[18].sprite:setX(18.90)
bones[18].sprite:setY(-0.69)
bones[18].sprite:setRotation(18.75)


-- bone_042

bones[19].sprite:setX(20.00)
bones[19].sprite:setY(0.75)
bones[19].sprite:setRotation(27.96)


-- bum

sprites[0].sprite:setX(-7.50)
sprites[0].sprite:setY(-16.25)


-- head

sprites[1].sprite:setX(-10.75)
sprites[1].sprite:setY(-23)


-- bone_000

bones[0].sprite:setX(40.50)
bones[0].sprite:setY(24.5)


-- bone_001

bones[1].sprite:setX(32.75)
bones[1].sprite:setY(65.25)
bones[1].sprite:setRotation(270.77)


-- bone_002

bones[20].sprite:setX(32.00)
bones[20].sprite:setY(71.25)
bones[20].sprite:setRotation(91.55)



local timeLine = {}

-- Pounce 

timeLine[1] = {1,27,bones[1].sprite,{x={32.50,32.20},y={65.25,66.47}}} -- bone_001
timeLine[2] = {28,100,bones[1].sprite,{x={32.20,32.26},y={66.47,66.23}}} -- bone_001
timeLine[3] = {1,27,bones[20].sprite,{x={31.75,30.53},y={69.5,74.68},scaleX={1,1.10,""},scaleX={1,1.10},scaleY={1,0.94}}} -- bone_002
timeLine[4] = {28,100,bones[20].sprite,{x={30.53,30.77},y={74.68,73.66},scaleX={1.10,1.08,""},scaleX={1.10,1.08},scaleY={0.94,0.95}}} -- bone_002
timeLine[5] = {1,27,bones[2].sprite,{rotation={53.55,53.55-19.21}}} -- bone_023
timeLine[6] = {28,100,bones[2].sprite,{rotation={34.34,34.34-3.23}}} -- bone_023
timeLine[7] = {28,100,bones[3].sprite,{rotation={293.21,293.21-3.18}}} -- bone_024
timeLine[8] = {1,27,bones[4].sprite,{rotation={343.90,343.90+15.38}}} -- bone_025
timeLine[9] = {28,100,bones[4].sprite,{rotation={359.28,359.28-65.06}}} -- bone_025
timeLine[10] = {1,13,bones[5].sprite,{x={-4.34,-15.44},y={13.4,17.05},rotation={112.96,112.96+5.13}}} -- bone_026
timeLine[11] = {14,27,bones[5].sprite,{x={-15.44,-8.24},y={17.05,14.83},rotation={118.09,118.09+6.26}}} -- bone_026
timeLine[12] = {28,100,bones[5].sprite,{x={-8.24,-8.52},y={14.83,15.15},rotation={124.35,124.35-2.26}}} -- bone_026
timeLine[13] = {1,27,bones[6].sprite,{rotation={9.00,9.00+54.29}}} -- bone_027
timeLine[14] = {28,100,bones[6].sprite,{rotation={63.29,63.29-22.39}}} -- bone_027
timeLine[15] = {1,13,bones[7].sprite,{rotation={31.33,31.33-6.03}}} -- bone_028
timeLine[16] = {14,27,bones[7].sprite,{rotation={25.30,25.30+62.97}}} -- bone_028
timeLine[17] = {28,100,bones[7].sprite,{rotation={88.27,88.27-21.42}}} -- bone_028
timeLine[18] = {1,27,bones[8].sprite,{rotation={66.57,66.57+21.95}}} -- bone_029
timeLine[19] = {28,100,bones[8].sprite,{rotation={88.52,88.52-4.35}}} -- bone_029
timeLine[20] = {1,27,bones[9].sprite,{rotation={339.73,339.73+45.25}}} -- bone_030
timeLine[21] = {28,100,bones[9].sprite,{rotation={24.98,24.98-8.96}}} -- bone_030
timeLine[22] = {1,27,bones[10].sprite,{rotation={332.39,332.39+105.13}}} -- bone_031
timeLine[23] = {28,100,bones[10].sprite,{rotation={77.52,77.52-20.82}}} -- bone_031
timeLine[24] = {1,27,bones[21].sprite,{x={22.77,17.18},y={-8.87,-11.74},rotation={331.49,331.49+57.58}}} -- bone_032
timeLine[25] = {28,100,bones[21].sprite,{x={17.18,18.29},y={-11.74,-11.17},rotation={29.07,29.07-11.4}}} -- bone_032
timeLine[26] = {1,27,bones[22].sprite,{x={22.02,13.86},y={9.66,12.4},rotation={40.54,40.54-71.7}}} -- bone_033
timeLine[27] = {28,100,bones[22].sprite,{x={13.86,15.48},y={12.4,11.86},rotation={328.84,328.84+14.2}}} -- bone_033
timeLine[28] = {1,27,bones[11].sprite,{x={2.08,6.91},y={-12.63,-13.5},rotation={136.50,136.50+13.74}}} -- bone_034
timeLine[29] = {28,100,bones[11].sprite,{x={6.91,17.52},y={-13.5,-13.95},rotation={150.24,150.24+8.32}}} -- bone_034
timeLine[30] = {1,27,bones[12].sprite,{rotation={307.19,307.19+9.8}}} -- bone_035
timeLine[31] = {28,100,bones[12].sprite,{rotation={316.99,316.99-1.18}}} -- bone_035
timeLine[32] = {1,27,bones[13].sprite,{rotation={333.84,333.84+13.19}}} -- bone_036
timeLine[33] = {28,100,bones[13].sprite,{rotation={347.03,347.03-19.77}}} -- bone_036
timeLine[34] = {1,27,bones[14].sprite,{rotation={109.55,109.55-14.09,"inQuadratic"}}} -- bone_037
timeLine[35] = {28,100,bones[14].sprite,{x={-4.69,-3.47},y={-12.77,-12.83},rotation={95.46,95.46+2.79}}} -- bone_037
timeLine[36] = {1,27,bones[15].sprite,{rotation={337.31,337.31+88.9}}} -- bone_038
timeLine[37] = {28,100,bones[15].sprite,{rotation={66.21,66.21-17.6}}} -- bone_038
timeLine[38] = {1,27,bones[16].sprite,{rotation={325.47,325.47+77.07}}} -- bone_039
timeLine[39] = {28,100,bones[16].sprite,{rotation={42.54,42.54-15.26}}} -- bone_039
timeLine[40] = {1,13,bones[17].sprite,{x={-10.84,-17.33},y={-15.44,-16.92},rotation={68.49,68.49-13.39}}} -- bone_040
timeLine[41] = {14,27,bones[17].sprite,{x={-17.33,-10.84,"outBounce"},y={-16.92,-15.44,"outBounce"},rotation={55.10,55.10-8.86,"outBounce"}}} -- bone_040
timeLine[42] = {28,100,bones[17].sprite,{rotation={46.24,46.24+4.41}}} -- bone_040
timeLine[43] = {1,13,bones[18].sprite,{rotation={18.75,18.75+24.4}}} -- bone_041
timeLine[44] = {14,27,bones[18].sprite,{rotation={43.15,43.15+29.71}}} -- bone_041
timeLine[45] = {28,100,bones[18].sprite,{rotation={72.86,72.86-10.72}}} -- bone_041
timeLine[46] = {1,13,bones[19].sprite,{rotation={27.96,27.96-14.45}}} -- bone_042
timeLine[47] = {14,27,bones[19].sprite,{rotation={13.51,13.51+56.57}}} -- bone_042
timeLine[48] = {28,100,bones[19].sprite,{rotation={70.08,70.08-8.34}}} -- bone_042


-- Backup 

timeLine[49] = {100,128,bones[1].sprite,{rotation={273.07,273.07-2.32}}} -- bone_001
timeLine[50] = {129,159,bones[1].sprite,{rotation={270.75,270.75+2.32}}} -- bone_001
timeLine[51] = {100,128,bones[20].sprite,{x={30.77,31.69},y={73.66,73.66},rotation={85.64,85.64+6.45}}} -- bone_002
timeLine[52] = {129,159,bones[20].sprite,{x={31.69,30.77},y={73.66,73.66},rotation={92.09,92.09-6.45}}} -- bone_002
timeLine[53] = {100,113,bones[2].sprite,{x={7.58,15.43},y={15.18,13.41},rotation={31.11,31.11+26.76}}} -- bone_023
timeLine[54] = {114,128,bones[2].sprite,{x={15.43,23.57},y={13.41,11.58},rotation={57.87,57.87-34.81}}} -- bone_023
timeLine[55] = {129,159,bones[2].sprite,{x={23.57,7.58},y={11.58,15.18},rotation={23.06,23.06+8.05}}} -- bone_023
timeLine[56] = {100,113,bones[3].sprite,{rotation={290.03,290.03+23.19}}} -- bone_024
timeLine[57] = {114,128,bones[3].sprite,{rotation={313.22,313.22-1.88}}} -- bone_024
timeLine[58] = {129,159,bones[3].sprite,{rotation={311.34,311.34-21.31}}} -- bone_024
timeLine[59] = {100,113,bones[4].sprite,{rotation={294.22,294.22+49.68}}} -- bone_025
timeLine[60] = {114,128,bones[4].sprite,{rotation={343.90,343.90-2.9}}} -- bone_025
timeLine[61] = {129,159,bones[4].sprite,{rotation={341.00,341.00-46.78}}} -- bone_025
timeLine[62] = {100,128,bones[7].sprite,{rotation={66.85,66.85+7.14}}} -- bone_028
timeLine[63] = {129,159,bones[7].sprite,{rotation={73.99,73.99-7.14}}} -- bone_028
timeLine[64] = {100,128,bones[8].sprite,{rotation={84.17,84.17-6.33}}} -- bone_029
timeLine[65] = {129,159,bones[8].sprite,{rotation={77.84,77.84+6.33}}} -- bone_029
timeLine[66] = {100,128,bones[9].sprite,{rotation={16.02,16.02-3.63}}} -- bone_030
timeLine[67] = {129,159,bones[9].sprite,{rotation={12.39,12.39+3.63}}} -- bone_030
timeLine[68] = {100,128,bones[10].sprite,{x={21.00,20.09},y={0.5,0.55},rotation={56.70,56.70-5.45}}} -- bone_031
timeLine[69] = {129,159,bones[10].sprite,{x={20.09,21.00},y={0.55,0.5},rotation={51.25,51.25+5.45}}} -- bone_031
timeLine[70] = {100,128,bones[11].sprite,{x={17.52,7.40},y={-13.95,-14.93},rotation={158.56,158.56-12.93}}} -- bone_034
timeLine[71] = {129,146,bones[11].sprite,{x={7.40,13.26},y={-14.93,-14.36},rotation={145.63,145.63-6.56}}} -- bone_034
timeLine[72] = {147,159,bones[11].sprite,{x={13.26,17.52},y={-14.36,-13.95},rotation={139.07,139.07+19.49}}} -- bone_034
timeLine[73] = {100,128,bones[12].sprite,{rotation={315.81,315.81-28.92}}} -- bone_035
timeLine[74] = {129,146,bones[12].sprite,{rotation={286.89,286.89+31.37}}} -- bone_035
timeLine[75] = {147,159,bones[12].sprite,{rotation={318.26,318.26-2.45}}} -- bone_035
timeLine[76] = {100,128,bones[13].sprite,{rotation={327.26,327.26-32.15}}} -- bone_036
timeLine[77] = {129,146,bones[13].sprite,{rotation={295.11,295.11+45.8}}} -- bone_036
timeLine[78] = {147,159,bones[13].sprite,{rotation={340.91,340.91-13.65}}} -- bone_036
timeLine[79] = {100,128,bones[14].sprite,{rotation={98.25,98.25+6.09}}} -- bone_037
timeLine[80] = {129,159,bones[14].sprite,{rotation={104.34,104.34-6.09}}} -- bone_037
timeLine[81] = {100,128,bones[15].sprite,{rotation={48.61,48.61-5.4}}} -- bone_038
timeLine[82] = {129,159,bones[15].sprite,{rotation={43.21,43.21+5.4}}} -- bone_038
timeLine[83] = {100,128,bones[16].sprite,{rotation={27.28,27.28-5.82}}} -- bone_039
timeLine[84] = {129,159,bones[16].sprite,{rotation={21.46,21.46+5.82}}} -- bone_039
timeLine[85] = {100,128,bones[19].sprite,{rotation={61.74,61.74-11.04}}} -- bone_042
timeLine[86] = {129,159,bones[19].sprite,{rotation={50.70,50.70+11.04}}} -- bone_042


-- Reset 

timeLine[87] = {159,198,bones[1].sprite,{x={32.26,32.50},y={66.23,65.25}}} -- bone_001
timeLine[88] = {159,198,bones[20].sprite,{x={30.77,31.75},y={73.66,69.5},scaleX={1.08,1.00,""},scaleX={1.08,1.00},scaleY={0.95,1.00}}} -- bone_002
timeLine[89] = {159,198,bones[2].sprite,{rotation={31.11,31.11+22.44}}} -- bone_023
timeLine[90] = {159,198,bones[3].sprite,{rotation={290.03,290.03+3.18}}} -- bone_024
timeLine[91] = {159,198,bones[4].sprite,{rotation={294.22,294.22+49.68}}} -- bone_025
timeLine[92] = {159,198,bones[5].sprite,{x={-8.52,-4.34},y={15.15,13.4},rotation={122.09,122.09-9.13}}} -- bone_026
timeLine[93] = {159,198,bones[6].sprite,{rotation={40.90,40.90-31.9}}} -- bone_027
timeLine[94] = {159,198,bones[7].sprite,{rotation={66.85,66.85-35.52}}} -- bone_028
timeLine[95] = {159,198,bones[8].sprite,{rotation={84.17,84.17-17.6}}} -- bone_029
timeLine[96] = {159,198,bones[9].sprite,{rotation={16.02,16.02-36.29}}} -- bone_030
timeLine[97] = {159,198,bones[10].sprite,{rotation={56.70,56.70-84.31}}} -- bone_031
timeLine[98] = {159,198,bones[21].sprite,{x={18.29,22.77},y={-11.17,-8.87},rotation={17.67,17.67-46.18}}} -- bone_032
timeLine[99] = {159,198,bones[22].sprite,{x={15.48,22.02},y={11.86,9.66},rotation={343.04,343.04+57.5}}} -- bone_033
timeLine[100] = {159,198,bones[11].sprite,{x={17.52,2.08},y={-13.95,-12.63},rotation={158.56,158.56-22.06}}} -- bone_034
timeLine[101] = {159,198,bones[12].sprite,{rotation={315.81,315.81-8.62}}} -- bone_035
timeLine[102] = {159,198,bones[13].sprite,{rotation={327.26,327.26+6.58}}} -- bone_036
timeLine[103] = {159,198,bones[14].sprite,{x={-3.47,-4.69},y={-12.83,-12.77},rotation={98.25,98.25+11.3}}} -- bone_037
timeLine[104] = {159,198,bones[15].sprite,{rotation={48.61,48.61-71.3}}} -- bone_038
timeLine[105] = {159,198,bones[16].sprite,{rotation={27.28,27.28-61.81}}} -- bone_039
timeLine[106] = {159,198,bones[17].sprite,{rotation={50.65,50.65+17.84}}} -- bone_040
timeLine[107] = {159,198,bones[18].sprite,{rotation={62.14,62.14-43.39}}} -- bone_041
timeLine[108] = {159,198,bones[19].sprite,{rotation={61.74,61.74-33.78}}} -- bone_042

self.mc = MovieClip.new(timeLine)
--self.mc:setGotoAction(100,1)

end


