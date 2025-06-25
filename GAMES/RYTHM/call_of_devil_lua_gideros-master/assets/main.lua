if not (initialized) then

	sceneManager = SceneManager.new({
		["level_scene"]       	= LevelScene,
		["game_over_scene"]   	= GameOverScene,
		["menu_scene"]        	= MenuScene,
		["win_scene"] 			= WinScene,
	})

	stage:addChild(sceneManager)

	sceneManager:changeScene("menu_scene", conf.TRANSITION_TIME,  SceneManager.fade)
	
	initialized = true
	
end
