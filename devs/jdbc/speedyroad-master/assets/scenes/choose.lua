ChooseScene = Core.class(Sprite)

function ChooseScene.setup()
	ChooseScene.texture_map = Texture.new("gfx/map.jpg", true)
end

-- Constructor
function ChooseScene:init()
	local map = Bitmap.new(ChooseScene.texture_map, true)
	map:setScale(0.54)
	--map:setY(-110)
	self:addChild(map)
end
