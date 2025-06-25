CatFlap = Core.class(Sprite);

function CatFlap:init(scene,x,y,flip,atlas)

	self.scene = scene
	self.flip = flip

	self.img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("catflap door.png"))
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

	self.scene.rube2:addChild(self)

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	
	self.poly = b2.PolygonShape.new()
	
	if(self.flip) then
		self.poly:setAsBox(35,60,-8,0,0)
	else
		self.poly:setAsBox(35,60,10,0,0)
	end
	
	
	local fixture = body:createFixture{shape = self.poly, density = 1, friction = 0, restitution = 0}
	local filterData = {categoryBits = 2, maskBits = 1}
	fixture:setFilterData(filterData)

	self.body = body
--	self.body.name = "enemy"

	table.insert(self.scene.spritesOnScreen, self)
	
	--create empty box2d body for joint
	local ground = self.scene.world:createBody({})
	
	local x,y = self:localToGlobal(0,0)

	if(self.flip) then
		self.jointDef = b2.createRevoluteJointDef(self.body, ground,x-10,y-28)
	else
		self.jointDef = b2.createRevoluteJointDef(self.body, ground,x+10,y-48)
	end
	
	self.revoluteJoint = self.scene.world:createJoint(self.jointDef)
	self.revoluteJoint:enableLimit(true)
	
	if(self.flip) then
		self.revoluteJoint:setLimits(math.rad(0), math.rad(80))
	else
		self.revoluteJoint:setLimits(math.rad(-80), math.rad(0))
	end

	--self:addEventListener(Event.ENTER_FRAME, self.showAngle, self)

end

function CatFlap:showAngle() 

	print(math.deg(self.body:getAngle()))

end



