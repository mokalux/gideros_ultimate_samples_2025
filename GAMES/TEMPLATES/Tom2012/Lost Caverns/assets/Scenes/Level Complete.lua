levelComplete = Core.class(Sprite)

function levelComplete:init()

	-- setup ad
	
	self.admob = Ads.new("admob")
	self.admob:setKey("8922743526077835/5905078139")
	self.admob:loadAd("interstitial", "ca-app-pub-8922743526077835/5905078139")
	self.admob:enableTesting()
	
	self.admob:addEventListener(Event.AD_RECEIVED, function() 
		print("received ad")
		self.adReceived = true
		
		self.admob:addEventListener(Event.AD_ACTION_END, self.changeLevel, self)
		self.admob:addEventListener(Event.AD_ACTION_END, self.changeLevel, self)
		self.admob:addEventListener(Event.AD_DISMISSED, self.changeLevel, self)
		
	end)
	
	
	
	self.admob:addEventListener(Event.AD_FAILED, function(e) 
		print("ad failed",e.error)

		
	end)


	collectgarbage()
	collectgarbage()
	collectgarbage()

	if(channel) then
		channel:setPaused(true)
	end

	Timer:stopAll() -- stop timers!
	--self.scene.vPad:stop()

	self.atlas = {}
	
	self.saveGame = dataSaver.load("|D|saveGame") -- load it
	--print(self.saveGame.levelMedals[11])
	--print(self.saveGame.test)

	local atlas4 = TexturePack.new("Atlases/Atlas 4.txt", "Atlases/Atlas 4.png", true);
	self.atlas[4] = atlas4
	
		-- Load volume setting
	
	local file = io.open("|D|saveGame.json", "r" )
	if(file) then

		self.saveGame = dataSaver.load("|D|saveGame") -- load it
		io.close( file )
		
		if(self.saveGame.soundVol) then
		
		self.soundVol = self.saveGame.soundVol
		self.musicVol = self.saveGame.musicVol
		
		else
		
			self.soundVol = defaultSoundVol
			self.musicVol = defaultMusicVol
		
		end
		
	else

		self.soundVol = defaultSoundVol
		self.musicVol = defaultMusicVol
		
	end
	
	-- SCALING SECTION
	
	self.scaleMode = application:getLogicalScaleX() -- will be 2 for 2x
	
	-- REMEMBER these values are for portrait, even if game is in landscape
	
	self.screenWidth = application:getDeviceHeight() / self.scaleMode
	self.screenHeight = application:getDeviceWidth() / self.scaleMode
	
	local logicalW = application:getLogicalHeight()
	local logicalH = application:getLogicalWidth()
	
	-- figure out aspect ratios on this device
	
	local aspectRatioX = self.screenWidth/logicalW
	local aspectRatioY = self.screenHeight/logicalH
	
	-- figure out x y offset
	
	xOffset = (logicalW - self.screenWidth) /2
	yOffset = (logicalH - self.screenHeight) /2


	-- set up sounds
	
	
	
	self.coinSound = Sound.new("Sounds/end level coin.wav")
	self.swoosh1 = Sound.new("Sounds/level complete swoosh.wav")
	self.swoosh2 = Sound.new("Sounds/end level menu swoosh.wav")
	

	-- for testing
	--lastLevelMedal = 3

	-- Set the delay before retry, menu, next are shown

	if(lastLevelMedal==1) then
		self.buttonDelay = 3000
	elseif(lastLevelMedal==2) then
		self.buttonDelay = 3500
	else
		self.buttonDelay = 4000
	end

	-- Medal BG Image
	
	local bgSprite = Sprite.new()
	self:addChild(bgSprite)

	local bg = Bitmap.new(self.atlas[4]:getTextureRegion("medal bg.png"))
	bgSprite:addChild(bg)
	bg:setPosition(78,100)

	self.behindBG = Sprite.new() -- make layer to move medals behind stone
	self:addChild(self.behindBG)

	--BG Image

	local bg = Bitmap.new(self.atlas[4]:getTextureRegion("bg.png"))
	bgSprite:addChild(bg)
	bgSprite:setScale(aspectRatioX, aspectRatioY)
	bgSprite:setPosition(xOffset,yOffset)

	--Header

	local header = Bitmap.new(self.atlas[4]:getTextureRegion("header.png"))
	header:setAnchorPoint(.5,.5)
	header:setScale(aspectRatioX, aspectRatioY)
	self:addChild(header)
	header:setPosition(application:getContentWidth()/2,-100)
	header:setScale(5)
	header:setAlpha(0)
	
	Timer.delayedCall(800, function()
		header:setAlpha(1)
		local tween = GTween.new(header, .15, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(38*aspectRatioY)+yOffset})
	end)
	
	Timer.delayedCall(600, self.playSwoosh1Sound, self)



	-- Retry

	local buttonImage = Bitmap.new(self.atlas[4]:getTextureRegion("retry.png"))
	buttonImage:setAnchorPoint(.5,.5)
	local buttonImagePressed = Bitmap.new(self.atlas[4]:getTextureRegion("retry-pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self:addChild(theButton)
	theButton:setPosition((78*aspectRatioX)+xOffset,(400*aspectRatioY)+yOffset)
	theButton:setScale(5)
	theButton:setVisible(false)
	theButton:addEventListener(Event.TOUCHES_END, self.retry, self)
	self.retryButton = theButton

	Timer.delayedCall(self.buttonDelay, function()
		theButton:setVisible(true)
		local tween = GTween.new(theButton, .1, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(273*aspectRatioY)+yOffset})
	end)
	
	Timer.delayedCall(self.buttonDelay, self.playSwoosh2Sound, self)

	-- Menu

	local buttonImage = Bitmap.new(self.atlas[4]:getTextureRegion("menu.png"))
	buttonImage:setAnchorPoint(.5,.5)
	local buttonImagePressed = Bitmap.new(self.atlas[4]:getTextureRegion("menu-pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self:addChild(theButton)
	theButton:setPosition((244*aspectRatioX)+xOffset,(400*aspectRatioY)+yOffset)
	theButton:setScale(5)
	theButton:setVisible(false)
	theButton:addEventListener(Event.TOUCHES_END, self.menu, self)
	self.menuButton = theButton

	Timer.delayedCall(self.buttonDelay+100, function()
		theButton:setVisible(true)
		local tween = GTween.new(theButton, .1, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(273*aspectRatioY)+yOffset})
	end)
	
	Timer.delayedCall(self.buttonDelay+100, self.playSwoosh2Sound, self)

	if(levelNum + 1 < 13) then
		-- Next

		local buttonImage = Bitmap.new(self.atlas[4]:getTextureRegion("next.png"))
		buttonImage:setAnchorPoint(.5,.5)
		local buttonImagePressed = Bitmap.new(self.atlas[4]:getTextureRegion("next-pressed.png"))
		buttonImagePressed:setAnchorPoint(.5,.5)
		local theButton = Button.new(buttonImage, buttonImagePressed)
		self:addChild(theButton)
		theButton:setPosition((402*aspectRatioX)+xOffset,(400*aspectRatioY)+yOffset)
		theButton:setScale(5)
		theButton:setVisible(false)
		theButton:addEventListener(Event.TOUCHES_END, self.next, self)
		self.nextButton = theButton

		Timer.delayedCall(self.buttonDelay+200, function()
			theButton:setVisible(true)
			local tween = GTween.new(theButton, .1, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(273*aspectRatioY)+yOffset})
		end)

		Timer.delayedCall(self.buttonDelay+200, self.playSwoosh2Sound, self)

	end


	--lastLevelMedal=3 --temp

	-- set up medals
	
	if(lastLevelMedal==nil) then
		lastLevelMedal = 0
	end

	if(lastLevelMedal>=1) then

		local medal = Bitmap.new(self.atlas[4]:getTextureRegion("big medal bronze.png"))
		self:addChild(medal)
		medal:setPosition((140*aspectRatioX)+xOffset,(167*aspectRatioY)+yOffset)
		medal:setAnchorPoint(.5,.5)
		medal:setScale(5*aspectRatioX)
		medal:setVisible(false)

		Timer.delayedCall(2000, function()
			medal:setVisible(true)
			local tween = GTween.new(medal, .15, {scaleX=aspectRatioX,scaleY=aspectRatioY})
			tween:addEventListener("complete", self.playCoinSound, self)
			tween.dispatchEvents = true
		end)

		--Timer.delayedCall(2150, function() self.behindBG:addChild(medal) end)

	end


	if(lastLevelMedal>=2) then

		local medal = Bitmap.new(self.atlas[4]:getTextureRegion("big medal silver.png"))
		self:addChild(medal)
		medal:setAnchorPoint(.5,.5)
		medal:setPosition((240*aspectRatioX)+xOffset,(167*aspectRatioY)+yOffset)
		medal:setScale(5*aspectRatioX)
		medal:setVisible(false)

		Timer.delayedCall(2500, function()
			medal:setVisible(true)
			local tween = GTween.new(medal, .15, {scaleX=aspectRatioX,scaleY=aspectRatioY})
			tween:addEventListener("complete", self.playCoinSound, self)
			tween.dispatchEvents = true
		end)

		--Timer.delayedCall(2650, function() self.behindBG:addChild(medal) end)

	end

	if(lastLevelMedal==3) then

		local medal = Bitmap.new(self.atlas[4]:getTextureRegion("big medal gold.png"))
		self:addChild(medal)
		medal:setAnchorPoint(.5,.5)
		medal:setPosition((341*aspectRatioX)+xOffset,(167*aspectRatioY)+yOffset)
		medal:setScale(5*aspectRatioX)
		medal:setVisible(false)

		Timer.delayedCall(3000, function()
			medal:setVisible(true)
			local tween = GTween.new(medal, .15, {scaleX=aspectRatioX,scaleY=aspectRatioY})
			tween:addEventListener("complete", self.playCoinSound, self)
			tween.dispatchEvents = true
		end)
		
		--Timer.delayedCall(3150, function() self.behindBG:addChild(medal) end)
		
	end

	fadeFromBlack()
	

	
	collectgarbage()
	
	--------------------------------------------------------------
	-- Setup music
	--------------------------------------------------------------
	
	if(playMusic) then
		levelMusicPlaying = true -- set global variable
		local myMusic = Sound.new("Music/level complete.mp3");
		channel = myMusic:play(0, 1)
		channel:setVolume(.5*self.musicVol)
	end

end




function levelComplete:playCoinSound()

	local channel1 = self.coinSound:play()
	channel1:setVolume(.3*self.soundVol)

end



function levelComplete:playSwoosh1Sound()

	local channel1 = self.swoosh1:play()
	channel1:setVolume(.3*self.soundVol)

end



function levelComplete:playSwoosh2Sound()

	if(channel1) then
		local channel1 = self.swoosh2:play()
		channel1:setVolume(.3*self.soundVol)
	end
	
end




function levelComplete:retry(event)

	if(self.retryButton:hitTestPoint(event.touch.x, event.touch.y)) then
	
		if(not(self.nextScene)) then
		
			fadeToBlack()
			
			self:pressButton()
			
			self.nextScene = "Level "..levelNum
		
			Timer.delayedCall(500, function()
				self:showAd()
			end)

		end
	end

end



function levelComplete:menu(event)

	if(self.menuButton:hitTestPoint(event.touch.x, event.touch.y)) then
	
		if(not(self.nextScene)) then
		
			fadeToBlack()
			
			self:pressButton()
	
			self.nextScene = "Menu"
			
			Timer.delayedCall(500, function()
				self:showAd()
			end)

		end
	end

end





function levelComplete:next(event)

	if(self.nextButton:hitTestPoint(event.touch.x, event.touch.y)) then
	
		if(not(self.nextScene)) then
		
			fadeToBlack()
			
			self:pressButton()
			
			print("just completed",levelNum)
			--if(levelNum ~= 1) then
				levelNum = levelNum + 1
			--end
			print("next",levelNum)
			
			self.nextScene = "Level "..levelNum
		
			Timer.delayedCall(500, function()
				self:showAd()
			end)

		end
	end

end





function levelComplete:showAd()
	
	if(self.adReceived) then
		self.admob:showAd("interstitial")
	else
	
		self:changeLevel()
	
	end
	
end



function levelComplete:pressButton()

	playSound("Sounds/button-press.wav",.8*self.soundVol)

end




function levelComplete:changeLevel()

	Timer:stopAll()
	sceneManager:changeScene(self.nextScene, 0, SceneManager.flipWithFade, easing.outBack)
	
	collectgarbage()
	collectgarbage()
	collectgarbage()
	
end





