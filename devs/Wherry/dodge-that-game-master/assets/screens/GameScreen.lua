local Obstacle 		= require "objects.Obstacle"
local Player		= require "objects.Player"
local PolarObject 	= require "objects.PolarObject"
local Ring 			= require "rings.Ring"
local Screen 		= require "screens.Screen"

local GameScreen = Core.class(Screen)

function GameScreen:load(...)
	self.gameContainer = Sprite.new()
	self.gameContainer:setPosition(screenWidth / 2, screenHeight / 2)
	self:addChild(self.gameContainer)

	self.currentRing = 1

	self.rings = {}
	for i = 1, Ring.TYPES_COUNT do
		self.rings[i] = Ring.new(i, 1)
		self.gameContainer:addChild(self.rings[i])
	end

	self.polarObjects = {}

	self.players = {}

	local player1 = Player.new(self.rings[self.currentRing].radius, 0, nil, "yellow")
	self.gameContainer:addChild(player1)
	table.insert(self.polarObjects, player1)
	self.players[1] = player1

	local player2 = Player.new(self.rings[self.currentRing].radius, 0, nil, "blue")
	self.gameContainer:addChild(player2)
	table.insert(self.polarObjects, player2)
	self.players[2] = player2
	self.players[2]:setVelocity(-self.players[2].velocity)

	for i = 1, 7 do
		local obstacle = Obstacle.new(self.rings[math.random(1, #self.rings)].radius, math.random(0, math.pi * 2))
		self.gameContainer:addChild(obstacle)
		table.insert(self.polarObjects, obstacle)
	end

	self:addEventListener(Event.KEY_DOWN, GameScreen.onKeyDown, self)
end

function GameScreen:onKeyDown(e)
	-- ring movement
	local newRing = self.currentRing
	if e.keyCode == KeyCode.DOWN then
		newRing = newRing - 1
		if newRing < 1 then 
			newRing = 1;
		end
		self.currentRing = newRing
		self.players[1]:setRadius(self.rings[self.currentRing].radius)
	elseif e.keyCode == KeyCode.UP then
		newRing = newRing + 1
		if newRing > Ring.TYPES_COUNT then 
			newRing = Ring.TYPES_COUNT;
		end

		self.currentRing = newRing
		self.players[1]:setRadius(self.rings[self.currentRing].radius)
	end

	-- ring morphing
	if e.keyCode == KeyCode.LEFT then
		for i = 1, Ring.TYPES_COUNT do
			self.rings[i]:swapState(self.rings[i].state - 1)
		end
	elseif e.keyCode == KeyCode.RIGHT then
		for i = 1, Ring.TYPES_COUNT do
			self.rings[i]:swapState(self.rings[i].state + 1)
		end
	end
end

function GameScreen:unload()

end

function GameScreen:update(deltaTime)
	for i, object in ipairs(self.polarObjects) do
		object:update(deltaTime)

		if object.type == "obstacle" then
			object:setAlpha(0.2)
		end
		for j, player in ipairs(self.players) do
			if object ~= player then
				local isHit, distance2 = player:hitTestObject(object)
				if isHit then
					-- TODO
				end

				if object.type == "obstacle" then
					object:setAlpha(object:getAlpha() + math.max(0, 1 - distance2 / 5000))
				end
			end
		end
	end
	for i = 1, Ring.TYPES_COUNT do
		self.rings[i]:update(deltaTime)
	end
end

return GameScreen