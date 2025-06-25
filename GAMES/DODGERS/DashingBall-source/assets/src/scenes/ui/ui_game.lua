-- Game Scene: UI Game
UIGameScene = Core.class(Sprite)

-- Init
function UIGameScene:init()
	-- Events
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitEnd", self.onExitEnd, self)
end

-- Scene has been entered
function UIGameScene:onEnterEnd(e)
	-- Global
	GL.GameUI = self
	-- Label "Score"
	self.lblScore = GL.getLabelUI("Score: ".. tostring(GL.Score), 10, CONST.DEVICE_TOP + 35)
	self.lblScore:setAnchorPoint(0, 0)
	self:addChild(self.lblScore)
	-- Button "Pause"
	local _btnUP = GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnPauseHover)
	local _btnDown = GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnPauseOver)
	self.btnPause = Button.new(_btnUP, _btnDown)
	self.btnPause:setPosition(CONST.W - 45, CONST.DEVICE_TOP + 10)
	self:addChild(self.btnPause)
	-- Event Click - Pause
	self.btnPause:addEventListener("click", 
						function() 
							--GL.sceneManagerUI:changeScene(CONST.SCENES_UI_NAME.GAMEOVER, 0, SceneManager.fade, easing.linear)
							GL.sceneManagerUI:changeScene(CONST.SCENES_UI_NAME.PAUSE, 0, SceneManager.fade, easing.linear)
						end)
end

-- Scene has been exited
function UIGameScene:onExitEnd(e)
	-- Global
	GL.GameUI = nil
	-- Button "Pause"
	self.btnPause:removeAllListeners()
	self:removeChild(self.btnPause)
	self.btnPause = nil
	-- Label "Score"
	self:removeChild(self.lblScore)
	self.lblScore = nil
end

-- Update score
function UIGameScene:updateScore()
	self.lblScore:setText("Score: ".. tostring(GL.Score))
end