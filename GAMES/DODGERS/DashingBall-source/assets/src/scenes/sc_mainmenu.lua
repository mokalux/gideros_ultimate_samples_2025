-- Scene: Main Menu

MainMenuScene = Core.class(Sprite)

-- Init
function MainMenuScene:init()
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitEnd", self.onExitEnd, self)
end

-- Scene has been entered
function MainMenuScene:onEnterEnd(e)
	-- Title
	local _lblTitle = GL.getLabelTitle(CONST.PROJECT_NAME, CONST.W_CENTER, CONST.H_CENTER - 105)
	_lblTitle:setTextColor(CONST.TITLE_COLOR)
	self:addChild(_lblTitle)
	
	-- Button "Start"
	local _upStart = GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall)
	local _downStart = GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnDownSmall)
	local _btnStart = Button.new(_upStart, _downStart)
	_btnStart:setAnchorPoint(0.5, 0.5)
	_btnStart:setPosition(CONST.W_CENTER, CONST.H_CENTER + 41)
	_btnStart:setAlpha(0)
	self:addChild(_btnStart)
	-- Label
	local _lblStart = GL.getLabelText("Start", CONST.W_CENTER, CONST.H_CENTER + 75)
	self:addChild(_lblStart)
	-- Animation
	GTween.new(_lblStart, 1,
		{ 
			scaleX = 1.15, 
			scaleY = 1.15,
			rotation = -1,
		}, 
		{
			delay = 0, 
			ease = easing.linear, 
			repeatCount = 0, 
			reflect = true,
		}
	)
	-- Event click - Start
	_btnStart:addEventListener("click", function()
		GL.sceneManager:changeScene(CONST.SCENES_NAME.GAME, 0.3, SceneManager.fade, easing.linear)
	end)
	
	-- Button "How to play"
	--  (?)
	
	-- Button "Settings" (?)
	--  (?)
	
	-- Button "Close" (not web)
	if (application:getDeviceInfo() ~= "Web") then		
		local _upStop = GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnUpSmall)
		local _downStop = GL.getBmpFromPack(CONST.RESOURCE_NAME.UI.BtnDownSmall)
		local _btnStop = Button.new(_upStop, _downStop)
		_btnStop:setAnchorPoint(0.5, 0.5)
		_btnStop:setPosition(CONST.W_CENTER, CONST.DEVICE_BOTTOM - 60)
		_btnStop:setAlpha(0)
		self:addChild(_btnStop)
		-- Label
		local _lblStop = GL.getLabelText("Close", CONST.W_CENTER, CONST.DEVICE_BOTTOM - 30)
		self:addChild(_lblStop)
	
		_btnStop:addEventListener("click", function()
			application:exit()
		end)
	end
end

-- Scene has been exited
function MainMenuScene:onExitEnd(e)
end
