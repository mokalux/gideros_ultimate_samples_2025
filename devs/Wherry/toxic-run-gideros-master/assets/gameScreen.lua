--!NEEDS:ground.lua
--!NEEDS:obstacle.lua
--!NEEDS:player.lua
--!NEEDS:screens.lua
--!NEEDS:zombie.lua

local gameScreen = {}
gameScreen.name = "game"
gameScreen.stage = Sprite.new()

local background = Background.new()
background:addLayer("gfx/bg1.png", 0.3)
background:addLayer("gfx/bg2.png", 0.5)
background:addLayer("gfx/bg3.png", 0.7)
background:addTree()
gameScreen.stage:addChild(background)

local lastHeight = 0
local jumpWidth = 51.65
local isVeryClose = false

local defaultZombieSpawnChance = 15
local maxZombieSpawnChance = 60
local zombieSpawnChance = 0

local grounds = {}
local zombies = {}
local obstacles = {}
local coins = {}

local player = Player.new()
gameScreen.stage:addChild(player)

-- Don't change this
local minRunningSpeed = 100
local maxRunningSpeed = 200
-- 
local runningSpeed = 100

local groundFLeft = 0

local isDead = false

local score = 0
local coinsCollected = 0
local zombiesAvoided = 0
local obstaclesAvoided = 0

local scoreLocalString = "Score: "
if lang == "ru" then
	scoreLocalString = "Очки: "
end

local isDeathScreenShowing = false
local nojump = 1

local failSound = Sound.new("sounds/fail.wav")
local coinSound = Sound.new("sounds/coin.wav")

-- Score text
local scoreTextFont = TTFont.new("fonts/MainFont.ttf", 6*gameScale)
local scoreTextShadow = TextField.new(scoreTextFont, "Score: 100")
scoreTextShadow:setTextColor(0x000000)
scoreTextShadow:setPosition(gameScale * 2 + gameScale/2, 10*gameScale + gameScale/2)
gameScreen.stage:addChild(scoreTextShadow)

local scoreText = TextField.new(scoreTextFont, "Score: 100")
scoreText:setTextColor(0xFFFFFF)
scoreText:setPosition(gameScale * 2, 10*gameScale)
gameScreen.stage:addChild(scoreText)

local gameOver = Bitmap.new(Texture.new("gfx/game_over.png"))
gameOver:setScale(gameScale, gameScale)
if screenWidth / gameOver:getWidth() > 1 then
	gameOver:setScale(gameScale * screenWidth / gameOver:getWidth(), gameScale * screenWidth / gameOver:getWidth())
end
gameOver:setX(screenWidth / 2 - gameOver:getWidth() / 2)

local gameOverText = TextField.new(scoreTextFont, "Oh my god, you are dead!")
gameOverText:setTextColor(0xFF0000)
local gameOverText2 = TextField.new(scoreTextFont, "Total score: 0")
gameOverText2:setTextColor(0xFFFFFF)
local gameOverText3 = TextField.new(scoreTextFont, "Coins collected: 0")
gameOverText3:setTextColor(0xFFFFFF)
local gameOverText4 = TextField.new(scoreTextFont, "Zombies avoided: 0")
gameOverText4:setTextColor(0xFFFFFF)
local gameOverText5 = TextField.new(scoreTextFont, "Tap to restart!")
gameOverText5:setTextColor(0xFFAA00)


local function showDeathScreen()
	if isDeathScreenShowing then
		return
	end
	isDeathScreenShowing = true
	gameScreen.stage:addChild(gameOver)
	gameScreen.stage:addChild(gameOverText)
	gameScreen.stage:addChild(gameOverText2)
	gameScreen.stage:addChild(gameOverText3)
	gameScreen.stage:addChild(gameOverText4)
	gameScreen.stage:addChild(gameOverText5)
	gameOverText:setText("Oh noes, you are dead!")
	gameOverText2:setText("Total score: " .. math.floor(score))
	gameOverText3:setText("Coins collected: " .. coinsCollected)
	gameOverText4:setText("Zombies avoided: " .. zombiesAvoided)
	gameOverText2:setPosition(screenWidth / 2 - gameOverText2:getWidth() / 2, gameOver:getHeight() + 10*gameScale * 1.2 * 2)
	gameOverText3:setPosition(screenWidth / 2 - gameOverText3:getWidth() / 2, gameOver:getHeight() + 10*gameScale * 1.2 * 3)
	gameOverText4:setPosition(screenWidth / 2 - gameOverText4:getWidth() / 2, gameOver:getHeight() + 10*gameScale * 1.2 * 4)
	gameOverText5:setPosition(screenWidth / 2 - gameOverText5:getWidth() / 2, screenHeight - 10 * gameScale)
	gameOver:setAlpha(0)
	scoreTextShadow:setVisible(false)
	scoreText:setVisible(false)
	
	score = math.floor(score)
	-- save top
	local currentScores = {}
	for i=1,5 do
--		currentScores[i] = dataSaver.loadValue("score-"..i)
		if not currentScores[i] then
			currentScores[i] = 0
		else
			currentScores[i] = tonumber(currentScores[i])
		end
	end
	local myTop = 0
	for i=1,5 do
		if math.max(currentScores[i], score) == score and currentScores[i] ~= score then
			table.insert(currentScores, i, score)
			myTop = i 
			break
		end
	end
	if myTop > 0 then
		gameOverText:setText("New highscore! (TOP " .. myTop..")")
	end
	gameOverText:setPosition(screenWidth / 2 - gameOverText:getWidth() / 2, gameOver:getHeight() + 10*gameScale * 1.2)
	for i=1,5 do
--		dataSaver.saveValue("score-"..i, currentScores[i])
	end
end

local function hideDeathScreen()
	gameOver:removeFromParent()
	gameOverText:removeFromParent()
	gameOverText2:removeFromParent()
	gameOverText3:removeFromParent()
	gameOverText4:removeFromParent()
	gameOverText5:removeFromParent()
	isDeathScreenShowing = false
	scoreTextShadow:setVisible(true)
	scoreText:setVisible(true)
end

local function updateDeathScreen()
	if not isDeathScreenShowing then
		return
	end
	gameOver:setAlpha(gameOver:getAlpha() + (1 - gameOver:getAlpha()) * 0.05)
end

local function setScore(newScore)
	local scoreString = tostring(math.floor(newScore))
	scoreTextShadow:setText("Score: " .. scoreString)
	scoreText:setText("Score: " .. scoreString)
	score = newScore
end

local function addCoin(x, y)
	local coin = Coin.new()
	gameScreen.stage:addChild(coin)
	coin:setX(x)
	coin:setY(y)
	table.insert(coins, coin)
end

local function addGround(t)
	local groundType = t
	if not groundType then
		groundType = math.random(2, 6)
	end
	local ground = Ground.new(groundType)
	
	ground:setY(screenHeight - ground.height + math.random(0, ground.height / 2))
	if groundType == 4 then
		ground:setY(ground:getY() + gameScale)
	end
	local heightCloser = (ground:getY() - lastHeight) / 2
	if heightCloser > 0 then
		heightCloser = 0
	end
	local distance = jumpWidth * 0.65 * math.random(80, 100)/100-- + heightCloser
	if lastHeight > ground:getY() then
		distance = distance * 0.7
	end
	if isVeryClose then
		distance = distance / 3
		isVeryClose = false
	end
	distance = distance * runningSpeed / minRunningSpeed
	
	ground:setX(screenWidth + distance * gameScale)
	
	lastHeight = ground:getY()
	
	local hasTwoFloors = false
	
	if groundType == 2 and math.random(1, 2) == 2 and runningSpeed < 130 then
		local ground2 = Ground.new(3)
		ground2:setX(math.random(ground:getX() + ground.width - ground2.width - ground2.width / 4, ground:getX() + ground.width - ground2.width))--math.random(ground:getX() + ground.width / 3, ground:getX() + ground.width - ground2.width))
		ground2:setY(ground:getY() - math.random(ground2.height * 0.3, ground2.height))
		table.insert(grounds, ground2)
		lastHeight = ground2:getY()
		isVeryClose = true
		gameScreen.stage:addChild(ground2)
		hasTwoFloors = true
		if math.random(1,3) == 1 then
			addCoin(ground2:getX() + ground2:getWidth() / 2 - 7*gameScale, ground2:getY() - player:getHeight()/1.5)
		end
	end
	
	if groundType == 3 or groundType == 4 and math.random(1,3) == 1 then
		addCoin(ground:getX() + ground:getWidth() / 2 - 7*gameScale, ground:getY() - player:getHeight()/1.5)
	end
	
	local hasZombie = false
	
	-- Zombies and obstacles spawn
	if (groundType == 5 or groundType == 6 or (groundType == 2 and not hasTwoFloors and runningSpeed <= 135))
	then
		if math.random(1, 100) <= zombieSpawnChance then
			local zombie = Zombie.new()
			table.insert(zombies, zombie)
			local xOffset = zombie:getWidth() * math.random(1, 3)
			if runningSpeed > 150 then
				xOffset = zombie:getWidth() * 4.5
			end 
			zombie:setX(ground:getX() + ground:getWidth() - xOffset)
			zombie:setY(ground:getY() - zombie:getHeight())
			gameScreen.stage:addChild(zombie)
			if zombieSpawnChance > maxZombieSpawnChance then
				zombieSpawnChance = maxZombieSpawnChance
			end
			hasZombie = true
		end
		-- 70% chance for obstacles to appear
		if not hasZombie and math.random(1, 10) <= 7 then
			local obstacle = Obstacle.new()
			table.insert(obstacles, obstacle)
			obstacle:setX(ground:getX() + ground:getWidth() / 2 - obstacle:getWidth() / 2)
			obstacle:setY(ground:getY() - obstacle:getHeight())
			gameScreen.stage:addChild(obstacle)
		end
		if math.random(1,3) == 1 and not isVeryClose then
			addCoin(ground:getX(), ground:getY() - player:getHeight())
		end
		if math.random(1,3) == 1 then
			addCoin(ground:getX() + ground:getWidth() / 2 - 3.5*gameScale, ground:getY() - player:getHeight() * 2.7)
		end
	end
	
	if not isVeryClose and math.random(1, 3) == 1 then
		addCoin(ground:getX() + ground:getWidth() + distance / 2 - 3.5*gameScale, ground:getY() - player:getHeight() * 2.7)
	end
	
	gameScreen.stage:addChild(ground)
	lastGround = ground
	table.insert(grounds, ground)
end

function gameScreen.init()
	nojump = 1
	isDeathScreenShowing = false
	hideDeathScreen()
	
	coinsCollected = 0
	zombiesAvoided = 0
	obstaclesAvoided = 0
	
	runningSpeed = 100
	setScore(0)
	-- Sky
	application:setBackgroundColor(0xACE5E0)
	isDead = false
	for i, o in ipairs(obstacles) do
		o:removeFromParent()
	end
	for i, z in ipairs(zombies) do
		z:removeFromParent()
	end
	for i, g in ipairs(grounds) do
		g:removeFromParent()
	end
	for i, c in ipairs(coins) do
		c:removeFromParent()
	end
	obstacles = {}
	zombies = {}
	grounds = {}
	coins = {}
	player:setState("jump")
	player.px = player:getWidth() * 2
	player.sx = 0
	player.sy = 0
	background:move(screenWidth * 5)
	addGround(1)
	player.py = screenHeight - player:getHeight() - lastGround.height
	while grounds[1]:getX() > 0 do
		for i, g in ipairs(grounds) do
			g:setX(g:getX() - 5)
		end
		if lastGround:getX() + lastGround:getWidth() < screenWidth then
			addGround()
		end
	end
	
	zombieSpawnChance = defaultZombieSpawnChance
end

function processDeath()
	failSound:play()
	player:setState("dead")
	isDead = true
	player.sy = -400 * gameScale
end

function gameScreen.destroy()
	for i, o in ipairs(obstacles) do
		o:removeFromParent()
	end
	for i, z in ipairs(zombies) do
		z:removeFromParent()
	end
	for i, g in ipairs(grounds) do
		g:removeFromParent()
	end
	for i, c in ipairs(coins) do
		c:removeFromParent()
	end
	obstacles = {}
	zombies = {}
	grounds = {}
	coins = {}
end

--local lastheight = 2000
function gameScreen.update(e)
	nojump = nojump - e.deltaTime
	if not isDead then
		if runningSpeed < maxRunningSpeed then
			runningSpeed = runningSpeed + e.deltaTime * 100 / 240
		end
		setScore(score + e.deltaTime * 4 * runningSpeed / minRunningSpeed)
	else
		updateDeathScreen()
	end
	--print(#coins, ' ', #grounds, ' ', #zombies)
	zombieSpawnChance = zombieSpawnChance + e.deltaTime / 3
	--lastheight = math.min(lastheight, player.py)
	--print(lastheight / gameScale)
	player.sy = player.sy + 1498.23 * gameScale * e.deltaTime
	if player.py > screenHeight then
		showDeathScreen()
	end
	player.px = player.px + player.sx * e.deltaTime
	player.py = player.py + player.sy  * e.deltaTime
	
	if not isDead then
		background:move(runningSpeed * e.deltaTime * gameScale)
	end
	
	local runningStep = runningSpeed * e.deltaTime * gameScale
	
	-- Coins
	local coinToRemove = 0
	for i, c in ipairs(coins) do
		if c:getX() + c:getWidth() < 0 then
			coins[i]:removeFromParent()
			coinToRemove = i
		elseif not isDead then
			c:setX(c:getX() - runningStep)
			c:update(e)
			if c:checkCollision(player.px, player.py, player:getWidth(), player:getHeight())
			then
				coins[i]:removeFromParent()
				coinToRemove = i
				setScore(score + 10)
				coinsCollected = coinsCollected +  1
				coinSound:play()
			end		
		end		
	end
	
	-- Obstacles
	local obstacleToRemove = 0
	for i, o in ipairs(obstacles) do
		if o:getX() + o:getWidth() < 0 then
			obstacles[i]:removeFromParent()
			obstacleToRemove = i
		elseif not isDead then
			o:setX(o:getX() - runningStep)
			if o:checkCollision(player.px, 
								player.py + player:getHeight() / 2) or
				o:checkCollision(player.px + player.width, 
								player.py + player:getHeight() / 2) 
			then
				processDeath()
			end		
		end	
	end
	
	-- Zombies
	local zombieToRemove = 0
	for i, z in ipairs(zombies) do
		if z:getX() + z:getWidth() < 0 then
			zombies[i]:removeFromParent()
			zombieToRemove = i
		elseif not isDead then
			z:setX(z:getX() - runningStep - z.speed * e.deltaTime * gameScale)
			z:update(e)
			if z:checkCollision(player.px + player.width / 2, 
								player.py + player:getHeight() / 2) 
			then
				processDeath()
			end		
		end
	end
	player.onGround = false
	local isAddingNew = false
	local groundToRemove = 0
	-- Ground movement and collision
	for i, g in ipairs(grounds) do
		if g:getX() + g:getWidth() < 0 then
			grounds[i]:removeFromParent()
			groundToRemove = i
		elseif not isDead then
			g:setX(g:getX() - runningStep)
			
			if	g:checkCollision(	player:getPosition(), 
									player.py + player:getHeight()	) or
				g:checkCollision(	player:getPosition() + player.width / 2, 
									player.py + player:getHeight()	)
			then
				player.py = g:getY() - player:getHeight()
				player:setY(player.py)
				player.sy = 0
				player.onGround = true
				
			end

			local dt = player.width / 4;
			-- Right
			if g:checkCollision(player.px + player.width, 
								player.py + player:getHeight() * 0.8) 
			then
				processDeath()
			end
		end
	end

	
	if not isDead then
		if groundToRemove > 0 then
			table.remove(grounds, groundToRemove)
		end
		if zombieToRemove > 0 then
			table.remove(zombies, zombieToRemove)
			zombiesAvoided = zombiesAvoided + 1
		end
		if obstacleToRemove > 0 then
			table.remove(obstacles, obstacleToRemove)
			obstaclesAvoided = obstaclesAvoided + 1
		end
		if coinToRemove > 0 then
			table.remove(coins, coinToRemove)
		end
		
		if lastGround:getX() + lastGround:getWidth() < screenWidth then
			addGround()
		end
		
		if player.py + player:getHeight() > screenHeight then
			processDeath()
		end
		if player.onGround then
			player:setState("run")
		else
			--player:setState("jump")
		end
	end
	player:update(e)
end


function gameScreen.onTouch(t)
	if not isDead and nojump <= 0 then
		player.isJumping = true
	elseif isDeathScreenShowing then
		hideDeathScreen()
		gameScreen.init()
	end
end

function gameScreen.onKey(e)
    if e.keyCode == KeyCode.BACK then
        changeScreen("menu")
    end
end

addScreen(gameScreen)