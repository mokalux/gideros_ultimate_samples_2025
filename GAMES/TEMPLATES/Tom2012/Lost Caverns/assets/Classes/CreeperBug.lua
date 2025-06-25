CreeperBug = Core.class(Sprite)

function CreeperBug:init(scene,x,y,speed,id)

	self.scene = scene
	self.type = "creeper bug"
	
	-- set up atlas if not already created
	
	if(not(self.scene.creeperBugAtlas)) then
	
		self.scene.creeperBugAtlas = TexturePack.new("Atlases/creeper bug.txt", "Atlases/creeper bug.png",true)

	end
	

	self.id = id
	self.speed = speed
	self.value = 150

	self.scene.rube1:addChild(self)
	self:createAnim()

	
	self.hunkerTimer = 0
	self.hunkerAt = math.random(150,250)
	self.pathCounter = 1
	
	self.theBug = Sprite.new()
	--self:addChild(self.theBug)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(x, y)
	
	-- Collect loot collision shape
	
	local circle = b2.CircleShape.new(0,0,20)
	local fixture = body:createFixture{shape = circle, density = 1, friction = 0, restitution = 0, isSensor=true}
	local filterData = {categoryBits = 128, maskBits = 2}
	fixture:setFilterData(filterData)
	
	fixture.parent = self
	fixture.name = "loot"
	self.body = body
	self.fixture = fixture
	self.body:setActive(false)

	local filterData = {categoryBits = 4096, maskBits = 8192}
	fixture:setFilterData(filterData)

	self.phase = "walking"
	
	--------------------------------------------------------------
	-- Set up particle emmiter
	--------------------------------------------------------------

	if(not(self.scene.creeperBugParticles)) then
	
		require("Classes/CreeperBugParticles")
		local particles = CreeperBugParticles.new(self.scene)
		self.scene.frontLayer:addChild(particles)
		self.scene.creeperBugParticles = particles
		self.scene.creeperBugParticles.emitter:start()
		
	end

	-- sounds
	
	self.maxVolume = .05
	self.volume = 0
	
	if(not(self.scene.bugWalkSound)) then
		self.scene.bugWalkSound = Sound.new("Sounds/bug walk.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.bugWalkSound:play(0,math.huge,false)
	self.channel1:setVolume(0)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end



function CreeperBug:pause()

	self.anim:stop()

end




function CreeperBug:resume()

	self.anim:play()

end





function CreeperBug:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		if(not(self.body.destroyed)) then
		

			local currentX,currentY = self:getPosition()

			local nextX = self.scene.path[self.id].vertices.x[self.pathCounter]
			local nextY = self.scene.path[self.id].vertices.y[self.pathCounter]

			local distance = math.sqrt( ((currentY-nextY) ^ 2) + ((currentX-nextX) ^ 2) )

			local xDiff = nextX - currentX
			local yDiff = nextY - currentY
			

			local angle = math.atan2(yDiff,xDiff)

			local nextX = currentX + (math.cos(angle) * self.speed)
			local nextY = currentY + (math.sin(angle) * self.speed)
			
			if(self.phase == "walking") then
			
				self.hunkerTimer = self.hunkerTimer + 1
				
				--print(self.hunkerAt, self.hunkerTimer)
				
				if(self.hunkerTimer==self.hunkerAt) then
				
					self:hunkerDown()

				end
				
				self:setPosition(nextX, nextY)
				
			end
			
			if(distance<=1) then
			
				self.pathCounter = self.pathCounter + 1
				
				if(self.pathCounter > #self.scene.path[self.id].vertices.x) then
					self.pathCounter = 1
				end
			
				--self.phase = "turning"
				self:rotateToAngle()
			

			end
			
			self.body:setPosition(self:getPosition())
			
		end
	
	end

end








function CreeperBug:hunkerDown()

	if(self.channel1) then
		self.channel1:setPaused(true)
	end

	-- play expose anim
	
	self.mc:gotoAndPlay(76)
	self.mc:setStopAction(123)

	self.phase = "hunker"
	self.hunkerTimer = 0
	self.hunkerAt = math.random(150,250)
	
	self.body:setActive(true)
	
	self:canCollect()
	
end




function CreeperBug:canCollect()
	
	local hunkerFor = math.random(1500,3500)
	Timer.delayedCall(hunkerFor,self.unHunker, self)

end




function CreeperBug:unHunker()



	if(not(self.isCollected)) then

		if(self.channel1) then
			self.channel1:setPaused(false)
		end

		if(not(self.body.destroyed)) then

		self.mc:gotoAndPlay(174)
		self.mc:setStopAction(207)


			self.body:setActive(false)
			Timer.delayedCall(500,self.startWalking, self)
		end
	
	end

end






function CreeperBug:startWalking()

	if(not(self.body.destroyed)) then
		self.mc:gotoAndPlay(1)
		self.mc:setGotoAction(74,1)
		self.phase = "walking"
		self.body:setActive(false)
	end

end





function CreeperBug:rotateToAngle()

	self.currentAngle = self:getRotation()

	local currentX,currentY = self:getPosition()
	
	self.nextXPoint = self.scene.path[self.id].vertices.x[self.pathCounter]
	self.nextYPoint = self.scene.path[self.id].vertices.y[self.pathCounter]
	
	local xDiff = currentX - self.nextXPoint
	local yDiff = currentY - self.nextYPoint

	self.newAngle = math.deg(math.atan2(yDiff,xDiff))-90
	
	-- work out the smallest angle
	
	self.rotation = self.newAngle - self.currentAngle
	
	while(self.rotation < -180) do
		self.rotation = self.rotation + 360
	end
	
	while(self.rotation > 180) do
		self.rotation = self.rotation - 360
	end
	
	self.timeToTurn = (self.rotation / 2) / 90
	
	if(self.timeToTurn<0) then
		self.timeToTurn = self.timeToTurn *-1
	end
	
	if(self.timeToTurn<.1) then
		self.timeToTurn = .2
	end
	
	
	local tween = GTween.new(self, self.timeToTurn, {rotation = self.currentAngle + self.rotation})
	
	-- If this was a really big turn, stop walking
	
	self.rotPos = self.rotation
	if(self.rotPos < 0) then
		self.rotPos = self.rotPos * -1
	end
	
	if(self.rotPos > 150) then
		self.phase = "turning"
		Timer.delayedCall(self.rotPos*4.1, function() self.phase = "walking" end)
	end


end









function CreeperBug:collected()

	local channel1 = self.scene.collectGoldSound:play()
	channel1:setVolume(.1*self.scene.soundVol)
	
	if(self.channel1) then
		self.channel1:setPaused(true)
	end

	self.scene.creeperBugParticles:setPosition(self:getX()+1, self:getY()-8)
	self.scene.creeperBugParticles.emitter:start()

	self.isCollected = true
	self.body.destroyed = true
	Timer.delayedCall(10, function()
		self:removeFromVolume()
		self.scene.world:destroyBody(self.body) -- remove physics body
		self:getParent():removeChild(self)
	end)
	
	self.scene.loot = self.scene.loot + self.value
	--self.scene.interface:updateLoot()
	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300,"creeper bug")
	
end




function CreeperBug:removeFromVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do
		if(v==self) then
			print("remove")
			table.remove(self.scene.spritesWithVolume, i)
		end
	end

end



function CreeperBug:exit()
	
	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

	
end



function CreeperBug:pause()

end




function CreeperBug:resume()

end




function CreeperBug:createAnim()

	local mainSprite = Sprite.new()
	self:addChild(mainSprite)
	mainSprite:setPosition(-115,-60)
	self.mainSprite = mainSprite
	
local bones = {}

-- Setup bones

-- bone_008

local sprite = Sprite.new()
mainSprite:addChild(sprite)
bones[0] = {}
bones[0].sprite = sprite

-- bone_010

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[1] = {}
bones[1].sprite = sprite

-- bone_000

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[2] = {}
bones[2].sprite = sprite

-- bone_001

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[3] = {}
bones[3].sprite = sprite

-- bone_002

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[4] = {}
bones[4].sprite = sprite

-- bone_006

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[5] = {}
bones[5].sprite = sprite

-- bone_007

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[6] = {}
bones[6].sprite = sprite

-- bone_009

local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
bones[7] = {}
bones[7].sprite = sprite

-- bone_011

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[8] = {}
bones[8].sprite = sprite

-- bone_005

local sprite = Sprite.new()
bones[8].sprite:addChild(sprite)
bones[9] = {}
bones[9].sprite = sprite

-- bone_012

local sprite = Sprite.new()
bones[8].sprite:addChild(sprite)
bones[10] = {}
bones[10].sprite = sprite

-- bone_003

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[11] = {}
bones[11].sprite = sprite

-- bone_004

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[12] = {}
bones[12].sprite = sprite

-- Setup image sprites

local sprites = {}

-- leg1 ---------

sprites[1] = {}
local sprite = Sprite.new()
bones[4].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[1].sprite = sprite

-- leg2 ---------

sprites[2] = {}
local sprite = Sprite.new()
bones[3].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[2].sprite = sprite

-- leg3 ---------

sprites[3] = {}
local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("leg3.png"))
sprite:addChild(img)
sprites[3].sprite = sprite

-- wing1 ---------

sprites[4] = {}
local sprite = Sprite.new()
bones[11].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("wing1.png"))
sprite:addChild(img)
sprites[4].sprite = sprite

-- leg1_000 ---------

sprites[9] = {}
local sprite = Sprite.new()
bones[7].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("leg1.png"))
sprite:addChild(img)
sprites[9].sprite = sprite

-- leg2_000 ---------

sprites[10] = {}
local sprite = Sprite.new()
bones[6].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("leg2.png"))
sprite:addChild(img)
sprites[10].sprite = sprite

-- leg3_000 ---------

sprites[11] = {}
local sprite = Sprite.new()
bones[5].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("leg3.png"))
sprite:addChild(img)
sprites[11].sprite = sprite

-- gem ---------

sprites[15] = {}
local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("gem.png"))
sprite:addChild(img)
sprites[15].sprite = sprite

-- head_000 ---------

sprites[17] = {}
local sprite = Sprite.new()
bones[8].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("head.png"))
sprite:addChild(img)
sprites[17].sprite = sprite

-- wing2 ---------

sprites[19] = {}
local sprite = Sprite.new()
bones[12].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("wing2.png"))
sprite:addChild(img)
sprites[19].sprite = sprite

-- antenna1 ---------

sprites[21] = {}
local sprite = Sprite.new()
bones[9].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("antenna1.png"))
sprite:addChild(img)
sprites[21].sprite = sprite

-- antenna2 ---------

sprites[22] = {}
local sprite = Sprite.new()
bones[10].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.creeperBugAtlas:getTextureRegion("antenna2.png"))
sprite:addChild(img)
sprites[22].sprite = sprite

-- Adjust the sprites (from first frame of timelines)

-- bone_008

bones[0].sprite:setX(87.52)
bones[0].sprite:setY(17.75)


-- leg1

sprites[1].sprite:setX(-0.12)
sprites[1].sprite:setY(-6.07)


-- leg2

sprites[2].sprite:setX(-1.00)
sprites[2].sprite:setY(-2.5)


-- leg3

sprites[3].sprite:setX(-7.00)
sprites[3].sprite:setY(-12.63)


-- wing1

sprites[4].sprite:setX(-5.05)
sprites[4].sprite:setY(-11.05)


-- bone_000

bones[2].sprite:setX(11.20)
bones[2].sprite:setY(-14.35)
bones[2].sprite:setScaleX(1.05)
bones[2].sprite:setRotation(252.37)


-- bone_001

bones[3].sprite:setX(15.38)
bones[3].sprite:setY(-15.68)
bones[3].sprite:setScaleX(1.05)
bones[3].sprite:setRotation(271.62)


-- bone_002

bones[4].sprite:setX(28.04)
bones[4].sprite:setY(-11.3)
bones[4].sprite:setScaleX(1.05)
bones[4].sprite:setRotation(345.87)


-- bone_003

bones[11].sprite:setX(33.93)
bones[11].sprite:setY(30.27)
bones[11].sprite:setRotation(90.92)


-- leg1_000

sprites[9].sprite:setX(-0.37)
sprites[9].sprite:setY(-6.51)


-- leg2_000

sprites[10].sprite:setX(-1.00)
sprites[10].sprite:setY(-2.81)


-- leg3_000

sprites[11].sprite:setX(-7.62)
sprites[11].sprite:setY(-12.63)


-- bone_006

bones[5].sprite:setX(2.78)
bones[5].sprite:setY(15.29)
bones[5].sprite:setScaleX(-1.05)
bones[5].sprite:setRotation(321.06)


-- bone_007

bones[6].sprite:setX(17.38)
bones[6].sprite:setY(18.29)
bones[6].sprite:setScaleX(-1.05)
bones[6].sprite:setRotation(248.34)


-- bone_009

bones[7].sprite:setX(20.75)
bones[7].sprite:setY(15.99)
bones[7].sprite:setScaleX(-1.05)
bones[7].sprite:setRotation(195.52)


-- gem

sprites[15].sprite:setX(-0.56)
sprites[15].sprite:setY(-15.6)


-- bone_010

bones[1].sprite:setX(28.65)
bones[1].sprite:setY(28.11)
bones[1].sprite:setScaleX(0.95)
bones[1].sprite:setRotation(89.49)


-- head_000

sprites[17].sprite:setX(-1.50)
sprites[17].sprite:setY(-8.65)


-- bone_011

bones[8].sprite:setX(23.57)
bones[8].sprite:setY(29.43)
bones[8].sprite:setRotation(257.33)


-- wing2

sprites[19].sprite:setX(-4.70)
sprites[19].sprite:setY(-6.02)


-- bone_004

bones[12].sprite:setX(22.63)
bones[12].sprite:setY(30.37)
bones[12].sprite:setRotation(90.83)


-- antenna1

sprites[21].sprite:setX(0.23)
sprites[21].sprite:setY(-2.8)


-- antenna2

sprites[22].sprite:setX(0.23)
sprites[22].sprite:setY(-2.1)


-- bone_005

bones[9].sprite:setX(12.21)
bones[9].sprite:setY(-6.47)
bones[9].sprite:setRotation(356.50)


-- bone_012

bones[10].sprite:setX(11.73)
bones[10].sprite:setY(4.2)
bones[10].sprite:setRotation(10.12)


-- bone_008

bones[0].sprite:setX(87.52)
bones[0].sprite:setY(17.75)


-- leg1

sprites[1].sprite:setX(-0.12)
sprites[1].sprite:setY(-6.07)


-- leg2

sprites[2].sprite:setX(-1.00)
sprites[2].sprite:setY(-2.5)


-- leg3

sprites[3].sprite:setX(-7.00)
sprites[3].sprite:setY(-12.63)


-- wing1

sprites[4].sprite:setX(-5.05)
sprites[4].sprite:setY(-11.05)


-- bone_000

bones[2].sprite:setX(11.20)
bones[2].sprite:setY(-14.35)
bones[2].sprite:setScaleX(1.05)
bones[2].sprite:setRotation(252.37)


-- bone_001

bones[3].sprite:setX(15.38)
bones[3].sprite:setY(-15.68)
bones[3].sprite:setScaleX(1.05)
bones[3].sprite:setRotation(271.62)


-- bone_002

bones[4].sprite:setX(28.04)
bones[4].sprite:setY(-11.3)
bones[4].sprite:setScaleX(1.05)
bones[4].sprite:setRotation(345.87)


-- bone_003

bones[11].sprite:setX(33.93)
bones[11].sprite:setY(30.27)
bones[11].sprite:setRotation(90.92)


-- leg1_000

sprites[9].sprite:setX(-0.37)
sprites[9].sprite:setY(-6.51)


-- leg2_000

sprites[10].sprite:setX(-1.00)
sprites[10].sprite:setY(-2.81)


-- leg3_000

sprites[11].sprite:setX(-7.62)
sprites[11].sprite:setY(-12.63)


-- bone_006

bones[5].sprite:setX(2.78)
bones[5].sprite:setY(15.29)
bones[5].sprite:setScaleX(-1.05)
bones[5].sprite:setRotation(321.06)


-- bone_007

bones[6].sprite:setX(17.38)
bones[6].sprite:setY(18.29)
bones[6].sprite:setScaleX(-1.05)
bones[6].sprite:setRotation(248.34)


-- bone_009

bones[7].sprite:setX(20.75)
bones[7].sprite:setY(15.99)
bones[7].sprite:setScaleX(-1.05)
bones[7].sprite:setRotation(195.52)


-- gem

sprites[15].sprite:setX(-0.56)
sprites[15].sprite:setY(-15.6)


-- bone_010

bones[1].sprite:setX(28.65)
bones[1].sprite:setY(28.11)
bones[1].sprite:setScaleX(0.95)
bones[1].sprite:setRotation(89.49)


-- head_000

sprites[17].sprite:setX(-1.50)
sprites[17].sprite:setY(-8.65)


-- wing2

sprites[19].sprite:setX(-4.70)
sprites[19].sprite:setY(-6.02)


-- bone_004

bones[12].sprite:setX(22.63)
bones[12].sprite:setY(30.37)
bones[12].sprite:setRotation(90.83)


-- antenna1

sprites[21].sprite:setX(0.23)
sprites[21].sprite:setY(-2.8)


-- antenna2

sprites[22].sprite:setX(0.23)
sprites[22].sprite:setY(-2.1)


-- bone_005

bones[9].sprite:setX(12.21)
bones[9].sprite:setY(-6.47)
bones[9].sprite:setRotation(356.50)


-- bone_012

bones[10].sprite:setX(11.73)
bones[10].sprite:setY(4.2)
bones[10].sprite:setRotation(10.12)



local timeLine = {}

-- Walking 

timeLine[1] = {1,17,bones[2].sprite,{x={11.20,6.40},y={-14.35,-13.48},rotation={252.37,252.37-11.87}}} -- bone_000
timeLine[2] = {18,36,bones[2].sprite,{x={6.40,1.36},y={-13.48,-12.57},rotation={240.50,240.50-12.47}}} -- bone_000
timeLine[3] = {37,56,bones[2].sprite,{x={1.36,6.49},y={-12.57,-13.5},rotation={228.03,228.03+12.7}}} -- bone_000
timeLine[4] = {57,75,bones[2].sprite,{x={6.49,11.20},y={-13.5,-14.35},rotation={240.73,240.73+11.64}}} -- bone_000
timeLine[5] = {1,17,bones[3].sprite,{x={15.38,17.65},y={-15.68,-15.09},rotation={271.62,271.62+10.69}}} -- bone_001
timeLine[6] = {18,36,bones[3].sprite,{x={17.65,20.03},y={-15.09,-14.47},rotation={282.31,282.31+11.22}}} -- bone_001
timeLine[7] = {37,56,bones[3].sprite,{x={20.03,17.60},y={-14.47,-15.1},scaleX={1.05,1.24,""},scaleX={1.05,1.24},scaleY={1.00,1.29},rotation={293.53,293.53-11.43}}} -- bone_001
timeLine[8] = {57,75,bones[3].sprite,{x={17.60,15.38},y={-15.1,-15.68},scaleX={1.24,1.05,""},scaleX={1.24,1.05},scaleY={1.29,1.00},rotation={282.10,282.10-10.48}}} -- bone_001
timeLine[9] = {1,17,bones[4].sprite,{x={28.04,25.65},y={-11.3,-11.89},rotation={345.87,345.87-8.87}}} -- bone_002
timeLine[10] = {18,36,bones[4].sprite,{x={25.65,23.14},y={-11.89,-12.51},rotation={337.00,337.00-9.31}}} -- bone_002
timeLine[11] = {37,56,bones[4].sprite,{x={23.14,25.70},y={-12.51,-11.88},rotation={327.69,327.69+9.48}}} -- bone_002
timeLine[12] = {57,75,bones[4].sprite,{x={25.70,28.04},y={-11.88,-11.3},rotation={337.17,337.17+8.7}}} -- bone_002
timeLine[13] = {1,17,bones[11].sprite,{scaleX={1.00,1.08,""},scaleX={1.00,1.08},rotation={90.92,90.92-3.61}}} -- bone_003
timeLine[14] = {18,36,bones[11].sprite,{scaleX={1.08,1.00,""},scaleX={1.08,1.00},rotation={87.31,87.31-3.79}}} -- bone_003
timeLine[15] = {37,56,bones[11].sprite,{scaleX={1.00,1.07,""},scaleX={1.00,1.07},rotation={83.52,83.52+3.86}}} -- bone_003
timeLine[16] = {57,75,bones[11].sprite,{scaleX={1.07,1.00,""},scaleX={1.07,1.00},rotation={87.38,87.38+3.54}}} -- bone_003
timeLine[17] = {1,17,bones[5].sprite,{x={2.78,4.81},y={15.29,16.34},rotation={321.06,321.06-13.23}}} -- bone_006
timeLine[18] = {18,36,bones[5].sprite,{x={4.81,6.94},y={16.34,17.43},rotation={307.83,307.83-13.89}}} -- bone_006
timeLine[19] = {37,56,bones[5].sprite,{x={6.94,4.77},y={17.43,16.32},rotation={293.94,293.94+14.14}}} -- bone_006
timeLine[20] = {57,75,bones[5].sprite,{x={4.77,2.78},y={16.32,15.29},rotation={308.08,308.08+12.98}}} -- bone_006
timeLine[21] = {1,17,bones[6].sprite,{x={17.38,14.86},y={18.29,18.38},scaleX={-1.05,-1.35,""},scaleX={-1.05,-1.35},scaleY={1.00,1.35},rotation={248.34,248.34+12.79}}} -- bone_007
timeLine[22] = {18,36,bones[6].sprite,{x={14.86,12.22},y={18.38,18.48},scaleX={-1.35,-1.05,""},scaleX={-1.35,-1.05},scaleY={1.35,1.00},rotation={261.13,261.13+13.42}}} -- bone_007
timeLine[23] = {37,56,bones[6].sprite,{x={12.22,14.91},y={18.48,18.38},rotation={274.55,274.55-13.67}}} -- bone_007
timeLine[24] = {57,75,bones[6].sprite,{x={14.91,17.38},y={18.38,18.29},rotation={260.88,260.88-12.54}}} -- bone_007
timeLine[25] = {1,17,bones[7].sprite,{x={20.75,23.52},y={15.99,14.99},rotation={195.52,195.52-7.61}}} -- bone_009
timeLine[26] = {18,36,bones[7].sprite,{x={23.52,26.42},y={14.99,13.93},rotation={187.91,187.91-8}}} -- bone_009
timeLine[27] = {37,56,bones[7].sprite,{x={26.42,23.47},y={13.93,15.01},rotation={179.91,179.91+8.14}}} -- bone_009
timeLine[28] = {57,75,bones[7].sprite,{x={23.47,20.75},y={15.01,15.99},rotation={188.05,188.05+7.47}}} -- bone_009
timeLine[29] = {1,17,bones[8].sprite,{x={23.57,24.04},y={29.43,27.56},scaleX={1,1.12,""},scaleX={1,1.12},rotation={257.33,257.33+13.13}}} -- bone_011
timeLine[30] = {18,36,bones[8].sprite,{x={24.04,23.57},y={27.56,29.43},scaleX={1.12,1.00,""},scaleX={1.12,1.00},rotation={270.46,270.46+13.78}}} -- bone_011
timeLine[31] = {37,56,bones[8].sprite,{scaleX={1,1.08,""},scaleX={1,1.08},rotation={284.24,284.24-14.03}}} -- bone_011
timeLine[32] = {57,75,bones[8].sprite,{scaleX={1.08,1.00,""},scaleX={1.08,1.00},rotation={270.21,270.21-12.88}}} -- bone_011
timeLine[33] = {1,17,bones[12].sprite,{scaleX={1,1.09,""},scaleX={1,1.09},rotation={90.83,90.83-2.55}}} -- bone_004
timeLine[34] = {18,36,bones[12].sprite,{scaleX={1.09,1.00,""},scaleX={1.09,1.00},rotation={88.28,88.28-2.69}}} -- bone_004
timeLine[35] = {37,56,bones[12].sprite,{scaleX={1,1.09,""},scaleX={1,1.09},rotation={85.59,85.59+2.74}}} -- bone_004
timeLine[36] = {57,75,bones[12].sprite,{scaleX={1.09,1.00,""},scaleX={1.09,1.00},rotation={88.33,88.33+2.5}}} -- bone_004
timeLine[37] = {1,17,bones[9].sprite,{scaleX={1,0.90,""},scaleX={1,0.90},rotation={356.50,356.50-13.37}}} -- bone_005
timeLine[38] = {18,36,bones[9].sprite,{scaleX={0.90,1.00,""},scaleX={0.90,1.00},rotation={343.13,343.13-5}}} -- bone_005
timeLine[39] = {37,56,bones[9].sprite,{scaleX={1,0.93,""},scaleX={1,0.93},rotation={338.13,338.13+33.35}}} -- bone_005
timeLine[40] = {57,75,bones[9].sprite,{scaleX={0.93,1.00,""},scaleX={0.93,1.00},rotation={11.48,11.48-14.98}}} -- bone_005
timeLine[41] = {1,17,bones[10].sprite,{scaleX={1,0.90,""},scaleX={1,0.90},rotation={10.12,10.12-23.23}}} -- bone_012
timeLine[42] = {18,36,bones[10].sprite,{scaleX={0.90,1.00,""},scaleX={0.90,1.00},rotation={346.89,346.89+5.76}}} -- bone_012
timeLine[43] = {37,56,bones[10].sprite,{scaleX={1,0.93,""},scaleX={1,0.93},rotation={352.65,352.65+20.79}}} -- bone_012
timeLine[44] = {57,75,bones[10].sprite,{scaleX={0.93,1.00,""},scaleX={0.93,1.00},rotation={13.44,13.44-3.32}}} -- bone_012



-- Expose 

timeLine[45] = {75,123,bones[2].sprite,{x={11.20,4.73},y={-14.35,-5.53},scaleX={1.05,0.95,""},scaleX={1.05,0.95}}} -- bone_000
timeLine[46] = {75,123,bones[3].sprite,{x={15.38,13.59},y={-15.68,-8.68},scaleX={1.05,0.95,""},scaleX={1.05,0.95}}} -- bone_001
timeLine[47] = {75,123,bones[4].sprite,{x={28.04,18.17},y={-11.3,-5.31},scaleX={1.05,0.95,""},scaleX={1.05,0.95}}} -- bone_002
timeLine[48] = {75,123,bones[11].sprite,{x={33.93,36.50,"outBounce"},y={30.27,28.63,"outBounce"},scaleY={1,0.60,"outBounce"},rotation={90.92,90.92-138.69,"outBounce"}}} -- bone_003
timeLine[49] = {75,123,bones[5].sprite,{x={2.78,8.60},y={15.29,11.3},scaleX={-1.05,-0.95,""},scaleX={-1.05,-0.95}}} -- bone_006
timeLine[50] = {75,123,bones[6].sprite,{x={17.38,11.91},y={18.29,13.08},scaleX={-1.05,-0.95,""},scaleX={-1.05,-0.95}}} -- bone_007
timeLine[51] = {75,123,bones[7].sprite,{x={20.75,17.15},y={15.99,7.38},scaleX={-1.05,-0.95,""},scaleX={-1.05,-0.95}}} -- bone_009
timeLine[52] = {75,123,bones[1].sprite,{x={28.65,27.95},y={28.11,31.85},scaleX={0.95,1.05,""},scaleX={0.95,1.05}}} -- bone_010
timeLine[53] = {75,123,bones[8].sprite,{x={23.57,25.68},y={29.43,32.47},scaleX={1,0.84,""},scaleX={1,0.84},scaleY={1,1.09},rotation={257.33,257.33+4.18}}} -- bone_011
timeLine[54] = {75,123,bones[12].sprite,{x={22.63,17.26,"outBounce"},y={30.37,29.9,"outBounce"},scaleY={1,0.65,"outBounce"},rotation={90.83,90.83+127.12,"outBounce"}}} -- bone_004
timeLine[55] = {75,123,bones[9].sprite,{scaleX={1,1.18,""},scaleX={1,1.18},scaleY={1,0.92}}} -- bone_005
timeLine[56] = {75,123,bones[10].sprite,{scaleX={1,1.18,""},scaleX={1,1.18},scaleY={1,0.92}}} -- bone_012


-- Close 

timeLine[57] = {174,207,bones[2].sprite,{x={4.73,11.20},y={-5.53,-14.35},scaleX={0.95,1.05,""},scaleX={0.95,1.05}}} -- bone_000
timeLine[58] = {174,207,bones[3].sprite,{x={13.59,15.38},y={-8.68,-15.68},scaleX={0.95,1.05,""},scaleX={0.95,1.05}}} -- bone_001
timeLine[59] = {174,207,bones[4].sprite,{x={18.17,28.04},y={-5.31,-11.3},scaleX={0.95,1.05,""},scaleX={0.95,1.05}}} -- bone_002
timeLine[60] = {174,207,bones[11].sprite,{x={36.50,33.23,"outBounce"},y={28.63,30.03,"outBounce"},scaleY={0.60,1.00,"outBounce"},rotation={312.23,312.23+135.26,"outBounce"}}} -- bone_003
timeLine[61] = {174,207,bones[5].sprite,{x={8.60,2.78},y={11.3,15.29},scaleX={-0.95,-1.05,""},scaleX={-0.95,-1.05}}} -- bone_006
timeLine[62] = {174,207,bones[6].sprite,{x={11.91,17.38},y={13.08,18.29},scaleX={-0.95,-1.05,""},scaleX={-0.95,-1.05}}} -- bone_007
timeLine[63] = {174,207,bones[7].sprite,{x={18.85,20.75},y={7.39,15.99},scaleX={-0.95,-1.05,""},scaleX={-0.95,-1.05}}} -- bone_009
timeLine[64] = {174,207,bones[1].sprite,{x={27.95,28.65},y={31.85,28.11},scaleX={1.05,0.95,""},scaleX={1.05,0.95}}} -- bone_010
timeLine[65] = {174,207,bones[8].sprite,{x={25.68,23.57},y={32.47,29.43},scaleX={0.84,1.00,""},scaleX={0.84,1.00},scaleY={1.09,1.00},rotation={261.51,261.51-4.18}}} -- bone_011
timeLine[66] = {174,207,bones[12].sprite,{x={17.26,22.63,"outBounce"},y={29.9,30.37,"outBounce"},scaleY={0.65,1.00,"outBounce"},rotation={217.95,217.95-127.12,"outBounce"}}} -- bone_004
timeLine[67] = {174,207,bones[9].sprite,{scaleX={1.18,1.00,""},scaleX={1.18,1.00},scaleY={0.92,1.00}}} -- bone_005
timeLine[68] = {174,207,bones[10].sprite,{scaleX={1.18,1.00,""},scaleX={1.18,1.00},scaleY={0.92,1.00}}} -- bone_012

self.mc = MovieClip.new(timeLine)
self.mc:setGotoAction(74,1)


end