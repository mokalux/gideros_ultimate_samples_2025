Bullet = Core.class(Sprite)

function Bullet:init(scene,x,y,angle,goThroughStuff,imageType,atlas)

	if(not(atlas)) then
		atlas = 2
	end

	self.scene = scene
	self.speed = 2
	self.angle = angle
	self.imageType = imageType

	-- if a custom image has been set
	
	
	
	if(imageType=="exploding fruit") then
	
		local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("exploding fruit bullet.png"))
		img:setAnchorPoint(.5,.5)
		self:addChild(img)
		self.bulletImage = img
		self.goThroughStuff = true
	else
	
		local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("turret bullet.png"))
		img:setAnchorPoint(.4,1)
		self:addChild(img)
		self:setRotation(angle)
		self.bulletImage = img
		self.imageType = "normal"
		
	end
	

	
	self:setPosition(x,y)
	

	self.scene.rube2:addChild(self)

	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY}

	body:setPosition(x,y)
	
	if(imageType~="exploding fruit") then
		body:setAngle(math.rad(self.angle))
	end

	local poly = b2.PolygonShape.new()
	poly:setAsBox(7,7,0,-20,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0, isSensor = true}
	
	fixture.parent = self
	fixture.name = "enemy"
	body.name = "bullet"
	self.body = body
	body.parent = self
	
	if(self.goThroughStuff) then
		self.filterData = {categoryBits = 128, maskBits = 8}
	else
		self.filterData = {categoryBits = 128, maskBits = 2+8}
		
	end
	
	
	body:setGravityScale(0)
	
	local x,y = self.body:getPosition()
	local angle = math.rad(angle-90)
	
	local vectorX = math.cos(angle) * 6
	local vectorY = math.sin(angle) * 6
	
	body:applyLinearImpulse(vectorX,vectorY, x,y)
	
	if(imageType=="exploding fruit") then
		
		body:setAngularVelocity(math.random(5,30))
	
	end
	
	fixture:setFilterData(self.filterData)
	
	Timer.delayedCall(2200, self.killSelf, self)
	
	table.insert(self.scene.spritesOnScreen, self)
	
	self.age = 0
	
	-- Create splat animation

	local animation = {}
	local frame
	local timing = 3

	for i = 1, 7 do
		frame = Bitmap.new(self.scene.atlas[2]:getTextureRegion("bullet splat 000"..i..".png"))
		frame:setAnchorPoint(.5,.5)
		animation[#animation+1] = {(i-1)*timing, i*timing, frame}
	end

	local mc = MovieClip.new(animation)


	mc:setStopAction(100)
	mc:setRotation(90)
	mc:setPosition(5,-35)
	mc:stop()

	self.splatAnim = mc
	self:addChild(mc)
	mc:setVisible(false)
	
	if(self.imageType=="exploding fruit") then
	
		self.maxAge = 100
		self.body:setAngle(self.body:getAngle()-.1)
		
	else
	
		self.maxAge = 500
		
	end


	-- sounds
	
	self.maxVolume = .05
	self.volume = 0
		
	if(not(self.scene.splatSound)) then
	
		self.scene.splatSound = Sound.new("Sounds/splat.wav")
		
	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)


end





function Bullet:killSelf()

	if(self.imageType ~= "exploding fruit") then
		self.channel1 = self.scene.splatSound:play()
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	end


	Timer.delayedCall(10, self.removeBody, self)
	Timer.delayedCall(2000, self.removeFromVolume, self)
	Timer.delayedCall(3000, self.removeSprite, self)
	
	if(self.imageType == "normal") then
	
		-- Show splat anim
	
		self.bulletImage:setVisible(false)
		self.splatAnim:gotoAndPlay(1)
		self.splatAnim:setVisible(true)

	else
	
		-- shrink out 
		local tween = GTween.new(self.bulletImage, 1, {scaleX=0, scaleY=0})
		
	end
	
end




function Bullet:removeBody()

	if(not(self.body.destroyed)) then
		self.body.destroyed = true
	
		self.scene.world:destroyBody(self.body) -- remove physics body

	end


end



function Bullet:removeSprite()

	if(not(self.spriteRemoved)) then
		
		self.spriteRemoved = true
		self:getParent():removeChild(self)
		
	end

end






function Bullet:removeFromVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do
		if(v==self) then
			table.remove(self.scene.spritesWithVolume, i)
		end
	end

end


