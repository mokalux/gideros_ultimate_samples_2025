--[[
Gun Class
@Author : Rere
]]

PistolGun = gideros.class(Sprite)

function PistolGun:init(projectilePool, projectileSpeed, projectileDistance)
	self.projectilePool = projectilePool
	self.projectileSpeed = projectileSpeed
	self.projectileDistance= projectileDistance	
end

function PistolGun:fire()
	self.projectilePool:make(self:getX(),self:getY(),self.projectileSpeed,self:getRotation(),self.projectileDistance)
end
