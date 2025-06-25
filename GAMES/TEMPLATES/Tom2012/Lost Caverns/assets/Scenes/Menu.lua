menu = Core.class(Sprite)

function menu:init()

	application:setBackgroundColor(0x000000)

	collectgarbage()
	collectgarbage()
	collectgarbage()

-- load modules

print("********* MENU *********")




	--TESTING, reset save file
--[[
	self.saveGame = {}
	self.saveGame.levelMedals = {}
	self.saveGame.levelMedals[1]=1
	self.saveGame.levelMedals[2]=2
	self.saveGame.levelNumber=2
	dataSaver.save("|D|saveGame", self.saveGame) -- save data
--]]

	Timer:stopAll() -- stop timers!
	
	if(channel and currentTrack ~= "title track") then
		currentTrack = nil
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
	

	-- Setup music
--	if(not introPlaying) then
	--	introPlaying = true -- set global variable
	if(playMusic and currentTrack ~= "title track") then
--		local myMusic = Sound.new("Music/intro.mp3")
--		currentTrack = "title track"
--		channel = myMusic:play(0, math.huge)
--		channel:setVolume(.6*self.musicVol)
	end
	
	Timer:stopAll() -- stop timers!

	-- Bring in atlases
	unloadAtlas("all")
	
	self.atlas = {}
	local atlas = TexturePack.new("Atlases/menu screen.txt", "Atlases/menu screen.png", true)
	self.atlas = atlas

	-- build graphics
	
	local mainSprite = Sprite.new() -- used for scaling
	self:addChild(mainSprite)


	local menuBG = Bitmap.new(Texture.new("gfx/title image.png", true))
	menuBG:setAnchorPoint(.5,.5)
	menuBG:setPosition(logicalW/2,logicalH/2)
	mainSprite:addChild(menuBG)
	
	-- Play
--	local buttonImage = Bitmap.new(self.atlas:getTextureRegion("play.png"))
--	buttonImage:setAnchorPoint(.5,.5)
--	local buttonImagePressed = Bitmap.new(self.atlas:getTextureRegion("play pressed.png"))
--	buttonImagePressed:setAnchorPoint(.5,.5)
--	local theButton = Button.new(buttonImage, buttonImagePressed)
--	mainSprite:addChild(theButton)
--	theButton:setPosition((application:getContentWidth()/2)+4,287)
--	self.playButton = theButton
--	theButton:addEventListener(Event.TOUCHES_END, self.play, self)
	
	-- Settings
--	local buttonImage = Bitmap.new(self.atlas:getTextureRegion("settings.png"))
--	buttonImage:setAnchorPoint(.5,.5)
--	local buttonImagePressed = Bitmap.new(self.atlas:getTextureRegion("settings pressed.png"))
--	buttonImagePressed:setAnchorPoint(.5,.5)
--	local theButton = Button.new(buttonImage, buttonImagePressed)
--	mainSprite:addChild(theButton)
--	theButton:setPosition(74,290)
--	self.settingsButton = theButton
	-- scale screen
	mainSprite:setScaleX(aspectRatioX)
	mainSprite:setScaleY(aspectRatioY)
	mainSprite:setPosition(xOffset,yOffset)
--	theButton:addEventListener(Event.TOUCHES_END, self.goToSettings, self)
	fadeFromBlack()
end

function menu:play(event)
	if(self.playButton:hitTestPoint(event.touch.x, event.touch.y)) then
		if(not(self.pressedButton)) then
			self.pressedButton = true
--			playSound("Sounds/button-press.wav",.8*self.soundVol)
			fadeToBlack()
			local worldNum = 1
			self.theLevel = "Level Select World 1"
			Timer.delayedCall(600, self.changeLevel, self)
		end
	end
end

function menu:goToSettings(event)
	if(self.settingsButton:hitTestPoint(event.touch.x, event.touch.y)) then
		if(not(self.pressedButton)) then
			self.pressedButton = true
--			playSound("Sounds/button-press.wav",.8*self.soundVol)
			fadeToBlack()
			local worldNum = 1
			self.theLevel = "Settings"
			Timer.delayedCall(600, self.changeLevel, self)
		end
	end
end

function menu:changeLevel()
	Timer:stopAll()
	sceneManager:changeScene(self.theLevel, 0, SceneManager.flipWithFade, easing.outBack)
end
