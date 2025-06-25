MultiSpike = Core.class(Sprite)

function MultiSpike:init(scene,x,y,atlas,id)

	self.scene = scene
	self.id = id
	self.currentId = 1
	self.transitions = {}
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("spike.png"));
	img:setAnchorPoint(.5,.1)
	--self.spike = img
	self:addChild(img)
	self.scene.behindRube:addChild(self)

	--Timer.delayedCall(5, self.setupTimers, self)
	Timer.delayedCall(6, self.setupTransitions, self)
	Timer.delayedCall(10, self.moveToNextPosition, self) -- sends to first pos

	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(15,65,0,0,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = .6, isSensor=true}
	fixture.name = "enemy"
	self.body = body

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	-- sounds
	
	self.maxVolume = .15
	self.volume = 0
		
	if(not(self.scene.sliceSound)) then
	
		self.scene.sliceSound = Sound.new("Sounds/slice.wav")
		
	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	self:addEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	self.scene:addEventListener("onExit", self.onExit, self)

end







function MultiSpike:setupTransitions()

	for i,v in pairs(self.scene.path[self.id].vertices.y) do
	
		self.transitions[i] = GTween.new(self, .15, {y = self.scene.path[self.id].vertices.y[i]},{reflect = true, repeatCount = 2, autoPlay = false--[[delay=self.delayBetween,--]],ease = easing.inQuadratic})
		self.transitions[i]:addEventListener("complete", self.moveToNextPosition, self)
		self.transitions[i].dispatchEvents = true
		
		
		
	end
	
end



function MultiSpike:moveToNextPosition()

	Timer.delayedCall(200, function()
		self.channel1 = self.scene.sliceSound:play()
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	end)
	
	local x = self.scene.path[self.id].vertices.x[self.currentId]
	local y = self.scene.path[self.id].vertices.y[self.currentId]-120
	
	self:setPosition(x,y)
	
	self.transitions[self.currentId]:setPaused(false)
	
	self.currentId = self.currentId + 1
	
	if(self.currentId > #self.scene.path[self.id].vertices.x) then
		self.currentId = 1
	end
	
end



function MultiSpike:updateSensor()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
		self.body:setPosition(self:getPosition())
	end
end




-- cleanup function

function MultiSpike:onExit()
		
	for i,v in pairs(self.transitions) do
		v:setPaused(true)
	end
	
	self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	self.scene:removeEventListener("onExit", self.onExit, self)
	
end