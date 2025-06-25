Countdown = Core.class(Sprite);

function Countdown:init(scene)

	self.scene = scene

	if(self.scene.secondsLeft < 10) then
		self.scene.secondsLeft = "0".. self.scene.secondsLeft
	end

	self.timeRemaining = self.scene.minutesLeft ..":"..self.scene.secondsLeft



	-- set fonts

	--local font = BMFont.new("Fonts/timer red.fnt", "Fonts/timer red.png"); -- normal colour

	local countdownText = BMTextField.new(self.scene.timerFont, tostring(self.timeRemaining));
	countdownText:setScale(self.scene.scalex, self.scene.scaley)
	self:addChild(countdownText)
	countdownText:setPosition(xOffset+(350*aspectRatioX),yOffset+(12*aspectRatioY))
	
	countdownText:setText(tostring(self.timeRemaining));
	self.countdownText = countdownText
	--self.countdownText:setVisible(false);


	local countdownTextRed = BMTextField.new(self.scene.timerRedFont, tostring(self.timeRemaining));
	countdownTextRed:setScale(self.scene.scalex, self.scene.scaley)
	self:addChild(countdownTextRed);
	countdownTextRed:setPosition(xOffset+(350*aspectRatioX),yOffset+(12*aspectRatioY))
	self.countdownTextRed = countdownTextRed
	self.countdownTextRed:setVisible(false);


	local countDown = Timer.new(1000);
	countDown:addEventListener(Event.TIMER, self.reduceTime, self);
	countDown:start()
	self.scene.countDown = countDown
	
	self.scene:addEventListener("onExit", self.onExit, self)

end




function Countdown:reduceTime()



	self.timeLeft = self.scene.minutesLeft ..":"..self.scene.secondsLeft

	-- Time has run out

	if(tonumber(self.scene.minutesLeft) == 0 and tonumber(self.scene.secondsLeft) == 0) then

	self.scene.vPad:stop()
	self.scene.gameEnded = true
	self.scene.countDown:stop()
	self.scene.hero.dead = true
	self.scene.hero.body:setLinearVelocity(0,0)
	self.scene.hero.body:setActive(false)

	self.blackOverlay = Shape.new()
	self.blackOverlay:setFillStyle(Shape.SOLID, 0x000000)       
	self.blackOverlay:beginPath()
	self.blackOverlay:moveTo(xOffset,yOffset)
	self.blackOverlay:lineTo((logicalW+math.abs(xOffset)), yOffset)
	self.blackOverlay:lineTo((logicalW+math.abs(xOffset)), (logicalH+math.abs(yOffset)))
	self.blackOverlay:lineTo(xOffset, (logicalH+math.abs(yOffset)))
	self.blackOverlay:lineTo(xOffset,yOffset)
	self.blackOverlay:endPath()
	self.scene.outOfTimeBlackLayer:addChild(self.blackOverlay)
	self.blackOverlay:setAlpha(0)
	
	local tween = GTween.new(self.blackOverlay, 1, {alpha = .7})

	-- show sad face
	
	self.scene.hero:makeSad(true)
	
	self.heroScreenX, self.heroScreenY = self.scene.hero:localToGlobal(0,0)

	--self.blackOverlay:setPosition(self.scene.hero:getX()-self.heroScreenX,self.scene.hero:getY()-self.heroScreenY)
	
	-- move hero to frontLayer
	
	self.scene.frontLayer:addChild(self.scene.hero)
	
	collectgarbage()
	collectgarbage()

	Timer.delayedCall(2000, function() self.scene.hero:die() end)
	Timer.delayedCall(4000, function() sceneManager:changeScene("Game Over Out Of Time", 0, SceneManager.flipWithFade, easing.outBack) end)
	
	self.scene:dispatchEvent(Event.new("onExit", self.scene))
	self.scene.gameEnded = true
	
	-- hero parts
		
	self.scene.hero.frontArmAnimation:pauseAnimation()
	self.scene.hero.legs:pauseAnimation()
	self.scene.hero.ears:pauseAnimation()
	self.scene.hero.eyes:pauseAnimation()
	self.scene.hero.rearArm:pauseAnimation()
	
	self:stopAllSounds()
	
	else

		self.scene.secondsLeft = self.scene.secondsLeft -1;

		if(self.scene.secondsLeft== -1) then
			self.scene.secondsLeft = 59
			self.scene.minutesLeft = self.scene.minutesLeft - 1;
		end
			
		if(self.scene.secondsLeft < 10) then
			self.scene.secondsLeft = "0".. self.scene.secondsLeft
		end
		
	end
	
		
	if(tonumber(self.scene.minutesLeft) == 0  and tonumber(self.scene.secondsLeft) <= 30) then

		self.countdownText:setVisible(false)
		self.countdownTextRed:setVisible(true)
				
	else
			
		self.countdownText:setVisible(true)
		self.countdownTextRed:setVisible(false)
				
	end

	self.countdownText:setText(tostring(self.timeLeft));
	self.countdownTextRed:setText(tostring(self.timeLeft))
	--]]

end





function Countdown:stopAllSounds()

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

end




-- cleanup function

function Countdown:onExit()

	self.scene.countDown:stop()
	self.scene:removeEventListener("onExit", self.onExit, self)
	
end