Wind = Core.class(Sprite)

-- This class decides when the wind should start and stop

function Wind:init(scene,minTimeBetween,maxTimeBetween,minDuration,maxDuration,atlas)

	--self.test = true
	
	self.scene = scene
	self.atlas = atlas
	self.minTimeBetween = minTimeBetween * 1000
	self.maxTimeBetween = maxTimeBetween * 1000
	self.minDuration = minDuration * 2000
	self.maxDuration = maxDuration * 3000
	
	-- Now add the timer to 

	self.windObjects = {}

	self:setupTimers()
	
	Timer.delayedCall(15000, self.startGusts, self) -- start it all off


	self.maxWindSpeed = 0
	self.windImg = 0
	
		
	-- sounds
	
	self.volume = .3
		
	if(not(self.scene.windSound)) then
	
		self.scene.windStartSound = Sound.new("Sounds/wind start.wav")
		self.scene.windSound = Sound.new("Sounds/wind.wav")
		self.scene.windEndSound = Sound.new("Sounds/wind end.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.windSound:play(0,math.huge,true)
	self.channel1:setVolume(self.volume*self.scene.soundVol)
	
--	self:startGusts()

end





function Wind:setupTimers()

	-- this timer blows player back
	
	local t = Timer.new(50,math.huge)
	t:addEventListener(Event.TIMER, self.playerWindForce, self)
	self.playerWindForceTimer = t
	--t:start()
	
	local t = Timer.new(50,math.huge)
	t:addEventListener(Event.TIMER, self.playerReduceWindForce, self)
	self.playerReduceWindForceTimer = t
	--t:start()
	
	-- timer to apply force to all objects

	local t = Timer.new(100,math.huge)
	t:addEventListener(Event.TIMER, self.windForce, self)
	self.windForceTimer = t
	--t:start()
	
	local t = Timer.new(200,math.huge)
	t:addEventListener(Event.TIMER, self.spawnObject, self)
	self.spawnTimer = t
	--t:start()

	-- wind gust timer
	
	local t = Timer.new(800,math.huge)
	t:addEventListener(Event.TIMER, self.addGust, self)
	self.gustSpawner = t

	-- leaf spawning timer
	
	local timer = Timer.new(200,1000)
	timer:addEventListener(Event.TIMER, self.addLeaf, self)
	self.leafSpawner = timer
	
	 -- cull images off screen
	
	local timer = Timer.new(100,math.huge)
	timer:addEventListener(Event.TIMER, self.cullImagesOffScreen, self)
	self.imagesOffScreenCuller = timer
	
end






function Wind:startGusts()

	if(self.test) then
		print("startGusts()")
	end
	

	local channel = self.scene.windStartSound:play()
	channel:setVolume(self.volume*self.scene.soundVol)
	
	Timer.delayedCall(500, function()
		self.channel1:setPaused(false)
	end)
	
	self.gustSpawner:start()

	self.imagesOffScreenCuller:start()

	Timer.delayedCall(1000, self.startLeaves, self)
--	self.playerWindForceTimer:start()

end




function Wind:startLeaves()
	
	if(self.test) then
		print("startLeaves()")
	end
	
	self.leafSpawner:start()
	Timer.delayedCall(2000, self.startWind, self)
	
end






function Wind:startWind()

	if(self.test) then
		print("startWind()")
	end

	--print("wind objects")
	
	Timer.delayedCall(math.random(self.minDuration,self.maxDuration), self.stopWind, self)
	self.windForceTimer:start()
	self:beginSpawning()
	
end






function Wind:beginSpawning()

	if(self.test) then
		print("self.spawnTimer:start()")
	end
	
	self.spawnTimer:start()
	
end



function Wind:stopWind()

	if(self.test) then
		print("stopWind()")
	end
	
	if(self.channel1) then
		self.channel1:setPaused(true)
		self.channel1:setVolume(0)
	end
	local channel1 = self.scene.windEndSound:play()
	channel1:setVolume(self.volume*self.scene.soundVol)



	
	self.spawnTimer:stop()
	self.windForceTimer:stop()
	self.playerWindForceTimer:stop()
	self.playerReduceWindForceTimer:start()
 
	Timer.delayedCall(math.random(self.minTimeBetween,self.maxTimeBetween), self.startGusts, self) -- start the process again
	
	self.leafSpawner:stop()
	self.gustSpawner:stop()
	
	Timer.delayedCall(3000, self.fadeWindImages, self)
	Timer.delayedCall(4000, self.removeWindImages, self)
	
end







function Wind:spawnObject()

	self.windImg = self.windImg + 1
	if(self.windImg > 19) then
		self.windImg = 1
	end
	local o = WindObject.new(self.scene, self.atlas, self.windImg)
	table.insert(self.windObjects, o)

end





function Wind:playerWindForce()

	if(self.scene.windSpeed > -self.maxWindSpeed) then
		self.scene.windSpeed = self.scene.windSpeed - .03
	end
	
end



function Wind:playerReduceWindForce()
	
	if(self.scene.windSpeed < 0) then
		self.scene.windSpeed = self.scene.windSpeed + .1
	end
	
	if(self.scene.windSpeed > 0) then
		self.scene.windSpeed = 0
		self.playerReduceWindForceTimer:stop()
	end
	
end






function Wind:windForce()

	for i,v in pairs(self.windObjects) do
	
		if(v.body and not(v.body.destroyed)) then

			self.xVel,self.yVel = v.body:getLinearVelocity()

			if(self.xVel > v.maxSpeed) then
				self.xVel = self.xVel - v.speed
			end

			v.body:setLinearVelocity(self.xVel, self.yVel)
		
		end
	
	end
	
end








function Wind:startBlowing()

	if(self.test) then
		print("startBlowing()")
	end
	
	Timer.delayedCall(math.random(self.minDuration,self.maxDuration), self.stopWind, self)

end






function Wind:addLeaf()

	--print("add")
	local i = math.random(1,5)
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("leaf "..i..".png"))
	self.scene.frontLayer:addChild(img)

	local leafX = math.random(0, 100) + self.scene.playerMovement.heroX
	local leafY = math.random(-200, 200) + self.scene.playerMovement.heroY
	
	img:setPosition(leafX, leafY)
	
	img:setAnchorPoint(.5,.5)

	local scale = (math.random() + math.random(40, 100)) / 100
	img:setScaleX(scale)
	img:setScaleY(scale)
	img:setPosition(self.scene.hero:getX()+500, self.scene.hero:getY()+math.random(-500,500))
	
	local r = math.random(150,255)
	local g = math.random(150,255)
	local b = math.random(150,255)
	img:setColorTransform(r/255,g/255,b/255,1)

	local time = math.random(8,10)
	local rotation = math.random(0, 4000)
	local y = math.random(-600, 600)
	
	self.tween = GTween.new(img, time, {x = -1000, rotation = rotation, y = img:getY()+y})

	table.insert(self.windObjects, img)
	table.insert(self.scene.sprites, img)

end





function Wind:addGust()

	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("wind.png"))
	self.scene.frontLayer:addChild(img)
	
	local x = math.random(0, 100) + self.scene.playerMovement.heroX
	local y = math.random(-200, 200) + self.scene.playerMovement.heroY
	
	img:setPosition(x, y)
	
	img:setAnchorPoint(.5,.5)

	
	local scale = (math.random() + math.random(70, 100)) / 100
	img:setScaleX(scale)
	img:setScaleY(scale)
	img:setPosition(self.scene.hero:getX()+500, self.scene.hero:getY()+math.random(-300,300))
	
	self.tween = GTween.new(img, math.random(8,10), {x = -1000})

	table.insert(self.windObjects, img)
	table.insert(self.scene.sprites, img)

end



-- this function removes images that have gone off left side

function Wind:cullImagesOffScreen()

	for i,v in pairs(self.windObjects) do
	
		if(v.body and not(v.body.destroyed)) then
		
			local x,y = v.body:getPosition()
			
			-- physics object, don't want to bounce off left side
			-- ao kill collision if x < less than 100
			
			if(x<50 and not(v.sensor)) then
				
				v.sensor = true
				local filterData = {categoryBits = 128, maskBits = 0}
				v.fixture:setFilterData(filterData)
			
			elseif(x <- 50) then
			
				v:killSelf()
				table.remove(self.windObjects, i)
			
			end
			
		else
	
		--	print(v:getX())
			if(v:getX() < 0) then

				self:removeImg(i,v)
	
			end
		
		end

	end

end









-- this one runs when wind stops to clear out any other objects after x seconds

function Wind:fadeWindImages()

	for i,v in pairs(self.windObjects) do

		if(v.body) then
			
			local tween = GTween.new(v.img, 1, {alpha=0})
			
			-- turn off hurt hero
			local filterData = {categoryBits = 0, maskBits = 0}
			if(not(v.body.destroyed)) then
				v.fixture:setFilterData(filterData)
			end
		else

			local tween = GTween.new(v, 1, {alpha=0})
		
		end

	end

end





function Wind:removeWindImages()

	if(self.test) then
		print("!!! removeWindImages() !!!")
	end

	for i,v in pairs(self.windObjects) do

		if(v.body) then
			
			v:killSelf()
			table.remove(self.windObjects, i)
			
		else

			self:removeImg(i,v)

		end

	end
	
	self.imagesOffScreenCuller:stop()
	
end




function Wind:removeImg(i,v)
	if(v.tween) then
--		v.tween:setPaused(true)
		print("y")
	end
	
	-- remove from sprites on screen (used for culling)

	for imgId,imgTable in pairs(self.scene.sprites) do
	
		if(imgTable==v) then
			--print(v.type)
			table.remove(self.scene.sprites, imgId)
		end
	end

	self.scene.frontLayer:removeChild(v)
	table.remove(self.windObjects, i)
	v = nil

end


