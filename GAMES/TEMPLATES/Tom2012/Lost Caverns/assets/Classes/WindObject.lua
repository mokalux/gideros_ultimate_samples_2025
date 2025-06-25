WindObject = Core.class(Sprite)

-- This class generates a wind object

function WindObject:init(scene,atlas,windImg)

	self.scene = scene
	
	local img = Bitmap.new(self.scene.atlas[19]:getTextureRegion("wind object "..windImg..".png"))

	img:setAnchorPoint(.5,.5)
	img:setPosition(0,0)
	self:addChild(img)
	self.scene.rube1:addChild(self)
	
	
	self.img = img
	img:setRotation(math.random(1,359))
	

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	
	
	if(i==15) then
		self.radius=15
	else
		self.radius = 25
	end
	
	local shape = b2.CircleShape.new(0,0,self.radius)
	
	local fixture = body:createFixture{shape = shape, density = 1, friction = .7, restitution = .8}
	
	if(math.random(1,2)==1) then
		self.maskBits = 8+2+16
	else
		self.maskBits = 128+8+2+16
	end
	
	local filterData = {categoryBits = 128, maskBits = self.maskBits}
	fixture:setFilterData(filterData)
	
	self.fixture = fixture
	
	body.name = "enemy"
	body.name2 = "windObject"
	self.body = body
	body:setGravityScale(0)

	body:setAngularVelocity(math.random(-5,5))

	self.body:setPosition(self.scene.hero:getX()+500, self.scene.hero:getY()+math.random(-400,400))
	body:setAngularVelocity(math.random()+math.random(-1,2))
	
	table.insert(self.scene.spritesOnScreen, self) -- move with box2D
	table.insert(self.scene.sprites, self) -- used for off screen culling

	self.maxSpeed = math.random()+math.random(-10,-7)
	self.mySpeed = math.random()+math.random(6,9)
	self.speed = math.random() + math.random(.6,.7)+.5 -- object speed
		
	body.parent = self
	
	Timer.delayedCall(10, self.blowUp, self)
	self:addTimers()

	self:addEventListener(Event.ENTER_FRAME, self.windSpeed, self)

	
	-- set a variable 'new'
	-- Then check in box2d to see if already colliding with ground
	-- If it is, then we kill it in box2d.lua
	-- This is to protect against spawning ON ground, which produces weird effects
	
	self.isNew = true
	Timer.delayedCall(10, self.notNew, self)
	
	
	
	
end




function WindObject:addTimers()
	
	-- set up the timers here that will continually apply up and down forces
	
	local t = Timer.new(100,math.huge)
	t:addEventListener(Event.TIMER, self.decreaseYVel, self)
	self.goUp = t
	
	local t = Timer.new(100,math.huge)
	t:addEventListener(Event.TIMER, self.increaseYVel, self)
	self.goDown = t

end


function WindObject:notNew()
	
	self.isNew = nil


end








function WindObject:windSpeed()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
	
		if(not(self.body.destroyed)) then
		
			local xVel,yVel = self.body:getLinearVelocity()
			self.body:setLinearVelocity(-self.mySpeed,yVel)

			-- set a maximum spin speed
			local r = self.body:getAngularVelocity()
			if(r<-3) then
				self.body:setAngularVelocity(-3)
			elseif(r>3) then
				self.body:setAngularVelocity(3)
			end
		
		end
	
	end
	
end




function WindObject:blowUp()

	-- pick new movement range
	self.maxYSpeed = math.random(3,6)
	self.yNum = math.random() + math.random(.4,.7) -- number it's increased by

	self.goUp:start()
	self.goDown:stop()

end


-- this function makes body go upwards

function WindObject:decreaseYVel()
	
	if(not(self.body.destroyed)) then
		self.xVel,self.yVel = self.body:getLinearVelocity()

		self.yVel = self.yVel - self.yNum
		self.body:setLinearVelocity(self.xVel, self.yVel)
		
		if(self.yVel< -self.maxYSpeed) then
			self:blowDown()
		end
	end

end




function WindObject:blowDown()

	self.goUp:stop()
	self.goDown:start()

end


-- this function makes body go downwards

function WindObject:increaseYVel()
	
	if(not(self.body.destroyed)) then
		self.xVel,self.yVel = self.body:getLinearVelocity()

		self.yVel = self.yVel + self.yNum
		self.body:setLinearVelocity(self.xVel, self.yVel)
		
		if(self.yVel > self.maxYSpeed) then
			self:blowUp()
		end
	end

end














function WindObject:killSelf()

	self:removeEventListener(Event.ENTER_FRAME, self.windSpeed, self)
	
	self.goUp:stop()
	self.goDown:stop()
	
	Timer.delayedCall(10, self.removeBody, self)
	Timer.delayedCall(20, self.removeSprite, self)

end





function WindObject:removeBody()

	if(not(self.body.destroyed)) then
		self.body.destroyed = true
		self.scene.world:destroyBody(self.body) -- remove physics body
	end

end





function WindObject:removeSprite()

	if(not(self.dead)) then
		self.dead = true
		self:getParent():removeChild(self)
		-- remove from sprites on screen (used for culling)

		for imgId,imgTable in pairs(self.scene.sprites) do
		
			if(imgTable==self) then
				table.remove(self.scene.sprites, imgId)
			end
		end
	
	
	end
	
		
end


