-- Game Scene: UI Start
UIStartScene = Core.class(Sprite)

-- Init
function UIStartScene:init()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitEnd", self.onExitEnd, self)
end

-- Touch event
function UIStartScene:onTouchesBegin(event)
	-- Play game - change ui
	GL.sceneManagerUI:changeScene("GAME", 0)
	GL.Game:play()
end

-- Scene has been entered
function UIStartScene:onEnterEnd(e)
	-- Start value
	GL.Score = 0
	-- State
	GL.Game:start()
	
	-- Substrate
	local _substrate = Pixel.new(0x000000, 0.4, CONST.DEVICE_W, CONST.DEVICE_H)
	_substrate:setPosition(CONST.DEVICE_LEFT, CONST.DEVICE_TOP)
	self.substrate = _substrate
	self:addChild(_substrate)
	
	-- Label "Tap to start"
	self.lblTapToStart = GL.getLabelText("Tap to start", CONST.W_CENTER, CONST.H_CENTER)
	-- Animation
	GTween.new(self.lblTapToStart, 
	           0.85, 
				{ 
					scaleX = 1.15, 
					scaleY = 1.15,
					rotation = -2
				}, 
				{
					delay = 0, 
					ease = easing.linear, 
					repeatCount = 0, 
					reflect = true
				})
	-- Event
	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addChild(self.lblTapToStart)
end

-- Scene has been exited
function UIStartScene:onExitEnd(e)
	-- Delete label
	self:removeEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:removeChild(self.lblTapToStart)
	self.lblTapToStart = nil
	self:removeChild(self.substrate)
	self.substrate = nil
end