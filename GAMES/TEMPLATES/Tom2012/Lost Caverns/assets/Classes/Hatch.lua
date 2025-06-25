Hatch = Core.class(Sprite);

function Hatch:init(scene,x,y,flip)

	self.scene = scene
	self.flip = flip

	self.img = Bitmap.new(self.scene.atlas[12]:getTextureRegion("hatch.png"))
	self.img:setAnchorPoint(.5,.5)
	self:addChild(self.img)
	
	if(self.flip) then
	
		self.img:setScaleX(1)
		self.img:setX(-3)
		self.img:setY(17)
		self:setPosition(x,y)
		
	else
	
		self:setPosition(x,y)
	
	end

	self.scene.rube1:addChild(self)

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	
	self.poly = b2.PolygonShape.new()
	
	if(self.flip) then
		self.poly:setAsBox(35,60,-8,0,0)
	else
		self.poly:setAsBox(37,5,-4,0,0)
	end
	
	
	local fixture = body:createFixture{shape = self.poly, density = 5, friction = 0, restitution = 0}
	local filterData = {categoryBits = 2, maskBits = 1}
	fixture:setFilterData(filterData)

	body.parent = self
	body.name = "Ground"
	body.name2 = "hatch"
	
	self.body = body

	table.insert(self.scene.spritesOnScreen, self)
	
	--create empty box2d body for joint
	local ground = self.scene.world:createBody({})
	
	local x,y = self:localToGlobal(0,0)

	if(self.flip) then
		self.jointDef = b2.createRevoluteJointDef(self.body, ground,x-50,y)
	else
		self.jointDef = b2.createRevoluteJointDef(self.body, ground,x-50,y)
	end
	
	self.revoluteJoint = self.scene.world:createJoint(self.jointDef)
	self.revoluteJoint:enableLimit(true)
	
	if(self.flip) then
		--self.revoluteJoint:setLimits(math.rad(0), math.rad(80))
	else
		self.revoluteJoint:setLimits(math.rad(0), math.rad(90))
	end
	
	-- sounds
	
	self.volume = .3
		
	if(not(self.scene.hatchSound)) then
	
		self.scene.hatchSound = Sound.new("Sounds/hatch slam.wav")
		
	end
	
	self:addEventListener(Event.ENTER_FRAME, self.checkAngle, self)
	self.scene:addEventListener("onExit", self.onExit, self)

end




function Hatch:touchHatch()
	
	if(not(self.touching)) then

		self.touching = true

	end

end




function Hatch:checkAngle()
	
	-- opens past certain angle, listen for close
	
	local angle = math.deg(self.body:getAngle())
	
	if(angle < 0) then
		self.open = true
	end
	
	
	
	if(angle >= 0 and self.open) then
		self.open = false
		self.shut = true
		local channel1 = self.scene.hatchSound:play()
		channel1:setVolume(self.volume*self.scene.soundVol)
	end
	
	

	

	

end



-- cleanup function

function Hatch:onExit()
	
	self:removeEventListener(Event.ENTER_FRAME, self.checkAngle, self)
	self.scene:removeEventListener("onExit", self.onExit, self)

end



