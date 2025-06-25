--[[
ProjectilePool Class
@Author : Rere
]]

ProjectilePool = gideros.class(Sprite)

function ProjectilePool:init(texture, capacity, offsetSpeed)
	self.projectiles = {}
	self.activeList = {}
	self.minX = 0
	self.maxX = conf.screenWidth
	self.offsetSpeed = offsetSpeed
	for i = 1 , capacity do
		self.projectiles[i] =  Projectile.new(texture,0,0)
		self.projectiles[i]:reset()
		self:addChild(self.projectiles[i])
		self.activeList[i] = false
	end
end

function ProjectilePool:make(startX, startY, speed, direction, distance)
	i = 1
	while self.activeList[i] and i <= #self.activeList do
		i=i+1
	end
	if i < #self.activeList then
		self.projectiles[i]:setPosition(startX, startY)
		self.projectiles[i]:setParameter(speed, direction, distance, self.offsetSpeed)
		--self.projectiles[i]:setAlpha(100)
		
		self.activeList[i] = true
	end
end

--auto release
function ProjectilePool:update()
	for i = 1 , #self.projectiles do
		if(self.activeList[i]) then
			if(self.projectiles[i]:getX() < self.minX or
			   self.projectiles[i]:getX() > self.maxX or -- hitting side walls
			   self.projectiles[i].isExploded ) then -- already exploded
				self.projectiles[i]:reset()
				self.activeList[i] = false
			else
				self.projectiles[i]:update()				
				--print(self.projectiles[i]:getX()  .. self.projectiles[i]:getY() )
			end
		end		
	end
end

function ProjectilePool:reset()
	for i = 1 , #self.projectiles do
		if(self.activeList[i]) then
			self.projectiles[i]:reset()
			self.activeList[i] = false
		end		
	end
end