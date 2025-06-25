levelSelectWorld1 = Core.class(Sprite)

function levelSelectWorld1:init()

local test = "tom"

	self.currentScreen = 1
	--TESTING
--[[
	self.saveGame = {}
	self.saveGame.levelMedals = {}
	self.saveGame.levelMedals[1]=1
	self.saveGame.levelMedals[2]=2
	self.saveGame.levelNumber=2
	dataSaver.save("|D|saveGame", self.saveGame) -- save data
--]]
	application:setBackgroundColor(0x757363)

	self.swipeTime = 0
	self.swipeDist = 0
		
	-- set up swipe timer

	local timer = Timer.new(100, math.huge);
	self.swipeTimer = timer;
	timer:addEventListener(Event.TIMER, self.timeSwipe, self)
	
	
		-- Load volume setting
	
	local file = io.open("|D|saveGame.json", "r")
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

	Timer:stopAll() -- stop timers!


	--------------------------------------------------------------
	-- Setup
	--------------------------------------------------------------

	self.worldNumber = 1

	self.atlas = {}
	local atlas1 = TexturePack.new("Atlases/Atlas 1.txt", "Atlases/Atlas 1.png", true);
	self.atlas[1] = atlas1

	-- Require things for this level

	require("Classes/Level Select Door")
	
	-- Create anim loaders

	local animLoader = CTNTAnimatorLoader.new()
	animLoader:loadAnimations("Animations/Atlas 1 Animations.tan", self.atlas[1], true)
	self.atlas1AnimLoader = animLoader

	--------------------------------------------------------------
	-- Load the savegame file
	--------------------------------------------------------------

	-- If save file exists
				
	local file = io.open("|D|saveGame.json", "r" )

	if(file) then
		print("file exists")
		self.saveGame = dataSaver.load("|D|saveGame") -- load it
		io.close( file )
	else
		print("save game does not exist")
		self.saveGame = {} -- create blank table
	end
				
	
	

	-- make main sprite to hold everything that will scroll
	
	self.mainSprite = Sprite.new()
	self:addChild(self.mainSprite)
	
	-- Act 1

	local bg = Bitmap.new(self.atlas[1]:getTextureRegion("map bg.png"));
	self.mainSprite:addChild(bg)


	-- Title
	local title = Bitmap.new(self.atlas[1]:getTextureRegion("act 1.png"));
	title:setAnchorPoint(.5,0)
	self.mainSprite:addChild(title)
	title:setPosition(application:getContentWidth()/2, -0)



	-- Level select icons


	local icon1 = LevelSelectDoor.new(self,1)
	self.mainSprite:addChild(icon1)
	icon1:setPosition(100,119)
	--icon1:openDoor()

	local icon2 = LevelSelectDoor.new(self,2)
	self.mainSprite:addChild(icon2)
	icon2:setPosition(240,119)

	local icon3 = LevelSelectDoor.new(self,3)
	self.mainSprite:addChild(icon3)
	icon3:setPosition(application:getContentWidth()-100,119)



	local icon4 = LevelSelectDoor.new(self,4)
	self.mainSprite:addChild(icon4)
	icon4:setPosition(100,225)
	 
	local icon5 = LevelSelectDoor.new(self,5)
	self.mainSprite:addChild(icon5)
	icon5:setPosition(240,225)

	local icon6 = LevelSelectDoor.new(self,6)
	self.mainSprite:addChild(icon6)
	icon6:setPosition(application:getContentWidth()-100,225)

	
	
	
	
	-- Act 2
	
	local offset = 480

	local bg = Bitmap.new(self.atlas[1]:getTextureRegion("map bg 2.png"))
	bg:setX(offset)
	self.mainSprite:addChild(bg)
	


	-- Title
	local title = Bitmap.new(self.atlas[1]:getTextureRegion("act 2.png"));
	title:setAnchorPoint(.5,0)
	self.mainSprite:addChild(title)
	title:setPosition(application:getContentWidth()/2+offset, -0)



	-- Level select icons


	local icon1 = LevelSelectDoor.new(self,7)
	self.mainSprite:addChild(icon1)
	icon1:setPosition(100+offset,119)

	local icon2 = LevelSelectDoor.new(self,8)
	self.mainSprite:addChild(icon2)
	icon2:setPosition(240+offset,119)

	local icon3 = LevelSelectDoor.new(self,9)
	self.mainSprite:addChild(icon3)
	icon3:setPosition(application:getContentWidth()-100+offset,119)




	local icon5 = LevelSelectDoor.new(self,10)
	self.mainSprite:addChild(icon5)
	icon5:setPosition(100+offset,225)
	 
	local icon6 = LevelSelectDoor.new(self,11)
	self.mainSprite:addChild(icon6)
	icon6:setPosition(240+offset,225)

	local icon7 = LevelSelectDoor.new(self,12)
	self.mainSprite:addChild(icon7)
	icon7:setPosition(application:getContentWidth()-100+offset,225)
	
	-- act 1
	
	-- page corner
	
	local img = Bitmap.new(self.atlas[1]:getTextureRegion("corner.png"))
	self.mainSprite:addChild(img)
	img:setPosition(380,7)
	
	-- arrow
	
	local img = Bitmap.new(self.atlas[1]:getTextureRegion("arrow.png"))
	img:setAnchorPoint(.5, .5)
	self.mainSprite:addChild(img)
	img:setPosition(436,48)
	img:setRotation(-3)
	
	local tween = GTween.new(img, .5, {rotation = img:getRotation() + 5, x = img:getX()+4},{ease = easing.outQuadratic, reflect = true, repeatCount = math.huge})
	
	-- page curl
	
	local img = Bitmap.new(self.atlas[1]:getTextureRegion("page curl.png"))
	self.mainSprite:addChild(img)
	img:setPosition(380,14)
	self.act1Button = img
	
	


	-- act 2

	-- page corner
	
	local img = Bitmap.new(self.atlas[1]:getTextureRegion("corner 2.png"))
	self.mainSprite:addChild(img)
	img:setPosition(5+offset,9)
	
	-- arrow
	
	local img = Bitmap.new(self.atlas[1]:getTextureRegion("arrow.png"))
	img:setAnchorPoint(.5, .5)
	self.mainSprite:addChild(img)
	img:setScaleX(-1)
	img:setPosition(offset+35,48)
	img:setRotation(-3)
	
	local tween = GTween.new(img, .5, {rotation = img:getRotation() + 5, x = img:getX()+4},{ease = easing.outQuadratic, reflect = true, repeatCount = math.huge})
	
	-- page curl
	
	local img = Bitmap.new(self.atlas[1]:getTextureRegion("page curl.png"))
	self.mainSprite:addChild(img)
	img:setPosition(offset+100,14)
	img:setScaleX(-1)
	self.act2Button = img

	-- scale screen
	
	self.mainSprite:setScaleX(aspectRatioX)
	self.mainSprite:setScaleY(aspectRatioY)
	self.mainSprite:setPosition(xOffset,yOffset)



	self:addEventListener(Event.TOUCHES_END, self.scroll, self)


	fadeFromBlack()
	
	--self:scroll()
	
	

	-- touch listeners

	self:addEventListener(Event.TOUCHES_BEGIN, self.touchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.touchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.touchesEnd, self)
	--self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end








function levelSelectWorld1:timeSwipe()
	self.swipeTime = self.swipeTime + 100
end


-- When touch begins
function levelSelectWorld1:touchesBegin(event)

	if(not(self.alreadySwiping)) then
	
		self.alreadySwiping = true -- ignore any touches that happen while we are swiping
	
		self.activeTouchId = event.touch.id -- remember touch id
	
		self.startX = event.touch.x
		self.swipeTimer:start()

	end
	
end


function levelSelectWorld1:touchesMove(event)

	self.swipeDist = math.abs(event.touch.x - self.startX)
		
	if(self.swipeDist>30) then
		self.swiping = true
	end

end





function levelSelectWorld1:touchesEnd(event)
	
	if(self.activeTouchId == event.touch.id) then -- if this is the touch that started the swipe
	
		self.swipeTimer:stop()
		self.swipeTime = 0
	
		self.alreadySwiping = false

		if(self.swipeTime <= 800 and self.swipeDist>30) then
		
		if(event.touch.x > self.startX + 20) then
			if(self.currentScreen==2) then
				self:moveLeft()
			end
		elseif(event.touch.x < self.startX - 20) then
			if(self.currentScreen==1) then
				self:moveRight()
			end

		end
			
		end
		
		Timer.delayedCall(20, function()
			self.swiping = false
			self.swipeDist = 0
		end)
		
	end
		

end








function levelSelectWorld1:scroll(event)

	-- delay this so we check if they touched a door
	Timer.delayedCall(10, function()
		if(not(self.scrolling) and not(self.touchedDoor)) then

			if(self.act1Button:hitTestPoint(event.touch.x, event.touch.y)) then
			
				self:moveRight()

			elseif(self.act2Button:hitTestPoint(event.touch.x, event.touch.y)) then
			
				self:moveLeft()
				
			end	

		end
	end)

end





function levelSelectWorld1:moveLeft()

		self.scrolling = true

		local tween = GTween.new(self.mainSprite, .5, {x = 0+xOffset},{ease = easing.inQuadratic})
		tween:addEventListener("complete", self.finishedScrolling, self)
		tween.dispatchEvents = true
		self.currentScreen = 1

end



function levelSelectWorld1:moveRight()

		self.scrolling = true

		local tween = GTween.new(self.mainSprite, .5, {x = (-480*aspectRatioX)+xOffset},{ease = easing.inQuadratic})
		tween:addEventListener("complete", self.finishedScrolling, self)
		tween.dispatchEvents = true
		self.currentScreen = 2

end





function levelSelectWorld1:finishedScrolling()

		self.scrolling = false

end






function levelSelectWorld1:onExit()
--[[
	print("************ levelSelectWorld1 ************")
	
	unrequire("Classes/Level Select Door")
	LevelSelectDoor = nil
	
	collectgarbage()
	collectgarbage()
	collectgarbage()
--]]
end















