Coin = Core.class(Sprite)

function Coin:init(scene,x,y,hasGravity,layer)

	self.canBeCollected = false -- for when they come out of the pot
	Timer.delayedCall(1000, function() self.canBeCollected = true end)

	self.scene = scene

	self.value = self.scene.coinValue
	
	-- Create coin animation
	
	self.img1 = Bitmap.new(self.scene.atlas[2]:getTextureRegion("coin 1.png"))
	self.img2 = Bitmap.new(self.scene.atlas[2]:getTextureRegion("coin 2.png"))
	self.img3 = Bitmap.new(self.scene.atlas[2]:getTextureRegion("coin 3.png"))

	local mc = MovieClip.new{
		{1, 10, self.img1},
		{11, 20, self.img2},
		{21, 30, self.img3},
		{31, 40, self.img2}
	}

	mc:setGotoAction(40,1)
	mc:play()
	self.mc = mc

	self:addChild(mc)
	mc:setPosition(-13,-12)
	
	table.insert(self.scene.sprites, self)
	table.insert(self.scene.pauseResumeExitSprites, self)

	-- Add physics

	Timer.delayedCall(1, function()

		if(hasGravity) then
		
			self.body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
		else
			self.body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
			self.body:setGravityScale(0)
			

		end
		
		self.body:setPosition(x,y)

		local circle = b2.CircleShape.new(0,0,12)
		local fixture = self.body:createFixture{shape = circle, density = .1, friction = .1, restitution = .3}
		
		fixture.name = "coin"
		fixture.parent = self
		self.fixture = fixture

		local filterData = {categoryBits = 4096, maskBits = 2+8+512+4096}
		fixture:setFilterData(filterData)

		if(hasGravity) then
			table.insert(self.scene.spritesOnScreen, self)
		end

	end)

		
	Timer.delayedCall(500, function() self.canCollect = true end)
	
	self.scene.rube1:addChild(self)
	
end



function Coin:collect()

	playSound("Sounds/coin 1.wav",.2*self.scene.soundVol)

	self.mc:setStopAction(1)
	self.mc:stop()
	self.mc:gotoAndStop(1)
	
	Timer.delayedCall(5, self.destroyBody, self)
	Timer.delayedCall(10, self.flyUp, self)
	Timer.delayedCall(200, self.fade, self)
	Timer.delayedCall(1300, self.removeSprite, self)

	self.scene.loot = self.scene.loot + 10
	self.scene.interface:updateLoot()

end






function Coin:removeSprite()
	
	if(not(self.destroyed)) then
		self.destroyed = true
		self:getParent():removeChild(self)
	end

end





function Coin:destroyBody()

	if(not(self.body.destroyed)) then
		self.body.destroyed = true
		self.body:destroyFixture(self.fixture)
		self.scene.world:destroyBody(self.body)
	end

end




function Coin:flyUp()

	self:setRotation(0)
	local tween = GTween.new(self.mc, .15, {y = -70},{repeatCount = 2, reflect = true, ease = easing.outQuadratic})
	--self.coin:setVisible(true)

end



function Coin:fade()

	local tween = GTween.new(self.mc, .17, {scaleX=0, scaleY=0,alpha=0})

end






function Coin:pause()

	self.mc:stop()
	
end



function Coin:resume()

	if(not(self.scene.gameEnded)) then
		self.mc:play()
	end

end




function Coin:exit()

	self.mc:stop()
	self:destroyBody()

end

