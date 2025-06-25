GiantSpinner = Core.class(Sprite);

function GiantSpinner:init(scene,x,y,rotationSpeed,atlas)

	self.scene = scene
	self.rotationSpeed = rotationSpeed
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("giant spinner.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	
	self:setPosition(x,y)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(30,206,0,0,0)
	local fixture = body:createFixture{shape = poly, density = .01, friction = 0, restitution = 0}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)

	self.body = body
	self.body.name = "enemy"
	self.scene.layer0:addChild(self)
	table.insert(self.scene.spritesOnScreen, self)
	
	--create empty box2d body for joint
	local ground = self.scene.world:createBody({})
	
	local x,y = self:localToGlobal(0,0)


	local jointDef = b2.createRevoluteJointDef(self.body, ground,x,y)
	self.revoluteJoint = self.scene.world:createJoint(jointDef)
	self.revoluteJoint:enableMotor(true)
	
	self.revoluteJoint:setMaxMotorTorque(5)
	self.revoluteJoint:setMotorSpeed(math.rad(self.rotationSpeed))

end

