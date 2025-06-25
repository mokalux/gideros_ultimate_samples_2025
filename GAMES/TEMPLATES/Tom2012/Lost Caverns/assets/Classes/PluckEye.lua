PluckEye = Core.class(Sprite)

function PluckEye:init(scene,x,y,id,atlas)

	self.scene = scene
	self.id = id
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("pluck eye.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.canDrag = true
	self.eyeSpeed = .2
	self.scene.frontLayer:addChild(self)
	self.eye = img
	
	Timer.delayedCall(100, function()
	--self:blowUpEye()
	end)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	
	self.theShape = b2.CircleShape.new(0,0,30)

	local fixture = body:createFixture{shape = self.theShape, density = .3, friction = 3, restitution = .3}
	local filterData = {categoryBits = 4096, maskBits = 2+512+8912}
	fixture:setFilterData(filterData)
	fixture.name = "eye"
	fixture.parent = self

	body.parent = self
	self.body = body
	
	--self.body:setLinearDamping(.1)
		
	table.insert(self.scene.spritesOnScreen, self)

	self.body:setPosition(x,y)
	table.insert(self.scene.pluckableEyes, self) -- so will be included in collisions
	
	-- set up sounds
	
	if(not(self.scene.popSound)) then
	
		self.scene.popSound = Sound.new("Sounds/pop.wav")

	end

end


function PluckEye:attachToClaw()

	local clawX, clawY = self.scene.claw:localToGlobal(0,0)
	local x,y = self:localToGlobal(0,0)
	local clawOffset = x - clawX

	self.body:setLinearDamping(0)
	self.scene.claw:stopAndReturnClaw(0)
	self.scene.claw.dragBlock = self
	self.scene.claw.clawOffset = clawOffset
	
	-- pause stuff
	
	self.scene.signShowing = true -- stops pause menu showing
	self.scene.pause:doPause()

	self.scene.eyeMiniGame:startMiniGame(self)
	
end


function PluckEye:pluckOutEye()

	self.channel1 = self.scene.popSound:play(1)
	self.channel1:setVolume(.7*self.scene.soundVol)
	self.body:setLinearVelocity(-8,-3)
	Timer.delayedCall(3000, self.fadeEye, self)
	Timer.delayedCall(4000, self.blowUpEye, self)
	Timer.delayedCall(1000, self.openDoor, self)
	
	
end



function PluckEye:fadeEye()

	if(not(self.dead)) then
	
		local tween = GTween.new(self.eye, 1, {scaleX = 0, scaleY = 0, alpha=0},{ease = easing.outQuadratic})

	end

end



function PluckEye:blowUpEye()

	if(not(self.dead)) then
	
		self.dead = true
		self.body.destroyed = true
		self.scene.signShowing = false

		Timer.delayedCall(100, function()
			self:getParent():removeChild(self)
			self.scene.world:destroyBody(self.body) -- remove physics body
		end)
		
	end

end



function PluckEye:openDoor()

	self.scene.tongueDoors[self.id]:openDoor()

end



