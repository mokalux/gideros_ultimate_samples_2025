FlyingShooter = Core.class(Sprite)

function FlyingShooter:init(scene,x,y,speed,id,flip)

	--TEMP
	--speed = 0

	self.health = 2
	
	self.id = id
	self.scene = scene
	self.speed = speed
	self.flip = flip
	
	-- set up atlas if not already created
	
	if(not(self.scene.flyingShooterAtlas)) then
	
		self.scene.flyingShooterAtlas = TexturePack.new("Atlases/flying shooter.txt", "Atlases/flying shooter.png",true)

	end
	
	-- setup the animation

	self:createAnim()

	self.scene.frontLayer:addChild(self)
	
	local startX = x
	
	self.shootCounter = 0
	self.shootOn = math.random(50,80)
	
	-- Make sprite rotate a bit
		
		self.tween1 = GTween.new(self, 1, {rotation=-5},{ease = easing.inOutQuadratic})
		self.tween2 = GTween.new(self, 1, {rotation=5},{ease = easing.inOutQuadratic,autoPlay = false})
		self.tween1.nextTween = self.tween2
		self.tween2.nextTween = self.tween1

	-- Add physics
	
	-- Hitbox - hits player and objects

	local body = self.scene.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(x, y)
	self.body = body
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,22,0,10,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = .2, restitution = 0, isSensor = true}
	
	local filterData = {categoryBits = 128, maskBits = 4+8}
	fixture:setFilterData(filterData)
	
	fixture.parent = self
	fixture.name = "enemy"

	Timer.delayedCall(200,self.startMove,self)
		
	-- sounds
	
	self.maxVolume = .15
	self.volume = 0
	
	if(not(self.scene.splatGunSound)) then
	
		self.scene.splatGunSound = Sound.new("Sounds/fire splat gun.wav")

	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
end





function FlyingShooter:pause()

	self.mc:stop()

end




function FlyingShooter:resume()

	self.mc:play()

end





function FlyingShooter:startMove()

	self.point1 = self.scene.path[self.id].vertices.y[1]
	self.point2 = self.scene.path[self.id].vertices.y[2]
	self.newSpeed = -self.speed
	
	self.direction = "up"
		
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end



function FlyingShooter:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		-- Going up, passed point1

		if(self.direction=="up" and self:getY() <= self.point1) then
			local x,y = self.body:getPosition()
			self:setPosition(x,self.point1)
			self.newSpeed = self.speed
			self.direction = "down"
			
		-- Going down, passed point 2
		
		elseif(self.direction=="down" and self:getY() >= self.point2) then
			local x,y = self.body:getPosition()
			self:setPosition(x,self.point2)
			self.newSpeed = -self.speed
			self.direction = "up"
		
		end
		
		
		self:setY(self:getY()+self.newSpeed)
		self.body:setPosition(self:getPosition())

		-- Shooting
		
		self.shootCounter = self.shootCounter + 1
		
		--print(self.shootCounter)
		
		if(self.shootCounter==self.shootOn) then
		
			self.channel1 = self.scene.splatGunSound:play()
			self.channel1:setVolume(self.volume*self.scene.soundVol)
		
			self.shootCounter = 0
			self.shootOn = math.random(100,200)
			
			-- play shoot anim
			
			self.mc:gotoAndPlay(101)
			self.mc:setStopAction(159)
			
			self.mc:addEventListener(Event.COMPLETE, self.finishShot, self)
			
			if(self.flip) then
			
				self.angle = -90
			
				local bullet = Bullet.new(self.scene,self:getX()+16,self:getY()+50,self.angle,true)
				
				
			else
				self.angle = 90

				local bullet = Bullet.new(self.scene,self:getX()-16,self:getY()+50,self.angle,true)
			end

		end
	
	end
	

end




function FlyingShooter:finishShot()

	self.mc:removeEventListener(Event.COMPLETE, self.finishShot, self)
	self.mc:gotoAndPlay(1)

end





-- cleanup function

function FlyingShooter:exit()
	
	--print("flying shooter cleanup")
	self.tween1:setPaused(true)
	self.tween2:setPaused(true)
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

	
end











function FlyingShooter:createAnim()

	local mainSprite = Sprite.new()
	self:addChild(mainSprite)
	self.mainSprite = mainSprite

	if(self.flip) then
		self:setScaleX(-1)
		mainSprite:setPosition(-70, -50)
	else
		mainSprite:setPosition(-70, -50)
	end


local bones = {}

-- Setup bones

-- bone_006

local sprite = Sprite.new()
mainSprite:addChild(sprite)
bones[0] = {}
bones[0].sprite = sprite

-- bone_001

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[1] = {}
bones[1].sprite = sprite

-- bone_007

local sprite = Sprite.new()
bones[0].sprite:addChild(sprite)
bones[2] = {}
bones[2].sprite = sprite

-- bone_000

local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
bones[3] = {}
bones[3].sprite = sprite

-- bone_002

local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
bones[4] = {}
bones[4].sprite = sprite

-- bone_004

local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
bones[5] = {}
bones[5].sprite = sprite

-- bone_003

local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
bones[6] = {}
bones[6].sprite = sprite

-- bone_005

local sprite = Sprite.new()
bones[2].sprite:addChild(sprite)
bones[7] = {}
bones[7].sprite = sprite

-- Setup image sprites

local sprites = {}

-- balloon ---------

sprites[0] = {}
local sprite = Sprite.new()
bones[1].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.flyingShooterAtlas:getTextureRegion("balloon.png"))
sprite:addChild(img)
sprites[0].sprite = sprite

-- body ---------

sprites[1] = {}
local sprite = Sprite.new()
bones[3].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.flyingShooterAtlas:getTextureRegion("body.png"))
sprite:addChild(img)
sprites[1].sprite = sprite

-- gun ---------

sprites[2] = {}
local sprite = Sprite.new()
bones[4].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.flyingShooterAtlas:getTextureRegion("gun.png"))
sprite:addChild(img)
sprites[2].sprite = sprite

-- arm ---------

sprites[3] = {}
local sprite = Sprite.new()
bones[6].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.flyingShooterAtlas:getTextureRegion("arm.png"))
sprite:addChild(img)
sprites[3].sprite = sprite

-- hand ---------

sprites[4] = {}
local sprite = Sprite.new()
bones[7].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.flyingShooterAtlas:getTextureRegion("hand.png"))
sprite:addChild(img)
sprites[4].sprite = sprite

-- tail ---------

sprites[5] = {}
local sprite = Sprite.new()
bones[5].sprite:addChild(sprite)
local img = Bitmap.new(self.scene.flyingShooterAtlas:getTextureRegion("tail.png"))
sprite:addChild(img)
sprites[5].sprite = sprite

-- Adjust the sprites (from first frame of timelines)

-- balloon

sprites[0].sprite:setX(-20.25)
sprites[0].sprite:setY(-39)


-- body

sprites[1].sprite:setX(-6.25)
sprites[1].sprite:setY(-32.5)


-- gun

sprites[2].sprite:setX(-10.87)
sprites[2].sprite:setY(-31.06)
sprites[2].sprite:setRotation(359.52)


-- arm

sprites[3].sprite:setX(-3.25)
sprites[3].sprite:setY(-5.75)


-- hand

sprites[4].sprite:setX(-1.25)
sprites[4].sprite:setY(-13)


-- tail

sprites[5].sprite:setX(-4.43)
sprites[5].sprite:setY(-21.95)
sprites[5].sprite:setRotation(358.92)


-- bone_000

bones[3].sprite:setX(-1.25)
bones[3].sprite:setY(4.75)
bones[3].sprite:setRotation(359.09)


-- bone_001

bones[1].sprite:setX(4.75)
bones[1].sprite:setY(66)
bones[1].sprite:setRotation(270.50)


-- bone_002

bones[4].sprite:setX(-12.23)
bones[4].sprite:setY(21.85)
bones[4].sprite:setRotation(359.51)


-- bone_003

bones[6].sprite:setX(19.04)
bones[6].sprite:setY(5.62)
bones[6].sprite:setScaleY(-1.00)
bones[6].sprite:setRotation(75.64)


-- bone_004

bones[5].sprite:setX(15.33)
bones[5].sprite:setY(31.5)
bones[5].sprite:setScaleX(-0.95)
bones[5].sprite:setRotation(0.39)


-- bone_005

bones[7].sprite:setX(52.51)
bones[7].sprite:setY(44.86)
bones[7].sprite:setRotation(280.12)


-- bone_006

bones[0].sprite:setX(64.25)
bones[0].sprite:setY(22.75)


-- bone_007

bones[2].sprite:setX(-24.00)
bones[2].sprite:setY(88.5)
bones[2].sprite:setRotation(359.30)







local timeLine = {}

-- Float 

timeLine[1] = {1,49,bones[3].sprite,{x={-1.25,-0.02},y={4.75,6.02},rotation={359.09,359.09+2.79}}} -- bone_000
timeLine[2] = {50,100,bones[3].sprite,{x={-0.02,-1.25},y={6.02,4.75},rotation={1.88,1.88-2.79}}} -- bone_000
timeLine[3] = {1,49,bones[4].sprite,{x={-12.23,-12.00},y={21.85,23.6}}} -- bone_002
timeLine[4] = {50,100,bones[4].sprite,{x={-12.00,-12.23},y={23.6,21.85}}} -- bone_002
timeLine[5] = {1,49,bones[6].sprite,{x={19.04,19.27},y={5.62,7.38},rotation={75.64,75.64+3.9}}} -- bone_003
timeLine[6] = {50,100,bones[6].sprite,{x={19.27,19.04},y={7.38,5.62},rotation={79.54,79.54-3.9}}} -- bone_003
timeLine[7] = {1,49,bones[5].sprite,{x={15.33,15.31},y={31.5,33.25},rotation={0.39,0.39+4.29}}} -- bone_004
timeLine[8] = {50,100,bones[5].sprite,{x={15.31,15.33},y={33.25,31.5},rotation={4.68,4.68-4.29}}} -- bone_004
timeLine[9] = {1,49,bones[7].sprite,{x={52.51,53.49},y={44.86,46.37},rotation={280.12,280.12+1.42}}} -- bone_005
timeLine[10] = {50,100,bones[7].sprite,{x={53.49,52.51},y={46.37,44.86},rotation={281.54,281.54-1.42}}} -- bone_005
timeLine[11] = {1,49,bones[2].sprite,{x={-24.00,-24.75},y={88.5,89.75}}} -- bone_007
timeLine[12] = {50,100,bones[2].sprite,{x={-24.75,-24.00},y={89.75,88.5}}} -- bone_007


-- Float_000 

timeLine[13] = {100,117,bones[3].sprite,{scaleX={1,0.95,""},scaleX={1,0.95},rotation={359.09,359.09-8.77}}} -- bone_000
timeLine[14] = {118,136,bones[3].sprite,{scaleX={0.95,0.97,""},scaleX={0.95,0.97},rotation={350.32,350.32+1.11}}} -- bone_000
timeLine[15] = {137,159,bones[3].sprite,{scaleX={0.97,1.00,""},scaleX={0.97,1.00},rotation={351.43,351.43+7.66}}} -- bone_000
timeLine[16] = {100,117,bones[1].sprite,{x={4.75,1.25},y={66,65.25},rotation={270.50,270.50+8.07}}} -- bone_001
timeLine[17] = {118,159,bones[1].sprite,{x={1.25,4.75},y={65.25,66},rotation={278.57,278.57-8.07}}} -- bone_001
timeLine[18] = {100,117,bones[4].sprite,{x={-12.23,-22.56},y={21.85,22.19},scaleX={1.00,0.90,""},scaleX={1.00,0.90}}} -- bone_002
timeLine[19] = {118,159,bones[4].sprite,{x={-22.56,-12.23},y={22.19,21.85},scaleX={0.90,1.00,""},scaleX={0.90,1.00}}} -- bone_002
timeLine[20] = {100,117,bones[6].sprite,{x={19.04,17.97},y={5.62,2.98},rotation={75.64,75.64+17.64}}} -- bone_003
timeLine[21] = {118,159,bones[6].sprite,{x={17.97,19.04},y={2.98,5.62},rotation={93.28,93.28-17.64}}} -- bone_003
timeLine[22] = {100,117,bones[5].sprite,{x={15.33,9.81},y={31.5,32.04}}} -- bone_004
timeLine[23] = {118,159,bones[5].sprite,{x={9.81,15.33},y={32.04,31.5}}} -- bone_004
timeLine[24] = {100,117,bones[7].sprite,{x={52.51,45.13},y={44.86,44.61},rotation={280.12,280.12+20.28}}} -- bone_005
timeLine[25] = {118,159,bones[7].sprite,{x={45.13,52.51},y={44.61,44.86},rotation={300.40,300.40-20.28}}} -- bone_005
timeLine[26] = {100,117,bones[2].sprite,{x={-24.00,-30.50,"outBounce"},y={88.5,89,"outBounce"},rotation={359.30,359.30-29.54,"outBounce"}}} -- bone_007
timeLine[27] = {118,159,bones[2].sprite,{x={-30.50,-24.00},y={89,88.5},rotation={329.76,329.76+29.54}}} -- bone_007

self.mc = MovieClip.new(timeLine)
self.mc:setGotoAction(100,1)



end
