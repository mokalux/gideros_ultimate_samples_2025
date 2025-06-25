Options = Core.class(Sprite)

local random = math.random

function Options:init(t)
	attractMode=1 -- turn on self play demo mode
	back=false
	self.done=false

-- add scene title
	local t=TextField.new(nil,"Game Options")
	t:setTextColor(0x30ff80)
	t:setScale(3)
	t:setAnchorPoint(0.5,0.5)
	t:setPosition(160,100)
	self:addChild(t)

-- add options menu	
	self.item=0
	addMenu(self,"",190,self.level)
	addMenu(self,"",190,self.music)
	addMenu(self,"",190,self.fx)
	addMenu(self,"Back",190,self.quit)
	selectMenu(self,#self.menu)

	self:level(true)
	self:music(true)
	self:fx(true)

	self:addEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
	self:addEventListener(Event.MOUSE_MOVE,self.onMouse,self)
	self:addEventListener(Event.MOUSE_HOVER,self.onMouse,self)
	self:addEventListener(Event.MOUSE_UP,self.onMouse,self)
	self:addEventListener("exitBegin",self.onTransitionOutBegin,self)
	self:addEventListener("exitEnd",self.onTransitionOutEnd,self)

end

function Options:onMouse(e)
	if not self.done then processMouse(self,e) end
end

function Options:level(justShow)
	if not justShow then
		level+=1
		if level>9 then level=1 end
	end
	setMenu(self,1,"Level: "..level)
end

function Options:music(justShow)
	if not justShow then
		if music then music=false else music=true end
	end
	setMenu(self,2,"Music: "..onOff(music))
end

function Options:fx(justShow)
	if not justShow then
		if soundfx then soundfx=false else soundfx=true end
	end
	setMenu(self,3,"Sound FX: "..onOff(soundfx))
end

function Options:quit()
	print(#transitions)
	if not self.done and sceneManager:changeScene("frontend",0.5,transitions[random(#transitions)]) then
		self.done=true
	end
end

function Options:onTransitionOutBegin()
	self:removeEventListener(Event.MOUSE_UP,self.onMouse,self)
	self:removeEventListener(Event.MOUSE_MOVE,self.onMouse,self)
	self:removeEventListener(Event.MOUSE_HOVER,self.onMouse,self)
end
function Options:onTransitionOutEnd()
	self:removeEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
end

function Options:onEnterFrame(Event)
	processPads()
	if back then self:quit() else processMenu(self) end
end
