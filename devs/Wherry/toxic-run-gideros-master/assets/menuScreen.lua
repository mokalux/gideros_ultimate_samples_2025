--!NEEDS:screens.lua

local menuScreen = {}
menuScreen.name = "menu"
menuScreen.stage = Sprite.new()

local background = Background.new()
background:addLayer("gfx/bg1.png", 0.3)
background:addLayer("gfx/bg2.png", 0.5)
menuScreen.stage:addChild(background)

local logo = Bitmap.new(Texture.new("gfx/logo.png"))
logo:setScale(gameScale, gameScale)
menuScreen.stage:addChild(logo)
if screenWidth / logo:getWidth() > 1 then
	logo:setScale(gameScale * screenWidth / logo:getWidth(), gameScale * screenWidth / logo:getWidth())
end
logo:setX(screenWidth / 2 - logo:getWidth() / 2)

local sOffset = 0
local sgPath = "gfx/start_game.png"
if lang == "ru" then
	sgPath = "gfx/start_game_ru.png"
end
local startGameButton = Bitmap.new(Texture.new(sgPath))
startGameButton:setScale(gameScale, gameScale)
startGameButton:setX(screenWidth/2 - startGameButton:getWidth()/2)
startGameButton:setY(logo:getY() + logo:getHeight())
menuScreen.stage:addChild(startGameButton)

local function buttonTap(e)
	local offset = (e.touch.y - startGameButton:getY()) / gameScale
	if offset >= 6 and offset <= 27 then
		changeScreen("game")
	elseif offset > 27 and offset <= 45 then
		changeScreen("scores")
	elseif offset > 45 and offset <= 70 then
		--changeScreen("tutorial")
	end
end
startGameButton:addEventListener(Event.TOUCHES_BEGIN, buttonTap)

local zombies = {}
for i=1,math.random(5,10) do
	local zombie = Zombie.new()
	zombie:setX(math.random(0, screenWidth))
	zombie:setY(screenHeight - zombie:getHeight())
	zombie:setScaleX(-1)
	menuScreen.stage:addChild(zombie)
	zombies[i] = zombie
	zombie.speed = math.random(30, 70)
end


function menuScreen.init()
	application:setBackgroundColor(0xACE5E0)
end

function menuScreen.destroy()

end

function menuScreen.update(e)
	background:move(10 * e.deltaTime * gameScale)
	for i,zombie in ipairs(zombies) do
		zombie:update(e)
		zombie:setX(zombie:getX() + gameScale * e.deltaTime * zombie.speed)
		if zombie:getX() > screenWidth + zombie:getWidth() then
			zombie:removeFromParent()
			zombies[i] = Zombie.new()
			menuScreen.stage:addChild(zombies[i])
			zombies[i]:setX(-zombies[i]:getWidth())
			zombies[i]:setY(screenHeight - zombies[i]:getHeight())
			zombies[i]:setScaleX(-1)
			zombies[i].speed = math.random(30, 70)
			zombies[i].sprite.delay = 0.12 - (zombies[i].speed - 30)/40*0.06
		end
	end
	startGameButton:setY(screenHeight - startGameButton:getHeight() - 10 + math.sin(sOffset) * 5)
	sOffset = sOffset + e.deltaTime * 2
end

function menuScreen.onKey(e)
    if e.keyCode == KeyCode.BACK then
        application:exit()
    end
end

addScreen(menuScreen)