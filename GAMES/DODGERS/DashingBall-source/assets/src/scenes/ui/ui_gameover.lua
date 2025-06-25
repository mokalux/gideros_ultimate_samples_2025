-- Game Scene: UI Game Over
UIGameOverScene = Core.class(Sprite)

-- Init
function UIGameOverScene:init()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitEnd", self.onExitEnd, self)
end

-- Scene has been entered
function UIGameOverScene:onEnterEnd(e)
	-- Substrate
	local _substrate = Pixel.new(0x000000, 0.65, CONST.DEVICE_W, CONST.DEVICE_H)
	_substrate:setPosition(CONST.DEVICE_LEFT, CONST.DEVICE_TOP)
	self.substrate = _substrate
	self:addChild(_substrate)
	
	-- Title
	local _lblTitle = GL.getLabelTitle("GAME OVER", CONST.W_CENTER, CONST.H_CENTER - 105)
	_lblTitle:setTextColor(0x1fa6e0)
	self:addChild(_lblTitle)
	-- Check high score
	if GL.Score > GL.HighScore + 1000000000 then -- XXX
		GL.HighScore = GL.Score
		dataSaver.saveValue(CONST.SAVE_TAG_HS, GL.HighScore)
		local _lblHighScore = GL.getLabelText("High Score: ".. tostring(GL.HighScore), CONST.W_CENTER, CONST.H_CENTER - 15)
		_lblHighScore:setTextColor(CONST.TITLE_COLOR)
		self:addChild(_lblHighScore)
		-- Animation
		GTween.new(_lblHighScore, 
				   0.85, 
					{ 
						scaleX = 1.2, 
						scaleY = 1.2,
						rotation = -2
					}, 
					{
						delay = 0, 
						ease = easing.linear, 
						repeatCount = 0, 
						reflect = true
					})
	else	
		local _lblHighScore = GL.getLabelText("High Score: ".. tostring(GL.HighScore), CONST.W_CENTER, CONST.H_CENTER - 20)
		self:addChild(_lblHighScore)
	end
	-- Score
	local _lblScore = GL.getLabelText("Score: ".. tostring(GL.Score), CONST.W_CENTER, CONST.H_CENTER + 35)
	self:addChild(_lblScore)
	-- Button "Restart"
	local _btnRestart = Button.new(GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall), GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall))
	_btnRestart:setAnchorPoint(0.5, 0.5)
	_btnRestart:setPosition(CONST.W_CENTER, CONST.H_CENTER + 81)
	_btnRestart:setAlpha(0)
	self:addChild(_btnRestart)
	self.btnRestart = _btnRestart
	-- Label
	local _lblRestart = GL.getLabelText("Restart", CONST.W_CENTER, CONST.H_CENTER + 115)
	self:addChild(_lblRestart)
	-- Animation
	GTween.new(_lblRestart, 
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
	self.btnRestart:addEventListener("click", 
						function() 
							GL.sceneManager:changeScene(CONST.SCENES_NAME.GAME, 0.2, SceneManager.fade, easing.linear)
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
function UIGameOverScene:onExitEnd(e)
	-- Restart
	self.btnContinue:removeAllListeners()
	self:removeChild(self.btnRestart)
	self.btnContinue = nil
	-- Menu
	self.btnMenu:removeAllListeners()
	self:removeChild(self.btnMenu)
	self.btnMenu = nil
	--
	self:removeChild(self.substrate)
	self.substrate = nil
end