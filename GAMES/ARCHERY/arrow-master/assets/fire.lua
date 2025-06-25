CLASS_fire = Core.class(Sprite)

function CLASS_fire:init(xp, yp, angle, xd, yd, world, physics)
	self.pack = TexturePack.new("gfx/frioArcher.txt", "gfx/frioArcher.png")
	self.fire =	Bitmap.new(self.pack:getTextureRegion("arrow.png"))
	
	self.body = world:createBody{type = b2.DYNAMIC_BODY}
	self.angle = angle
	if angle > 2.07 then
		self.body:setPosition(xp - 30, yp - 10)
	elseif angle < 2.07 and angle > 1.57 then
		self.body:setPosition(xp - 20, yp - 40)
	elseif angle < 1.07 then
		self.body:setPosition(xp + 30, yp - 10)
	elseif angle > 1.07 and angle < 1.57 then
		self.body:setPosition(xp + 20, yp - 40)
	else
		self.body:setPosition(xp + 5, yp - 50)
	end
	-- allow to callback on collision
	self.body.parent = self
	item = "arrow"
	self.body.name = item
	physics:addFixture(self.body, item)	
	
	self.fire:setAnchorPoint(physics:getAnchorPoint(item))	
	self.fire:setPosition(self.body:getPosition())
	self:addChild(self.fire)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self.move = true
	self.isDestroyed = false
	
	self.body:setLinearVelocity((-1)*(xp - xd)/12, (-1)*(yp - yd)/12)
end

function CLASS_fire:onEnterFrame(Event)
	
	if self.isDestroyed == false then
		local xPos, yPos = self.body:getPosition()
		
		if self.move == true then

			if xPos > application:getLogicalHeight() then	
				xPos = 0
			elseif xPos < 0 then 
				xPos = application:getLogicalHeight()
			end
			if yPos > application:getLogicalWidth() then	
				yPos = 0
			elseif yPos < 0 then 
				yPos = application:getLogicalWidth()
			end
			
			
			if self.angle > 1.58 then --look left
				if self.angle < 4.70 then
					self.angle = self.angle + 0.02
					self.fire:setRotation((-1)*math.deg(self.angle))
				end
			else			
				--look right
				if self.angle < 1.56 then
					self.angle = self.angle - 0.02
					self.fire:setRotation((-1)*math.deg(self.angle))
				end 
			end
		else
			--destroy object
		end

		self.body:setPosition(xPos, yPos)
		self.fire:setPosition(xPos, yPos)
	end
end

function CLASS_fire:collision(with)
	if with == "sfondo3" then
		self.move = false
		self.fire:setTextureRegion(self.pack:getTextureRegion("arrow_dive.png"))
		Timer.delayedCall(1000, function() 
			self.fire:setTextureRegion(self.pack:getTextureRegion("nothing.png"))
		end)
	elseif with == "FrioArcher" then
		self.move = false
		self.fire:setTextureRegion(self.pack:getTextureRegion("nothing.png"))
	end
end
