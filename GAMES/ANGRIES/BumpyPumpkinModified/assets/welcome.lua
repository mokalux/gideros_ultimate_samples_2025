WelcomeScreen = gideros.class(Sprite)

local gameTune
local endTune

-- Play tune
local function playTune(fileName)
	gameTune = Sound.new(fileName)
	endTune = gameTune:play(100,true)
end

-- Play button touch handler
local function playTouch(imgPlayBtn, event)
	-- See if the Start Button object was touched
	if imgPlayBtn:hitTestPoint(event.touch.x, event.touch.y) then
		imgPlayBtn:removeEventListener(Event.TOUCHES_END, playTouch)
		
		-- Clear the stage
							--stage:removeChild(imgPlayBtn)
							--imgPlayBtn=nil
		--gameTune:stop()
		--gameTune = nil
		for i = 1, stage:getNumChildren() do
			stage:removeChildAt(1)
		end
		endTune:stop()
		--playTune("sounds/BackGroundSound.mp3")
		stage:addChild(LoadGame.new(1));
	end
end

function WelcomeScreen:init()
	--print("WelcomeScreen")
	application:setOrientation(Application.LANDSCAPE_LEFT)
	local bg = Bitmap.new(Texture.new("images/Background.png"));
	bg:setPosition(0,0)
	stage:addChild(bg)
	local playBtn = Bitmap.new(Texture.new("images/Play.png"));
	playBtn:setAnchorPoint(0.5,0.5)
	playBtn:setPosition(math.floor((application:getContentWidth() - playBtn:getWidth())/2), 100)
	stage:addChild(playBtn)
	playBtn:addEventListener(Event.TOUCHES_BEGIN, playTouch, playBtn)
	playTune("sounds/StartEnd.mp3")
end

