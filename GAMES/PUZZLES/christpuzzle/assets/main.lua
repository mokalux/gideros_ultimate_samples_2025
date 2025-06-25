sceneManager = SceneManager.new({
	["splash"] = splash,
	["levels"] = levels,
	["puzzle"] = puzzle
})
font = TTFont.new("ariblk.ttf", 13)
stage:addChild(sceneManager)

 transitions = {
	SceneManager.moveFromLeft,
	SceneManager.moveFromRight,
	SceneManager.moveFromBottom,
	SceneManager.moveFromTop,
	SceneManager.moveFromLeftWithFade,
	SceneManager.moveFromRightWithFade,
	SceneManager.moveFromBottomWithFade,
	SceneManager.moveFromTopWithFade,
	SceneManager.overFromLeft,
	SceneManager.overFromRight,
	SceneManager.overFromBottom,
	SceneManager.overFromTop,
	SceneManager.overFromLeftWithFade,
	SceneManager.overFromRightWithFade,
	SceneManager.overFromBottomWithFade,
	SceneManager.overFromTopWithFade,
	SceneManager.fade,
	SceneManager.crossFade,
	SceneManager.flip,
	SceneManager.flipWithFade,
	SceneManager.flipWithShade,
}

 scenes = {"splash","levels"}
font2=TTFont.new("ariblk.ttf",30)
 currentScene = 1
 function nextScene()
	local next = scenes[currentScene]

	currentScene = currentScene + 1
	if currentScene > #scenes then
		currentScene = 1
	end
	
	return next
end



sceneManager:changeScene(nextScene())