--[[
PolicePool Class
@Author : Rere
]]

PolicePool = gideros.class(Sprite)

function PolicePool:init(texture_idle, texture_fire, sound, capacity)
	self.polices = {}
	self.activeList = {}
	self.maxY = conf.screenHeight + 50 -- texture dimension
	for i = 1 , capacity do
		self.polices[i] =  Police.new(texture_idle, texture_fire, 0, sound)
		self.polices[i]:reset()
		self:addChild(self.polices[i])
		self.activeList[i] = false
	end
end

function PolicePool:setGun(gun)
	self.gun = gun
end

function PolicePool:make(startX, fireRate, speed)
	i = 1
	while self.activeList[i] and i <= #self.activeList do
		i=i+1
	end
	if i < #self.activeList then
		self.polices[i]:setPosition(startX, 0)
		self.polices[i]:setParameter(fireRate,speed)
		self.polices[i]:equip(self.gun)
		--self.polices[i]:setAlpha(100)
		self.activeList[i] = true
	end
end

--auto release
function PolicePool:update(targetX,targetY)
	for i = 1 , #self.polices do
		if(self.activeList[i]) then
			if(self.polices[i]:getY() > self.maxY) then -- hitting bottom walls
				self.polices[i]:reset()
				self.activeList[i] = false
			else
				self.polices[i]:setShootTarget(targetX,targetY)
				self.polices[i]:update()
				--print(self.projectiles[i]:getX()  .. self.projectiles[i]:getY() )
			end
		end		
	end
end

function PolicePool:reset()
	for i = 1 , #self.polices do
		if(self.activeList[i]) then
			self.polices[i]:reset()
			self.activeList[i] = false
		end		
	end
end
