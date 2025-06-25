sceneInGame = Core.class(Sprite)

function sceneInGame:init(levelSelect)

SWALL = 1
SBOX = 2
SHOLE = 3
SPAWN = 4

local btnRes = Bitmap.new(Texture.new("resetBtn.png", true))
local dpos = {}
local upos = {}
local char = Bitmap.new(Texture.new("char.png", true))
local charPos = {}
local startPos = nil
local holeList = {}
local currentLevel = nil
local nextLevel = nil
local maps = nil
local bg = Bitmap.new(Texture.new("overlay.png", true))
local btnBgRes = Bitmap.new(Texture.new("resetBtn.png", true))
local btnBgNext = Bitmap.new(Texture.new("nextBtn.png", true))

btnBgRes:setPosition(180, 180)
bg:addChild(btnBgRes)
btnBgNext:setPosition(250, 180)
bg:addChild(btnBgNext)

function btnBgRes_click(event)
	if (self:contains(bg) and btnBgRes:hitTestPoint(event.x, event.y)) then
		destroyLevel()
		loadLevel(currentLevel)
	end
end

function btnBgNext_click(event)
	if (self:contains(bg) and btnBgNext:hitTestPoint(event.x, event.y)) then
		destroyLevel()
		loadLevel(nextLevel)
	end
end

btnBgRes:addEventListener(Event.MOUSE_UP, btnBgRes_click)
btnBgNext:addEventListener(Event.MOUSE_UP, btnBgNext_click)

function isClickable(event)
	if ( self:contains(bg) ) then
		return false
	else 
		return true
	end
end

function gesture(pdown, pup)
	local delta = 60
	if (pup.y > pdown.y and math.abs(pdown.x - pup.x) <= delta) then
		return "DOWN"
	end 
	if (pup.y < pdown.y and math.abs(pdown.x - pup.x) <= delta) then
		return "UP"
	end 
	if (pup.x > pdown.x and math.abs(pdown.y - pup.y) <= delta) then
		return "RIGHT"
	end 
	if (pup.x < pdown.x and math.abs(pdown.y - pup.y) <= delta) then
		return "LEFT"
	end 
	return nil
end

function mouse_down(event)
	dpos = { x = event.x, y = event.y }
end

function mouse_up(event)
	upos = { x = event.x, y = event.y }
	if (maps ~= nil and isClickable(event)) then
		char:move(gesture(dpos, upos))
	end
end

self:addEventListener(Event.MOUSE_DOWN, mouse_down)
self:addEventListener(Event.MOUSE_UP, mouse_up)

function char:setPos(x, y, anim)
	if (anim == nil) then
		self:setPosition(60 * (x - 1) + self:getWidth() / 4, 60 * (y - 1))
	else
		local anim = {}
			anim.x = 60 * (x - 1) + self:getWidth() / 4
			anim.y = 60 * (y - 1)
		local prop = {}
			prop.ease = easing.outBack
		local tween = GTween.new(self, 0.2, anim, prop)
	end
	charPos = { x = x, y = y }
end

function char:move(act) 
	if (act == "UP") then
		--if (maps:getTile(charPos.x, charPos.y - 1) == nil or maps:getTile(charPos.x, charPos.y - 1) == SPAWN) then
		if maps:walkable(charPos.x, charPos.y - 1) then
			char:setPos(charPos.x, charPos.y - 1, 1)
		else
			if (maps:getTile(charPos.x, charPos.y - 1) == SBOX) then -- if next to char is box
				if (maps:getTile(charPos.x, charPos.y - 2) == nil or maps:getTile(charPos.x, charPos.y - 2) == SHOLE) then -- if next to box is nil
					maps:getMap(3):setTile(charPos.x, charPos.y - 2, SBOX, 1)
					maps:getMap(3):clearTile(charPos.x, charPos.y - 1)
					char:setPos(charPos.x, charPos.y - 1, 1)
					maps:checkWin()
				end
			end
		end
	end
	if (act == "DOWN") then
		--if (maps:getTile(charPos.x, charPos.y + 1) == nil or maps:getTile(charPos.x, charPos.y + 1) == SPAWN) then
		if maps:walkable(charPos.x, charPos.y + 1) then
			char:setPos(charPos.x, charPos.y + 1, 1)
		else
			if (maps:getTile(charPos.x, charPos.y + 1) == SBOX) then -- if next to char is box
				if (maps:getTile(charPos.x, charPos.y + 2) == nil or maps:getTile(charPos.x, charPos.y + 2) == SHOLE) then -- if next to box is nil
					maps:getMap(3):setTile(charPos.x, charPos.y + 2, SBOX, 1)
					maps:getMap(3):clearTile(charPos.x, charPos.y + 1)
					char:setPos(charPos.x, charPos.y + 1, 1)
					maps:checkWin()
				end
			end
		end
	end
	if (act == "LEFT") then
		--if (maps:getTile(charPos.x - 1, charPos.y) == nil or maps:getTile(charPos.x - 1, charPos.y) == SPAWN) then
		if maps:walkable(charPos.x - 1, charPos.y) then
			char:setPos(charPos.x - 1, charPos.y, 1)
		else
			if (maps:getTile(charPos.x - 1, charPos.y) == SBOX) then -- if next to char is box
				if (maps:getTile(charPos.x - 2, charPos.y) == nil or maps:getTile(charPos.x - 2, charPos.y) == SHOLE) then -- if next to box is nil
					maps:getMap(3):setTile(charPos.x - 2, charPos.y, SBOX, 1)
					maps:getMap(3):clearTile(charPos.x - 1, charPos.y)
					char:setPos(charPos.x - 1, charPos.y, 1)
					maps:checkWin()
				end
			end
		end
	end
	if (act == "RIGHT") then
		--if (maps:getTile(charPos.x + 1, charPos.y) == nil or maps:getTile(charPos.x + 1, charPos.y) == SPAWN) then
		if maps:walkable(charPos.x + 1, charPos.y) then
			char:setPos(charPos.x + 1, charPos.y, 1)
		else
			if (maps:getTile(charPos.x + 1, charPos.y) == SBOX) then -- if next to char is box
				if (maps:getTile(charPos.x + 2, charPos.y) == nil or maps:getTile(charPos.x + 2, charPos.y) == SHOLE) then -- if next to box is nil
					maps:getMap(3):setTile(charPos.x + 2, charPos.y, SBOX, 1)
					maps:getMap(3):clearTile(charPos.x + 1, charPos.y)
					char:setPos(charPos.x + 1, charPos.y, 1)
					maps:checkWin()
				end
			end
		end
	end
end

function destroyLevel()
	if (maps ~= nil) then
		bg:removeFromParent()
		maps:unload()
		maps:removeFromParent()
		charPos = {}
		startPos = nil
		holeList = {}
		maps = nil
	end
end

function finishLevel()
	bg:setPosition(0, 0)
	self:addChild(bg)
	setColor(0xFFFFFF)
	self:addText("You Win !!!", 100, 150, 3)
end

function loadLevel(level)
	currentLevel = level
	maps = TiledMap.new("map/"..currentLevel..".lua")
	maps:setScale(0.7)
	maps:setPosition(0, 0)
	nextLevel = maps:getProperty("next_level")
	print("Next: ", nextLevel)
	function maps:checkHole(x, y)
		return (self:getMap(3):getTile(x, y) ~= nil)
	end
	function maps:walkable(x, y)
		return (maps:getTile(x, y) == nil or maps:getTile(x, y) == SPAWN or (maps:getMap(3):getTile(x, y) == SBOX and maps:getMap(2):getTile(x, y) == SHOLE))
	end
	function maps:checkWin()
		local rs = true
		for i = 1, #holeList do
			if (self:checkHole(holeList[i].x, holeList[i].y) ~= true) then 
				rs = false
			end
		end
		print(rs)
		if (rs) then
			print("YOU WIN!!!!!!!!")
			finishLevel()
		end
	end
	self:addChild(maps)
	for dx = 1, maps:getLayer("hole").width do
		for dy = 1, maps:getLayer("hole").height do
			if (maps:getMap(2):getTile(dx, dy) ~= nil) then
				local hp = { x = dx, y = dy }
				holeList[#holeList + 1] = hp
			end
			if (maps:getMap(1):getTile(dx, dy) == SPAWN) then
				startPos = { x = dx, y = dy }
			end
		end
	end
	maps:addChild(char)
	if (startPos ~= nil) then
		char:setPos(startPos.x, startPos.y)
	else 
		char:setPos(1, 1)
	end
	if (self:contains(btnRes)) then
		btnRes:removeFromParent()
		self:addChildAt(btnRes, self:getNumChildren())
	end
end

if (levelSelect ~= nil) then
	currentLevel = levelSelect
else
	currentLevel = "map1"
end

loadLevel(currentLevel)
function resetLevel(event) 
	if (btnRes:hitTestPoint(event.x, event.y) and isClickable(event)) then
		destroyLevel()
		loadLevel(currentLevel)
	end
end
btnRes:setPosition(application:getContentWidth() - btnRes:getWidth() - 10, 10)
btnRes:addEventListener(Event.MOUSE_UP, resetLevel)
self:addChild(btnRes)

local touchPS = {}
local touchPE = {}
local touchDown = false

function moveMap(act)
	local speed = 5
	if (act == "UP") then
		maps:setPosition(maps:getX(), maps:getY() - speed)
	end
	if (act == "DOWN") then
		maps:setPosition(maps:getX(), maps:getY() + speed)
	end
	if (act == "LEFT") then
		maps:setPosition(maps:getX() - speed, maps:getY())
	end
	if (act == "RIGHT") then
		maps:setPosition(maps:getX() + speed, maps:getY())
	end
end

function onTouchesBegin(event)
	if (event.touch.id == 2) then
		touchDown = true
		touchPS = { x = event.touch.x, y = event.touch.y }
	end
end
function onTouchesMove(event)
	if (touchDown == true) then
		if (event.touch.id == 2) then
			touchPE = { x = event.touch.x, y = event.touch.y }
			moveMap(gesture(touchPS, touchPE))
		end
	end
end
function onTouchesEnd(event)
	touchDown = false
	touchPE = {}
	touchPS = {}
	
	if (event.touch.tapCount == 2) then
		maps:setPosition(0, 0)
	end
end
self:addEventListener(Event.TOUCHES_BEGIN, onTouchesBegin)
self:addEventListener(Event.TOUCHES_MOVE, onTouchesMove)
self:addEventListener(Event.TOUCHES_END, onTouchesEnd)

end