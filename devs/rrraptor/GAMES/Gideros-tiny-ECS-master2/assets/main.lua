-- scene manager
sceneManager = SceneManager.new
	{
		["Game"] = GameScene,
	}
sceneManager:changeScene("Game")
stage:addChild(sceneManager)
