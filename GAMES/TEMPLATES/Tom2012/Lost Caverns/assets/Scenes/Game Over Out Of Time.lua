gameOverOutOfTime = Core.class(Sprite)

function gameOverOutOfTime:init()

	-- setup ad
	
	self.admob = Ads.new("admob")
	self.admob:setKey("8922743526077835/5905078139")
	self.admob:loadAd("interstitial", "ca-app-pub-8922743526077835/5905078139")
	--admob:enableTesting()
	
	self.admob:addEventListener(Event.AD_RECEIVED, function() 
		print("received ad")
		self.adReceived = true
		
		self.admob:addEventListener(Event.AD_ACTION_END, self.changeLevel, self)
		self.admob:addEventListener(Event.AD_ACTION_END, self.changeLevel, self)
		self.admob:addEventListener(Event.AD_DISMISSED, self.changeLevel, self)
		
	end)
	
	self.admob = admob

	Timer:stopAll() -- stop timers!

	collectgarbage()
	collectgarbage()

	self.atlas = {}

	local atlas = TexturePack.new("Atlases/Out Of Time.txt", "Atlases/Out Of Time.png", true)
	self.atlas = atlas
	
	if(channel) then
		channel:setPaused(true)
	end
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




	--BG Image

	local bg = Bitmap.new(self.atlas:getTextureRegion("bg.png"))
	self:addChild(bg)
	bg:setScale(aspectRatioX, aspectRatioY)
	bg:setPosition(xOffset,yOffset)


	--Header

	local header = Bitmap.new(self.atlas:getTextureRegion("out of time.png"))
	header:setAnchorPoint(.5,.5)
	header:setScale(aspectRatioX, aspectRatioY)
	self:addChild(header)
	header:setPosition(application:getContentWidth()/2,-100)
	header:setScale(5)
	header:setAlpha(0)
	
	Timer.delayedCall(800, function()
		header:setAlpha(1)
		local tween = GTween.new(header, .15, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(33*aspectRatioY)+yOffset})
	end)





	-- Menu

	local buttonImage = Bitmap.new(self.atlas:getTextureRegion("menu.png"))
	buttonImage:setAnchorPoint(.5,.5)
	local buttonImagePressed = Bitmap.new(self.atlas:getTextureRegion("menu-pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self:addChild(theButton)
	theButton:setPosition((154*aspectRatioX)+xOffset,(400*aspectRatioY)+yOffset)
	self.menuButton = theButton

	theButton:addEventListener(Event.TOUCHES_END, self.goToMenu, self)
	

	Timer.delayedCall(2000, function()
		theButton:setAlpha(1)
		local tween = GTween.new(theButton, .1, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(284*aspectRatioY)+yOffset})
	end)



		-- Retry

	local buttonImage = Bitmap.new(self.atlas:getTextureRegion("retry.png"))
	buttonImage:setAnchorPoint(.5,.5)
	local buttonImagePressed = Bitmap.new(self.atlas:getTextureRegion("retry-pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self:addChild(theButton)
	theButton:setPosition((315*aspectRatioX)+xOffset,(400*aspectRatioY)+yOffset)
	
	self.retryButton = theButton
	
	theButton:addEventListener(Event.TOUCHES_END, self.retry, self)
	
	Timer.delayedCall(2100, function()
		local tween = GTween.new(theButton, .1, {scaleX=aspectRatioX,scaleY=aspectRatioY,y=(284*aspectRatioY)+yOffset})
	end)

	fadeFromBlack()
	
	--------------------------------------------------------------
	-- Setup music
	--------------------------------------------------------------
	
	if(playMusic) then
		levelMusicPlaying = true -- set global variable
		local myMusic = Sound.new("Music/game over.mp3");
		channel = myMusic:play(0, 1)
		channel:setVolume(.5*self.musicVol)
	end

end




function gameOverOutOfTime:goToMenu(event)

	if(self.menuButton:hitTestPoint(event.touch.x, event.touch.y)) then
	
		if(not(self.pressedButton)) then
		
			self.pressedButton = true
			
			fadeToBlack()
			
			unloadAtlas("all")

			--self:doResume()
			event:stopPropagation()
			playSound("Sounds/button-press.wav",.8*self.soundVol)
			fadeToBlack()
			self.theLevel = "Menu"
			
			Timer.delayedCall(500, function()
				self:showAd()
			end)
		
		end
		
	end

end




function gameOverOutOfTime:retry(event)

	if(self.retryButton:hitTestPoint(event.touch.x, event.touch.y)) then
	
		if(not(self.pressedButton)) then
	
			self.pressedButton = true

			fadeToBlack()
			self.theLevel = "Level "..levelNum
			
			Timer.delayedCall(500, function()
				self:showAd()
			end)
		
		end

	end

end


function gameOverOutOfTime:changeLevel()

	Timer:stopAll()
	sceneManager:changeScene(self.theLevel, 0, SceneManager.flipWithFade, easing.outBack)

end



function gameOverOutOfTime:showAd()

	fadeToBlack()
	
	if(self.adReceived) then
		self.admob:showAd("interstitial")
	else
		self:changeLevel()
	end
	
end









