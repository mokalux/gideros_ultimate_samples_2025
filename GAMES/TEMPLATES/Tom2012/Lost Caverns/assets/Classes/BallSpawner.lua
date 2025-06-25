BallSpawner = Core.class(Sprite)

function BallSpawner:init(scene,startX,startY,spawnEveryXSecs,id,hurtHero,linearDamping,restitution,angle,atlas,lifeSpan)

	self.atlas = atlas
	self.scene = scene
	self.startX = startX
	self.startY = startY
	self.hurtHero = hurtHero
	self.spawnEveryXSecs = spawnEveryXSecs
	self.lifeSpan = lifeSpan
	
	--print(self.lifeSpan)
	

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("chute top.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.behindRube:addChild(img)
	img:setPosition(startX,startY-47)
	
	-- setup images
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("chute bottom.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.layer0:addChild(img)
	img:setPosition(startX,startY+20)

	-- Set defaults
	
	if(linearDamping==0 or linearDamping==nil) then
		self.linearDamping=0
	else
		self.linearDamping = linearDamping
	end
	
	-- Set defaults
	
	if(restitution==0 or restitution==nil) then
		self.restitution=.5
	else
		self.restitution = restitution
	end
	
	if(self.id) then
	
		self.scene.idList[id] = self
	
	end

	Timer.delayedCall(100, self.startSpawning, self)
	
	-- Add to table of ball spawners so we can control them
	
	if(id) then
		self.scene.idList[id] = self
	end
	
	
	-- temp
	--self:spawnBall()
	
	-- sounds
	
	self.maxVolume = .40
	self.volume = 0
	
	if(not(self.scene.ballSpawnSound)) then
	
		self.scene.ballSpawnSound = Sound.new("Sounds/ball launch.wav")

	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
end






function BallSpawner:startSpawning()

	-- Only add a timer to spawn if no id is set
	-- The id is linked to a pressure plate which spawns the ball
	
	if(not(self.stopped)) then
		local spawnTimer = Timer.new((self.spawnEveryXSecs*1000), math.huge)
		spawnTimer:addEventListener(Event.TIMER, self.spawnBall, self)
		spawnTimer:start()
	end

end



function BallSpawner:spawnBall()

	if(not(self.stopped) and not(self.scene.gameEnded)) then
	
		self.channel1 = self.scene.ballSpawnSound:play()
		self.channel1:setVolume(self.volume*self.scene.soundVol)

		local ball = Ball.new(self.scene,self.startX+27,self.startY-60,self.hurtHero,self.linearDamping,self.restitution,self.atlas,self.lifeSpan)
	--	self.scene.rube1:addChild(ball)

	end

end


