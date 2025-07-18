
require "box2d"

TrackScene = Core.class(Sprite)

local width = application:getContentWidth()
local height = application:getContentHeight()

local half_width = width * 0.5
local half_height = height * 0.5

local bg_width = 4 * width
local bg_height = 6 * height
local maxY = bg_height - half_height

--[[
local track = {
				--1, 1, 1, 2, 4, 
				--5, 1, 1
				1, 2, 4, 4, 5, 1, 1, 2, 4, 4, 5, 1, 3, 4, 4, 6,
				1, 1, 1
				}
]]--

local track = {
				1, 1, 1, 1, 1, 1, 1, 1, 2,
				4, 4, 4, 4, 4, 4, 4, 4, 3,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 5,
				4, 4, 4, 4, 4, 4, 4, 4, 6, 1
				
				}
local textures = {
					Texture.new("images/tile1.png", true),
					Texture.new("images/tile2.png", true),
					Texture.new("images/tile3.png", true),
					Texture.new("images/tile4.png", true),
					Texture.new("images/tile5.png", true),
					Texture.new("images/tile6.png", true),
				}	

local texture_left = Texture.new("images/left.png", true)
local texture_right = Texture.new("images/right.png", true)
local texture_goal = Texture.new("images/goal.png", true)
local texture_trees = {
						Texture.new("images/tree_short.png", true),
						Texture.new("images/tree_ugly.png", true)
						--Texture.new("images/tree3_00.png", true),
						--Texture.new("images/tree5_00.png", true),
					}
local texture_cars = {
						Texture.new("images/blue_car.png", true),
						Texture.new("images/yellow_car.png", true),
						Texture.new("images/green_car.png", true),
						Texture.new("images/white_car.png", true)
					}
local texture_target = Texture.new("images/circle_yellow.png", true)
local texture_pause = Texture.new("images/pause.png", true)

local font_hud = TTFont.new("fonts/futur1.ttf", 20)

local zoom = 1

local random = math.random
local cos = math.cos
local sin = math.sin
local rad = math.rad
local deg = math.deg
local sqrt = math.sqrt

local function seek(target)
	
end

-- Constructor
function TrackScene:init()
	
	print("TrackScene")
	
	application:setBackgroundColor(0x000000)
	
	self.world = b2.World.new(0, 0, true)
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	
	self.speed = 0.1
	--self.velocity = {0, -1} -- Velocity vector
	self.inc = 0
	self.dirX = 1
	self.dirY = -1
	self.laps = 1
	
	self:drawBackground()
	self:drawCircuit()
	
	--self:setScale(0.5)
	--self.map:setScale(0.5)

	self:addEventListener("enterEnd", self.enterEnd, self)
end


function TrackScene:enterEnd()
		
	--self:debugEnabled()
	
	self:drawCars()
	self:drawHUD()
	--self:drawPlayer()
	
	-- Create box2d camera following car player
	local camera = Camera.new(self)
	self.camera = camera
	camera:update()
	
	self:drawController()

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

-- Draw grass background
function TrackScene:drawBackground()
		
	local map = Sprite.new()
	self:addChild(map)
	self.map = map
	
	local bg = Shape.new()
	bg:setFillStyle(Shape.TEXTURE, Texture.new("images/grass.png", true, {wrap = Texture.REPEAT}) )    
	bg:beginPath(Shape.NON_ZERO)
	bg:moveTo(0,0)
	bg:lineTo(bg_width, 0)
	bg:lineTo(bg_width, bg_height)
	bg:lineTo(0, bg_height)
	bg:lineTo(0, 0)
	bg:endPath()
		
	self.map:addChild(bg)
	
	self.worldWidth = map:getWidth()
	self.worldHeight = map:getHeight()
	
	print(bg_width, bg_height)
	print(self.worldWidth, self.worldHeight)
		
	--create bounding walls to surround world and not screen
	self:wall(0,self.worldHeight/2,10,self.worldHeight/2*2)
	self:wall(self.worldWidth/2,0,self.worldWidth,10)
	self:wall(self.worldWidth,self.worldHeight/2,10,self.worldHeight)
	self:wall(self.worldWidth/2,self.worldHeight,self.worldWidth,10)
end

-- Draw tiled circuit
function TrackScene:drawCircuit()
	local dirX, dirY = 1, -1	
	local posX, posY = 400, 2000
	local previous_tile, previous_index
	--local next_index
	
	self.objects = {}
	self.points = {} -- Polygon shape
	
	self.borders = {} 
	self.borders_inside = {} 
	
	local map = self.map
	
	for a=1, #track do
		local index = track[a]
				
		local tile = Bitmap.new(textures[index])
		map:addChild(tile)
		
		if (a > 1) then
			if (index == 1) then
				
				if (previous_index == 5) then
					posY = posY - tile:getHeight() 
					posX = posX + 16
					dir = -1
				elseif (previous_index == 3) then
					posX = posX + 16
					posY = posY + previous_tile:getHeight()
					dir = 1
				else
					posY = posY + dirY * tile:getHeight()
				end
			elseif (index == 2) then
				posY = posY - tile:getHeight() 
			elseif (index == 3) then
			
				if (previous_index == 1) then
					posX = posX - 16 * scale
					posY = posY - tile:getHeight()
				else
					posX = posX + previous_tile:getWidth()
					dirY = 1
				end
				
			elseif (index == 4) then
				if (previous_index == 2) then
					posX = posX + previous_tile:getWidth() * dirX
				elseif (previous_index == 5) then
					posX = posX - tile:getWidth()
					posY = posY + 16
				else
					posX = posX + previous_tile:getWidth() * dirX
				end
			elseif (index == 5) then
			
				if (previous_index == 1) then
					posX = posX - 16
					posY = posY + previous_tile:getHeight()
					dirX = -1
				else
					posX = posX + previous_tile:getWidth()
					posY = posY - 16
				end
			elseif (index == 6) then
				posX = posX + tile:getWidth() * dirX
				posY = posY - 16
				
				dirY = -1
			end
		else		
			-- Draw goal
			local goal = Bitmap.new(texture_goal)
			goal:setPosition(posX + 25, posY)
			
			map:addChild(goal)
		end
		
		tile:setPosition(posX, posY)
		
		-- Draw trees and other collision objects
		self.dirX = dirX
		self.dirY = dirY
		
		self:drawObjects(tile, index, a)
		
		previous_tile = tile
		previous_index = index
		
		--print("dirY", dirY)
	end
	
	--self:drawPoints()
	self:drawBorders(self.borders)
	self:drawBorders(self.borders_inside)
	
	-- Draw objects over track
	for a=1, #self.objects do
		self.map:addChild(self.objects[a])
	end
	
end

-- Draw all cars
function TrackScene:drawCars()

	local coords = {
						{460, 2200},
						{580, 2200},
						{460, 2300},
						{580, 2300}
					}
	local cars = {}
	
	for a = 1, #coords do
		local player = Player.new(texture_cars[a], self)
		player:updatePosition(coords[a][1], coords[a][2])
		
		if (a==1) then
			self.player = player
		else
			player.computer = true
		end
		
		cars[a] = player
		self.map:addChild(player)
	end
	
	self.cars = cars
end

-- Draw car player
function TrackScene:drawPlayer(x, y)
	
	--[[
	local player = Bitmap.new(texture_car)
	player:setAnchorPoint(0.5, 0.5)
	player:setScale(0.5)
	self.player = player

	self.map:addChild(player)
	player:setPosition(450, 2200)
		
	-- Physic player body
	local world = self.world
	local config = {
					type = "dynamic",
					update = false
				   }
	world:createRectangle(player, config)

	--player.body:setLinearDamping(0.4)
	player.body:setAngularDamping(0.1)
	player.body:setPosition(player:getX(), player:getY())
	
	]]--
	
	local player = Player.new(texture_car, self)
	player:updatePosition(450, 2200)
	self.player = player
	
	self.map:addChild(player)
	
end

-- Draw objects near road
function TrackScene:drawObjects(tile, tile_index, track_index)
	
	--local points = {}
	--print("tile:getWidth()", tile:getWidth())
	
	local EXTRA_BORDER = 30
	local borders = self.borders
	local borders_inside = self.borders_inside
	
	local next_index
	if (track_index < #track) then
		next_index = track[track_index + 1]
	else
		next_index = nil
	end
	
	--print("next_index", next_index)
	local dirY = self.dirY
	
	if (tile_index == 1) then -- Up to down or Down to up
	
		for a=1, 2 do
		
			local object_left = Tree.new(texture_trees[random(2)], self)
			object_left:setPosition(tile:getX() - 55, tile:getY() +  a * 70)

			local object_right = Tree.new(texture_trees[random(2)], self)
			object_right:setPosition(tile:getX() + tile:getWidth() + 55, tile:getY() + a * 70)
		end
		
		self.points[track_index] = { tile:getX() + tile:getWidth() * 0.5, tile:getY() + tile:getHeight() * 0.5}
		
		--print(self.dirX, self.dirY)
		
		-- Add points to collision border
		if (dirY > 0) then
			table.insert(borders, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY() + EXTRA_BORDER})
			table.insert(borders, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
			
			table.insert(borders_inside, {tile:getX() - EXTRA_BORDER, tile:getY() + EXTRA_BORDER})
			table.insert(borders_inside, {tile:getX() - EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
		else
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + EXTRA_BORDER})
			
			table.insert(borders_inside, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
			table.insert(borders_inside, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY() + EXTRA_BORDER})
		end
			
		
	elseif (tile_index == 4) then -- Left to right or Right to left
	
		for a=1, 2 do
			local object_up = Tree.new(texture_trees[random(2)], self)
			object_up:setPosition(tile:getX() + a * 65, tile:getY() - 65)
			
			local object_down = Tree.new(texture_trees[random(2)], self)
			object_down:setPosition( tile:getX() + a * 65, tile:getY() + tile:getHeight() + 65)
		end
		
		self.points[track_index] = { tile:getX() + tile:getWidth() * 0.5, tile:getY() + tile:getHeight() * 0.5}
		
		--[[
		local dirX = self.dirX
		if (dirX > 0) then
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + EXTRA_BORDER})
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
		else
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + EXTRA_BORDER})
		end
		]]--
		
	elseif (tile_index == 2) then
		local object1 = Tree.new(texture_trees[random(2)], self)
		object1:setPosition(tile:getX(), tile:getY())
		
		local object2 = Tree.new(texture_trees[random(2)], self)
		object2:setPosition(tile:getX() - 55, tile:getY() + tile:getHeight())
		
		local object3 = Tree.new(texture_trees[random(2)], self)
		object3:setPosition(tile:getX() - 50, tile:getY() + tile:getHeight() - 80)
		
		local object4 = Tree.new(texture_trees[random(2)], self)
		object4:setPosition(tile:getX() + 80, tile:getY() - 10)
		
		local object5 = Tree.new(texture_trees[random(2)], self)
		object5:setPosition(tile:getX() + 180, tile:getY() - 30)
		
		local object6 = Tree.new(texture_trees[random(2)], self)
		object6:setPosition(tile:getX() - 40, tile:getY() + 100)
		
		self.points[track_index] = { tile:getX() + tile:getWidth() * 0.5, tile:getY() + tile:getHeight() * 0.8}
		
		-- Add points to collision border
		if (dirY > 0) then
			table.insert(borders, {tile:getX() + tile:getWidth() , tile:getY() - EXTRA_BORDER})
			table.insert(borders, {tile:getX(), tile:getY() + EXTRA_BORDER})
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
						
		else
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
			table.insert(borders, {tile:getX(), tile:getY() + EXTRA_BORDER})
			table.insert(borders, {tile:getX() + tile:getWidth() , tile:getY() - EXTRA_BORDER})
						
		end
	elseif (tile_index == 3) then
		--local object1 = Tree.new(texture_trees[random(2)], self)
		--object1:setPosition(tile:getX() + tile:getWidth(), tile:getY())
		
		--local object2 = Tree.new(texture_trees[random(2)], self)
		--object2:setPosition(tile:getX() + tile:getWidth() + 55, tile:getY() + self:getHeight())
		
		--local object3 = Tree.new(texture_trees[random(2)], self)
		--object3:setPosition(tile:getX() + tile:getWidth() + 50, tile:getY() + self:getHeight() - 80)
		
		self.points[track_index] = { tile:getX() + tile:getWidth() * 0.2, tile:getY() + tile:getHeight() * 0.5}
		
		-- Add points to collision border
		if (dirY > 0) then
			table.insert(borders, {tile:getX(), tile:getY() - EXTRA_BORDER})
			table.insert(borders, {tile:getX() + tile:getWidth(), tile:getY()})
			table.insert(borders, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
		else
			table.insert(borders, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY() + tile:getHeight() - EXTRA_BORDER})
			table.insert(borders, {tile:getX() + tile:getWidth(), tile:getY()})
			table.insert(borders, {tile:getX(), tile:getY() - EXTRA_BORDER})
		end
		
	elseif (tile_index == 5) then
		local object1 = Tree.new(texture_trees[random(2)], self)
		object1:setPosition(tile:getX() + tile:getWidth(), tile:getY() + tile:getHeight())
		
		local object2 = Tree.new(texture_trees[random(2)], self)
		object2:setPosition(tile:getX() + 50, tile:getY() + tile:getHeight() + 40)
		
		local object3 = Tree.new(texture_trees[random(2)], self)
		object3:setPosition(tile:getX() + tile:getWidth() + 95, tile:getY() + tile:getHeight() + 20)
		
		self.points[track_index] = { tile:getX() + tile:getWidth() * 0.3, tile:getY() + tile:getHeight() * 0.3}
		
		-- Add points to collision border
		if (dirY > 0) then
			table.insert(borders, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY()})
			table.insert(borders, {tile:getX() + tile:getWidth(), tile:getY() + tile:getHeight()})
			table.insert(borders, {tile:getX() , tile:getY() + tile:getHeight() + EXTRA_BORDER})
		else
			table.insert(borders, {tile:getX() , tile:getY() + tile:getHeight() + EXTRA_BORDER})
			table.insert(borders, {tile:getX() + tile:getWidth(), tile:getY() + tile:getHeight()})
			table.insert(borders, {tile:getX() + tile:getWidth() + EXTRA_BORDER, tile:getY()})
		end
		
	elseif (tile_index == 6) then
		local object1 = Tree.new(texture_trees[random(2)], self)
		object1:setPosition(tile:getX(), tile:getY() + tile:getHeight())
		
		local object2 = Tree.new(texture_trees[random(2)], self)
		object2:setPosition(tile:getX() - 15, tile:getY() + tile:getHeight() - 100)
		
		local object3 = Tree.new(texture_trees[random(2)], self)
		object3:setPosition(tile:getX() + 95, tile:getY() + tile:getHeight() + 20)
		
		local object4 = Tree.new(texture_trees[random(2)], self)
		object4:setPosition(tile:getX() - 45, tile:getY() + tile:getHeight() - 200)
		
		self.points[track_index] = { tile:getX() + tile:getWidth() * 0.8, tile:getY() + tile:getHeight() * 0.5}
		
		-- Add points to collision border
		if (dirY > 0) then
			table.insert(borders, {tile:getX() + EXTRA_BORDER, tile:getY()})
			table.insert(borders, {tile:getX() , tile:getY() + tile:getHeight()})
			table.insert(borders, {tile:getX() + tile:getWidth() , tile:getY() + tile:getHeight() + EXTRA_BORDER})
		else
			table.insert(borders, {tile:getX() + tile:getWidth() , tile:getY() + tile:getHeight() + EXTRA_BORDER})
			table.insert(borders, {tile:getX() , tile:getY() + tile:getHeight()})
			table.insert(borders, {tile:getX() - EXTRA_BORDER, tile:getY()})
		end
		
	end
end

-- Draw path of the track
function TrackScene:drawPoints()
	
	local points = self.points
	print("#self.points", #points)
	
	--[[
	for a=1, #points do
		print(points[a][1], points[a][2])
	end
	]]--
	
	--[[
	local shape = Shape.new()
	--shape:setFillStyle(Shape.SOLID, 0xff0000)
	shape:setLineStyle(2, 0xff0000, 1)
	shape:drawPoly(points)
	self.map:addChild(shape)
	
	for a = 1, #points do
		local target = Bitmap.new(texture_target)
		target:setScale(0.1)
		target:setPosition(points[a][1], points[a][2])
		self.map:addChild(target)
	end
	]]--
end

-- Draw borders of the track	
function TrackScene:drawBorders(borders)
	
	--local borders = self.borders
	
	local shape = Shape.new()
	shape:setLineStyle(4, 0x48D1CC)
	self.map:addChild(shape)
	
	shape:drawPoly(borders)
	
	local world = self.world
	--world:createTerrain(shape, self.borders)
	local body = world:createBody{type = b2.STATIC_BODY}
	
	local vertices = {}
	for a=1, #borders do
		local x, y = unpack(borders[a])
		table.insert(vertices, x)
		table.insert(vertices, y)
	end
	
	local chain = b2.ChainShape.new()
	--chain:createChain(unpack(vertices))
	
	world:createTerrain(shape, vertices)
end

-- Draw left and right arrows to handle the car player
function TrackScene:drawController()
		
	local icon_left = Bitmap.new(texture_left)
	icon_left:setPosition(20, 360)
	icon_left:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_left:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.inc = -1
								self.speed = self.speed - 1
								
								if (self.speed < 0) then
									self.speed = 0
								end
							end
						end)
							
	icon_left:addEventListener(Event.MOUSE_UP,
						function(event)
							if (icon_left:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.inc = 0
							end
						end)
							
	self:addChild(icon_left)
	
	local icon_right = Bitmap.new(texture_right)
	icon_right:setPosition(700, 360)
	icon_right:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_right:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.inc = 1
								self.speed = self.speed - 1
								
								if (self.speed < 0) then
									self.speed = 0
								end
							end
						end)
							
	icon_right:addEventListener(Event.MOUSE_UP,
						function(event)
							if (icon_right:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.inc = 0
							end
						end)
							
	self:addChild(icon_right)
end

-- Draw laps and elapsed time
function TrackScene:drawHUD()
	local text_laps = TextField.new(font_hud, self.laps.."/5")
	text_laps:setTextColor(0xffffff)
	text_laps:setShadow(1, 1, 0x0000ff)
	text_laps:setPosition(50, 15)
	self:addChild(text_laps)
	
	self.text_laps = text_laps
	
	local icon_pause = Bitmap.new(texture_pause)
	icon_pause:setScale(0.7)
	icon_pause:setPosition(730, 15)
	self:addChild(icon_pause)
	
	icon_pause:addEventListener(Event.MOUSE_DOWN,
						function(event)
							if (icon_pause:hitTestPoint(event.x, event.y)) then
								event:stopPropagation()
								self.paused = not self.paused
							end
						end)
end

-- Update laps counter
function TrackScene:updateLaps()

	self.laps = self.laps + 1
	
	local text_laps = self.text_laps
	text_laps:setText(self.laps.."/5")
	
	if (self.laps == 5) then
		self.paused = true
	end
end

-- Update camera and car player
function TrackScene:onEnterFrame()
	
	if self.paused then
		return
	end
	
	--self:updatePlayer()	
	
	self:updateCars()
	
	self.camera:update()
	
end

-- Update car player position and rotation
function TrackScene:updatePlayer()
	
	local player = self.player
				
	local speed = player:increaseSpeed()
	
	local angle = player.body:getAngle() + rad(self.inc * 2)
	player.body:setAngle(angle)
	
	--local velocity = self.velocity
	local velocityX = speed * sin(angle)
	local velocityY = -speed * cos(angle)
	player.body:setLinearVelocity(velocityX, velocityY)
		
	self.world:step(1/30, 8, 3)

	player:setRotation(deg(angle))
				
	local bodyX, bodyY = player.body:getPosition()
	player:setPosition(bodyX, bodyY)
	
end

-- Update all cars
function TrackScene:updateCars()

	local points = self.points
	
	for a=1, #self.cars do
		local car = self.cars[a]
		car:increaseSpeed()
		
		local speed = car.speed
				
		-- Near control point
		local index = car.index
		local next_index = index + 1
		if (next_index == #points + 1) then
			next_index = 1
		end
		local diff = (car:getX() - points[index][1]) + (car:getY() - points[index][2])
		--local diff2 = (car:getX() - points[next_index][1]) + (car:getY() - points[next_index][2])
		local dist = sqrt(diff * diff)
		--local dist2 = diff2 * diff2
			
		local change = false
		--if (dist2 < dist) then
		
		--print("dist", dist)
		if (dist < 100) then
		
			if (index == #points) then
				index = 1
				
				if (not car.computer) then
					self:updateLaps()
				end
			else
				index = index + 1
			end
						
			change = true
		end
		
		if (car.computer) then -- Every car must follow the path
		
			local next_index = index + 1
			if (next_index == #points + 1) then
				next_index = 1
			end
			--local segment = {points[next_index][1] - points[index][1],
			--			 points[next_index][2] - points[index][2]}
			local velocity = Vector.new(car.body:getLinearVelocity())
			local location = Vector.new(car:getX() + velocity.x, car:getY() + velocity.y) --Position())
								
			-- TODO car.start = start 
			-- http://natureofcode.com/book/chapter-6-autonomous-agents/
			local path_start = Vector.new(points[index][1], points[index][2])
			local path_end
			if (index < #points) then
				path_end = Vector.new(points[index + 1][1], points[index + 1][2])
			else
				path_end = Vector.new(points[1][1], points[1][2])
			end
						
			local vector_a = Vector.sub(location, path_start)
			local vector_b = Vector.sub(path_end, path_start)
			
			--local theta = vector_a:angleTo(vector_b)
			vector_b:normalize_inplace()
			--vector_b = Vector.mul(vector_a:len() * cos(theta), vector_b)
			vector_b = Vector.mul(vector_a:dot(vector_b), vector_b)
			
			local normal_point = Vector.add(path_start, vector_b)						
			local angle = car.body:getAngle()
			
			local distance = Vector.dist(location, normal_point)
			--print("distance", distance)
			
			if (distance > random(10, 20)) then
				-- Seek target point
				vector_b = Vector.sub(path_end, path_start)
				vector_b:normalize_inplace()
				vector_b = Vector.mul(80, vector_b) -- TODO Change 60 related to car speed
				local target = Vector.add(normal_point, vector_b)
				
				local desired = Vector.sub(target, location)
				
				local angle_path = vector_b:angleTo(velocity)
				local angle_target = desired:angleTo(velocity)
				
				if (change) then
					--print("vector_b", vector_b:unpack())
					
					--print("velocity", velocity:unpack())
					--print("angle_path", deg(angle_path))
					--print("angle_target", deg(angle_target))
					
					--print("desired", desired:unpack())
					--print("location", location:unpack())
					--print("path_end", path_end:unpack())
				end	
				
				-- Angle must be between 0 and math.pi radians
				if (angle_target < - math.pi) then
					angle_target = 2 * math.pi + angle_target
				elseif (angle_target > math.pi) then
					angle_target = -angle_target + math.pi
				end
				
				if (angle_target > 0) then
					angle = angle + rad(3)
										
					--[[
					if (angle_path > math.pi * 0.5) then
						print("raro 1")
						angle = angle + rad(-3)
					else
						angle = angle + rad(3)
					end
					]]--
				elseif (angle_target < 0) then
					angle = angle + rad(-3)
									
					--[[
					if (angle_path > math.pi * 0.5) then
						print("raro 2")
						angle = angle + rad(3)
					else
						angle = angle + rad(-3)
					end
					]]--
				end
				
				--print("desired", desired:unpack())
				--print("angle", deg(angle))
			end
			
			car.angle = angle
			car.body:setAngle(angle)
			
			--[[
			if change then
				print("index", index)
			end
			]]--
		else
			-- Use arrows to rotate car
			local angle = car.body:getAngle() + rad(self.inc * 3)
			car.body:setAngle(angle)
			
			car.angle = angle	
		end
		
		car.index = index
		
		local angle = car.body:getAngle()
		local velocityX = speed * sin(angle)
		local velocityY = -speed * cos(angle)
		car.body:setLinearVelocity(velocityX, velocityY)
		
		--car.body:applyLinearImpulse(velocityX, velocityY, car.body:getPosition())
	end
	
	-- Update box2d world
	self.world:step(1/30, 8, 3)
	
	-- Update sprite position
	for a=1, #self.cars do
		local car = self.cars[a]
		
		local angle = car.angle
		car:setRotation(deg(angle))
		
		local bodyX, bodyY = car.body:getPosition()
		car:setPosition(bodyX, bodyY)
	end
end

-- Collision callback
function TrackScene:onBeginContact(event)
	
	-- Reduce car speed * 0.9
	
	self.collision = true
end

-- Debug box2d
function TrackScene:debugEnabled()
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self.map:addChild(debugDraw)
end

-- for creating objects using shape
-- as example - bounding walls
function TrackScene:wall(x, y, width, height)
	local wall = Shape.new()
	--define wall shape
	wall:beginPath()
	wall:setFillStyle(Shape.SOLID, 0x0000ff)
	--we make use (0;0) as center of shape,
	--thus we have half of width and half of height in each direction
	wall:moveTo(-width/2,-height/2)
	wall:lineTo(width/2, -height/2)
	wall:lineTo(width/2, height/2)
	wall:lineTo(-width/2, height/2)
	wall:closePath()
	wall:endPath()
	wall:setPosition(x,y)
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(wall:getX(), wall:getY())
	body:setAngle(wall:getRotation() * math.pi/180)
	local poly = b2.PolygonShape.new()
	poly:setAsBox(wall:getWidth()/2, wall:getHeight()/2)
	local fixture = body:createFixture{shape = poly, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	wall.body = body
	wall.body.type = "wall"
	
	--add to scene
	self.map:addChild(wall)
	
	--return created object
	return wall
end

function TrackScene:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
