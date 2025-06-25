gameOverOutOfTime = Core.class(Sprite)
function gameOverOutOfTime:init()

self.atlas = {}

local atlas1 = TexturePack.new("Atlases/Atlas 1.txt", "Atlases/Atlas 1.png");
self.atlas[1] = atlas1

--Header

local menuHeader = Bitmap.new(self.atlas[1]:getTextureRegion("game over header.png"))
menuHeader:setAnchorPoint(.5,0)
self:addChild(menuHeader)
menuHeader:setPosition(application:getContentWidth()/2,20)

-- Out of time text

local outTime = Bitmap.new(self.atlas[1]:getTextureRegion("game over out of time 2.png"))
outTime:setAnchorPoint(.5,0)
self:addChild(outTime)
outTime:setPosition(application:getContentWidth()/2,80)

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




fadeFromBlack()

end










