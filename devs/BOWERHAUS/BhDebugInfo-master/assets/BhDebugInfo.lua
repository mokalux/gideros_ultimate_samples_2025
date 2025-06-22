--[[ 
BhDebugInfo.lua

Useful debug information display for Gideros Studio
Simply include this module in your Gideros project and allow it to be executed.
 
MIT License
Copyright (C) 2012. Andy Bower, Bowerhaus LLP

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

BhDebugInfo=gideros.class(Sprite)

function BhDebugInfo:onEnterFrame()
	-- Always bring to front
	self:getParent():addChild(self)	
	self.count=self.count+1
	if (self.count==60) then
		self.count=0
		local nowTime=os.timer()
		local fps=60/(nowTime-self.timer)
		self.timer=nowTime
		
		-- Comment out the following line so instrumentation does
		-- not affect app memory
		-- collectgarbage()
		local usedMem=collectgarbage("count")		
		local os,osver,device,uiIdiom,model=application:getDeviceInfo()
		
		self.displayText:setText(string.format("%s [%d, %d] Fps: %d Mem: %.2fMb", 
			model or "", application:getDeviceWidth(), application:getDeviceHeight(), 
			fps, usedMem))
		self.displayText:setPosition((application:getContentWidth()-self.displayText:getWidth())/2, 20)
	end
end

function BhDebugInfo:onAddedToStage()
  self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
 
function BhDebugInfo:onRemovedFromStage()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
 
 function BhDebugInfo:init()
	self.count=0
	self.timer=os.timer()
	self.displayText=TextField.new(TTFont.new("Fonts/Tahoma.ttf", 24))
	self:addChild(self.displayText)

	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)
	stage:addChild(self)
end

BhDebugInfo.new()
