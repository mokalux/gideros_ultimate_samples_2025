local tex = Texture.new("gfx/player2.png")
local _tworld

ENme = Core.class(EBase)

function ENme:init(x, y)
	if (not _tworld) then _tworld = tworld end
	self.isNme = true

	-- components BODY
	self.body = CBody.new(50, 50)
	self.pos = Vec2.new(x, y)
	self.rotation = 180
	self.movement = {
		speed = 20,
		maxSpeed = 100,
	}
	self.body:setFriction(30)
	self.body.offsetX = -8
	self.body.offsetY = -8

	-- component DRAWABLE
	self.drawable = CDrawable.new("main") -- "main" = camera layer
	local bmp = Bitmap.new(tex)
	local sw, sh = bmp:getSize()
	self.drawable:add(bmp)
	self.drawable:setAnchorPosition(sw / 2, sh / 2)
	self.drawable:setPosition(self.pos:unpack())

	self.hasGun = false
end

function ENme:onCollsion(col)
	local other = col.other
	if other.isPlayer then
		print("player touched me!")
--		other.body.active = false
		print(other.body.active)
	end
end
