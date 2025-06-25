settings = Core.class(Sprite)

function settings:init()

	Timer:stopAll() -- stop timers!
	
	--TESTING
--[[
	self.saveGame = {}
	dataSaver.save("|D|saveGame", self.saveGame) -- save data
	--]]


	-- Setup music

	Timer:stopAll() -- stop timers!

	self.atlas = {}
	local atlas = TexturePack.new("Atlases/settings screen.txt", "Atlases/settings screen.png", true)
	self.atlas = atlas
	
	-- set BG
	
	local bg = Bitmap.new(self.atlas:getTextureRegion("settings bg.png"))
	bg:setScaleX(aspectRatioX)
	bg:setScaleY(aspectRatioY)
	bg:setAnchorPoint(.5,.5)
	bg:setPosition(logicalW/2,logicalH/2)
	self:addChild(bg)
	
	-- settings text

	local img = Bitmap.new(self.atlas:getTextureRegion("settings text.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(logicalW/2,38)
	self:addChild(img)
	
	-- sound text
	
	local img = Bitmap.new(self.atlas:getTextureRegion("sound text.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(110,140)
	self:addChild(img)
	
	-- sound slider
	
	local img = Bitmap.new(self.atlas:getTextureRegion("stone slider 1.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(300,138)
	self:addChild(img)
	
	-- sound chip
	
	local img = Bitmap.new(self.atlas:getTextureRegion("stone chip 1.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(300,138)
	self:addChild(img)
	self.soundChip = img
	
	-- music text
	
	local img = Bitmap.new(self.atlas:getTextureRegion("music text.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(110,210)
	self:addChild(img)
	
	-- sound slider
	
	local img = Bitmap.new(self.atlas:getTextureRegion("stone slider 1.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(300,206)
	self:addChild(img)
	
	self.minX = img:getX() - (img:getWidth()/2)+20
	self.maxX = img:getX() + (img:getWidth()/2)-20
	self.sliderWidth = self.maxX - self.minX
	self.onePerc = self.sliderWidth / 100

	
	-- music chip
	
	local img = Bitmap.new(self.atlas:getTextureRegion("stone chip 1.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(300,208)
	self:addChild(img)
	self.musicChip = img
	
	self:addEventListener(Event.TOUCHES_BEGIN, self.moveChip, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.touchMove, self)
	self:addEventListener(Event.TOUCHES_END, self.endTouch, self)
	

	-- Buttons

	local buttonImage = Bitmap.new(self.atlas:getTextureRegion("back icon.png"))
	buttonImage:setAnchorPoint(.5,.5)
	
	local buttonImagePressed = Bitmap.new(self.atlas:getTextureRegion("back icon pressed.png"))
	buttonImagePressed:setAnchorPoint(.5,.5)
	
	local theButton = Button.new(buttonImage, buttonImagePressed)
	self:addChild(theButton)
	theButton:setScale(aspectRatioX,aspectRatioY)
	
	theButton:setPosition(application:getContentWidth()/2,(application:getContentHeight()-31*aspectRatioY)-yOffset)
	self.retryButton = theButton

	theButton:addEventListener(Event.TOUCHES_END, self.play, self)
	
	



	-- Get the current volumes
	

		
		
		
	-- Load volume setting
	
	local file = io.open("|D|saveGame.json", "r" )
	if(file) then

		self.saveGame = dataSaver.load("|D|saveGame") -- load it
		io.close( file )
		
		if(self.saveGame.soundVol) then
		
		--print(self.saveGame.soundVol,self.saveGame.musicVol)
		
		self.soundVol = self.saveGame.soundVol
		self.musicVol = self.saveGame.musicVol
		
		else
		
			self.soundVol = defaultSoundVol
			self.musicVol = defaultMusicVol
		
		end
		
		self:setVol(self.soundVol,self.musicVol)
		self:saveVol(self.soundVol,self.musicVol)
		
	else

		self.soundVol = defaultSoundVol
		self.musicVol = defaultMusicVol
		
	end
		
		
		
		
		
		
		
		
		
		
		
	
	fadeFromBlack()
	
	

end




function settings:setVol(soundVol,musicVol)

	self.soundChip:setX(self.minX+(self.onePerc * soundVol * 100))
	self.musicChip:setX(self.minX+(self.onePerc * musicVol * 100))
	
	
	print(self.minX+(self.onePerc * soundVol * 100))
	
	print(self.onePerc)

end




function settings:saveVol(soundVol,musicVol)

	--print("save",soundVol, musicVol)
	
	-- SAVING SECTION
	
	-- Check file exists and load it
	
	local file = io.open("|D|saveGame.json", "r" )
	
	if(file) then
		print("|D|saveGame.json DOES exist")
		self.saveGame = dataSaver.load("|D|saveGame") -- load it

	else
		print("|D|saveGame.json does not exist")
		self.saveGame = {} -- create blank table
	end
	
	self.saveGame.soundVol = self.soundVol
	self.saveGame.musicVol = self.musicVol
	
	--self.scene.saveGame = {} -- RESET EVERYTHING
	dataSaver.save("|D|saveGame", self.saveGame) -- save data
	
	--io.close(file)

end





function settings:touchMove(event)

	if(self.moving) then
		self.moving:setX(event.touch.x)
		if(self.moving:getX()>self.maxX) then
			self.moving:setX(self.maxX)
		elseif(self.moving:getX()<self.minX) then
			self.moving:setX(self.minX)
		end
		
		local xOnSlider = self.soundChip:getX()-self.minX
		self.soundVol = xOnSlider / self.onePerc / 100

		local xOnSlider = self.musicChip:getX()-self.minX
		self.musicVol = xOnSlider / self.onePerc / 100
		
		-- set theme volume
		if(channel) then
			channel:setVolume(.8*self.musicVol)
		end
		
	end


end


function settings:moveChip(event)

	if(self.soundChip:hitTestPoint(event.touch.x, event.touch.y) and not(self.moving)) then
		
		self.moving = self.soundChip
		self.touchId = event.touch.id

	elseif(self.musicChip:hitTestPoint(event.touch.x, event.touch.y)) then
	
		self.moving = self.musicChip
		self.touchId = event.touch.id
	
	
	end
	
end



function settings:endTouch(event)

	if(self.moving) then

		self:saveVol(self.soundVol,self.musicVol)
		
		if(self.moving == self.soundChip) then
			playSound("Sounds/coin 1.wav",.2*self.soundVol)
		end
		
		self.moving = nil
		
	end

end



function settings:play(event)

	if(self.retryButton:hitTestPoint(event.touch.x, event.touch.y)) then
	
		if(not(self.pressedButton)) then
	
			self.pressedButton = true
		
			playSound("Sounds/button-press.wav",.8*self.soundVol)

			fadeToBlack()
			
			local worldNum = 1
			
			self.theLevel = "Menu"
			Timer.delayedCall(600, self.changeLevel, self)
			
		end

	end

end







function settings:changeLevel()

	Timer:stopAll()
	sceneManager:changeScene(self.theLevel, 0, SceneManager.flipWithFade, easing.outBack)

end




