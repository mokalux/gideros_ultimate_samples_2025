LevelSelectDoor = Core.class(Sprite)

function LevelSelectDoor:init(scene,levelNumber)

	self.scene = scene
	self.levelNumber = levelNumber
	
	
	
	-- testing
	
	--[[if(not(self.scene.saveGame.levelNumber)) then
		self.scene.saveGame.levelNumber = 0
	end
	--]]


	-- create group

	local bigDoor = Bitmap.new(self.scene.atlas[1]:getTextureRegion("mini door open 1.png"))
	bigDoor:setAnchorPoint(.5,.5)
	self:addChild(bigDoor)
	self.bigDoor = bigDoor
	
	-- add the open door image
	
	local img = Bitmap.new(self.scene.atlas[1]:getTextureRegion("mini door open 9.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.openDoorImg = img
	img:setVisible(false)

	-- This is the first play of the game
	

	
	if(not(self.scene.saveGame.levelMedals)) then
	
		local littleDoor1 = Bitmap.new(self.scene.atlas[1]:getTextureRegion("little doors blank.png"))
		self:addChild(littleDoor1)
		self.littleDoor1 = littleDoor1
		littleDoor1:setAnchorPoint(.5,.5)
		littleDoor1:setPosition(bigDoor:getX(),44)
		
	else

		-- Work out what the image should be

		--self.scene.saveGame.levelMedals[self.level] = math.random(1,3)
		
		print("door",self.levelNumber,"medal",self.scene.saveGame.levelMedals[tonumber(self.levelNumber)])
		

		if(self.scene.saveGame.levelMedals[self.levelNumber]) then

			if(self.scene.saveGame.levelMedals[self.levelNumber]>=1) then

				-- Bronze

				local littleDoor1 = Bitmap.new(self.scene.atlas[1]:getTextureRegion("little doors bronze.png"))
				self:addChild(littleDoor1)
				self.littleDoor1 = littleDoor1
				littleDoor1:setAnchorPoint(.5,.5)
				littleDoor1:setPosition(bigDoor:getX(),44)
				
			end



			if(self.scene.saveGame.levelMedals[self.levelNumber]>=2) then

				-- Silver

				local littleDoor1 = Bitmap.new(self.scene.atlas[1]:getTextureRegion("little doors silver.png"))
				self:addChild(littleDoor1)
				self.littleDoor1 = littleDoor1
				littleDoor1:setAnchorPoint(.5,.5)
				littleDoor1:setPosition(bigDoor:getX(),44)
				
			end

			if(self.scene.saveGame.levelMedals[self.levelNumber]==3) then
			
				-- Gold

				local littleDoor1 = Bitmap.new(self.scene.atlas[1]:getTextureRegion("little doors gold.png"));
				self:addChild(littleDoor1)
				self.littleDoor1 = littleDoor1
				littleDoor1:setAnchorPoint(.5,.5)
				littleDoor1:setPosition(bigDoor:getX(),44)
			
			end

		else

			-- Have not got any medals on this level yet...
			-- Show blank doors
		
			local littleDoor1 = Bitmap.new(self.scene.atlas[1]:getTextureRegion("little doors blank.png"));
			self:addChild(littleDoor1)
			self.littleDoor1 = littleDoor1
			littleDoor1:setAnchorPoint(.5,.5)
			littleDoor1:setPosition(bigDoor:getX(),44)

		end
	
	-- End if this was the first time playing
	end

	-- Decide what to show for this door
	-- If we have passed this level, open this door
	
	--print("self.level", self.level)
	--print(self.scene.saveGame.level+1)
	
	if(not(self.scene.saveGame.levelNumber)) then
		self.scene.saveGame.levelNumber = 0
	end

--print(self.scene.saveGame.levelNumber,self.levelNumber)

	if(self.scene.saveGame.levelNumber >= self.levelNumber) then

		-- just open

		self.openDoorImg:setVisible(true)
		self:canTouchDoor()
		

	elseif(self.levelNumber == (self.scene.saveGame.levelNumber+1)) then
		
		-- anim
		
		Timer.delayedCall(400, self.openTheDoor, self)
		self:canTouchDoor()
			
	end
	
	-- sounds

	if(not(self.scene.openDoorSound)) then
	
		self.scene.openDoorSound = Sound.new("Sounds/world door open.wav")

	end
	

	


end


function LevelSelectDoor:playOpenDoorSound()

	local channel1 = self.scene.openDoorSound:play()
	channel1:setVolume(.3*self.scene.soundVol)


end





function LevelSelectDoor:openTheDoor()

	Timer.delayedCall(40, self.playOpenDoorSound, self)
	self.bigDoor:setVisible(false)
	local anim = CTNTAnimator.new(self.scene.atlas1AnimLoader)
	anim:setAnimation("DOOR_OPEN")
	anim:setAnimAnchorPoint(.5,.5)
	anim:addToParent(anim)
	anim:playAnimation()
	self:addChild(anim)
	self.anim = anim
	self.scene.mainSprite:addChild(self)
	
	
	Timer.delayedCall(400, self.canTouchDoor, self)

end



function LevelSelectDoor:canTouchDoor()

	self:addEventListener(Event.TOUCHES_END, self.goToLevel, self)

end



function LevelSelectDoor:goToLevel(event)

	if(self:hitTestPoint(event.touch.x, event.touch.y) and not self.touched and not(self.scene.swiping)) then
	
		self.scene.touchedDoor = true
		self.scene:onExit()
	
		playSound("Sounds/jump-and-land.wav",.8*self.scene.soundVol)
				
		self.touched = true
		self.theLevel = "Level " .. self.levelNumber
		levelNum = self.levelNumber
		
		fadeToBlack()
		
		Timer.delayedCall(600, self.changeLevel, self)

	end

end



function LevelSelectDoor:changeLevel()

	sceneManager:changeScene(self.theLevel, 0, SceneManager.flipWithFade, easing.outBack)

end








