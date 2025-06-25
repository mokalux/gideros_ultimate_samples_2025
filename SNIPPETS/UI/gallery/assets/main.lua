sceneManager = SceneManager.new({
	["scene1"] = Scene1, -- Main Scene
	["scene2"] = Scene2, -- 2 Scene
	["scene3"] = Scene3, -- 3 Scene
})

stage:addChild(sceneManager)

scenes = {"scene1", "scene2", "scene3"}

AceSlide.init({
	orientation = 'horizontal',
	spacing = 100,
	parent = stage,
	speed = 5,
	unfocusedAlpha = 0.5,
	easing = nil,
	allowDrag = true,
	dragOffset = 10
})

font = TTFont.new("font/Roboto-Regular.ttf", 24)

--for i = 1, table.getn(scenes) do
--print(#scenes)
for i = 1, #scenes do
	local myText = TextField.new(font, i)
	AceSlide.add(myText)
end
AceSlide.show()

sceneManager:changeScene("scene1")
