Camera = Core.class(Sprite)

function Camera:init(scene)

	self.scene = scene
		
	-- Get screen dimensions
	self.screenWidth = application:getContentWidth()
	self.screenHeight = application:getContentHeight()
	self.offsetX = 0
	self.offsetY = 0

end

function Camera:update()

--print("update")

	--define offsets
	
	local offsetX = 0
	local offsetY = 0
	
	
--	print(self.scene.hero:getX())
	
	if((self.scene.worldWidth - self.scene.hero:getX()) < self.screenWidth/2) then
		offsetX = -self.scene.worldWidth + self.screenWidth
		
	elseif(self.scene.hero:getX() >= self.screenWidth/2) then
		offsetX = -(self.scene.hero:getX() - self.screenWidth/2)
	end
	
	--print(self.scene.hero:getX() -offsetX)
	
	--check if we are not too close to upper or bottom wall
	--so we won't go further that wall
	
	if((self.scene.worldHeight - self.scene.hero:getY()) < self.screenHeight/2) then
		offsetY = -self.scene.worldHeight + self.screenHeight
	elseif(self.scene.hero:getY()>= self.screenHeight/2) then
		offsetY = -(self.scene.hero:getY() - self.screenHeight/2)
	end
	
	--apply offset so scene
	self.scene.layer0:setPosition(offsetX,offsetY)
	self.scene.physicsLayer:setPosition(offsetX,offsetY)
	self.scene.rube1:setPosition(offsetX,offsetY)
	self.scene.rube2:setPosition(offsetX,offsetY)
	if(self.scene.rube3) then
		self.scene.rube3:setPosition(offsetX,offsetY)
	end
	self.scene.bgLayer:setPosition(offsetX*.25, offsetY*.25)
	self.scene.fgLayer:setPosition(offsetX*.4, offsetY*.4)
	self.scene.frontLayer:setPosition(offsetX, offsetY)
	self.scene.collectibles:setPosition(offsetX, offsetY)
	self.scene.enemyLayer:setPosition(offsetX, offsetY)
	self.scene.behindRube:setPosition(offsetX, offsetY)
	self.scene.clawLayer:setPosition(offsetX, offsetY)
	
	-- If there is a fixed background as well
	
	if(self.scene.fixedBG) then

		self.scene.fixedBGLayer:setPosition((offsetX*.45)+self.scene.fixedBG.xOffset, (offsetY*.45)+self.scene.fixedBG.yOffset)
	
	end
	
	self.offsetX = offsetX
	self.offsetY = offsetY

end
