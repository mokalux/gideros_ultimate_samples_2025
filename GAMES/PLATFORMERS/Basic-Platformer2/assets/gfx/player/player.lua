Hero = Core.class(Sprite)

function Hero:init(scene,startX,startY)
	self.canMove = true -- used to stop moving when scrolling
	self.xSpeed = 0
	self.groundBraking = 0.2
	self.xSpeed = 5
	self.scene = scene

	local heroTemp = Bitmap.new(self.scene.atlas2:getTextureRegion("happy-block.png"))
	self:addChild(heroTemp)

	-- Add physics to him
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true, fixedRotation = true }
	body:setPosition(self:getX(), self:getY())
	body:setAngle(self:getRotation() * math.pi/180)
	local poly = b2.PolygonShape.new()
	poly:setAsBox((self:getWidth()/2)-5,(self:getHeight()/2)-5,self:getWidth()/2,self:getHeight()/2,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = 0, restitution = .3}
	--local filterData = {categoryBits = 2, maskBits = 1}
	--fixture:setFilterData(filterData)
	self.body = body
	body.name = "Hero"
	--self.body.name = "hero"
	--self.body.parent = self
	self.body:setPosition(startX-(self.scene.tilemap:getX()),startY-(self.scene.tilemap:getY()))
end
