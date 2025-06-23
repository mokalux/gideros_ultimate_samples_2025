local min=math.min

SGun = Core.class()

function SGun:init()
	tiny.processingSystem(self)
end

function SGun:filter(ent)
	return ent.gun ~= nil and ent.gun.active
end

function SGun:process(ent, dt)
	local gun = ent.gun
	gun.timer += dt
	
	if (gun.reloading or (gun.ammo == 0 and gun.total > 0)) then
		if (gun.timer >= gun.reloadTime) then
			gun.timer = 0
			
			local needed = gun.magazine - gun.ammo
			local v = clamp(gun.total - needed, 0, gun.total)
			
			if (v == 0) then
				gun.ammo = gun.total
			else
				gun.ammo += needed
			end
			gun.total = v
			
			gun.reloading = false
		end
	elseif (gun.shooting and gun.ammo > 0) then
		if (gun.timer >= gun.fireRate) then
			gun.timer = 0			
			gun.ammo -= 1			
			if (ent.onShoot) then ent:onShoot() end
		end
	end
end