Crystal = Core.class(Sprite)

function Crystal:init(scene,type,x,y)

	self.scene = scene
	self.hp = 3
	
	-- Add to crystals table
	
	table.insert(self.scene.crystals, self)

	if(type=="purple") then

		self.frame1 = "purple1.png"
		self.frame2 = "purple2.png"
		self.frame3 = "purple3.png"
		
		self.type = "purple crystal"
		self.value = 20

	else

		self.frame1 = "red1.png"
		self.frame2 = "red2.png"
		self.frame3 = "red3.png"
		self.value = 30
		self.type = "red crystal"

	end

	-- add frame 1

	local crystal = Bitmap.new(self.scene.atlas[2]:getTextureRegion(self.frame1));
	crystal:setAnchorPoint(.5,.5)
	self:addChild(crystal)
	self.crystal = crystal
	self.scene.rube1:addChild(self)
	
	-- Add physics

	Timer.delayedCall(1, function()
		local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
		body:setPosition(x,y)
		
		local circle = b2.CircleShape.new(0,0,12)
		local fixture = body:createFixture{shape = circle, density = 1, friction = .1, restitution = .1, isSensor = true}
		
		fixture.name = "crystal"
		fixture.parent = self
		
		self.body = body
		body:setGravityScale(0)

		local filterData = {categoryBits = 4096, maskBits = 8912}
		fixture:setFilterData(filterData)

	end)

end




function Crystal:harvest()

	self.hp = self.hp - 1

	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300)
	
	if(self.hp==0) then -- no more, remove
	
		self:removeChild(self.crystal)
		table.remove(self.scene.crystals, i)
		
		self.body.destroyed = true
		Timer.delayedCall(10, function()
			self.scene.world:destroyBody(self.body) -- remove physics body
		end)
		
		
	elseif(self.hp==2) then

		self:removeChild(self.crystal)

		local crystal = Bitmap.new(self.scene.atlas[2]:getTextureRegion(self.frame2));
		crystal:setAnchorPoint(.5,.5)
		self:addChild(crystal)
		self.crystal = crystal

	elseif(self.hp==1) then

		self:removeChild(self.crystal)

		local crystal = Bitmap.new(self.scene.atlas[2]:getTextureRegion(self.frame3));
		crystal:setAnchorPoint(.5,.5)
		self:addChild(crystal)
		self.crystal = crystal

	else

		self:removeChild(self.crystal)

	end


end



