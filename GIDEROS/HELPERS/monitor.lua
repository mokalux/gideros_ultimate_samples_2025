--[[

 Bismillahirrahmanirrahim
 
 Gideros Monitor
 Show memory usage and frame rate
 By: Edwin Zaniar Putra (zaniar@nightspade.com)
 Version: 2012.11.0

 This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
 Copyright © 2012 Nightspade (http://nightspade.com).

--]]
local _W, _H = application:getContentWidth(), application:getContentHeight()
local Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
local Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()

Monitor = Core.class(Sprite)

function Monitor:init()
	leftBorder = -(_W+Wdx)
	topBorder = -(_H+Hdy)
	rightBorder = _W+Wdx
	
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
	self.tfMemory:setPosition(5, self.tfMemory:getHeight()-35)
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
	
	local timer = Timer.new(1000)
	timer:addEventListener(Event.TIMER, function(self)
		self.tfFPS:setText(self.frameCount.." FPS")
		self.tfFPS:setX(rightBorder-self.tfFPS:getWidth()-2)
		self.frameCount = 0
	end, self)
	timer:start()
	--check this link
	--http://giderosmobile.com/forum/discussion/2565/texture-memory-usage/p1
	stage:addEventListener(Event.ENTER_FRAME, function()
		self.frameCount = self.frameCount + 1
		self.tfMemory:setText("luaMem: "..math.ceil(collectgarbage("count"))/(1000).."Mb textureMem: "..math.ceil(application:getTextureMemoryUsage()-64)/(1000).."Mb")
		print("luaMem: "..math.ceil(collectgarbage("count"))/(1000).."Mb textureMem: "..math.ceil(application:getTextureMemoryUsage()-64)/(1000).."Mb")
		stage:addChildAt(self, stage:getNumChildren()+1)
	end)
	
	-- remove this line
	--stage:addChild(self.tfMemory)
end

monitor = Monitor.new()

--[[
	http://giderosmobile.com/forum/discussion/773/scenemanager-and-managing-memory/p1
	
	@avo using local variables is about %30 faster than global variables.
	And speed of accessing a field of a table and accessing a global variable should be almost the same.
]]