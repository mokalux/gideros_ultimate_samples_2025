-- Game Scene: UI Pause
UIPauseScene = Core.class(Sprite)

-- Init
function UIPauseScene:init()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitEnd", self.onExitEnd, self)
end

-- Scene has been entered
function UIPauseScene:onEnterEnd(e)
	-- Set pause game
	GL.Game:pause()
	-- Substrate
	local _substrate = Pixel.new(0x000000, 0.4, CONST.DEVICE_W, CONST.DEVICE_H)
	_substrate:setPosition(CONST.DEVICE_LEFT, CONST.DEVICE_TOP)
	self.substrate = _substrate
	self:addChild(_substrate)
	-- Title
	local _lblTitle = GL.getLabelTitle("PAUSE", CONST.W_CENTER, CONST.H_CENTER - 105)
	_lblTitle:setTextColor(0x1fa6e0)
	self:addChild(_lblTitle)
	-- Button "Continue"
	local _btnContinue = Button.new(GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall), GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall))
	_btnContinue:setAnchorPoint(0.5, 0.5)
	_btnContinue:setPosition(CONST.W_CENTER, CONST.H_CENTER + 41)
	_btnContinue:setAlpha(0)
	self:addChild(_btnContinue)
	self.btnContinue = _btnContinue
	-- Label
	local _lblContinue = GL.getLabelText("Continue", CONST.W_CENTER, CONST.H_CENTER + 75)
	self:addChild(_lblContinue)
	-- Animation
	GTween.new(_lblContinue, 
	           0.85, 
				{ 
					scaleX = 1.1, 
					scaleY = 1.1,
					rotation = -1
				}, 
				{
					delay = 0, 
					ease = easing.linear, 
					repeatCount = 0, 
					reflect = true
				})
	-- Event - CLick
	self.btnContinue:addEventListener("click", 
						function() 
							GL.sceneManagerUI:changeScene(CONST.SCENES_UI_NAME.GAME, 0.2, SceneManager.fade, easing.linear)
							GL.Game:resume()
						end)

	-- Button "Menu"
	local _btnMenu = Button.new(GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall), GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall))
	_btnMenu:setAnchorPoint(0.5, 0.5)
	_btnMenu:setPosition(CONST.W_CENTER, CONST.DEVICE_BOTTOM - 60)
	_btnMenu:setAlpha(0)
	self:addChild(_btnMenu)
	self.btnMenu = _btnMenu
	-- Label
	self:addChild(GL.getLabelText("Menu", CONST.W_CENTER, CONST.DEVICE_BOTTOM - 30))
	-- Event - CLick
	self.btnMenu:addEventListener("click", 
						function() 
							GL.sceneManager:changeScene(CONST.SCENES_NAME.MAINMENU, 0.2, SceneManager.fade, easing.linear)
						end)
end

-- Scene has been exited
function UIPauseScene:onExitEnd(e)
	-- Restart
	self.btnContinue:removeAllListeners()
	self:removeChild(self.btnContinue)
	self.btnContinue = nil
	-- Menu
	self.btnMenu:removeAllListeners()
	self:removeChild(self.btnMenu)
	self.btnMenu = nil
	--
	self:removeChild(self.substrate)
	self.substrate = nil
end