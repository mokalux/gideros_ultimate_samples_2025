levelComplete = Core.class(Sprite)
function levelComplete:init()

local atlas1 = TexturePack.new("Atlases/Atlas 1.txt", "Atlases/Atlas 1.png");
self.atlas[1] = atlas1

--Header

local header = Bitmap.new(Atlas1:getTextureRegion("level complete header.png"))
header:setAnchorPoint(.5,0)
self:addChild(header)
header:setPosition(application:getContentWidth()/2,20)

-- Continue button

local continueButtonImage = Bitmap.new(self.atlas[1]:getTextureRegion("continue button.png"))
continueButtonImage:setAnchorPoint(.5,0)
local continueButtonPressedImage = Bitmap.new(self.atlas[1]:getTextureRegion("continue button pressed.png"))
continueButtonPressedImage:setAnchorPoint(.5,0)
local continueButton = Button.new(continueButtonImage, continueButtonPressedImage)
self:addChild(continueButton)
continueButton:setPosition(application:getContentWidth()/2,100)
continueButton:addEventListener("click", function() playSound("Sounds/button-press.wav",.8) fadeToBlack("Level Select World 1") end);

-- Try again button

local TryAgainButtonImage = Bitmap.new(self.atlas[1]:getTextureRegion("try again button.png"))
local TryAgainButtonPressedImage = Bitmap.new(self.atlas[1]:getTextureRegion("try again button pressed.png"))
local tryAgainButton = Button.new(TryAgainButtonImage, TryAgainButtonPressedImage)
self:addChild(tryAgainButton)
tryAgainButton:setPosition(40,250);
tryAgainButton:addEventListener("click", function() playSound("Sounds/button-press.wav",.8) fadeToBlack("Level 1") end);

-- Menu button

local menuButtonImage = Bitmap.new(self.atlas[1]:getTextureRegion("menu button.png"))
local menuButtonPressedImage = Bitmap.new(self.atlas[1]:getTextureRegion("menu button pressed.png"))
local menuButton = Button.new(menuButtonImage, menuButtonPressedImage)
self:addChild(menuButton)
menuButton:setPosition(320,250);





menuButton:addEventListener("click", function()
	if(not(self.pressedMenu)) then
		self.pressedMenu = true
		playSound("Sounds/button-press.wav",.8)
		fadeToBlack("Menu")
		Timer.delayedCall(800, function() themeMusic:stop() themeMusic = nil end) -- stop music playing
	end
end)




-- set up medals

-- 3 medal backgrounds

local medal1BG = Bitmap.new(self.atlas[1]:getTextureRegion("medal blank.png"))
self:addChild(medal1BG)
medal1BG:setAnchorPoint(.5,.5)
medal1BG:setPosition(application:getContentWidth()/2,195);

local medal2BG = Bitmap.new(self.atlas[1]:getTextureRegion("medal blank.png"))
self:addChild(medal2BG)
medal2BG:setAnchorPoint(.5,.5)
medal2BG:setPosition(medal1BG:getX()-(medal2BG:getWidth()),195);

local medal3BG = Bitmap.new(self.atlas[1]:getTextureRegion("medal blank.png"))
self:addChild(medal3BG)
medal3BG:setAnchorPoint(.5,.5)
medal3BG:setPosition(medal1BG:getX()+(medal2BG:getWidth()),195);


if(lastLevelMedal>=1) then

	local medal = Bitmap.new(self.atlas[1]:getTextureRegion("big medal bronze.png"))
	self:addChild(medal)
	medal:setAnchorPoint(.5,.5)
	medal:setPosition(medal2BG:getX(),medal2BG:getY());

end

if(lastLevelMedal>=2) then

	local medal = Bitmap.new(self.atlas[1]:getTextureRegion("big medal silver.png"))
	self:addChild(medal)
	medal:setAnchorPoint(.5,.5)
	medal:setPosition(medal1BG:getX(),medal1BG:getY())
	
end

if(lastLevelMedal==3) then

	local medal = Bitmap.new(self.atlas[1]:getTextureRegion("big medal gold.png"))
	self:addChild(medal)
	medal:setAnchorPoint(.5,.5)
	medal:setPosition(medal2BG:getX(),medal2BG:getY())

end


fadeFromBlack()

end










