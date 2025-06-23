local tex = Texture.new("gfx/player2.png")
local _tworld

EPlayer = Core.class(EBase)

function EPlayer:init(x, y)
	if (not _tworld) then _tworld = tworld end
	self.isPlayer = true
	self.locked = false
	self.watchingDir = Vec2.new(1, 0)

	-- components BODY
	self.body = CBody.new(22, 22)
	self.pos = Vec2.new(x, y)
	self.rotation = 0
	self.movement = {
		speed = 250,
		maxSpeed = 1400,
	}
	self.body:setFriction(30)
	self.body.offsetX = 8
	self.body.offsetY = 8

	-- component DRAWABLE
	self.drawable = CDrawable.new("main")
	local sprite = Bitmap.new(tex)
	local sw, sh = sprite:getSize()
	self.drawable:add(sprite)
	self.drawable:setAnchorPosition(sw / 2, sh / 2)
	self.drawable:setPosition(self.pos:unpack())

	self.hasGun = false
end

function EPlayer:lock(flag)
	self.locked = flag
end

function EPlayer:onCollsion(col)
	local other = col.other
	if (other.isGun and other.gun and not self.hasGun and not col.overlap) then
		self.hasGun = true
		self.eGun = other.gun
		-- mark to add to the gun system
		other.gun.active = true
		-- mark to remove from the physics system
		other.body.active = false
		-- set flag to RE-ADD entity to the world
		other:updateInSystem()
		other:pinTo(self)
	elseif (other.isPickup and other.isAmmo and self.hasGun) then
		if (self.eGun:addAmmo(other.amount)) then
			_tworld:remove(other)
		end
	end
end
