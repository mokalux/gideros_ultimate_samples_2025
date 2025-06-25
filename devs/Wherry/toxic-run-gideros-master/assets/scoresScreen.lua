local scoresScreen = {}
scoresScreen.name = "scores"
scoresScreen.stage = Sprite.new()

-- Score text
local scoresLogoFont = TTFont.new("fonts/MainFont.ttf", 15*gameScale)
local scoresLogo = TextField.new(scoresLogoFont, "Top scores")
scoresLogo:setTextColor(0xFFFFFF)
scoresLogo:setPosition(screenWidth / 2 - scoresLogo:getWidth() / 2, 20*gameScale	)
scoresScreen.stage:addChild(scoresLogo)

local scoresListFont = TTFont.new("fonts/MainFont.ttf", 10*gameScale)
local scoresList = {}
for i=1,5 do
	local scoreLine = TextField.new(scoresListFont, i..". -")
	scoreLine:setTextColor(0xFFAA00 - i * 0x002200)
	scoreLine:setPosition(20*gameScale, scoresLogo:getHeight() + 20*gameScale + 15*gameScale*i)
	scoresScreen.stage:addChild(scoreLine)
	scoresList[i] = scoreLine
end

function scoresScreen.init()
	application:setBackgroundColor(0x3A6B3A)
	for i=1,5 do
--		local s = dataSaver.loadValue("score-"..i)
		local s
		if not s then
			s = 0
		end
		s = tonumber(s)
		s = math.floor(s)
		if s == 0 then
			s = "-"
		end
		scoresList[i]:setText(i..". "..tostring(s))
	end
end

function scoresScreen.destroy()

end

function scoresScreen.update(e)

end

function scoresScreen.onKey(e)
    if e.keyCode == KeyCode.BACK then
        changeScreen("menu")
    end
end

addScreen(scoresScreen)