splashScreen = Core.class(Sprite)

function splashScreen:init()

application:setBackgroundColor(0x5b5b5b)

-- load modules

print("********* Splash screen *********")

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
	
	unloadAtlas("all")
	
	local menuBG = Bitmap.new(Texture.new("gfx/splash.png", true))
	menuBG:setAnchorPoint(.5,.5)
	menuBG:setPosition(logicalW/2,logicalH/2)
	self:addChild(menuBG)
	
	fadeFromBlack()
	
	-- add atlas 2 (used every level)
	loadAtlas(2,"Atlas 2")
	
	Timer.delayedCall(1500, self.next, self)


end




function splashScreen:next(event)

	fadeToBlack()
	
	local worldNum = 1
	
	self.theLevel = "splashGideros"
	Timer.delayedCall(1000, self.changeLevel, self)
	
end





function splashScreen:changeLevel()

	Timer:stopAll()
	sceneManager:changeScene(self.theLevel, 0, SceneManager.flipWithFade, easing.outBack)

end

