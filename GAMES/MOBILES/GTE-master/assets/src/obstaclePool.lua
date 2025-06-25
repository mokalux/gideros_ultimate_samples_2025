--[[
ObstaclePool Class
@Author : Rere
]]

ObstaclePool = gideros.class(Sprite)

function ObstaclePool:init(texture, capacity)
	self.obstacles = {}
	self.activeList = {}
	self.maxY = conf.screenHeight + 50 -- texture dimension
	for i = 1 , capacity do
		self.obstacles[i] = Obstacle.new(texture)
		self.obstacles[i]:reset()
		self:addChild(self.obstacles[i])
		self.activeList[i] = false
	end
end

function ObstaclePool:make(startX, direction, speed)
	--print(speed)
	i = 1
	while self.activeList[i] and i <= #self.activeList do
		i=i+1
	end
	if i < #self.activeList then
		self.obstacles[i]:setPosition(startX, -50)
		self.obstacles[i]:setParameter(direction, speed)
		--self.obstacles[i]:setAlpha(100)
		self.activeList[i] = true
	end
end

--auto release
function ObstaclePool:update(targetX,targetY)
	for i = 1 , #self.obstacles do
		if(self.activeList[i]) then
			if(self.obstacles[i]:getY() > self.maxY) then -- hitting bottom walls
				self.obstacles[i]:reset()
				self.activeList[i] = false
			else
				self.obstacles[i]:update()
				--print(self.projectiles[i]:getX()  .. self.projectiles[i]:getY() )
			end
		end		
	end
end

function ObstaclePool:reset()
	for i = 1 , #self.obstacles do
		if(self.activeList[i]) then
			self.obstacles[i]:reset()
			self.activeList[i] = false
		end		
	end
end
