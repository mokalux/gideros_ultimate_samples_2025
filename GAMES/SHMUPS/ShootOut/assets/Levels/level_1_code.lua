Level_1 = Core.class(Sprite)

--maps--
local ship, ship_damage, item, gear
local mapMain = TiledMap.new("Levels/level_1.lua", 1)
local mapSky = TiledMap.new("Levels/level_1.lua", 2)
local mapSkyBold = TiledMap.new("Levels/level_1.lua", 3)

function Level_1:init()
ship_damage = Damage.new()
ship = Ship.new(ship_damage)

mapMain:setPosition(0, -3616)
mapSky:setPosition(0, -3616)
mapSkyBold:setPosition(0, -3616)

self:addChild(mapMain)
self:addChild(mapSky)
self:addChild(ship)
self:addChild(mapSkyBold)
self:addChild(ship_damage)

self.fadeOut = 1
self.counter = 1
self.subcounter = 1
self.shipDied = false

application:setBackgroundColor(255)

--channel = song_1:play(0, true, false)


--self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown)
--self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove)
--self:addEventListener(Event.MOUSE_UP, self.onMouseUp)
self:addEventListener(Event.ENTER_FRAME, self.move)
self:addEventListener(Event.ENTER_FRAME, self.events, self)

end

local contador = 0

function Level_1.move(event)
	local y, x, z = mapMain:getY(), mapSky:getY(), mapSkyBold:getY()
	
	mapMain:setY(y+1)
	mapSky:setY(x+0.4)
	mapSkyBold:setY(z+0.5)
	
	--print(mapMain:getX(), mapMain:getY())
	
	if mapMain:getY() == 0 then
		local map2Main = TiledMap.new("Levels/level_1.lua", 1)
		
		mapMain:addChildAt(map2Main, 1)
		
		map2Main:setPosition(0, -4096)
		
		if mapMain:getY() == 480 then
			self:removeChild(mapMain)
			self:removeChild(mapSky)
			self:removeChild(mapSkyBold)
		end
	end
	
	if mapSky:getY() == 0 then
		local map2Sky = TiledMap.new("Levels/level_1.lua", 2)
		local map2SkyBold = TiledMap.new("Levels/level_1.lua", 3)
		
		mapSky:addChildAt(map2Sky, 1)
		mapSkyBold:addChildAt(map2SkyBold, 1)
		
		map2Sky:setPosition(0, -4096)
		map2SkyBold:setPosition(0, -4096)
		
		if mapSky:getY() == 480 then
			self:removeChild(mapSky)
			self:removeChild(mapSkyBold)
		end
	end
	contador += 1
	if mapMain:getY() >= 3200 then
		
		if contador > 15 then
			if mapMain:getAlpha() >= 0 then
				mapMain:setAlpha(mapMain:getAlpha()-0.02)
				contador = 0
			else
				if application:getBackgroundColor() <= 255 and application:getBackgroundColor() >= 1 then
					application:setBackgroundColor(application:getBackgroundColor()-1.5)
					contador=0
				end
			end
		end
	end
end

fadingOut = 0
function Level_1:events(event)

	self.counter += 1
	self.subcounter += 1
	
	--local gears = {}
	
	--local function createGears(count)
		--for i = 1, count do
		--	gears[#gears + 1] = Gear.new(ship)
		--end
	--end
	
	--createGears(5)
	
	-- INITIALLY I'M TRYING WITH ONLY ONE
	gear = Gear.new(ship)
	
	if self.counter == 100 then
--		self:addChild(gear)
	end
	
	if self.counter == 300 then
		--self:addChild(gears[2])
	end
	
	if self.counter == 600 then
		--self:addChild(gears[3])
	end
	if self.counter == 900 then
		--self:addChild(gears[4])
	end
	if self.counter == 1100 then
		--self:addChild(gears[5])
		--self.counter = 0
	end
		
	if self.subcounter == 1100 then
		print("item 1")
	end
	if self.subcounter == 1990 then
		item = Items.new(ship, 3)
		self:addChild(item)
		print("item 2")
	end
	
	if self.subcounter == 3450 then
		item = Items.new(ship, 2)
		self:addChild(item)
	end
	
	if self.subcounter == 7000 then
		item = Items.new(ship, 3)
		self:addChild(item)
	end
	
	if self.subcounter == 7700 then 
		self.counter = 1101
	end
	
	if self.subcounter == 8000 then
		boss = Boss1.new(ship, true)
		self:addChild(boss)
	end
	
--	if ship_damage.ndamage > 11 then
	if ship_damage.ndamage > math.huge then
		fadingOut += 1
		ship:removeFromParent()
		
		if fadingOut > 20 then
			self.fadeOut -= 0.2
--			channel:setVolume(self.fadeOut)
			fadingOut = 0
		end
		if self.fadeOut <= -0.2 then
			self.shipDied = true
		end
	end
	
	if self.shipDied then
--		channel:stop()
		application:setBackgroundColor(0)
		lives -= 1
		
		--'THE PROBLEM IS IN HERE -- HOW TO REMOVE THE GEAR'
		-- ???????????????????????????????????????????
		
		if lives == 0 then
			--Game:changeScene("game_over", 2, SceneManager.fade)
		else
			--Game:changeScene("level_1", 2, SceneManager.fade)
		end

		self:removeEventListener(Event.ENTER_FRAME, self.move)
		self:removeEventListener(Event.ENTER_FRAME, self.events, self)
	end
	--print(self.counter, self.subcounter)
end

---------- other functions -----------------------------
local dragging, startx, starty

function Level_1.onMouseDown(event)
	dragging = true
	startx = event.x
	starty = event.y
end

function Level_1.onMouseMove(event)
	if dragging then
		local dx = event.x - startx
		local dy = event.y - starty
		mapMain:setX(mapMain:getX() + dx)
		mapMain:setY(mapMain:getY() + dy)
		startx = event.x
		starty = event.y
		
		--print(mapMain:getX(), mapMain:getY())
	end
end

function Level_1.onMouseUp(event)
	dragging = false
end
