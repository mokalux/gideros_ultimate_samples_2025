--- Main

--- --- --- Include
require "scenemanager"
require "easing"
require "json"
require "liquidfun"

--- --- --- Const
CONST = cConst.new()
--- --- --- Global
GL = cGlobal.new()

--- --- --- "Layers"
-- BG
G_BG = BG.new()
G_BG:start()
stage:addChild(G_BG)

-- Scene manager
GL.sceneManager = SceneManager.new({
   [CONST.SCENES_NAME.GAME] = GameScene,
   [CONST.SCENES_NAME.TEST] = SceneTest,
   [CONST.SCENES_NAME.MAINMENU] = MainMenuScene
})

-- Set scene - Main Menu
GL.sceneManager:changeScene(CONST.SCENES_NAME.MAINMENU, 1, SceneManager.moveFromLeft, easing.linear)
stage:addChild(GL.sceneManager)
--- --- --- 
-- Clip field
if (application:getDeviceInfo() == "Web") then	
	stage:setClip(0, 0, CONST.W, CONST.H)
end
