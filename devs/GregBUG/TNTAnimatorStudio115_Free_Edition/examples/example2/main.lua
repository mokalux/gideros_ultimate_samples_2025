
--------------------------------------------
-- TNT Animator Studio 1.15               --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- example 2  ** walking crock **         --
--------------------------------------------
-- for GIDEROS 2012.2.2.2 or above        --
--------------------------------------------
local function is32bit()
	return string.dump(is32bit):byte(9) == 4
end

if is32bit() then
	require("tntanimator32")
else
	require("tntanimator64")
end

require "accelerometer"

application:setKeepAwake(true)
application:setBackgroundColor(0x252530)


accelerometer:start()

local filter = 0.2  -- the filtering constant, 1.0 means no filtering, lower values mean more filtering
local fx = 0
local fy = 0

-- just read texture pack
local crockTexturePack = TexturePack.new("crock.txt", "crock.png")
local background = Bitmap.new(Texture.new("logo.png"))

-- init texture animation loader and read animations... 
local crockLoader = CTNTAnimatorLoader.new()

-- read nimation infos 
crockLoader:loadAnimations("crock.tan", crockTexturePack, true)

CPlayer = Core.class(Sprite)

function CPlayer:init(playerType)
	self.lastDirection = 1
	self.anim = CTNTAnimator.new(crockLoader)
	self.anim:setAnimation("CROCK_IDLE_DOWN")
	self.anim:playAnimation()
    self.anim:addToParent(self)
	self.w = application:getLogicalWidth() + 32
    self.h = application:getLogicalHeight() + 32
    
	self.xPos = application:getLogicalWidth() /2
    self.yPos = application:getLogicalHeight() /2
    self.speed = self.anim:getSpeed()
    self:setPosition(self.xPos, self.yPos)
    self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function CPlayer:onEnterFrame(event)
	local newSpeed = self.speed
	local x, y = accelerometer:getAcceleration()
	
	fx = x * filter + fx * (1 - filter)
	fy = y * filter + fy * (1 - filter)
	
	if fx > 0.20 then 
		newSpeed = self.speed * (fx*2)
		self.xPos = self.xPos + (newSpeed * event.deltaTime)
		self.anim:setAnimation("CROCK_RIGHT")
		self.anim:setSpeed(5000/(newSpeed))
		self.lastDirection = 3
	elseif fx < -0.20 then
		newSpeed = self.speed * (fx*2)
		self.xPos = self.xPos + (newSpeed * event.deltaTime)
		self.anim:setAnimation("CROCK_LEFT")
		self.anim:setSpeed(5000/(newSpeed*-1))
		self.lastDirection = 4
	elseif fy > 0.20 then 
		newSpeed = self.speed * (fy*2)
		self.yPos = self.yPos - (newSpeed * event.deltaTime)
		self.anim:setAnimation("CROCK_UP")
		self.lastDirection = 2
		self.anim:setSpeed(5000/(newSpeed))
	elseif fy < -0.20 then
		newSpeed = self.speed * (fy*2)
		self.yPos = self.yPos - (newSpeed * event.deltaTime)
		self.anim:setAnimation("CROCK_DOWN")
		self.lastDirection = 1
		self.anim:setSpeed(5000/(newSpeed*-1))
	else
		-- set to idle animations
		if self.lastDirection == 3 then
			self.anim:setAnimation("CROCK_IDLE_RIGHT")
		elseif self.lastDirection == 4 then
			self.anim:setAnimation("CROCK_IDLE_LEFT")
		elseif self.lastDirection == 1 then
			self.anim:setAnimation("CROCK_IDLE_DOWN")
		elseif self.lastDirection == 2 then
			self.anim:setAnimation("CROCK_IDLE_UP")
		end
	end

	if self.xPos < -32 then
        self.xPos = self.w
    elseif self.xPos > self.w then
        self.xPos = -32
    end
    if self.yPos < -32 then
		self.yPos = self.h
    elseif self.yPos > self.h then
        self.yPos = -32
    end
	
    self:setPosition(self.xPos, self.yPos)
end

local function onStartAnimation(event)
	print(event.animationName.." animation started")
end
local function onStopAnimation(event)
	print(event.animationName.." animation Stopped")
end
local function onChangeAnimation(event)
	print(" animation changed FROM: <"..event.previousAnimationName..">")
	print(" animation changed TO: <"..event.animationName..">")
end

stage:addChild(background)
local crock = CPlayer.new()
crock.anim:addEventListener("ANIM_START", onStartAnimation, event)  
crock.anim:addEventListener("ANIM_STOP", onStopAnimation, event)  
crock.anim:addEventListener("ANIM_CHANGE", onChangeAnimation, event)  

stage:addChild(crock)

