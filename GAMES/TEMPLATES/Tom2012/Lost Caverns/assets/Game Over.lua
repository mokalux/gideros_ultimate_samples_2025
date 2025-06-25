gameOver = Core.class(Sprite)
function gameOver:init()

--[[
local loading = Bitmap.new(Texture.new("gfx/loading.png"))
self:addChild(loading)

local function preloader()

-- load all your assets here
--]]

local Atlas1 = TexturePack.new("Atlases/Atlas 1.txt", "Atlases/Atlas 1.png");

--[[
self:removeChild(loading)
loading = nil;
self:removeEventListener(Event.ENTER_FRAME, preloader)

-- rest of code here


-- stop all timers
Timer:stopAll()


local menuBG = Bitmap.new(Atlas1:getTextureRegion("menu background.png"));
self:addChild(menuBG);

local gameOver = Bitmap.new(Atlas1:getTextureRegion("game-over.png"));
gameOver:setAnchorPoint(0.5,0.5);
self:addChild(gameOver)
gameOver:setPosition(application:getContentWidth()/2, 55);


--------------------------------------------------
-- Show the scores
--------------------------------------------------

-- Load the data

local saveGame = dataSaver.load("|D|saveGame");

-- Set up fonts

local font1 = BMFont.new("Fonts/hairy monster medium.fnt", "Fonts/hairy monster medium.png"); -- normal colour
local font2 = BMFont.new("Fonts/hairy monster high score.fnt", "Fonts/hairy monster high score.png"); -- normal colour

local line1 = BMTextField.new(font1, "Cavemen");
self:addChild(line1);
line1:setPosition((application:getContentWidth()/2) - (line1:getWidth()/2), 120);

local line2 = BMTextField.new(font1, "Eaten");
self:addChild(line2);
line2:setPosition((application:getContentWidth()/2) - (line2:getWidth()/2), 160);

local highScoreText = BMTextField.new(font2, tostring(saveGame.score));
self:addChild(highScoreText);
highScoreText:setPosition((application:getContentWidth()/2) - (highScoreText:getWidth()/2), 208);

local line3 = BMTextField.new(font1, "Your Best");
self:addChild(line3);
line3:setPosition((application:getContentWidth()/2) - (line3:getWidth()/2), 282);

local highScoreText = BMTextField.new(font2, tostring(saveGame.highScore));
self:addChild(highScoreText);
highScoreText:setPosition((application:getContentWidth()/2) - (highScoreText:getWidth()/2), 330);

--]]

--Header

local menuHeader = Bitmap.new(Atlas1:getTextureRegion("game over header.png"))
menuHeader:setAnchorPoint(.5,0)
self:addChild(menuHeader)
menuHeader:setPosition(application:getContentWidth()/2,20)

-- Try again button

local TryAgainButtonImage = Bitmap.new(Atlas1:getTextureRegion("try again button.png"))
local TryAgainButtonPressedImage = Bitmap.new(Atlas1:getTextureRegion("try again button pressed.png"))
local tryAgainButton = Button.new(TryAgainButtonImage, TryAgainButtonPressedImage)
self:addChild(tryAgainButton)
tryAgainButton:setPosition(40,250);
tryAgainButton:addEventListener("click", function() playSound("Sounds/button-press.wav",.8) fadeToBlack("Level 1") end);

-- Menu button

local menuButtonImage = Bitmap.new(Atlas1:getTextureRegion("menu button.png"))
local menuButtonPressedImage = Bitmap.new(Atlas1:getTextureRegion("menu button pressed.png"))
local menuButton = Button.new(menuButtonImage, menuButtonPressedImage)
self:addChild(menuButton)
menuButton:setPosition(320,250);

--[[

-- Game Center button

local gameCenterImage = Bitmap.new(Atlas1:getTextureRegion("game center.png"));
local gameCenterButton = Button.new(gameCenterImage,gameCenterImage);
self:addChild(gameCenterButton)
gameCenterButton:setPosition(245,404)
gameCenterButton:addEventListener("click", function() playSound("Sounds/button-press.wav",.8) gamekit:showLeaderboard() end);

--]]




menuButton:addEventListener("click", function()
	if(not(self.pressedMenu)) then
		self.pressedMenu = true
		playSound("Sounds/button-press.wav",.8)
		fadeToBlack("Menu")
		Timer.delayedCall(800, function() themeMusic:stop() themeMusic = nil end) -- stop music playing
	end
end)


--[[
fadeFromBlack(self)

end
self:addEventListener(Event.ENTER_FRAME, preloader)


--]]


fadeFromBlack()

end










