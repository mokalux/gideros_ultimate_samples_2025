Interface = Core.class(Sprite)

function Interface:init(scene)

	self.scene = scene

	self.canFire = true;
	self.direction = 6.26

	-- create a table to keep track of touches
	self.scene.upButtonTouches = {}
	self.scene.leftButtonTouches = {}
	self.scene.rightButtonTouches = {}

	-- create a layer for controls (will be faded)

	local controls = Sprite.new()
	self:addChild(controls)
	self.scene.controls = controls
	
	-- set the position of the controls here
	self.leftButtonX = xOffset-5
	self.leftButtonY = (yOffset+screenHeight)-110
	self.rightButtonX = xOffset+215
	self.rightButtonY = (yOffset+screenHeight)-110
	self.upButtonX = (xOffset+screenWidth)-60
	self.upButtonY = (yOffset+screenHeight)-110
	self.joypadX = (xOffset+screenWidth)-160
	self.joypadY = (yOffset+screenHeight)-70
	
	--------------------------------------------------------------
	-- L/R Buttons
	--------------------------------------------------------------

	--up states

	local leftButton = Buttons.new(scene,"lr-button.png", "lr-button-pressed.png")
	leftButton.type = "leftButton"
	self.scene.controls:addChild(leftButton)
	leftButton:setPosition(self.leftButtonX,self.leftButtonY)
	self.scene.leftButton = leftButton

	local rightButton = Buttons.new(scene,"lr-button.png", "lr-button-pressed.png")
	rightButton.type = "rightButton"
	self.scene.controls:addChild(rightButton)
	rightButton:setPosition(self.rightButtonX,self.rightButtonY)
	rightButton:setScaleX(-1)
	self.scene.rightButton = rightButton

	--down states

	local leftButtonPressed = Buttons.new(scene,"lr-button-pressed.png", "lr-button-pressed.png")
	self.scene.controls:addChild(leftButtonPressed)
	leftButtonPressed:setPosition(self.leftButtonX,self.leftButtonY)
	self.scene.leftButtonPressed = leftButtonPressed
	self.scene.leftButtonPressed:setVisible(false)

	local rightButtonPressed = Buttons.new(scene,"lr-button-pressed.png", "lr-button-pressed.png")
	self.scene.controls:addChild(rightButtonPressed)
	rightButtonPressed:setPosition(self.rightButtonX,self.rightButtonY)
	rightButtonPressed:setScaleX(-1)
	self.scene.rightButtonPressed = rightButtonPressed
	self.scene.rightButtonPressed:setVisible(false)

	--------------------------------------------------------------
	-- Joypad
	--------------------------------------------------------------

	-- create a layer for the joypad

	local joyPadLayer = Sprite.new()
	self:addChild(joyPadLayer)
	self.joyPadLayer = joyPadLayer

	-- setup Virutal Pad

	local vPad = CTNTVirtualPad.new(self.scene.controls, "Atlases/Atlas 2",  PAD.STICK_DOUBLE, PAD.BUTTONS_ONE, 20, 3)
	self.scene.vPad = vPad

	vPad:setPosition(PAD.COMPO_BUTTON1, self.upButtonX, self.upButtonY) -- up button
	vPad:setMaxRadius(PAD.COMPO_RIGHTPAD,100)
	vPad:setPosition(PAD.COMPO_LEFTPAD, -200, 100)
	vPad:setPosition(PAD.COMPO_RIGHTPAD, self.joypadX, self.joypadY)
	vPad:setHideMode(PAD.MODE_NOHIDE)

	vPad:setColor(PAD.COMPO_BUTTON1, 255,255,255)
	vPad:setAlpha(1, 1)
	--vPad:setAlpha(PAD.COMPO_BUTTON1, 0)
	vPad:setMaxRadius(PAD.COMPO_RIGHTPAD, 93)

	vPad:start()
	self.vPad = vPad

	vPad:addEventListener(PAD.BUTTON1_EVENT, self.upButton, self)
	vPad:addEventListener(PAD.RIGHTPAD_EVENT, self.rightJoy, self)

	if(self.scene.hideControls) then
		self.scene.controls:setAlpha(0)
	else
		Timer.delayedCall(1500, function() 	local tween = GTween.new(self.scene.controls, .5, {alpha=.6}) end)
	end

	--------------------------------------------------------------
	-- Health
	--------------------------------------------------------------

	local health = Health.new(self.scene)
	self:addChild(health)
	health:setPosition(xOffset+(10*aspectRatioX),yOffset+(10*aspectRatioY))
	self.scene.health = health

	--------------------------------------------------------------
	-- Countdown timer
	--------------------------------------------------------------

	local countdown = Countdown.new(self.scene)
	self:addChild(countdown)




	--------------------------------------------------------------
	-- Loot Bar
	--------------------------------------------------------------

	local lootBar = Sprite.new()
	self:addChild(lootBar)
	lootBar:setPosition(xOffset+(186*aspectRatioX),yOffset+(2*aspectRatioY))
	self.lootBar = lootBar

	local lootBarBG = Bitmap.new(self.scene.atlas[2]:getTextureRegion("loot bar bg.png"));
	lootBarBG:setPosition(0, 9)
	self.lootBar:addChild(lootBarBG)

	local barLayer = Sprite.new()
	self.lootBar:addChild(barLayer)
	self.barLayer = barLayer


	local lootBarFrame = Bitmap.new(self.scene.atlas[2]:getTextureRegion("loot bar frame.png"));
	lootBarFrame:setPosition(-2, 5)
	
	self.lootBar:addChild(lootBarFrame)



	



	--------------------------------------------------------------
	-- Pause Button -- must go last
	--------------------------------------------------------------

	local pauseButton = Pause.new(self.scene)
	self:addChild(pauseButton)
	self.scene.pause = pauseButton

	-- set up sounds
	
	if(not(self.scene.fireObjectSound)) then
	
		self.scene.fireObjectSound = Sound.new("Sounds/throw object.wav")
		self.scene.targetSound = Sound.new("Sounds/target achieved.wav")
		
	end
	
	self.scene:addEventListener("onExit", self.onExit, self)
	
end







function Interface:updateLoot()

	-- remove the shape mask if it exists

	if(self.lootBarBronze) then
		self.barLayer:removeChild(self.lootBarBronze)
	end

	if(self.lootBarSilver) then
		self.barLayer:removeChild(self.lootBarSilver)
	end

	if(self.lootBarGold) then
		self.barLayer:removeChild(self.lootBarGold)
	end

	self.lootBarDrawn = true

	self.onePercent = .87 -- we know one percent of loot bar length

	-- Work out bronze percent complete

	self.currentBronzeLootPercentage = math.floor((self.scene.loot / self.scene.lootBronzeTarget) * 100) -- Get current loot as percentage
	self.bronzeLootBarLength = math.floor(self.onePercent * self.currentBronzeLootPercentage) -- Work out length loot progress bar should be

	if(self.bronzeLootBarLength > 87) then
		self.bronzeLootBarLength = 87
	end

	-- Redraw Loot Bar (Bronze)
	if(self.scene.showLootCollected) then
		print(self.scene.loot)
	end

	local lootBarBronze = Shape.new()
	self.barLayer:addChild(lootBarBronze)
	self.lootBarBronze = lootBarBronze
	self.lootBarLootImage = Texture.new("gfx/lb bronze.png")
	lootBarBronze:clear()
	lootBarBronze:setFillStyle(Shape.TEXTURE, self.lootBarLootImage)
	lootBarBronze:beginPath()
	lootBarBronze:moveTo(0,0)
	lootBarBronze:lineTo(self.bronzeLootBarLength+4,0)
	lootBarBronze:lineTo(self.bronzeLootBarLength+4,27)
	lootBarBronze:lineTo(0,27)
	lootBarBronze:closePath()
	lootBarBronze:endPath()
	lootBarBronze:setPosition(0, 11)
	
	
		--lootBarFrame:setPosition(xOffset+(182*aspectRatioX), yOffset+(5*aspectRatioY))
	
	

	-- Work out Silver percent complete

	self.silverComplete = self.scene.loot - self.scene.lootBronzeTarget

	self.currentSilverLootPercentage = math.floor((self.silverComplete / (self.scene.lootSilverTarget-self.scene.lootBronzeTarget)) * 100)
	
	self.silverLootBarLength = math.floor(self.onePercent * self.currentSilverLootPercentage)

	if(self.silverLootBarLength > 87) then
		self.silverLootBarLength = 87
	end
	
	-- Redraw Silver

	local lootBarSilver = Shape.new()
	self.barLayer:addChild(lootBarSilver)
	self.lootBarSilver = lootBarSilver
	self.lootBarLootImage = Texture.new("gfx/lb silver.png")

	lootBarSilver:clear()
	lootBarSilver:setFillStyle(Shape.TEXTURE, self.lootBarLootImage)
	lootBarSilver:beginPath()
	lootBarSilver:moveTo(0,0)
	lootBarSilver:lineTo(self.silverLootBarLength+4,0)
	lootBarSilver:lineTo(self.silverLootBarLength+4,27)
	lootBarSilver:lineTo(0,27)
	lootBarSilver:closePath()
	lootBarSilver:endPath()
	lootBarSilver:setPosition(0, 11)
	


-- Work out Gold percent complete


	self.goldComplete = self.scene.loot - self.scene.lootSilverTarget

	self.currentGoldLootPercentage = math.floor((self.goldComplete / (self.scene.lootGoldTarget - self.scene.lootSilverTarget)) * 100)
	
	self.goldLootBarLength = math.floor(self.onePercent * self.currentGoldLootPercentage)

	if(self.goldLootBarLength > 87) then
		self.goldLootBarLength = 87
	end
	
	-- Redraw Gold

	local lootBarGold = Shape.new()
	self.barLayer:addChild(lootBarGold)
	self.lootBarGold = lootBarGold
	self.lootBarLootImage = Texture.new("gfx/lb gold.png")
	lootBarGold:clear()
	lootBarGold:setFillStyle(Shape.TEXTURE, self.lootBarLootImage)
	lootBarGold:beginPath()
	lootBarGold:moveTo(0,0)
	lootBarGold:lineTo(self.goldLootBarLength+4,0)
	lootBarGold:lineTo(self.goldLootBarLength+4,27)
	lootBarGold:lineTo(0,27)
	lootBarGold:closePath()
	lootBarGold:endPath()
	lootBarGold:setPosition(0, 11)
	
	-- Got the Bronze target

	if(self.scene.loot >= self.scene.lootBronzeTarget and self.scene.medal < 1) then
		
		local channel1 = self.scene.targetSound:play()
		channel1:setVolume(.3*self.scene.soundVol)

		if(not(self.scene.doorOpen)) then
		
			self.scene.doorOpen = true
		
			for i,v in pairs(self.scene.exitDoors) do

				v:openDoor()
				--v.whiteEmitter:start()
				v.whiteEmitter.running = true
				--v.bronzeEmitter:start()
				v.bronzeEmitter.running = true
				v.bronzeChip:setVisible(true)--]]

			end
	
		end
		
		-- show level target text
		
		local targetText = TargetText.new(self.scene,"bronze achieved text.png")
		
		
		self.scene.medal = 1

			
	end

	-- Got the Silver target

	if(self.scene.loot >= self.scene.lootSilverTarget and self.scene.medal < 2) then
	
		local channel1 = self.scene.targetSound:play()
		channel1:setVolume(.3*self.scene.soundVol)

		-- change the colour chip above door here... 
		
		for i,v in pairs(self.scene.exitDoors) do
			
			v:openDoor()
			v.bronzeEmitter:stop()
			v.bronzeEmitter.running = false
			v.silverEmitter:start()
			v.silverEmitter.running = true
			v.silverChip:setVisible(true)
				
		end
		
		self.scene.medal = 2
		
		-- show level target text
		
		local targetText = TargetText.new(self.scene,"silver achieved text.png")
		
	end
		
	-- Got the Gold target	

	if(self.scene.loot >= self.scene.lootGoldTarget  and self.scene.medal < 3) then
	
		local channel1 = self.scene.targetSound:play()
		channel1:setVolume(.3*self.scene.soundVol)
	
		-- show level target text
		
		local targetText = TargetText.new(self.scene,"gold achieved text.png")
		
		-- change the colour chip above door here...
		
		for i,v in pairs(self.scene.exitDoors) do
			
			v:openDoor()
			v.silverEmitter:stop()
			v.silverEmitter.running = false
			v.goldEmitter:start()
			v.goldEmitter.running = true
			v.goldChip:setVisible(true)
				
		end
		
		self.scene.medal = 3
			
	end

end










-- If the move up button was pressed or released

function Interface:upButton(event)

	-- pressed up
	if(event.data.state==18) then
	
	--print("call up")

	self.scene.playerMovement:moveUp()
	
	elseif(event.data.state==19) then
		
		self:stopMovingUp()
		
	end

end





function Interface:stopMovingUp()

	-- Released up
		
	self.scene.playerMovement.movingUp = false
	
	if(self.scene.playerMovement.channel1) then
		self.scene.playerMovement.flyingSound = false
		self.scene.playerMovement.channel1:stop()
	end
			
	self.scene.hero.flying = false
	self.scene.heroAnimation:updateAnimation()
		
	if(self.scene.playerMovement.heroY) then
		if(self.scene.playerMovement.heroY < 5) then
			self.scene.hero.body:setLinearVelocity(0,0)
		end
	end

end



-- Touch released, fire the claw

function Interface:fireClaw(direction)

	if(not(self.scene.touchingSign)) then
	
		local armX,armY = self.scene.hero.frontArm:localToGlobal(0, 0) -- get arm coords on stage
		
		local distXScrolled = 0 - self.scene.rube1:getX()
		local distYScrolled = 0 - self.scene.rube1:getY()
		
		-- Fire object
		
		if(self.scene.holdingObject) then
		
			self.clawObjectX, self.clawObjectY = self.scene.theObject:localToGlobal(0,0)
			self.scene.theObject:makeDangerous() -- starts timer when this object is able to hit stuff
			
			self.scene.theObject.body:setPosition(self.clawObjectX+distXScrolled,self.clawObjectY+distYScrolled)
			
			self.scene.frontLayer:addChild(self.scene.theObject) -- move back to it's layer
			
			self.scene.theObject.body:setActive(true) -- set body to active
			self.scene.theObject.body.disabled = nil -- let physics run on it
			
			local heroX,heroY = self.scene.hero:localToGlobal(0,0)
			
			if(self.scene.theObject.type == "key.png") then
				
				self.objectSpeed = 1
				
			else
				
				self.objectSpeed = 2
				
			end


			local vectorX = math.cos(self.direction) * self.objectSpeed
			local vectorY = math.sin(self.direction) * self.objectSpeed
			self.scene.theObject.body:setLinearVelocity(0,0)
			self.scene.theObject.body:applyLinearImpulse(vectorX,vectorY, heroX,heroY)

			
			local channel1 = self.scene.fireObjectSound:play()
			channel1:setVolume(.3*self.scene.soundVol)
			
			 -- set the spin
			
			if(self.scene.heroAnimation.facing=="right") then
				self.scene.theObject.body:setAngularVelocity(5)
			end
			
			self.scene.theObject.body:setAngularVelocity(-5)
			self.scene.aimingClaw = false
			self.scene.retractingClaw = false
			self.scene.heroAnimation.animation = nil
			self.scene.heroAnimation:updateAnimation()
			
			self.scene.theObject = nil

		else
			-- Fire claw
		
			local claw = Claw.new((distXScrolled+armX)+(math.cos(direction)*30), (distYScrolled+armY)+(math.sin(direction)*30), direction, self.scene)
			self.scene.clawLayer:addChild(claw)
			self.scene.clawSprite = claw
			
		end
		
	end
	
end











function Interface:rightJoy(event)

self.direction = event.data.angle

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
		
	-- Touch started on the joystick

		if(event.data.state==17 or event.data.state==18) then
			
			if(not(self.scene.touchingSign)) then

				if(not self.scene.paused and not(self.scene.hero.dead)) then
				
					self.scene.touchingJoypad = true
					--self.scene.hero.frontArm:setScaleX(1)
					--self.scene.armFacing = "right"
					

						
					if(not(self.scene.firingClaw) and not(self.scene.retractingClaw) and not(self.scene.pauseClaw)) then
						
						self.scene.aimingClaw = true
						self.scene.hero.backClaw:setVisible(false)
							
					end

					

					-- there is an angle and we are not aiming, firing and retracting, turn on aiming

					if((not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) and self.direction > 0) then

						if(self.scene.holdingObject) then
						
							self.scene.aimingClaw = false
							self.scene.holdingObject = false
							self.scene.heroAnimation:updateAnimation()	
							
						else
						
							self.scene.aimingClaw = true
							self.scene.hero.backClaw:setVisible(false)
									
						end
					
						self.scene.heroAnimation:updateAnimation()
					end

					-- If aiming claw, then point claw that direction

					if(self.scene.aimingClaw) then
						self.scene.heroAnimation:updateAnimation()
							if(not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
							
								-- Rotate front arm
								self.scene.hero.frontArm:setRotation(math.deg(event.data.angle))
								
							end
					end
					
				end
			
			end
			
		elseif(event.data.state==19) then
		
			if(not(self.scene.touchingSign)) then

				self.scene.touchingJoypad = false
				
				-- Fire claw
				if(self.canFire) then
				
					self:fireClaw(self.direction)
					self.canFire = false
					
					if(self.scene.holdingObject) then
					
						self.canFire = true
						self.scene.firingClaw = false	
						self.scene.holdingObject = false

					else

						self.scene.firingClaw = true

					end
					
					self.scene.heroAnimation:updateAnimation()	

				end
				
			end
		
		end
	
	end

end




function Interface:onExit()

	self.scene.vPad:stop()
	self.scene.vPad = nil
	self.scene:removeEventListener("onExit", self.onExit, self)


end
