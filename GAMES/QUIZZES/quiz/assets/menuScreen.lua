menuScreen = gideros.class(Sprite)

local myScene

function menuScreen:init(t)
	myScene = self

	local startTheGame = TextField.new(myFont,"Start The Game")
	local xPos = 480-startTheGame:getWidth()
	local yPos = 320-startTheGame:getHeight()
	startTheGame:setPosition(xPos*0.5,yPos*0.5)
	self:addChild(startTheGame)
end

