DropSwitch = Core.class(Sprite)

function DropSwitch:init(scene,x,y,id,atlas)

	self.scene = scene
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("ds bg.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.rube1:addChild(img)
	img:setPosition(x,y-30)
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("ds head.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("ds frame.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.frontLayer:addChild(img)
	img:setPosition(x,y-30)
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("ds green.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.frontLayer:addChild(img)
	img:setPosition(x-4,y-36)
	self.green = img
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("ds red.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.frontLayer:addChild(img)
	img:setPosition(x-4,y-36)
	self.red = img
	img:setVisible(false)
	
	
	
	
	self.scene.rube1:addChild(self)
	self.id = id
	
	-- Add physics
	
	-- This body moves up and down

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	body:setPosition(x,y)
	self.body = body
	local poly = b2.PolygonShape.new()
	poly:setAsBox(40,40,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}
	local filterData = {categoryBits = 256, maskBits = 1}
	fixture:setFilterData(filterData)
	
	-- This fixture contacts with hero, triggering the function to stop balls spawning

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}

	body:setPosition(x,y)
	--self.body = body
	body.name = nil
	local poly = b2.PolygonShape.new()
	poly:setAsBox(36,20,0,4,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0,isSensor=true}
	local filterData = {categoryBits = 256, maskBits = 1}
	fixture:setFilterData(filterData)
	body.name = "drop switch trigger"
	body.parent = self
	
	Timer.delayedCall(10, self.addJoint, self)
	table.insert(self.scene.spritesOnScreen, self)
	
	-- sounds
	
	if(not(self.scene.switchSound)) then
		self.scene.switchSound = Sound.new("Sounds/switch.wav")
		
	end
end



function DropSwitch:addJoint()

	--create empty box2d body for joint
	
	local ground = self.scene.world:createBody({})

	local x,y = self:localToGlobal(0,0)

	local jointDef = b2.createPrismaticJointDef(self.body, ground,x,y,0, 1)
	self.revoluteJoint = self.scene.world:createJoint(jointDef)
	
	self.revoluteJoint:enableLimit(true)
	self.revoluteJoint:setLimits(0,20)

end



function DropSwitch:trigger()

	if(not(self.triggered)) then
	
		local channel1 = self.scene.switchSound:play()
		channel1:setVolume(.4*self.scene.soundVol)
	
		self.triggered = true
		self.scene.idList[self.id].stopped = true
		self.body:setGravityScale(0)
		Timer.delayedCall(150, self.redLight, self)
	
	end

end




function DropSwitch:redLight()

	self.green:setVisible(false)
	self.red:setVisible(true)

end









