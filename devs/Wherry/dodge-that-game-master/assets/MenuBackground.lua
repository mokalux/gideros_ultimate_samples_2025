local MenuBackground = Core.class(Sprite)

local RINGS_COUNT = 4

function MenuBackground:init()
	-- Фоновая картинка
	self.background = Bitmap.new(Texture.new("assets/menu/background.png"))
	self:addChild(self.background)

	-- Кольца
	self.rings = {}
	for i = 1, RINGS_COUNT do
		local ringTexture = Texture.new("assets/menu/" .. tostring(i) .. ".png")
		local ring = Bitmap.new(ringTexture)
		ring:setAnchorPoint(0.5, 0.5)
		ring:setPosition(screenWidth / 2, screenHeight / 2)
		ring:setScale(1.5)
		ring:setAlpha(0.5 / (i / 2))
		self:addChild(ring)
		table.insert(self.rings, ring)
	end
end

function MenuBackground:update(deltaTime)
	for i, ring in ipairs(self.rings) do
		ring:setRotation(ring:getRotation() + deltaTime * 10 * i)
	end
end

return MenuBackground