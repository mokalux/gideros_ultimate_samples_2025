GameOver = Core.class(Sprite)

local random = math.random

function GameOver:init(t)
	attractMode=-1 -- game over mode
	back=false
	
	self.done=false

-- add scene title
	local t=TextField.new(nil,"Game Over")
	t:setTextColor(0x30ffff)
	t:setScale(3)
	t:setAnchorPoint(0.5,0.5)
	t:setPosition(160,100)
	self:addChild(t)

-- add game over menu	
	self.item=0
	addMenu(self,"Play Again",190,self.play)
	addMenu(self,"Quit",190,self.quit)
	selectMenu(self,#self.menu)

	self:addEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
	self:addEventListener(Event.MOUSE_MOVE,self.onMouse,self)
	self:addEventListener(Event.MOUSE_HOVER,self.onMouse,self)
	self:addEventListener(Event.MOUSE_UP,self.onMouse,self)
	self:addEventListener("exitBegin",self.onTransitionOutBegin,self)
	self:addEventListener("exitEnd",self.onTransitionOutEnd,self)

end

function GameOver:onMouse(e)
	if not self.done then processMouse(self,e) end
end

function GameOver:play()
	if not self.done and sceneManager:changeScene("play",0.5,transitions[random(#transitions)]) then self.done=true end
end

function GameOver:quit()
	if not self.done and sceneManager:changeScene("frontend",0.5,transitions[random(#transitions)]) then self.done=true end
end

function GameOver:onTransitionOutBegin()
	self:removeEventListener(Event.MOUSE_UP,self.onMouse,self)
	self:removeEventListener(Event.MOUSE_MOVE,self.onMouse,self)
	self:removeEventListener(Event.MOUSE_HOVER,self.onMouse,self)
end
function GameOver:onTransitionOutEnd()
	self:removeEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
end

function GameOver:onEnterFrame(Event)
	processPads()
	if back then self:quit() else processMenu(self) end
end
