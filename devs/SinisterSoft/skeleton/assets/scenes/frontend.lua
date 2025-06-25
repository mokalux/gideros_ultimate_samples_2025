Frontend = Core.class(Sprite)

local random,floor,sin,cos,tan,abs,atan2,sqrt=math.random,math.floor,math.sin,math.cos,math.tan,math.abs,math.atan2,math.sqrt

function Frontend:init(t)
	attractMode=1 -- turn on self play demo mode
	back=false

	self.done=false
	
-- add scene title
	local t=TextField.new(nil,"My Game Title")
	t:setTextColor(0x8000ff)
	t:setScale(3)
	t:setAnchorPoint(0.5,0.5)
	t:setPosition(160,100)
	self:addChild(t)

-- add game menu
	self.item=0
	addMenu(self,"Start",240,self.play)
	addMenu(self,"Options",240,self.options)
	addMenu(self,"Quit",240,self.quit)
	selectMenu(self,1)

	self:addEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
	self:addEventListener(Event.MOUSE_MOVE,self.onMouse,self)
	self:addEventListener(Event.MOUSE_HOVER,self.onMouse,self)
	self:addEventListener(Event.MOUSE_UP,self.onMouse,self)
	self:addEventListener("exitBegin",self.onTransitionOutBegin,self)
	self:addEventListener("exitEnd",self.onTransitionOutEnd,self)
end

function Frontend:onMouse(e)
	if not self.done then processMouse(self,e) end
end

function Frontend:options()
	if not self.done and sceneManager:changeScene("options",0.5,transitions[random(#transitions)]) then self.done=true end
end

function Frontend:play()
	if not self.done and sceneManager:changeScene("play",0.5,transitions[random(#transitions)]) then self.done=true end
end

function Frontend:quit()
	application:exit()
end

function Frontend:onTransitionOutBegin()
	self:removeEventListener(Event.MOUSE_UP,self.onMouse,self)
	self:removeEventListener(Event.MOUSE_MOVE,self.onMouse,self)
	self:removeEventListener(Event.MOUSE_HOVER,self.onMouse,self)
end
function Frontend:onTransitionOutEnd()
	self:removeEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
end

function Frontend:onEnterFrame(Event)
	processPads()
	if back then self:quit() else processMenu(self) end
end
