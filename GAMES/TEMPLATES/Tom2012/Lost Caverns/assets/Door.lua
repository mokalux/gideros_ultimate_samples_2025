Door = Core.class(Sprite)

function Door:init(scene,x,y)

	self.scene = scene
	
	if(not(self.scene.exitDoors)) then
		self.scene.exitDoors = {}
	end
	
	table.insert(self.scene.exitDoors, self)
	
	self.x = x
	self.y = y

	-- create group

	local doorGroup = Sprite.new()
	self:addChild(doorGroup)
	self.doorGroup = doorGroup

	self.scene.layer0:addChild(self)
	
	-- bg
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("open 0010.png"));
	self.doorGroup:addChild(img)
	img:setAnchorPoint(.5,.5)

	
	-- left door
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("exit door left.png"));
	self.doorGroup:addChild(img)
	img:setAnchorPoint(.5,.5)
	img:setPosition(-17,0)
	self.leftDoor = img
	
	-- right door
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("exit door right.png"));
	self.doorGroup:addChild(img)
	img:setAnchorPoint(.5,.5)
	img:setPosition(17,0)
	self.rightDoor = img


	-- frame

	local frame = Bitmap.new(self.scene.atlas[2]:getTextureRegion("door frame.png"));
	self.doorGroup:addChild(frame)
	frame:setPosition(-58,-60)

	-- bronze chip

	local bronzeChip = Bitmap.new(self.scene.atlas[2]:getTextureRegion("top bronze.png"));
	self.doorGroup:addChild(bronzeChip)
	self.bronzeChip = bronzeChip
	bronzeChip:setPosition(-27,-60)
	bronzeChip:setVisible(false)

	-- silver chip

	local silverChip = Bitmap.new(self.scene.atlas[2]:getTextureRegion("top silver.png"));
	self.doorGroup:addChild(silverChip)
	self.silverChip = silverChip
	silverChip:setPosition(-27,-60)
	silverChip:setVisible(false)

	-- gold chip

	local goldChip = Bitmap.new(self.scene.atlas[2]:getTextureRegion("top gold.png"));
	self.doorGroup:addChild(goldChip)
	self.goldChip = goldChip
	goldChip:setPosition(-27,-60)
	goldChip:setVisible(false)

	-- Set up emitters
	
	local emitter = CEmitter.new(0,-45,0, self)
	emitter.isDoor = true
	emitter.parent = self
	table.insert(self.scene.particleEmitters, emitter)
	self.bronzeEmitter = emitter
	
	local emitter = CEmitter.new(0,-45,0, self)
	emitter.isDoor = true
	emitter.parent = self
	table.insert(self.scene.particleEmitters, emitter)
	self.silverEmitter = emitter
	
	local emitter = CEmitter.new(0,-45,0, self)
	emitter.isDoor = true
	emitter.parent = self
	table.insert(self.scene.particleEmitters, emitter)
	self.goldEmitter = emitter
	
	local emitter = CEmitter.new(0,-45,0, self)
	emitter.isDoor = true
	emitter.parent = self
	table.insert(self.scene.particleEmitters, emitter)
	self.whiteEmitter = emitter

	-- load graphics

	local particles1 = self.scene.atlas[2]:getTextureRegion("particle 1.png");
	local particles2 = self.scene.atlas[2]:getTextureRegion("loot-particles-2.png");

	-- Bronze

	local parts1 = CParticles.new(particles1, 15, 1.2, 1, "alpha")
	parts1:setSpeed(40, 60)
	parts1:setSize(.1)
	parts1:setAlphaMorphOut(50, .4)
	parts1:setSizeMorphIn(.2,.2,.5,.2)
	parts1:setSizeMorphOut(0.2, 1.5)
	parts1:setDirection(0,360)
	parts1:setColor(200,100,15, 250,150,70)

	self.bronzeEmitter:assignParticles(parts1)

	-- Silver

	local parts1 = CParticles.new(particles1, 15, 1.2, 1, "alpha")
	parts1:setSpeed(40, 60)
	parts1:setSize(.1)
	parts1:setAlphaMorphOut(50, .4)
	parts1:setSizeMorphIn(.2,.2,.5,.2)
	parts1:setSizeMorphOut(0.2, 1.5)
	parts1:setDirection(0,360)
	parts1:setColor(203,217,219, 226,241,244)

	self.silverEmitter:assignParticles(parts1)
	
	-- Gold

	local parts1 = CParticles.new(particles1, 15, 1.2, 1, "alpha")
	parts1:setSpeed(40, 60)
	parts1:setSize(.1)
	parts1:setAlphaMorphOut(50, .4)
	parts1:setSizeMorphIn(.2,.2,.5,.2)
	parts1:setSizeMorphOut(0.2, 1.5)
	parts1:setDirection(0,360)
	parts1:setColor(255,219,17, 255,241,244)

	self.goldEmitter:assignParticles(parts1)

	-- White particles

	local parts1 = CParticles.new(particles1, 10, 1, 1, "alpha")
	parts1:setSpeed(20, 30)
	parts1:setSize(.1, .2)
	parts1:setColor(255,255,255)
	parts1:setAlphaMorphIn(255, .2)
	parts1:setAlphaMorphOut(50, .4)
	parts1:setSizeMorphOut(0.2, 0.9)
	parts1:setDirection(0,360)
	parts1:setRotation(0, -160, 360, 160)
	
	self.whiteEmitter:assignParticles(parts1)
	
	
	
	-- Now add the exit level text
	
	local exitLevel = Sprite.new()
	self.scene.topLayer:addChild(exitLevel)
	self.exitLevel = exitLevel
	
	local header = Bitmap.new(self.scene.atlas[2]:getTextureRegion("exit level text.png"));
	header:setAnchorPoint(.5,.5)
	header:setPosition(application:getContentWidth()/2, 35)
	self.exitLevel:addChild(header)

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("exit level image.png"));
	img:setAnchorPoint(.5,.5)
	img:setPosition(application:getContentWidth()/2, 160)
	self.exitLevel:addChild(img)



	-- No Button

	local buttonImage = Bitmap.new(self.scene.atlas[2]:getTextureRegion("cross.png"))
	buttonImage:setAnchorPoint(.5,.5)
	local buttonImagePressed = Bitmap.new(self.scene.atlas[2]:getTextureRegion("cross-pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	buttonImagePressed:setY(-5)
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self.exitLevel:addChild(theButton)
	theButton:setPosition(application:getContentWidth()/2-100,400)
	theButton:addEventListener("click", function()
		playSound("Sounds/button-press.wav",.8*self.scene.soundVol)
		self:hideMenu()
	end)
	self.noButton = theButton
	
	-- Yes Button

	local buttonImage = Bitmap.new(self.scene.atlas[2]:getTextureRegion("tick.png"))
	buttonImage:setAnchorPoint(.5,.5)
	local buttonImagePressed = Bitmap.new(self.scene.atlas[2]:getTextureRegion("tick-pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self.exitLevel:addChild(theButton)
	theButton:setPosition(application:getContentWidth()/2+100,400)
	theButton:addEventListener("click", function()
		playSound("Sounds/button-press.wav",.8*self.scene.soundVol)
		self:exitTheLevel()
	end)
	self.yesButton = theButton

	
	self.exitLevel:setAlpha(0)
	self.exitLevel:setVisible(false)
	
	-- Add physics

		local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
		body:setPosition(x,y)
		
		local circle = b2.CircleShape.new(0,0,40)
		local fixture = body:createFixture{shape = circle, density = 1, friction = .1, restitution = .1}
		
		fixture.name = "exit door"
		fixture.parent = self
		self.body = body

		local filterData = {categoryBits = 4096, maskBits = 8}
		fixture:setFilterData(filterData)

		--Timer.delayedCall(4000, self.exitTheLevel, self)
end



function Door:openDoor()

	if(not(self.open)) then
		self.open = true
		
		local tween = GTween.new(self.leftDoor, .5, {x = self.leftDoor:getX()-20, scaleX=.5},{ease = easing.outQuadratic})
		local tween = GTween.new(self.rightDoor, .5, {x = self.rightDoor:getX()+23, scaleX=.5},{ease = easing.outQuadratic})
		
	end

end



function Door:heroHitDoor()

	if(not(self.scene.heroTouchingDoor)) then
	
		self.scene.heroTouchingDoor = true
		self.exitLevel:setVisible(true)
		self.scene.showingExitOverlay = true
		self.tween1 = GTween.new(self.exitLevel, .2, {alpha=1.2})
		
		-- Move buttons on screen
		
		self.noButton:setY(272)
		self.yesButton:setY(265)

		-- pause stuff
		
		self.scene.pause:doPause()
			

			
	end

end




function Door:heroMovedOffDoor()

	--print("not touching")
	self.scene.heroTouchingDoor = false
	
end



function Door:hideMenu()

	self.noButton:setY(400)
	self.yesButton:setY(400)
	self.scene.pause:doResume()
	self.tween1 = GTween.new(self.exitLevel, .2, {alpha=0})
	Timer.delayedCall(200, function() self.exitLevel:setVisible(false) end)
	self.scene.showingExitOverlay = nil

end




function Door:exitTheLevel()

	if(not(self.scene.hitDoor)) then
	

	
			-- pause all sounds
		if(self.scene.spritesWithVolume) then
			for i,v in pairs(self.scene.spritesWithVolume) do
				if(v.channel1) then
					v.channel1:setVolume(0)
				end
				
				if(v.channel2) then
					v.channel2:setVolume(0)
				end
			
			end
		end
	
		-- Resume timers
		Timer.resumeAll()
		
		self.scene:dispatchEvent(Event.new("onExit", self.scene))
		
		self.scene.gameEnded = true
		self.scene.spritesWithVolume = {}

		--self.scene.paused = false

		--GTween
	
		GTween.pauseAll = false
	
		self.scene.hitDoor = true
		
				
		-- Store the medal scored this level in a global
		-- This is used on the level complete scene
		
		lastLevelMedal = self.scene.medal
		
		
		

		-- SAVING SECTION
		
		print("Saving")
		print("self.scene.levelNumber is", self.scene.levelNumber)
		
		-- Check file exists and load it
		
		local file = io.open("|D|saveGame.json", "r" )
		
		if(file) then
			print("|D|saveGame.json DOES exist")
			self.scene.saveGame = dataSaver.load("|D|saveGame") -- load it
			io.close( file )
		else
			print("|D|saveGame.json does not exist")
			self.scene.saveGame = {} -- create blank table
		end
			
			

		
		-- If we beat our best medal for this level
		-- Then overwrite it in saveGame

		-- Check table exists that stores levelMedals
		
		if(not(self.scene.saveGame.levelMedals)) then
			print("self.scene.saveGame.levelMedals didn't exist, creating")
			self.scene.saveGame.levelMedals = {}
		else
			print("self.scene.saveGame.levelMedals table found on file")
		end
		
		-- check if we have a medal for this level
		
		-- for testing comment out
		--self.scene.saveGame.levelMedals[self.scene.levelNumber]=nil
		
		if(not(self.scene.saveGame.levelMedals[self.scene.levelNumber])) then
		
			-- If not, this is the first time we played this level
		
			print("no medal found for this level in self.scene.saveGame.levelMedals[self.scene.levelNumber]")
			print("setting to the medal we just attained", self.scene.medal)
			
			-- note for testing you can't just insert the variable into the table if the values below are blank
			-- so we need to set any previous levels with no medal to 1
			
			--	self.scene.saveGame.test = "test"
			--self.scene.saveGame.levelMedals = {}
			
			for i=1,self.scene.levelNumber do
			
				if(not(self.scene.saveGame.levelMedals[i])) then
					self.scene.saveGame.levelMedals[i] = 1
				end
			end
			
			-- set to the level we just got
			self.scene.saveGame.levelMedals[self.scene.levelNumber] = self.scene.medal

		else
		
		print("a medal was found for this level")
			
		-- This is not the first time we played this level
		-- Check if this is better than the one on file
		
		--[[
		print("scene",self.scene)
		print("self.scene.saveGame",self.scene.saveGame)
		print("self.scene.saveGame.levelMedals",self.scene.saveGame.levelMedals)
		print("self.scene.levelNumber",self.scene.levelNumber)
		print("self.scene.saveGame.levelMedals[self.scene.levelNumber]",self.scene.saveGame.levelMedals[self.scene.levelNumber])
--]]
			if(self.scene.medal > self.scene.saveGame.levelMedals[self.scene.levelNumber]) then
				self.scene.saveGame.levelMedals[self.scene.levelNumber] = self.scene.medal
				print("last medal is better than one on file")
			else
				print("last medal is NOT better than one on file")
			end

		end
		
		
	
		
		
		
		
		
		-- Now store what level we are up to
		
		-- First ever game
		
		if(not(self.scene.saveGame.levelNumber)) then
		
			self.scene.saveGame.levelNumber = self.scene.levelNumber
			print("nothing for self.scene.saveGame.levelNumber, setting it to",self.scene.levelNumber)
		
		else
		
			-- We have completed at least one level
		
			print("self.scene.saveGame.levelNumber was found:", self.scene.saveGame.levelNumber)
		
			-- Did we beat what's on record
			
			if(self.scene.levelNumber>self.scene.saveGame.levelNumber) then
				self.scene.saveGame.levelNumber = self.scene.levelNumber
				print("the level we just beat was greater than self.scene.saveGame.levelNumber")
				
			end
			
			

		end
		



		--self.scene.saveGame = {} -- RESET EVERYTHING
		--dataSaver.save("|D|saveGame", self.scene.saveGame) -- save data

		
		fadeToBlack() 

		Timer.delayedCall(500, self.goToLevelComplete, self)

	end
	
	--temp
		
		


end




function Door:goToLevelComplete(event)

	Timer:stopAll()

	-- stop all sounds
	if(self.scene.spritesWithVolume) then
		for i,v in pairs(self.scene.spritesWithVolume) do
			if(v.channel1) then
				v.channel1:setVolume(0)
			end
			
			if(v.channel2) then
				v.channel2:setVolume(0)
			end
		
		end
	end

	self.scene.gameEnded = true
	self.scene.spritesWithVolume = {}
	sceneManager:changeScene("Level Complete", 0, SceneManager.flipWithFade, easing.outBack)

end


