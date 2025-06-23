SStaticPhysicsBodies = Core.class()

function SStaticPhysicsBodies:init(bumpWorld)
--	self.system = tiny.system(self)
--	local system = tiny.system(self)
	tiny.system(self)
	self.bumpWorld = bumpWorld
end

function SStaticPhysicsBodies:filter(ent)
	return ent.body and ent.pos and ent.body.isStatic and ent.body.active
end

function SStaticPhysicsBodies:onAdd(ent)
	local body, drawable, pos = ent.body, ent.drawable, ent.pos
	self.bumpWorld:add(ent, pos.x, pos.y, body.w, body.h)
end

function SStaticPhysicsBodies:onRemove(ent)
    self.bumpWorld:remove(ent)
end
