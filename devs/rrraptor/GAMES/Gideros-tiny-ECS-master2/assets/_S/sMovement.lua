SMovement = Core.class()

function SMovement:init()
	tiny.processingSystem(self)
end

function SMovement:filter(ent)
	return ent.movement and ent.body
end

function SMovement:process(ent, dt)
	local body = ent.body
	local speed = ent.movement.speed
	
	if (ent.flagLeft) then 
		body:applyForceXY(-speed, 0)		
	end
	
	if (ent.flagRight) then 
		body:applyForceXY(speed, 0)
	end
	
	if (ent.flagUp) then 
		body:applyForceXY(0, -speed)
	end
	
	if (ent.flagDown) then
		body:applyForceXY(0, speed)
	end
	
	-- limit movement vector
	body.vel:limit(ent.movement.maxSpeed)
end
