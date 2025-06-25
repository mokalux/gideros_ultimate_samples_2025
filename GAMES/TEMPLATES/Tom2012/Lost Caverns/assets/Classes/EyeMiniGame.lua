EyeMiniGame = Core.class(Sprite)

function EyeMiniGame:init(scene)

	self.scene = scene
	
	-- temp
	Timer.delayedCall(100, function()
		--self:showMiniGame()
	end)
	
	self.speed = 3
	self.leftEdge = 40
	self.rightEdge = self.leftEdge + 390
	self.direction = "right"
	
end


function EyeMiniGame:startMiniGame(eye)

	self.eye = eye
	-- Resume timers
	Timer.resumeAll()
	Timer.delayedCall(600, self.showMiniGame, self)
	
end


function EyeMiniGame:showMiniGame()

	Timer.pauseAll()

	-- Show background
	
	local img = Bitmap.new(self.scene.atlas[9]:getTextureRegion("mini game bg.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(application:getContentWidth()/2, application:getContentHeight()/2)
	self.scene.topLayer:addChild(img)
	self.miniGameBG = img
	
	local img = Bitmap.new(self.scene.atlas[9]:getTextureRegion("mini game stripe.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(application:getContentWidth()/2, application:getContentHeight()/2)
	self.scene.topLayer:addChild(img)
	self.miniGameStripe = img
	
	local img = Bitmap.new(self.scene.atlas[9]:getTextureRegion("mini game eye.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(application:getContentWidth()/2, application:getContentHeight()/2-15)
	self.scene.topLayer:addChild(img)
	self.miniGameEye = img
	
	-- Pointer
	
	local img = Bitmap.new(self.scene.atlas[9]:getTextureRegion("mini game pointer.png"))
	img:setAnchorPoint(.5,0)
	img:setPosition(40,65)
	self.scene.topLayer:addChild(img)
	self.miniGamePointer = img
	
	local img = Bitmap.new(self.scene.atlas[9]:getTextureRegion("mini game border.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(application:getContentWidth()/2, application:getContentHeight()/2)
	self.scene.topLayer:addChild(img)
	self.miniGameBorder = img
	

	
	self:addEventListener(Event.ENTER_FRAME, self.movePointer, self)
	
	-- Add touch event listener
	
	self.scene:addEventListener(Event.TOUCHES_BEGIN, self.tap, self)

end


function EyeMiniGame:movePointer()

	local pointerX = self.miniGamePointer:getX()
	
	if(self.direction=="right") then
		self.miniGamePointer:setX(pointerX+self.speed)
		if(pointerX>= self.rightEdge) then
			self.direction="left"
		end
	else
		self.miniGamePointer:setX(pointerX-self.speed)
		if(pointerX<= self.leftEdge) then
			self.miniGamePointer:setX(self.leftEdge)
			self.direction="right"
		end
	end
	
end




function EyeMiniGame:tap(event)

	local pointerX = self.miniGamePointer:getX()
	
	if(pointerX > 210 and pointerX < 270) then
		self:win()
	else
		self:fail()
	end
	
end




function EyeMiniGame:win()

	self:closeMiniGame()

	-- trigger function to move eye here
	
	self.eye:pluckOutEye()
	
end



function EyeMiniGame:fail()

	self:closeMiniGame()
	
end




function EyeMiniGame:closeMiniGame()

	self.scene.topLayer:removeChild(self.miniGameBG)
	self.scene.topLayer:removeChild(self.miniGameStripe)
	self.scene.topLayer:removeChild(self.miniGameEye)
	self.scene.topLayer:removeChild(self.miniGamePointer)
	self.scene.topLayer:removeChild(self.miniGameBorder)
	
	self.scene:removeEventListener(Event.TOUCHES_BEGIN, self.tap, self)
	self:removeEventListener(Event.ENTER_FRAME, self.movePointer, self)
	self.scene.pause:doResume()
	self.scene.claw.dragBlock = false
	self.scene.claw:stopAndReturnClaw(0)
	
end


