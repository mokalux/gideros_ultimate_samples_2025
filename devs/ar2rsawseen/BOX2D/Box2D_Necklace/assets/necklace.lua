require "box2d"

Necklace = gideros.class(Sprite)
local radius = 4
function Necklace:init()

	self.world = b2.World.new(0, 9.8, true)
	
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()

	self:CreateNecklace(0,100,380)
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	--self:addChild(debugDraw)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Necklace:onEnterFrame() 
	self.world:step(1/40, 12, 10)
	for i = 1, self:getNumChildren() do
		local sprite = self:getChildAt(i)
		if sprite.body then
			local body = sprite.body
			local bodyX, bodyY = body:getPosition()
			sprite:setPosition(bodyX, bodyY)
			sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end
end

function Necklace:CreateNecklace(x, y, width)
	
	local shape = b2.PolygonShape.new()
	shape:setAsBox(radius, radius)
	local fixtureDef = {shape = shape, density = 600, friction = 0.1, restitution = 0.01}
	
	local ground = self.world:createBody({})
	
	local prevBody = ground
	local distanceJoint
	
	local amount = math.floor((width-x)/radius)

	if amount % 2 ~= 0 then
		amount = amount + 1
	end
	print(amount)
	for i=0,amount do
		
		if i == amount/2  then
			body = self:CreateCardHolder(prevBody,i,x,y)
			
			self:CreateCard(body,i,x,y)
			
			prevBody = body
			
		else	
			local bodyType = b2.DYNAMIC_BODY
			if i == amount or i == 0 then
				bodyType = b2.STATIC_BODY
			end
			
			prevBody = self:CreateChain(prevBody,i,x,y,shape,fixtureDef,bodyType)
			
		end
		
	end
	
	return prevBody
end

function Necklace:CreateCardHolder(lastBody,index,baseX,baseY)
	

	local hook = b2.PolygonShape.new()
	hook:setAsBox(radius, radius)
	local fixtureDef = {shape = hook,density = 550, friction = 0.01, restitution = 0.01}
	
	local newX = baseX + ((radius+(radius/2)-1)*index)+radius
	local newY = baseY 
	local bodyDef = {type = b2.DYNAMIC_BODY, position = {x = newX, y = newY}, allowSleep = true}
	local body = self.world:createBody(bodyDef)
	body:createFixture(fixtureDef)
	

	local jointDef = b2.createRevoluteJointDef(lastBody, body, newX, newY)
	local revoluteJoint = self.world:createJoint(jointDef)
	
	return body
end

function Necklace:CreateCard(cardHolderBody,index,baseX,baseY)
	
	local cardPoly = b2.PolygonShape.new()
	cardPoly:setAsBox(170, 75)
	
	local fixtureDef = {shape = cardPoly, density =1, friction = 0.01, restitution = 0.001}
	
	local newX = baseX + ((radius+(radius/2)-1)*index)
	local newY = baseY +10
	
	local bodyDef = {type = b2.DYNAMIC_BODY, position = {x = newX, y = newY}, allowSleep = true}
	local cardBody = self.world:createBody(bodyDef)
	cardBody:createFixture(fixtureDef)
	
	
	local bitmap = Bitmap.new(Texture.new("profile-card.jpg"))
	bitmap:setAnchorPoint(0.5, 0.5)
	bitmap:setScale(340/bitmap:getWidth())
	bitmap:setPosition(cardBody:getPosition())
	self:addChild(bitmap)
	bitmap.body = cardBody
	
	
	local jointDef = b2.createDistanceJointDef(cardBody,body, newX, newY, newX, newY-10)
	local distanceJoint = self.world:createJoint(jointDef)
	
end

function Necklace:CreateChain(prevChain,index,baseX,baseY,shape,fixtureDef,bodyType)
	
	
	local newX = baseX + ((radius+(radius/2)-1)*index)
	local newY = baseY 
	
	local bodyDef = {type = bodyType, position = {x = newX, y = newY}, allowSleep = true}
	
	local ropeBody = self.world:createBody(bodyDef)
	ropeBody:createFixture(fixtureDef)
	
	local ropeBitmap = Bitmap.new(Texture.new("rope.jpg"))
	ropeBitmap:setAnchorPoint(0.5, 0.5)
	ropeBitmap:setScale(((radius+1)*2)/ropeBitmap:getWidth())
	ropeBitmap:setPosition(ropeBody:getPosition())
	self:addChildAt(ropeBitmap,1)
	
	ropeBitmap.body = ropeBody
	
	local jointDef = b2.createRevoluteJointDef(prevChain, ropeBody, newX, newY)
	local revoluteJoint = self.world:createJoint(jointDef)
	
	return ropeBody
	
end

