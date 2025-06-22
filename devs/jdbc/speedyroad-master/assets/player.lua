Player = Core.class(Sprite)

Player.SPEED_NORMAL = 1
Player.SPEED_MAX = 4

function Player.setup()
--	Player.texture = Texture.new("gfx/cars/carRed6_002.png", true)
	Player.texture = Texture.new("gfx/cars/carRed5_000.png", true)
end

-- Constructor
function Player:init()
	
	self.speed = Player.SPEED_NORMAL
	
	local image = Bitmap.new(Player.texture)
	self:addChild(image)

	--MovieClip.new{{1, 20, image, {x = {-100, (width - title1:getWidth()) * 0.5, "linear"}, y = 200}}}
end
