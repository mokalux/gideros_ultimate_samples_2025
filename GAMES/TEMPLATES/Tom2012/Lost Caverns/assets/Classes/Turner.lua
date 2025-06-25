Turner = Core.class(Sprite);

function Turner:init(scene,x,y)

	self.scene = scene

	self.img = Bitmap.new(self.scene.atlas[12]:getTextureRegion("turner.png"))
	self.img:setAnchorPoint(.5,.5)
	self:addChild(self.img)
	self.img:setPosition(-8,36)

	self.scene.behindRube:addChild(self)
	
	-- Add physics

	-- Body


	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	body:setPosition(x+5,y-20)

	local coords = {}

	local vertices = {10.39,52.02,-18.29,52.06,-62.55,41.53,-37.51,33.49,22.84,35.35,51.73,41.28}
	table.insert(coords,vertices)
	local vertices = {-62.55,41.53,-68.22,-20.73,-59.17,-21.41,-37.51,33.49}
	table.insert(coords,vertices)
	local vertices = {22.84,35.35,40.72,-19.3,49.16,-19.75,51.73,41.28}
	table.insert(coords,vertices)
	local vertices = {1.6,97.83,-10.43,98.31,-18.29,52.06,10.39,52.02}
	table.insert(coords,vertices)

	
	for i,v in pairs(coords) do
		
		local poly = b2.PolygonShape.new()
		poly:set(unpack(v))
		local fixture = body:createFixture{shape = poly, density = .1, friction = .2, restitution = 0}
		fixture.parent = self
		fixture.name = "turner"
		local filterData = {categoryBits = 2, maskBits = 1+4+8+128}
		fixture:setFilterData(filterData)
		
	end
	
	self.action = "none"
	
	table.insert(self.scene.spritesOnScreen, self)
	
	self.body = body
	body.name = "Ground"
	
	
	--create empty box2d body for joint
	local ground = self.scene.world:createBody({})
	
	--local x,y = self:localToGlobal(0,0)

	self.jointDef = b2.createRevoluteJointDef(self.body, ground,x,y)
	
	self.revoluteJoint = self.scene.world:createJoint(self.jointDef)
	--self.revoluteJoint:enableLimit(true)
	
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,16,0,70,0)
	local fixture = body:createFixture{shape = poly, density = 5, friction = .2, restitution = 0}

	
self.body:setAngularDamping(1.5)



end



function Turner:startTurn()

	
	--print("turn")
end




function Turner:stopTurn()

--	self.body:setAngularDamping(99)
	--print("stop")
end



function Turner:doTurn()

	if(self.scene.hero:getX() > self:getX()) then
		self.turnSpeed = .01
	else
		self.turnSpeed = -.01
	end

	self.body:setAngle(self.body:getAngle()+ self.turnSpeed)

end
