SUpdate = Core.class()

function SUpdate:init()
	self.system = tiny.processingSystem(self)
	self.system.filter = tiny.requireAll("update")
end

function SUpdate:process(ent, dt)
	ent:update(dt)
	if (ent.needToUpdate) then
		ent.needToUpdate = false
		tworld:addEntity(ent)
	end
end
