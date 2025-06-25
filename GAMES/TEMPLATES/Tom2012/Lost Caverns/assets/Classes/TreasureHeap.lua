TreasureHeap = Core.class(Sprite)

function TreasureHeap:init(scene,x,y,atlas)

	self.scene = scene
	self.value = 250
	self.canCollect = true
	

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("treasure heap.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.img = img
	self.scene.rube1:addChild(self)
	
	-- Add physics

	self.body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}

	self.body:setPosition(x,y)
	 
	local poly = b2.PolygonShape.new()
	poly:setAsBox(45,20,0,12,0)
	local fixture = self.body:createFixture{shape = poly, density = 1, friction = 1, restitution = 0, isSensor=true}
	 
	fixture.name = "coin"
	fixture.parent = self

	local filterData = {categoryBits = 4096, maskBits = 2+8+512+4096}
	fixture:setFilterData(filterData)
	
	local particles = LootParticles.new(self.scene)
	self:addChild(particles)
	self.lootParticles = particles
	
		-- sounds
	
	if(not(self.scene.treasureSound)) then
		self.scene.treasureSound = Sound.new("Sounds/collect treasure.wav")
		
	end

end







function TreasureHeap:collect()

	local channel1 = self.scene.treasureSound:play()
	channel1:setVolume(.4*self.scene.soundVol)
	
	self.lootParticles.emitter:start()
	self.img:setVisible(false)

	Timer.delayedCall(1, self.removeBody, self)
	Timer.delayedCall(1500, self.removeAll, self)

	-- show loot number
	
	self.scene.loot = self.scene.loot + self.value
	self.scene.interface:updateLoot()

end



function TreasureHeap:removeBody()

	self.body.destroyed = true
	self.scene.world:destroyBody(self.body) -- remove physics body

end




function TreasureHeap:removeAll()

	self:getParent():removeChild(self)
end
