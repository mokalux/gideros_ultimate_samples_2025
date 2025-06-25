HealthPickup = Core.class(Sprite)

function HealthPickup:init(scene,x,y)

	Timer.delayedCall(1000, function() self.canBeCollected = true end)

	self.scene = scene
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("health pickup.png"))
	self:addChild(img)
	img:setAnchorPoint(.5,.5)
	self.scene.rube1:addChild(self)
	
	img:setScale(.7,.7)
	self.tween = GTween.new(img, .5, {scaleX = 1, scaleY = 1},{ease = easing.inBounce, reflect = true, repeatCount = math.huge})
	self.img = img
	
	-- Add physics

	Timer.delayedCall(1, function()

		self.body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
		self.body:setGravityScale(0)

		self.body:setPosition(x,y)

		local circle = b2.CircleShape.new(0,0,14)
		local fixture = self.body:createFixture{shape = circle, density = .1, friction = .1, restitution = .3}

		fixture.name = "health"
		fixture.parent = self

		local filterData = {categoryBits = 4096, maskBits = 2+8+512+4096}
		fixture:setFilterData(filterData)

	end)
	
end




function HealthPickup:collect()

	if(not(self.collected)) then
	
		self.collected = true

		playSound("Sounds/collect-health.mp3",.2*self.scene.soundVol)
		self.body.destroyed = true

		Timer.delayedCall(5, self.destroyBody, self) 
		Timer.delayedCall(10, self.removeSprite, self)
		self.tween:setPaused(true)

		-- make fly up
		
		local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("health pickup.png"))
		self:addChild(img)
		img:setAnchorPoint(.5,.5)
		self.scene.interfaceLayer:addChild(img)
		
		self.img = img
		
		local x,y = self:globalToLocal(0,0)
		x = math.abs(x)
		y = math.abs(y)
		
		img:setPosition(x,y)
		--self.tween = GTween.new(img, .3, {x=24+(health*12), y=20, scaleX = .5, scaleY = .5},{ease = easing.inQuadratic})
		self.tween = GTween.new(img, .5, {x=(24+(health*12))+xOffset, y=20+yOffset, scaleX = .5, scaleY = .5},{ease = easing.inQuadratic})
		self.tween:addEventListener("complete", self.increaseHealth, self)
		self.tween.dispatchEvents = true
	
	end
	
	

end


function HealthPickup:increaseHealth()
	
	self.scene.health:increaseHealth(2)

	self.tween = GTween.new(self.img, .2, {alpha = 0, scaleX = .3, scaleY = .3})

end



function HealthPickup:removeSprite()
	
	self:getParent():removeChild(self)

end





function HealthPickup:destroyBody()
	
	self.scene.world:destroyBody(self.body)
	
	for i,v in pairs(self.scene.coins) do
		if(v==self) then
			table.remove(self.scene.coins, i)
		end
	end

end




function HealthPickup:pause()

	--self.mc:stop()
	
end



function HealthPickup:resume()

	if(not(self.scene.gameEnded)) then
		--self.mc:play()
	end

end




function HealthPickup:exit()

	if(self.tween) then
		self.tween:setPaused(true)
	end

end


