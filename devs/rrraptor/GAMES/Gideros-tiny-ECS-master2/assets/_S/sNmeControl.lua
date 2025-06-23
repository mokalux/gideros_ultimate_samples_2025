local floor=math.floor

SNmeControl = Core.class()

function SNmeControl:init()
	local system = tiny.processingSystem(self)
	system.filter = tiny.requireAll("isNme")
end

function SNmeControl:onAdd(ent)
	self.actor = ent
end

function SNmeControl:process(ent, dt)
	local sx, sy = self.actor.pos:unpack()
	local x = right and 1 or -1
--	local d = self.actor.drawable
--	if (d) then d:setRotation(self.actor.rotation) end
	self.actor.flagLeft = true
--	self.actor.flagRight = true
--	self.actor.flagUp = true
--	self.actor.flagDown = true
--	self.actor.eGun:shoot(false)
end
