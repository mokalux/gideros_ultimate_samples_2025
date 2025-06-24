
--------------------------------------------
-- TNT Animator Studio 1.15               --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- example 3  ** walking crock **         --
-- Touch crock to Free memory 
-- and close example.
-- example how to modify animation sprite
-- you can handle with standard gideros sprites
-- commands using getSpriteHandle or accessing 
-- directly with "sprite" reference.
-- check example for details.
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
local spriteHandle = nil
local angle = 0
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
    spriteHandle = self.anim:getSpriteHandle()
	-- spriteHandle = self.anim.sprite now!
	
	self.xPos = application:getLogicalWidth() /2
    self.yPos = application:getLogicalHeight() /2
    self.speed = self.anim:getSpeed() 
    self:setPosition(self.xPos, self.yPos)
    self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
    self:addEventListener(Event.MOUSE_DOWN , self.onClick, self)
end
function CPlayer:onClick(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		
		--self.anim:stopAnimation()
		self.anim = self.anim:free()
		crockLoader = crockLoader:free()
		
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self:removeEventListener(Event.MOUSE_DOWN , self.onClick, self)
		
		background = nil
		crockTexturePack = nil
		-- if you use getSpriteHandle 
		-- REMEMBER to free spriteHandle var...
		spriteHandle = nil
		Application.exit(application)
	end
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
	
	-- remember to free spriteHanfle var...
	spriteHandle:setScale(1+(math.sin(angle*5)/6))
	
	-- or you casn access directly with ...
	--self.anim.sprite:setScale(1+(math.sin(angle*5)/6))
	
	angle = angle + (2 * event.deltaTime)
	self:setPosition(self.xPos, self.yPos)
end
stage:addChild(background)
local crock = CPlayer.new()

local function onStartAnimation(event)
	print(event.animationName.." animation started")
end
local function onStopAnimation(event)
	print(event.animationName.." animation Stopped")
	--crock.anim = crock.anim:free()
end
local function onChangeAnimation(event)
	print(" animation changed FROM: <"..event.previousAnimationName..">")
	print(" animation changed TO: <"..event.animationName..">")
end

local function onFreeAnimation(event)
	print(event.animationName.." animation Free.")
end

local function onLoopAnimation(event)
	print(event.animationName.." ..animation loop re-started...")
end

crock.anim:addEventListener("ANIM_START", onStartAnimation, event)  
crock.anim:addEventListener("ANIM_STOP", onStopAnimation, event)  
crock.anim:addEventListener("ANIM_CHANGE", onChangeAnimation, event)  
crock.anim:addEventListener("ANIM_FREE", onFreeAnimation, event)  
crock.anim:addEventListener("ANIM_NEWLOOP", onLoopAnimation, event)  

stage:addChild(crock)
