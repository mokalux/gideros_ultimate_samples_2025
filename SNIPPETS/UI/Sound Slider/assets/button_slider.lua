ButtonSlider = Core.class(Sprite)

function ButtonSlider:init(type)
	local display = Bitmap.new(Texture.new("slider_button.png"))
	self:addChild(display)
	display:setAnchorPoint(0.5, 0.5)
	
	self.clicked = false
	self.type = type
	self.vol = 1
	
	self:addEventListener(Event.MOUSE_DOWN, self.click, self)
	self:addEventListener(Event.MOUSE_UP, self.release, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.removed, self)
end
function ButtonSlider:click(e)
	if self:hitTestPoint(e.x, e.y) then
		if self.type == "sound" then
			playSoundForMenu ()
			--makeSound("click")
		elseif self.type == "music" then
			playMusicForMenu ()
		elseif self.type == "music_game" then
			playMusicForPauseMenu ()
		elseif self.type == "sound_game" then
			playSoundForPauseMenu ()
		end
		
		self.clicked = true
		self:addEventListener(Event.MOUSE_MOVE, self.slide, self)
		--self:addEventListener(Event.ENTER_FRAME, self.release, self)
	end
end
function ButtonSlider:release()	
	if self.clicked then
		if self.type == "music" then
			stopMusicForMenu()
		elseif self.type == "sound" or self.type == "sound_game" then
			stopSoundForMenu()
		elseif self.type == "music_game" then
			stopMusicForPauseMenu()
		elseif self.type == "sound_game" then
			stopSoundForPauseMenu()
		end
		self:removeEventListener(Event.MOUSE_MOVE, self.slide, self)
	end
end
function ButtonSlider:slide(e)
	self:setX(e.x-160)
	if self:getX() > 80 then
		self:setX(80)
	elseif self:getX() < - 80 then
		self:setX(-80)
	end
	self.vol = (self:getX() + 80) / 160
	if self.type == "sound" then
		setSoundVol(self.vol)
	elseif self.type == "music" then
		--print("vol ", self.vol)
		--stage.music_vol = self.vol
		setMusicVol(self.vol)
	elseif self.type == "sound_game" then
		setSoundVol(self.vol)
	elseif self.type == "music_game" then
		setMusicVol(self.vol)
	end
	--print(e.x)
end
function ButtonSlider:removed ()
	self:removeEventListener(Event.MOUSE_DOWN, self.click, self)
	self:removeEventListener(Event.MOUSE_UP, self.release, self)
end