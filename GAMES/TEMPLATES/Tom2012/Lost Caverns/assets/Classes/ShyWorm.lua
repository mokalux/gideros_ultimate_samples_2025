ShyWorm = Core.class(Sprite)

function ShyWorm:init(scene,x,y,id,atlas)

	self.scene = scene
	self.id = id
	self.value = 40

	self.scene.shyWorms[self.id] = self -- record to table
	
	local sprite = Sprite.new()
	self:addChild(sprite)
	self.worm = sprite

	-- worm body
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("shy worm.png"));
	img:setAnchorPoint(.5,1)
	self.worm:addChild(img)

	-- worm eye
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("shy eye.png"));
	img:setAnchorPoint(.5,.5)
	self.worm:addChild(img)
	self.eye = img
	img:setY(-115)
	img:setScaleY(0)

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("shy hole.png"))
	img:setY(34)
	img:setAnchorPoint(.5,.5)
	self.scene.rube1:addChild(img)
	img:setPosition(x,y+43)
	
	self.worm:setY(190)
	
	self.scene.layer0:addChild(self)
	
	

	-- add pupil
	
	local sprite = Sprite.new()
	self.worm:addChild(sprite)
	self.pupilSprite = sprite
	sprite:setY(-188)
	
	self.startRotation = self:getRotation()+18
	sprite:setRotation(self.startRotation)
	
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("shy worm pupil.png"));
	img:setAnchorPoint(.5,.5)
	self.pupilSprite:addChild(img)
	self.pupil = img
	img:setY(75)
	img:setScaleY(0)

--	Timer.delayedCall(10, self.hideLoot, self)
	
	-- set up tweens
	
	self.tweens = {}
	
	self.leftTween1 = GTween.new(self.pupilSprite, 2, {rotation = -15},{ease = easing.inOutQuadratic})
	self.leftTween2 = GTween.new(self.pupilSprite, 1.5, {rotation = -15},{delay=1,ease = easing.inOutQuadratic,autoPlay=false})
	self.rightTween = GTween.new(self.pupilSprite, 2, {rotation = 15},{delay=1,ease = easing.inOutQuadratic,autoPlay=false})

	self.leftTween1.nextTween = self.rightTween
	self.rightTween.nextTween = self.leftTween2
	self.leftTween2.nextTween = self.rightTween
	
	table.insert(self.tweens, self.leftTween1)
	table.insert(self.tweens, self.leftTween2)
	table.insert(self.tweens, self.rightTween)
	
	-- add physics
	
	local body = self.scene.world:createBody{type = b2.STATIC_BODY, allowSleep = true}

	local circle = b2.CircleShape.new(0,-50,20)
	local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
	
	body:setPosition(x,y)
	self.body = body
	fixture.name = "loot"
	self.fixture = fixture
	fixture.parent = self

	local filterData = {categoryBits = 4096, maskBits = 8912}
	fixture:setFilterData(filterData)
	self.body:setActive(false)

	-- set up sounds
	
	if(not(self.scene.popSound)) then
	
		self.scene.popSound = Sound.new("Sounds/pop.wav")

	end

	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end









function ShyWorm:closeEye()

	local tween = GTween.new(self.eye, .1, {scaleY = 0},{ease = easing.inOutQuadratic})
	local tween = GTween.new(self.pupil, .1, {scaleY = 0},{ease = easing.inOutQuadratic})
	
end





function ShyWorm:hideLoot()

	if(not(self.scene.shyWormBushes[self.id].wormDead)) then
		self.body:setActive(false)
	end

end





function ShyWorm:showLoot()
	
	self.pupil:setRotation(self.startRotation)
	local tween1 = GTween.new(self.eye, .2, {scaleY=1},{ease = easing.inQuadratic})
	local tween2 = GTween.new(self.pupil, .2, {scaleY=1},{ease = easing.inQuadratic})
	
	if(not(self.scene.shyWormBushes[self.id].wormDead)) then
		self.body:setActive(true)
	end


end






function ShyWorm:collected()

	self.channel1 = self.scene.popSound:play(1)
	self.channel1:setVolume(.7*self.scene.soundVol)

	self.scene.claw.type = "shy eye"
	
	self.eye:setVisible(false)
	self.pupil:setVisible(false)
	
	self.scene.shyWormBushes[self.id].wormDead = true
	
	Timer.delayedCall(10, self.removeBody, self)
	Timer.delayedCall(1000, self.removeSprite, self)
	Timer.delayedCall(100, self.wormDown, self)
	self.scene.loot = self.scene.loot + self.value
	self.scene.interface:updateLoot()
	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300)


end



function ShyWorm:wormDown()

	self.scene.shyWormBushes[self.id]:wormDown()

end



function ShyWorm:removeBody()

	self.scene.world:destroyBody(self.body) -- remove physics body

end

function ShyWorm:removeSprite()

	self:getParent():removeChild(self)

end




function ShyWorm:pause()

end




function ShyWorm:resume()

end


-- cleanup function

function ShyWorm:exit()
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
end
