JellyFish = Core.class(Sprite)

function JellyFish:init(scene,x,y,id,timeBetween,delayBetween,easing,atlas)

	self.delayBetween = delayBetween
	self.scene = scene
	self.atlas = tonumber(atlas)
	self.id = tonumber(id)
	self.tweens = {}
	
	self.y = y

	self.timeBetween = timeBetween -- time taken to move between points
	self.delayBetween = delayBetween

	self.scene.behindRube:addChild(self)
	
	self.direction = "up"

	Timer.delayedCall(10, self.setup, self)
	
	-- sounds
	
	self.maxVolume = .15
	self.volume = 0
		
	if(not(self.scene.slimeJumpSound)) then
	
		self.scene.slimeJumpSound = Sound.new("Sounds/slime jump.wav")
		
	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	Timer.delayedCall(15, function()
	
		self:addEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	end)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
end


function JellyFish:setup()

	-- define the top and bottom points (on this sprite)
	
	self.startY = self:getY()
	self.point2 = self.scene.path[self.id].vertices.y[1]
	self.point2X = self.scene.path[self.id].vertices.x[1]
	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("jellyfish1.png"))
	self:addChild(img)
	img:setAnchorPoint(.5,.5)
	self.jellyFish = img

	local x,y = self:getPosition()
	
	-- Bottom base
	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("jellyfish2.png"))
	img:setAnchorPoint(.5,.5)
	img:setY(30)
	self.scene.rube3:addChild(img)
	img:setPosition(x,y+20)
	self.bottomBase = img

	-- Top base
	
	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion("jellyfish3.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(self.point2X,self.point2-20)
	self.scene.rube3:addChild(img)
	self.topBase = img

	-- create transitions

	-- Up tween
	local tween = GTween.new(self, self.timeBetween, {y = self.point2},{ease = easing.inCubic,autoplay=false})
	tween:setPaused(true)
	tween.dispatchEvents = true
	tween:addEventListener("complete", self.finishedMove, self)
	self.upTween = tween
	table.insert(self.tweens, self.upTween)

	-- down tween
	local tween = GTween.new(self, self.timeBetween, {y = self.startY},{ease = easing.inCubic,autoPlay=false})
	tween:setPaused(true)
	tween.dispatchEvents = true
	tween:addEventListener("complete", self.finishedMove, self)
	self.downTween = tween
	table.insert(self.tweens, self.downTween)

	-- Tweens to make move
	

	-- Bob when at top base

	self.topBaseBob = GTween.new(self.topBase, self.delayBetween*.3, {scaleY = .93,scaleX = 1.05},{ease = easing.inQuadratic,repeatCount=6, reflect=true,autoPlay=false})
	self.topJellyFishBob = GTween.new(self, self.delayBetween*.3, {y = self.point2-6},{ease = easing.inQuadratic,repeatCount=5, reflect=true,autoPlay=false})
	self.topJellyFishBob.dispatchEvents = true
	self.topJellyFishBob:addEventListener("complete", self.move, self)
	table.insert(self.tweens, self.topJellyFishBob)
	
	-- Bob when at bottom base
	
	self.bottomBaseBob = GTween.new(self.bottomBase, self.delayBetween*.3, {scaleY = .93,scaleX = 1.05},{ease = easing.inQuadratic,repeatCount=6, reflect=true})
	self.bottomJellyFishBob = GTween.new(self, self.delayBetween*.3, {y = self:getY()+6},{ease = easing.inQuadratic,repeatCount=5, reflect=true})
	self.bottomJellyFishBob.dispatchEvents = true
	self.bottomJellyFishBob:addEventListener("complete", self.move, self)
	table.insert(self.tweens, self.bottomJellyFishBob)
		
	self.thinTween =  GTween.new(self, .5, {scaleY = 1.2,scaleX = .9},{repeatCount=2, reflect=true,autoPlay=false})
	table.insert(self.tweens, self.thinTween)
	
	-- Jellyfish wobble

	local tween = GTween.new(self.jellyFish, .4, {scaleY = 1.04,scaleX = .96},{ease = easing.inBounce,repeatCount=math.huge, reflect=true})
	table.insert(self.tweens, tween)
	
	self.rotateDown = GTween.new(self, (self.delayBetween*.3)*3, {rotation=180},{delay=.5,autoPlay=false})
	self.rotateUp = GTween.new(self, (self.delayBetween*.3)*3, {rotation=0},{delay=.5,autoPlay=false})
	
	table.insert(self.tweens, self.rotateUp)
	table.insert(self.tweens, self.rotateDown)

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local poly = b2.PolygonShape.new()
	poly:setAsBox(18,22,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	
	fixture.parent = self
	fixture.name = "enemy"
	self.body = body
	
	--self.body:setLinearDamping(math.huge)
	body:setGravityScale(0)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	
	-- up and down sensors
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local poly = b2.PolygonShape.new()
	poly:setAsBox(30,10,0,20,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	
	fixture.parent = self
	--fixture.name = "enemy"
	self.body1 = body
	
	self.body1:setGravityScale(0)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	
	
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local poly = b2.PolygonShape.new()
	poly:setAsBox(30,10,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	
	fixture.parent = self
	--fixture.name = "enemy"
	self.body2 = body
	
	self.body2:setLinearDamping(math.huge)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	local x,y = self.body:getPosition()
	self.body2:setPosition(x, self.point2-10)
	


end



function JellyFish:move()

	Timer.delayedCall(250, function()
		self.channel1 = self.scene.slimeJumpSound:play()
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	end)

	if(self.direction=="up") then
	
		self.upTween:setPaused(false)
		self.thinTween:setPaused(false)
	
	else
	
		self.downTween:setPaused(false)
		self.thinTween:setPaused(false)
		
	end

end



function JellyFish:finishedMove()

	if(self.direction=="up") then
		
		self:setY(self:getY())
		self.topBaseBob:setPaused(false)
		self.topJellyFishBob:setPaused(false)
		self.rotateDown:setPaused(false)
		self.direction="down"


		
	else

		self:setY(self:getY())
		self.bottomBaseBob:setPaused(false)
		self.bottomJellyFishBob:setPaused(false)
		self.direction="up"
		self.rotateUp:setPaused(false)

	end

end



function JellyFish:updateSensor()

	self.body:setPosition(self:getPosition())
	
end



function JellyFish:pause()

end




function JellyFish:resume()

end



-- cleanup function

function JellyFish:exit()
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
	self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	
end
