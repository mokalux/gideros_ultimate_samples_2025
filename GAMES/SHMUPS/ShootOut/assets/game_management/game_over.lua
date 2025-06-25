GameOver = Core.class(Sprite)

function GameOver:init()

w = application:getContentWidth()
h = application:getContentHeight()

local pack = TexturePack.new("game_management/buttons/buttons.txt", "game_management/buttons/buttons.png", true)
local font = TTFont.new("font/UQ_0.ttf", 75, true)
local font2 = TTFont.new("font/UQ_0.ttf", 50, true)
local gameOverText, hiscoreText

gameOverText = TextField.new(font, "Game Over")

local botaoContinue = { 
		Bitmap.new(pack:getTextureRegion("continue_1.PNG")),
		Bitmap.new(pack:getTextureRegion("continue_2.PNG")),
	}
for i=1, #botaoContinue do
	botaoContinue[i]:setPosition(w/2, (h/2)+((h/2)/2))
	botaoContinue[i]:setAnchorPoint(0.5,0.5)
end

local i = 1

hiscore = points

hiscoreText = TextField.new(font2, "Hiscore: "..hiscore)

gameOverText:setTextColor(0xFF0000)
gameOverText:setAnchorPoint(0.5,0.5)
hiscoreText:setTextColor(0xFFFFFF)
hiscoreText:setAnchorPoint(0.5,0.5)

gameOverText:setPosition(w/2, (h/2)-((h/2)/2))
hiscoreText:setPosition(w/2, h/2)

self:addChild(botaoContinue[i])
self:addChild(gameOverText)
self:addChild(hiscoreText)

function onMouseDown(event)
	if botaoContinue[i]:hitTestPoint(event.x, event.y) then
		self:removeChild(botaoContinue[i])
		i = 2
		self:addChild(botaoContinue[i])
	end
end
function onMouseUp(event)
	if i == 2 then
		if botaoContinue[i]:hitTestPoint(event.x, event.y) then
			self:removeChild(botaoContinue[i])
			i = 1
			self:addChild(botaoContinue[i])
			
			--Game:changeScene("level_1", 2, SceneManager.fade)
		end
	end
end

self:addEventListener(Event.MOUSE_DOWN, onMouseDown)
self:addEventListener(Event.MOUSE_UP, onMouseUp)

end