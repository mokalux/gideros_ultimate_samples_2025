-- This file is supplied as part of the OptionsDemo by Scouser

-- This module has code dependencies to
--	init.lua & optionScreen.lua



-- Usual SceneManager stuff.
sceneManager = SceneManager.new({
--	["logoScreen"] = logoScreen,
--	["menuScreen"] = menuScreen,
--	["gameScreen"] = gameScreen,
--	["levelEndScreen"] = levelEndScreen,
--	["nextLevelScreen"] = nextLevelScreen,
	["splineScreen"] = splineScreen
})

--add manager to stage
stage:addChild(sceneManager)

--start start scene
sceneManager:changeScene("splineScreen", 1, SceneManager.flipWithFade, easing.outBack)
