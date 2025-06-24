
--------------------------------------------
-- TNT Animator Studio 1.15               --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- example 1  ** walking guys **          --
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

application:setKeepAwake(true)
application:setBackgroundColor(0x252530)



-- just read texture pack
local boyTexturePack = TexturePack.new("boyPack_1.txt", "boyPack_1.png")
local crockTexturePack = TexturePack.new("crock.txt", "crock.png")
local background = Bitmap.new(Texture.new("logo.png"))

-- init texture animation loader and read animations... 
local boyLoader = CTNTAnimatorLoader.new()
local crockLoader = CTNTAnimatorLoader.new()

-- read nimation infos from file "boyPack_1.tan" use texture pack defined in texturePack and center all sprites...
boyLoader:loadAnimations("boyPack_1.tan", boyTexturePack, true)
crockLoader:loadAnimations("crock.tan", crockTexturePack, true)

CPlayer = Core.class(Sprite)


function CPlayer:init(playerType)
	if playerType == "BOY" then
		self.anim = CTNTAnimator.new(boyLoader)
		self.direction = math.random(1, 4)
		if self.direction == 1 then
			self.anim:setAnimation("BOY_LEFT")
		elseif self.direction == 2 then
			self.anim:setAnimation("BOY_RIGHT")
		elseif self.direction == 3 then
			self.anim:setAnimation("BOY_UP")
		elseif self.direction == 4 then
			self.anim:setAnimation("BOY_DOWN")
		end
	else
		self.anim = CTNTAnimator.new(crockLoader)
		self.direction = math.random(1, 4)
		if self.direction == 1 then
			self.anim:setAnimation("CROCK_LEFT")
		elseif self.direction == 2 then
			self.anim:setAnimation("CROCK_RIGHT")
		elseif self.direction == 3 then
			self.anim:setAnimation("CROCK_UP")
		elseif self.direction == 4 then
			self.anim:setAnimation("CROCK_DOWN")
		end
	end
	
    self.anim:setSpeed(math.random(60, 120))

    self.anim:addToParent(self)
    self.anim:playAnimation()

	self.xPos = math.random(0, 320)
    self.yPos = math.random(0, 480)
    self.speed = self.anim:getSpeed()
    self.w = application:getLogicalWidth() + 32
    self.h = application:getLogicalHeight() + 32
    self:setPosition(self.xPos, self.yPos)
    self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function CPlayer:onEnterFrame(event)
    if self.direction == 1 then
        self.xPos = self.xPos - (self.speed * event.deltaTime)
        if self.xPos < -32 then
            self.xPos = self.w
        end
    elseif self.direction == 2 then
        self.xPos = self.xPos + (self.speed * event.deltaTime)
        if self.xPos > self.w then
            self.xPos = -32
        end
    elseif self.direction == 3 then
        self.yPos = self.yPos - (self.speed * event.deltaTime)
        if self.yPos < -32 then
            self.yPos = self.h
        end
    elseif self.direction == 4 then
        self.yPos = self.yPos + (self.speed * event.deltaTime)
        if self.yPos > self.h then
            self.yPos = -32
        end
    end
    self:setPosition(self.xPos, self.yPos)
end



stage:addChild(background)
local boy = {}
for j = 1, 10 do
    boy[j] = CPlayer.new("BOY")
    stage:addChild(boy[j])
end

local crock = {}
for j = 1, 10 do
    crock[j] = CPlayer.new("CROCK")
    stage:addChild(crock[j])
end
