local scenes = {}
scenes[1] = MnScene.new()
scenes[2] = PlScene.new()

-- fade sprite()
local fadeLogo = Bitmap.new(Texture.new("gfx/switchbmp.png"))
fadeLogo:setAnchorPoint(0.5, 0.5)
fadeLogo:setPosition(540, 900)

switchScene(stage, scenes[1], scenes, fadeLogo)

-- event listeners
stage:addEventListener("switchScene", function(event)
	switchScene(stage, scenes[event.scene], scenes, fadeLogo)
end)
