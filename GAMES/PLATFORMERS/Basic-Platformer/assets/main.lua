--define scenes
sceneManager = SceneManager.new({
["Level 1"] = level1,

})

--add manager to stage
stage:addChild(sceneManager);

sceneManager:changeScene("Level 1", 1, SceneManager.flipWithFade, easing.outBack);

