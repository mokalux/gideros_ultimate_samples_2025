GClevel = Core.class(Sprite)

function GClevel:init()
	local sceneCamera = Sprite.new()
	self:addChild(sceneCamera)
	local firstBar = GCplatform.new(Texture.new("gfx/platform/platform.png"), 450, 20, sceneCamera)
	local char = GCchar.new(Texture.new("gfx/player/char.png"))
	sceneCamera:addChild(char)
end
