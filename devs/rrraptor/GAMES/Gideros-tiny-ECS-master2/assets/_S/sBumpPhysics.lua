local min=math.min

SBumpPhysics = Core.class()

local function collisionFilter(e1, e2)
	if (e1.isPlayer) then
		if e2.isGun then return "cross" end
		if e2.isWall then return "slide" end
        if e2.isBullet then return nil end
		if e2.isPickup then return "cross" end
	elseif (e1.isGun) then
		if e2.isWall then return "bounce" end
	elseif (e1.isBullet) then
		if e2.isPlayer or e2.isBullet then return nil end
		if e2.isWall then return "touch" end
	elseif (e1.isNme) then
		if e2.isPlayer or e2.isBullet then return "slide" end
		if e2.isWall then return "touch" end
	end
end

function SBumpPhysics:init(bumpWorld)
--	self.system = tiny.processingSystem(self)
--	local system = tiny.processingSystem(self)
	tiny.processingSystem(self)
	self.bumpWorld = bumpWorld
end

function SBumpPhysics:filter(ent)
	-- return not (ent.body == nil or (not ent.body.active) or ent.body.isStatic)
	-- same as 
	return ent.body and ent.pos and ent.body.active and (not ent.body.isStatic)
end

function SBumpPhysics:onAdd(ent)
	local body, drawable, pos = ent.body, ent.drawable, ent.pos
	self.bumpWorld:add(ent, pos.x, pos.y, body.w, body.h)
end

function SBumpPhysics:onRemove(ent)
    self.bumpWorld:remove(ent)
end

function SBumpPhysics:process(ent, dt)
	local body, drawable, pos = ent.body, ent.drawable, ent.pos
	local ax, ay = 0, 0
	if (drawable) then ax, ay = drawable:getAnchorPosition() end

	body.vel:mult(1 - min(dt * body.friction, 1))
	local fx = (pos.x - ax + body.offsetX) + (body.vel.x * dt)
	local fy = (pos.y - ay + body.offsetY) + (body.vel.y * dt)
	local x, y, cols, len = self.bumpWorld:move(ent, fx, fy, collisionFilter)
	pos:setXY(x - body.offsetX + ax, y - body.offsetY + ay)
	if (drawable) then
		drawable:setPosition(pos:unpack())
	end

	for i = 1, len do
		local col = cols[i]
		if (col.type == "touch") then
			body.vel:setXY(0, 0)
		elseif (col.type == "slide") then
			if (col.normal.x == 0) then
				body.vel.y = 0
			else
				body.vel.x = 0
			end
		elseif (col.type == "bounce") then
			if (col.normal.x == 0) then
				body.vel.y *= -1
				body.vel.y *= body.bounce
			else
				body.vel.x *= -1
				body.vel.x *= body.bounce
			end
		end

		if (ent.onCollsion) then
			ent:onCollsion(col)
		end
	end
end
