DragBlock = Core.class(Sprite)

function DragBlock:init(scene,x,y,atlas)

	self.scene = scene

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("drag block.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.canDrag = true
	self.scene.behindRube:addChild(self)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	self.theShape = b2.PolygonShape.new()
	self.theShape:setAsBox(img:getWidth()/2-6,img:getHeight()/2-6,0,10,0)

	local fixture = body:createFixture{shape = self.theShape, density = 999, friction = 3, restitution = 0}
	local filterData = {categoryBits = 256, maskBits = 1+2+1024+8912}
	fixture:setFilterData(filterData)
	fixture.name = "block"
	fixture.parent = self
	
	body.name = "Ground"
	
	body.parent = self
	self.body = body
	
	self.body:setLinearDamping(.1)
	
	table.insert(self.scene.spritesOnScreen, self)

	self.body:setPosition(x,y)
	table.insert(self.scene.dragBlocks, self) -- so will be included in collisions
	
	-- set up sounds
	
	if(not(self.scene.dragBlockSound)) then
	
		self.scene.dragBlockSound = Sound.new("Sounds/drag object.wav")

	end
	


end


function DragBlock:attachToClaw()

	local clawX, clawY = self.scene.claw:localToGlobal(0,0)
	local blockX, blockY = self:localToGlobal(0,0)
	local clawOffset = blockX - clawX
	
	self.body:setLinearDamping(0)
	self.scene.claw:stopAndReturnClaw(300)
	self.scene.claw.dragBlock = self
	self.scene.claw.clawOffset = clawOffset

	-- Add timer to disconnect to prevent getting stuck
	
	self.timer = Timer.delayedCall(4000, function()
		self.scene.claw.dragBlock = false
	end)

	self:addEventListener(Event.ENTER_FRAME, self.correctRotation, self)
	self.correctingRotation = true
	
	self:playSound()



end



function DragBlock:playSound()

	self.channel1 = self.scene.dragBlockSound:play(0,math.huge)
	self.channel1:setVolume(.3*self.scene.soundVol)

end







function DragBlock:stopCorrectingRotation()

	self:removeEventListener(Event.ENTER_FRAME, self.correctRotation, self)
	self.correctingRotation = false
	
end




function DragBlock:correctRotation()

	local angle = math.deg(self.body:getAngle())
	
	if(angle < -10) then
		self.body:setAngle(math.rad(-10))
	elseif(angle > 10) then
		self.body:setAngle(math.rad(10))
	end

end
