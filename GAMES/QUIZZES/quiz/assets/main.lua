
sceneManager = SceneManager.new({
	["menuScreen"] = menuScreen,
	["quizScene"] = quizScene,
	
})
--application:setBackgroundColor(0x000000)
stage:addChild(sceneManager)

sceneManager:changeScene("quizScene", 1, SceneManager.fade, easing.linear) 
