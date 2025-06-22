
GameScene = Core.class(Sprite)

GameScene.LEFT_MOVE = "1"
GameScene.RIGHT_MOVE = "2"
GameScene.UP_MOVE = "3"
GameScene.DOWN_MOVE = "4"

local half_width = application:getContentWidth() * 0.5
local floor = math.floor

local level = {
					{0,0,0,0,0,0,0,0,0,0,0,0,0,0},
					{0,1,1,1,1,1,1,1,1,1,1,1,1,0},
					{0,1,0,0,0,0,0,1,0,0,0,0,1,0},
					{0,1,1,1,1,1,1,1,1,1,1,1,1,0},
					{0,1,0,0,0,0,0,0,1,0,1,0,1,0},
					{0,1,1,1,1,1,1,1,1,0,1,0,1,0},
					{0,1,0,0,0,0,0,0,0,0,1,0,1,0},
					{0,1,0,0,0,0,0,0,0,0,1,0,1,0},
					{0,1,1,1,1,1,1,1,1,1,1,1,1,0},
					{0,0,0,0,0,0,0,0,0,0,0,0,0,0}
					}
local tile_width = 64

-- Constructor
function GameScene:init()
	self:addEventListener("enterEnd", self.enterEnd, self)
end

function GameScene:enterEnd()
	print("Loaded GameScene")
	
	application:setBackgroundColor(0x000000)
	local texture_floor = Texture.new("images/white.png", true)
	local texture_wall = Texture.new("images/crate.png", true)
	local map = Sprite.new()
	self:addChild(map)
	self.map = map
	
	self.squares = {}
	for row=1,#level do
		self.squares[row] = {}
		for col=1,#level[row] do
			local square
			if (level[row][col] == 1) then 
				square = Bitmap.new(texture_floor)
			else
				square = Bitmap.new(texture_wall)
			end
			square:setPosition((col-1)*64,(row-1)*64)
			--square:setAnchorPoint(0.5, 0.5)
			map:addChild(square)
			--print(level[row][col], row, col)
			self.squares[row][col] = level[row][col]
		end
	end
	
	--print(#self.squares)
	
	self.worldWidth = map:getWidth()
	self.worldHeight = map:getHeight()
	
	self:createPlayer()
	self:createCamera()
	self:drawController()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

-- Create maze level
function GameScene:createLevel()
	local tilemap = TileMapSingle.new("data/platformer.lua")
	self:addChild(tilemap)
end

-- Create our player
function GameScene:createPlayer()
	local texture = Texture.new("images/red.png", true)
	local player = Bitmap.new(texture)
	--player:setScale(0.6)
	--player:setScale(0.5)
	--player:setAnchorPoint(0.5, 0.5)
	player:setPosition(256, 64)
	self.map:addChild(player)
	self.player = player
	
	self.speedX = 0
	self.speedY = 0
end

-- Create camera following player
function GameScene:createCamera()
	local camera = Camera.new(self.map)
	camera:setFollowMode()
	self.camera = camera
	self.camera:setTarget(self.player:getPosition())
end

-- Update player position
function GameScene:updatePlayer()
	local player = self.player
	local newX = player:getX() + self.speedX
	local newY = player:getY() + self.speedY
	
	--print("onGridSquare", self:onGridSquare(player:getX(), player:getY()))
	if (self:onGridSquare(newX, newY)) then
		self.speedX = 0
		self.speedY = 0
	end
	
	-- Collision with maze
	--if (not self:checkCollision()) then
		player:setPosition(newX, newY)
		--if (self.player:getX() > half_width-32 and self.player:getX() < self.worldWidth - half_width-32) then
			self.camera:setTarget(player:getPosition())
		--end
	--else
		--[[if not (speedX == 0) then
			player:setX(player:getX() - self.speedX)
		end
		if not (speedY == 0) then
			player:setY(player:getY() - self.speedY)
		end
		]]--
		--self.speedX = 0
		--self.speedY = 0
	--end
end

-- Draw left and right arrows to handle the car player
function GameScene:drawController()
	local texture_left = Texture.new("images/left.png", true)
	local icon_left = Bitmap.new(texture_left)
	icon_left:setPosition(10, 620)
	icon_left:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_left:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.speedX = -2
								self.speedY = 0
								self.next_move = GameScene.LEFT_MOVE
							end
						end)	
	self:addChild(icon_left)
	
	local texture_right= Texture.new("images/right.png", true)
	local icon_right = Bitmap.new(texture_right)
	icon_right:setPosition(110, 620)
	icon_right:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_right:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.speedX = 2
								self.speedY = 0
								self.next_move = GameScene.RIGHT_MOVE
							end
						end)
	self:addChild(icon_right)
	
	local texture_up = Texture.new("images/up.png", true)
	local icon_up = Bitmap.new(texture_up)
	icon_up:setPosition(60, 560)
	icon_up:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_up:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.speedX = 0
								self.speedY = -2
								self.next_move = GameScene.UP_MOVE
							end
						end)
	self:addChild(icon_up)
	
	local texture_down = Texture.new("images/down.png", true)
	local icon_down = Bitmap.new(texture_down)
	icon_down:setPosition(60, 680)
	icon_down:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_down:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.speedX = 0
								self.speedY = 2
								self.next_move = GameScene.DOWN_MOVE
							end
						end)
	self:addChild(icon_down)
end

-- Collision with maze
function GameScene:checkCollision()

	if (self.speedX == 0 and self.speedY == 0) then
		return
	end
	
	local player = self.player
	local squares = self.squares
	local newX = player:getX() + self.speedX
	local newY = player:getY() + self.speedY
	local left_tile = floor(newX/ tile_width) + 1
	local right_tile = floor((newX + player:getWidth()) / tile_width) + 1
	local top_tile = floor(newY / tile_width) + 1
	local bottom_tile = floor((newY + player:getHeight()) / tile_width) + 1
	
	--[[if (self.speedX > 0) then
		local square = squares[top_tile][right_tile]
		if (square == 0) then
			print("x,y", player:getX(), player:getY())
			print("right_tile", right_tile)
			print("top_tile", top_tile)
			player:setX(newX)
			self.speedX = 0
			return true
		--elseif (self.next_move !=RIGHT_MOVE) then
			
		end
	end
	
	if (self.speedX < 0) then
		local square = squares[top_tile][left_tile]
		if (square == 0) then
			print("x,y", player:getX(), player:getY())
			print("left_tile", left_tile)
			self.speedX = 0
			return true
		end
	end
	
	if (self.speedY > 0) then
		local current_tileX = left_tile + 1
		local square = squares[bottom_tile][left_tile]
		if (square == 0) then
			print("x,y", player:getX(), player:getY())
			print("current_tileX", left_tile)
			player:setY(newY)
			self.speedY = 0
			return true
		end
	end
	
	if (self.speedY < 0) then
		local current_tileX = left_tile + 1
		local square = squares[top_tile][left_tile]
		if (square == 0) then
			print("x,y", player:getX(), player:getY())
			print("current_tileX", left_tile)
			self.speedY = 0
			return true
		end
	end
	]]--
	
	--print("left", left_tile)
	--print("right", right_tile)
	--print("top", top_tile)
	--print("bottom", bottom_tile)
	
	local collision = false
	
	for col=left_tile, right_tile do
		for row=top_tile, bottom_tile do
			local square = squares[row][col]
			if (square == 0) then
				print("hemos chocado", row, col)
				print("x,y", player:getX(), player:getY())
				print("left", left_tile)
				print("right", right_tile)
				print("top", top_tile)
				print("bottom", bottom_tile)
				local right = player:getX() + player:getWidth()
				local bottom = player:getY() + player:getHeight()
				x_overlaps = (player:getX() < right) and (right > player:getWidth())
				y_overlaps = (player:getY() < bottom) and (bottom > player:getY())
				collision = x_overlaps and y_overlaps
				--collision = true
				return collision
			end
		end
	end
end

function GameScene:changeMoving()
	if (self.next_move == LEFT_MOVE) then
		self.speedX = -2
		self.speedY = 0
	elseif (self.next_move == RIGHT_MOVE) then
		self.speedX = 2
		self.speedY = 0
	end
end

function GameScene:onGridSquare(posX, posY)
	return (posX % tile_width == 0) and (posY % tile_width == 0)
end

-- Update camera and car player
function GameScene:onEnterFrame()
	self:updatePlayer()
	self.camera:update()
end

function GameScene:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end