Ball = Core.class(Sprite)

function Ball:init(scene,x,y,hurtHero,linearDamping,restitution,atlas,lifeSpan)

	self.atlas = atlas
	self.x = x
	self.y = y
	self.scene = scene
	self.linearDamping = linearDamping
	if(self.linearDamping==nil) then
		self.linearDamping = .2
	end
	self.restitution = restitution

	self.skullBodies = {}
	self.skullImages = {}
	self.fixtures = {}
	self.lifeSpan = lifeSpan
	
	--print(lifeSpan)
	
	if(not(lifeSpan) or lifeSpan < 1) then
		self.lifeSpan = 9
	end
	self.lifeSpan = self.lifeSpan * 1000

	self.scene.behindRube:addChild(self)

	-- Add physics -- hurt / ground body
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}

	self.theShape = b2.CircleShape.new(-27,23,40)

	local fixture = body:createFixture{shape = self.theShape, density = .4, friction = 3, restitution = self.restitution}
	local filterData = {categoryBits = 128, maskBits = 2+8+256+128}
	fixture:setFilterData(filterData)

	fixture.parent = self
	fixture.name = "skull"
	
	if(hurtHero==true) then
		body.name = "danger"
	end
	
	body.name2 = "ball"
	body.parent = self
	self.body = body
		
	table.insert(self.scene.spritesOnScreen, self)

	self.body:setPosition(x, y)
	
	-- Now lets set up particles

	if(not(self.scene.ballParticles)) then
		local particles = BallParticles.new(self.scene)
		self.scene.frontLayer:addChild(particles)
		self.scene.ballParticles = particles
	end
	

	body:setLinearDamping(self.linearDamping)

	-- Add timer to kill self after 5 seconds
	
	--print(self.lifeSpan)
	
	Timer.delayedCall(self.lifeSpan, self.killSelf, self)
	

	-- (img,imgX,imgY,fix1X,fix1Y,fix1R,fix2X,fix2Y,fix2R)

	self:addSkullPart("skull bit 1.png",0,0,-5,-5,8,3,7,6)
	self:addSkullPart("skull bit 2.png",-27,-2,-14,-5,10,5,-5,10)
	self:addSkullPart("skull bit 3.png",-48,17,-7,-15,7,2,5,17)
	self:addSkullPart("skull bit 4.png",-9,22,		-15,-10,5,   2,0,13)
	self:addSkullPart("skull bit 5.png",-7,51,		-7,0,12,    9,-10,5)
	self:addSkullPart("skull bit 6.png",-33,53,		-4,0,11,    11,13,6)

	-- sounds
	
	self.maxVolume = .3
	self.volume = 0

	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	if(not(self.scene.smashSound)) then
	
		self.scene.smashSound2 = Sound.new("Sounds/pot smash.wav")
		
	end

end





function Ball:addSkullPart(img,imgX,imgY,fix1X,fix1Y,fix1R,fix2X,fix2Y,fix2R)

	local img = Bitmap.new(self.scene.atlas[self.atlas]:getTextureRegion(img))
	self.scene.layer0:addChild(img)
	img:setAnchorPoint(.5,.5)
	table.insert(self.skullImages, img)
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	table.insert(self.scene.spritesOnScreen, img)
	body:setPosition(self.x+imgX, self.y+imgY)
	img.body = body
	body:setLinearDamping(3)
	
	table.insert(self.skullBodies, body)
	
	self.theShape = b2.CircleShape.new(fix1X,fix1Y,fix1R)
	local fixture = body:createFixture{shape = self.theShape, density = .1, friction = 1, restitution = .5}
	local filterData = {categoryBits = 128, maskBits = 0}
	fixture:setFilterData(filterData)
	table.insert(self.fixtures,fixture)
	
	self.theShape = b2.CircleShape.new(fix2X,fix2Y,fix2R)
	local fixture = body:createFixture{shape = self.theShape, density = .1, friction = 1, restitution = .5}
	local filterData = {categoryBits = 128, maskBits = 0}
	fixture:setFilterData(filterData)
	table.insert(self.fixtures,fixture)
	
	local jointDef = b2.createWeldJointDef(self.body, body, self.x+imgX,self.y+imgY,self.x+imgX,self.y+imgY)
	local weldJoint = self.scene.world:createJoint(jointDef)

end






-- This function tells skull parts to collide with ground and each other

function Ball:makeSkullPartsCollide()

	for i,v in pairs(self.fixtures) do
	
		local filterData = {categoryBits = 128, maskBits = 2+8+128}
		v:setFilterData(filterData)
		
	end
	
	-- And make each part's body something that can break other skulls
	
	for i,v in pairs(self.skullBodies) do
	
		v.name = "danger"
		v.name2 = "skull buster"
			
	end

end





-- This function tells skull parts to STOP colliding with hero

function Ball:stopSkullPartsColliding()

	for i,v in pairs(self.skullBodies) do
	
		v.name = "none"
		v.name2 = "none"
			
	end

end





function Ball:killSelf()

	if(not(self.dead)) then
	
		if(not(self.smashed)) then
	
			self.smashed = true
			self.channel1 = self.scene.smashSound2:play(0,1)
			self.channel1:setVolume(self.volume*self.scene.soundVol)
	
		end
	
		self:makeSkullPartsCollide()
	
		local x,y = self.body:getPosition()
		self.scene.ballParticles.emitter:setPosition(x,y)
		self.scene.ballParticles.emitter:start()
		
		Timer.delayedCall(1, self.removeMainBody, self)
		Timer.delayedCall(1, self.stopSkullPartsColliding, self)
		Timer.delayedCall(2000, self.fadeSkullImages, self)
		Timer.delayedCall(2000, self.removeSkullBodies, self)
		Timer.delayedCall(3100, self.removeFromVolume, self)
		Timer.delayedCall(3200, self.removeSprite, self)

		self.dead = true
	
	end

end



function Ball:removeMainBody()
	
	self.scene.world:destroyBody(self.body)
	self.body.destroyed = true

end


function Ball:removeSkullBodies()

	for i,v in pairs(self.skullBodies) do
	
		v.destroyed = true
		self.scene.world:destroyBody(v)
			
	end

end



function Ball:fadeSkullImages()

	for i,v in pairs(self.skullImages) do
	
		local tween = GTween.new(v, .5, {alpha = 0})
		v.name= "bust part"
			
	end
	
	Timer.delayedCall(500, self.removeSkullImages, self)

end



function Ball:removeSkullImages()

	for i,v in pairs(self.skullImages) do
	
		v:getParent():removeChild(v)
			
	end

end



function Ball:removeSprite()

	self:getParent():removeChild(self)

end




function Ball:removeFromVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do
		if(v==self) then
			table.remove(self.scene.spritesWithVolume, i)
		end
	end

end





