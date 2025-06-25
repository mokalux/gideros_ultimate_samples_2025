scenemanager = SceneManager.new(
	{
		["menu"] = Menu,
		["plotter"] = Plotter,
		["myclass"] = MyClass, -- imgui tests
	}
)
stage:addChild(scenemanager)
scenemanager:changeScene("plotter")
