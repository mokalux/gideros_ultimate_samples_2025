-- Scene: Game 
GameScene = Core.class(Sprite)

-- Init
function GameScene:init()	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
	self:addEventListener("exitEnd", self.onExitEnd, self)
	
	-- Game state
	GL.GameState = CONST.GAME_STATE.START
	GL.Game = self
	
	-- Evant application
	self:addEventListener(Event.APPLICATION_SUSPEND, self.onAppSuspend, self)
end

-- Scene has been entered
function GameScene:onEnterEnd()
	self.phy_world = self:createPhysicsWorld(self.phy_world)
	-- Start game field
	self.gameField = cField.new(self.phy_world)
	self:addChild(self.gameField)
	self.gameField:setPosition(CONST.W_CENTER, CONST.H_CENTER)
	-- UI manager
	GL.sceneManagerUI = SceneManager.new({
		[CONST.SCENES_UI_NAME.START] = UIStartScene,
		[CONST.SCENES_UI_NAME.GAME] = UIGameScene,
		[CONST.SCENES_UI_NAME.PAUSE] = UIPauseScene,
		[CONST.SCENES_UI_NAME.GAMEOVER] = UIGameOverScene
	})
	self:addChild(GL.sceneManagerUI)
	-- Set start UI
	GL.sceneManagerUI:changeScene(CONST.SCENES_UI_NAME.START)
end

-- Create physics world
function GameScene:createPhysicsWorld()
	-- Physics
	local _phy_world = b2.World.new(0, 0, false)
	
	-- DEBUG
--[[
	local _debugDraw = b2.DebugDraw.new()
	_debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT)
	_phy_world:setDebugDraw(_debugDraw)
	self:addChild(_debugDraw)
]]

	return _phy_world
end

-- Start game
function GameScene:start()
	self.gameField:start()
end

-- Play game
function GameScene:play()
	self.gameField:play()
end

-- Pause game
function GameScene:pause()
	self.gameField:pause()
end

-- Resume game
function GameScene:resume()
	self.gameField:resume()
end

-- Resume game
function GameScene:gameOver()
	GL.sceneManagerUI:changeScene(CONST.SCENES_UI_NAME.GAMEOVER, 0.2, SceneManager.fade, easing.linear)
	self.gameField:gameOver()
end

-- Callback application suspend
function GameScene:onAppSuspend(e)
	self:pause()
	GL.sceneManagerUI:changeScene(CONST.SCENES_UI_NAME.PAUSE, 0, SceneManager.fade, easing.linear)
end

-- Scene has been exited
function GameScene:onExitEnd()
	-- Clear events
	self:removeEventListener("enterEnd", self.onEnterEnd)
	self:removeEventListener("exitEnd", self.onExitEnd)
	self:removeEventListener(Event.APPLICATION_SUSPEND, self.onAppSuspend, self)
	self:removeAllListeners()
		
	-- Clear variable
	self:removeChild(GL.sceneManagerUI)
	GL.sceneManagerUI = nil	
end
