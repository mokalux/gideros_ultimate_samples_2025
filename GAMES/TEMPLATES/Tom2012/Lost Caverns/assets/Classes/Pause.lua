Pause = Core.class(Sprite);

function Pause:init(scene)

	self.scene = scene
	self.scene.paused = false
	self.type = pause

	local pauseButton = Bitmap.new(self.scene.atlas[2]:getTextureRegion("pause.png"));
	pauseButton:setAnchorPoint(.5,.5)
	self:addChild(pauseButton)
	pauseButton:setPosition(xOffset+(455*aspectRatioX),yOffset+(19*aspectRatioY))
	
	
	self.pauseButton = pauseButton

	self:addEventListener(Event.TOUCHES_END, self.touchPause, self)
	
	-- Build the paused menu
	
	self.blackOverlay = Shape.new()
	self.blackOverlay:setFillStyle(Shape.SOLID, 0x000000)       
	self.blackOverlay:beginPath()
	self.blackOverlay:moveTo(xOffset,yOffset)
	self.blackOverlay:lineTo((logicalW+math.abs(xOffset)), yOffset)
	self.blackOverlay:lineTo((logicalW+math.abs(xOffset)), (logicalH+math.abs(yOffset)))
	self.blackOverlay:lineTo(xOffset, (logicalH+math.abs(yOffset)))
	self.blackOverlay:lineTo(xOffset,yOffset)
	self.blackOverlay:endPath()
	--self:addChild(blackOverlay)

	self.scene.blackLayer:addChild(self.blackOverlay)

	-- create a layer to store the interface

	self.pausedMenu = Sprite.new()
	self.scene.topLayer:addChild(self.pausedMenu)

	local pausedHeader = Bitmap.new(self.scene.atlas[2]:getTextureRegion("paused header.png"));
	pausedHeader:setAnchorPoint(.5,.5)
	pausedHeader:setPosition(application:getContentWidth()/2, 40)
	self.pausedMenu:addChild(pausedHeader)

	local resume = Bitmap.new(self.scene.atlas[2]:getTextureRegion("paused resume.png"));
	resume:setAnchorPoint(.5,.5)
	resume:setPosition(application:getContentWidth()/2, 110)
	self.pausedMenu:addChild(resume)
	self.resume = resume
	resume:addEventListener(Event.TOUCHES_END, self.resumeButton, self)

	local restart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("paused restart.png"));
	restart:setAnchorPoint(.5,.5)
	restart:setPosition(application:getContentWidth()/2, 180)
	self.pausedMenu:addChild(restart)
	self.restart = restart
	restart:addEventListener(Event.TOUCHES_END, self.restartLevel, self)

	local menu = Bitmap.new(self.scene.atlas[2]:getTextureRegion("paused menu.png"));
	menu:setAnchorPoint(.5,.5)
	menu:setPosition(application:getContentWidth()/2, 250)
	self.menu = menu
	self.pausedMenu:addChild(menu)
	menu:addEventListener(Event.TOUCHES_END, self.goToMenu, self)

	--self.pausedMenu:setAlpha(0)
	self.pausedMenu:setVisible(false)
	self.pauseMenuVisible = false
	
	self.blackOverlay:setAlpha(0)
	
	-- sound
	
		if(not(self.scene.pauseSound)) then
	
		self.scene.pauseSound = Sound.new("Sounds/pause.wav")
		
	end
	


end




-- Function to handle touching pause button
-- Handles both pause and un-pause

function Pause:touchPause(event)

	if(self.pauseButton:hitTestPoint(event.touch.x,event.touch.y) and not(self.scene.signShowing) and not(self.scene.showingExitOverlay)) then
	
		self.touchedPause = true
	
		if(not(self.scene.paused)) then
	
			self:doPause()
			
		else
		
			self:doResume()
			
		end
		
	end

end




-- pause all the tweens

function Pause:pauseTweens()

	if(self.scene.paused) then
		GTween.pauseAll = true
	end

end


-- function to do the pause

function Pause:doPause(ignoreSound)

	if(channel and not(self.scene.heroTouchingDoor) and not(self.scene.signShowing)) then
		channel:setPaused(true)
	end
	
	self.scene:dispatchEvent(Event.new("onPause", self.scene))

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

	if(not(ignoreSound)) then
		local channel1 = self.scene.pauseSound:play()
		channel1:setVolume(.3*self.scene.soundVol)
	end

	-- Pause timers
	Timer.pauseAll()
	
	if(self.scene.heroTouchingDoor) then
		self.alpha = .75
	else
		self.alpha = .5
	end

	if(not(self.scene.signShowing) and self.touchedPause == true) then
	
		self.pausedMenu:setVisible(true)
		self.pauseMenuVisible = true
		self.tween1 = GTween.new(self.pausedMenu, .2, {alpha=1.2})
	end
	
	self.scene.paused = true

	self.tween2 = GTween.new(self.blackOverlay, .2, {alpha=self.alpha})
	self.tween2:addEventListener("complete", self.pauseTweens, self)
	self.tween2.dispatchEvents = true
	
	-- vpad
			
	--self.scene.vPad:setPosition(PAD.COMPO_RIGHTPAD, -1000, -1000) -- move off screen
	
	self.scene.controls:setAlpha(0)
		

	
	-- Pause emitters
	
	for i,v in pairs(self.scene.particleEmitters) do
		v:pause(true)
	end
	


		
	-- hero parts
		
	self.scene.hero.frontArmAnimation:pauseAnimation()
	self.scene.hero.legs:pauseAnimation()
	self.scene.hero.ears:pauseAnimation()
	self.scene.hero.eyes:pauseAnimation()
	self.scene.hero.rearArm:pauseAnimation()
	
	-- pause all sounds
	
	self:stopAllSounds()
	

	
end




-- Function to do the resume

function Pause:doResume(ignoreSound)

	self.scene:dispatchEvent(Event.new("onResume", self.scene))
	
	if(self.touchedPause) then
		self.touchedPause = nil
	end

	if(channel and not(self.ignoreTheme)) then
		channel:setPaused(false)
	end

	if(not(ignoreSound)) then
		local channel1 = self.scene.pauseSound:play()
		channel1:setVolume(.3*self.scene.soundVol)
	end

	-- Resume timers
	Timer.resumeAll()

	-- reset touch holders so character stops running after pause
	
	--self.scene.rightButtonTouches = {}
	--self.scene.leftButtonTouches = {}

	self.scene.paused = false
	

	--GTween
	GTween.pauseAll = false
	--print("resmue all")
	
	-- Put any here that need pausing

	if(self.scene.gameEnded) then
		self.scene.heroAnimation:stopBob()
	end



	-- Unpause
	
	if(self.tween1) then
		self.tween1:setPaused(true)
	end
	
	self.tween2:setPaused(true)
	self.tween1 = GTween.new(self.pausedMenu, .2, {alpha=0})
	self.tween2 = GTween.new(self.blackOverlay, .2, {alpha=0})
	Timer.delayedCall(200, function()
		self.pausedMenu:setVisible(false)
		self.pauseMenuVisible = false
	end)
	self.tween2.dispatchEvents = true

	self.scene.controls:setAlpha(.6) -- show controls

	
	-- Un-pause emitters
	
	for i,v in pairs(self.scene.particleEmitters) do
		v:pause(false)
	end
	

	
	-- hero parts
	
	if(not(self.scene.gameEnded)) then
		self.scene.hero.frontArmAnimation:unPauseAnimation()
		self.scene.hero.legs:unPauseAnimation()
		self.scene.hero.ears:unPauseAnimation()
		self.scene.hero.eyes:unPauseAnimation()
		self.scene.hero.rearArm:unPauseAnimation()
	end
	
		-- Stop moving up
	
	self.scene.interface:stopMovingUp()

end





function Pause:resumeButton(event)

	if(not(self.scene.signShowing)) then
		if(self.resume:hitTestPoint(event.touch.x, event.touch.y) and self.scene.paused and self.pauseMenuVisible) then

			self:doResume()
			event:stopPropagation()

		end
	end
	
end



function Pause:restartLevel(event)

	if(self.restart:hitTestPoint(event.touch.x, event.touch.y) and self.scene.paused and self.pauseMenuVisible) then
	
		-- remove all running sounds
		
	--	self.scene.volumeByDistance:kill()
		
		health = 4
		self.scene.gameEnded = true
		self:doResume()
		
		self.scene:dispatchEvent(Event.new("onExit", self.scene))
		self.scene.gameEnded = true
		self.scene.spritesWithVolume = {}
		
		event:stopPropagation()
		playSound("Sounds/button-press.wav",.8*self.scene.soundVol)
		fadeToBlack()
		self.theLevel = "Level "..levelNum
		
		
		Timer.delayedCall(600, self.changeLevel, self)
		
	end

end



function Pause:goToMenu(event)

	if(self.menu:hitTestPoint(event.touch.x, event.touch.y) and self.scene.paused and self.pauseMenuVisible) then
	
		health = 4
		
		-- Resume timers
		self.scene.gameEnded = true
		self.ignoreTheme = true
		self:doResume()
		
		self.scene:dispatchEvent(Event.new("onExit", self.scene))

		self.scene.spritesWithVolume = {}
		
		event:stopPropagation()
		playSound("Sounds/button-press.wav",.8*self.scene.soundVol)
		fadeToBlack()
		self.theLevel = "Menu"
		Timer.delayedCall(600, self.changeLevel, self)
		
		-- clear out atlasHolder
		
		unloadAtlas("all")
		
	end

end


function Pause:changeLevel()

	-- stop all timers
	Timer:stopAll()
	sceneManager:changeScene(self.theLevel, 0, SceneManager.flipWithFade, easing.outBack)

end


function Pause:stopAllSounds()

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