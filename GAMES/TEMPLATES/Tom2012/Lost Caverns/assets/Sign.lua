Sign = Core.class(Sprite);

function Sign:init(scene,text,atlas)

	self.scene = scene

	local sign = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("sign.png"))
	sign:setAnchorPoint(.5,.5)
	self:addChild(sign)
	self.sign = sign

	self.text = text
	self.scene.behindRube:addChild(self)

	-- add the background

	self.signSprite = Sprite.new()
	self.scene.topLayer:addChild(self.signSprite)

	local signBG = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("sign large.png"));
	signBG:setAnchorPoint(.5,.5)
	signBG:setPosition(application:getContentWidth()/2,application:getContentHeight()/2)
	self.signSprite:addChild(signBG)
	self.signBG = signBG

	local signText = BMTextField.new(self.scene.signTextFont, self.text, 300*self.scene.deviceScale, "center")
	signText:setScale(self.scene.scalex, self.scene.scaley)
	self.signSprite:addChild(signText)
	self.signText = signText
	
	-- Now work out vertical align
	
	local textH = signText:getHeight()
	
	if(textH>20) then
		self.vAlign = 130
	end
	
	if(textH>44) then
		self.vAlign = 123
	end
	
	if(textH>65) then
		self.vAlign = 110
	end
	
	if(textH>90) then
		self.vAlign = 93
	end
	
	self.signText:setPosition(100,self.vAlign)
	
	--print(signText:getHeight())

	self.signSprite:setAlpha(0)
	self.signSprite:setVisible(false)

	self.status = "hidden"

	self.scene.topLayer:addEventListener(Event.TOUCHES_BEGIN, self.touchesBegin,self)
	self.scene.topLayer:addEventListener(Event.TOUCHES_END, self.touchesEnd,self)
	self.signBG:addEventListener(Event.TOUCHES_END, self.closeSign, self)
	
	-- set up claw sound
	
	if(not(self.scene.touchSignSound)) then
	
		self.scene.touchSignSound = Sound.new("Sounds/touch sign.wav")
		self.scene.touchSignCloseSound = Sound.new("Sounds/touch sign close.wav")
	end
	


end


function Sign:touchesBegin(event)

	if(self.sign:hitTestPoint(event.touch.x, event.touch.y) and not (self.scene.paused) and not(self.scene.touchingSign)) then
	
		self.ignoreTouch = false
		
		-- Now check each control to make sure the touch was not on that
		-- As we want the controls to trigger any touches rather than the sign
		-- If they are overlapping
	
		if(event.touch.x > self.scene.interface.upButtonX - 50
		and event.touch.x < self.scene.interface.upButtonX + 50
		and event.touch.y > self.scene.interface.upButtonY - 50
		and event.touch.y < self.scene.interface.upButtonY + 50) then
		
			self.ignoreTouch = true

		end
		
		
		if(event.touch.x > self.scene.interface.joypadX - 50
		and event.touch.x < self.scene.interface.joypadX + 50
		and event.touch.y > self.scene.interface.joypadY - 50
		and event.touch.y < self.scene.interface.joypadY + 50) then
		
			self.ignoreTouch = true

		end

		-- Now check L/R buttons
		
		if(self.scene.leftButton:hitTestPoint(event.touch.x, event.touch.y))
		or(self.scene.leftButtonPressed:hitTestPoint(event.touch.x, event.touch.y))
		or(self.scene.rightButton:hitTestPoint(event.touch.x, event.touch.y))
		or(self.scene.rightButtonPressed:hitTestPoint(event.touch.x, event.touch.y))
		 then
			print("no")
			self.ignoreTouch = true
		end



		if(not(self.ignoreTouch)) then

			--print("touch was on sign")
			local channel1 = self.scene.touchSignSound:play()
			channel1:setVolume(.4*self.scene.soundVol)
			self.scene.touchingSign = true
			self.touched = true
			self.scene.interface.vPad:stop()
			self.scene.aimingClaw = false

		end

	end

end


-- Show sign function

function Sign:touchesEnd(event)

--print("self.scene.signShowing", self.scene.signShowing, "self.scene.paused", self.scene.paused,"self.scene.aimingClaw", self.scene.aimingClaw,"self.scene.touchingSign",self.scene.touchingSign)

	if(not(self.scene.signShowing) and not (self.scene.paused) and not(self.scene.aimingClaw) and self.touched) then
	
		if(self.sign:hitTestPoint(event.touch.x, event.touch.y)) then

			self.scene.signShowing = true

			-- pause stuff
			self.scene.pause:doPause(true)
			self.signSprite:setVisible(true)
			self.tween = GTween.new(self.signSprite, .2, {alpha=1.2})
			event:stopPropagation()
			
		else
			
			-- touch was not on sign need to turn vPad back on
			
			self.scene.touchingSign = false

			self.scene.vPad:start()
			
		end
	
	end

end




-- Hide sign function

function Sign:closeSign(event)

	if(self.scene.signShowing and self.signBG:hitTestPoint(event.touch.x, event.touch.y) and self.touched) then
	
		-- if this touch wasn't one of the current left or right button touchesBegin
	
		self.ignore = false
	
		for i,v in pairs(self.scene.upButtonTouches) do
			if(event.touch.id == v) then
				self.ignore = true
			end
		end
		
		for i,v in pairs(self.scene.leftButtonTouches) do
			if(event.touch.id == v) then
				self.ignore = true
			end
		end
		
		for i,v in pairs(self.scene.rightButtonTouches) do
			if(event.touch.id == v) then
				self.ignore = true
			end
		end
		
		if(not(self.ignore)) then
		
			local channel1 = self.scene.touchSignCloseSound:play()
			channel1:setVolume(.4*self.scene.soundVol)
			self.scene.signShowing = false
			self.scene.touchingSign = false
			self.touched = false
			if(self.tween) then
				self.tween:setPaused(true)
			end

			if(self.scene.paused) then
				self.scene.pause:doResume(true)
			end
			self.tween = GTween.new(self.signSprite, .2, {alpha=0})
			Timer.delayedCall(200, function() self.signSprite:setVisible(false) end)
			self.scene.vPad:start()
			--event:stopPropagation()
		end
	end
--]]
end
