--[[

 Bismillahirrahmanirrahim
 
 Gideros Monitor
 Show memory usage and frame rate
 By: Edwin Zaniar Putra (zaniar@nightspade.com)
 Version: 2012.11.0

 This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
 Copyright © 2012 Nightspade (http://nightspade.com).

--]]
local contentW = application:getContentWidth()
local contentH = application:getContentHeight()

print("-------------------------------------------------------------")
-- absolute x and y position global values for monitor.lua
local dx = application:getLogicalTranslateX() / application:getLogicalScaleX()
local dy = application:getLogicalTranslateY() / application:getLogicalScaleY()
local aw_start = -dx -- absolute width start point
local aw_end = contentW + 2*dx
local ah_start = -dy -- absolute height start point
local ah_end = contentH + 2*dy
print("-------------------------------------------------------------")

local Monitor = Core.class(Sprite)

local leftBorder 	= aw_start
local rightBorder 	= aw_end
local topBorder 	= ah_start

local application 	= application
local collectgarbage 	= collectgarbage
local timer 		= os.timer()
local qFloor 		= math.floor
local qCeil 		= math.ceil
local sformat		= string.format
local luaMem
local textureMem
local childNum

function Monitor:init()
	self:setPosition(leftBorder, topBorder)

	self.bg = Shape.new()
	self.bg:setFillStyle(Shape.SOLID, 0x000000, .3)
	self:addChild(self.bg)
	
	self.frameCount = 0
	self.tfFPS = TextField.new(nil, "0 FPS")
	self.tfFPS:setPosition(rightBorder-self.tfFPS:getWidth()-2, self.tfFPS:getHeight()+1)
	self.tfFPS:setTextColor(0xffffff)
	self:addChild(self.tfFPS)

	self.tfMemory = TextField.new(nil, "0 kB")
	self.tfMemory:setPosition(2, self.tfMemory:getHeight()+1)
	self.tfMemory:setTextColor(0xffffff)
	self:addChild(self.tfMemory)
	
	local bgHeight = self.tfMemory:getHeight()+4
	self.bg:beginPath()
	self.bg:moveTo(leftBorder,topBorder)
	self.bg:lineTo(rightBorder,topBorder)
	self.bg:lineTo(rightBorder,bgHeight)
	self.bg:lineTo(leftBorder,bgHeight)
	self.bg:closePath()
	self.bg:endPath()
	
	stage:addEventListener(Event.ENTER_FRAME, function()
		self.frameCount = self.frameCount + 1
		
		if self.frameCount == 60 then
			local currentTimer = os.timer()
			local dt = currentTimer - timer
			self.tfFPS:setText("FPS "..qFloor(60 / dt))
			self.tfFPS:setX(rightBorder-self.tfFPS:getWidth()-2)
			self.frameCount = 0
			timer = currentTimer
		end
		
		luaMem = qCeil(collectgarbage("count"))
		textureMem = qCeil(application:getTextureMemoryUsage()-64)
		childNum = self:countChildren(stage)

		self.tfMemory:setText(sformat("luaMem: %s  kB textureMem: %s  kB stageChild: %s", luaMem, textureMem,childNum - 4))
		stage:addChildAt(self, stage:getNumChildren()+1)
	end)
end

function Monitor:countChildren(parent)
	local nc = 0
	for index = 1,parent:getNumChildren() do
		nc = nc + 1
		local child = parent:getChildAt(index)
		nc = nc + self:countChildren(child)
	end

	return nc
end

Monitor.new() -- start monitoring
