ShyWormBush = Core.class(Sprite)

function ShyWormBush:init(scene,x,y,id,atlas)

	self.scene = scene
	self.id = id
	self.tweens = {}

	self.scene.shyWormBushes[self.id] = self -- record to table
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("shy bush.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)

	
	self.scene.frontLayer:addChild(self)

	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(17,17,0,0,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0, isSensor=true}
	fixture.name = "shy bush"
	fixture.parent = self
	self.body = body

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)

	self.counter = 0
	
	if(not(self.scene.wormUpSound)) then
	
		self.scene.wormUpSound = Sound.new("Sounds/worm up.wav")
		self.scene.wormDownSound = Sound.new("Sounds/worm down.wav")
		
	end
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end



function ShyWormBush:enterBush()

	if(not(self.wormDead)) then
	
		if(not(self.wormStartY)) then
			self.wormStartY = self.scene.shyWorms[self.id].worm:getY()
		end

		self:bob()
		
		self.timer = Timer.new(100,25)
		self.timer:addEventListener(Event.TIMER, self.onTimer, self)
		self.timer:start()
	
	end
	
end



function ShyWormBush:bob()
	
	if(not(self.scene.inBush)) then
		self.scene.inBush = true
		
		self.bobTween = GTween.new(self.scene.shyWorms[self.id].worm, .2,{y = self.wormStartY-35},{repeatCount=2,ease = easing.outQuadratic,reflect = true})
		table.insert(self.tweens, self.bobTween)
	end
	
end



function ShyWormBush:onTimer()

	self.counter = self.counter+1
	
	if(self.counter==10) then
		
		self:wormUp()
		
	end
	
	
	
	if(self.counter==15) then
		
		self.scene.shyWorms[self.id]:showLoot()
		
	end

end




function ShyWormBush:wormUp()
	
	if(not(self.wormDead)) then
		if(self.scene.inBush) then
		
			self.channel2 = self.scene.wormUpSound:play(1)
			self.channel2:setVolume(.5*self.scene.soundVol)
			
			self.wormIsUp = true
			self.upTween = GTween.new(self.scene.shyWorms[self.id].worm, .2,{y = self.wormStartY-130},{repeatCount=1,ease = easing.outQuadratic,reflect = true})
			self.upTween = GTween.new(self.scene.shyWorms[self.id].worm, .2,{scaleY = 1.2},{repeatCount=2,ease = easing.outQuadratic,reflect = true})
			self.upTween = GTween.new(self.scene.shyWorms[self.id].worm, .2,{scaleX = .6},{repeatCount=2,ease = easing.outQuadratic,reflect = true})
		end
	end
end




function ShyWormBush:exitBush()
	
	if(not(self.wormDead)) then
		self.timer:stop()
		self.counter = 0
		self.scene.inBush = false
		
		if(self.wormIsUp) then
			Timer.delayedCall(100, self.scene.shyWorms[self.id].closeEye, self.scene.shyWorms[self.id])
			Timer.delayedCall(400, self.wormDown, self)
		end
	end

end



function ShyWormBush:wormDown()

	--if(not(self.wormDead)) then
		self.channel1 = self.scene.wormDownSound:play(1)
		self.channel1:setVolume(.5*self.scene.soundVol)

		local tween = GTween.new(self.scene.shyWorms[self.id].worm, .2,{y = self.wormStartY},{ease = easing.outQuadratic})
		self.scene.shyWorms[self.id]:hideLoot()
	--end

end


function ShyWormBush:pause()

end




function ShyWormBush:resume()

end


-- cleanup function

function ShyWormBush:exit()
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
end

