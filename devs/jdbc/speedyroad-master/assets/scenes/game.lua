GameScene = Core.class(Sprite)

local width = application:getContentWidth()
local height = application:getContentHeight()

local TILE_WIDTH = 64
local TILE_HEIGHT = 64

local NORMAL_SPEED = 0.5 -- 1
local MAX_SPEED = 4 -- 6

-- Get isometric coordinates from cartesian coordinates (x,y)
function twoDToIso(x, y)
	local isoX = x -y
	local isoY = (x + y) / 2
	
	return isoX, isoY
end

-- Get cartesian coordinates from isometric (isoX, isoY)
function isoTo2D(isoX, isoY)
	local x = (2 * isoY + isoX) / 2
	local y = (2 * isoY - isoX) / 2
  
	return x,y
end

function GameScene.setup()
	GameScene.font_title = getTTFont("fonts/quantico_bold.ttf", 50)
	GameScene.font = getTTFont("fonts/quantico_bold.ttf", 30, 24)
end

-- Constructor
function GameScene:init()
	application:setBackgroundColor(0x000000)
	collectgarbage()
	self.paused = true
	self.counter = 0
	self.speed = { x = NORMAL_SPEED * 2, y = NORMAL_SPEED}
	self.num = math.random(1,3)
	self:addEventListener("enterEnd", self.enterEnd, self)
end

-- Scene is loaded
function GameScene:enterEnd()
	self:draw_road()
	self:draw_player()
	self:draw_title()
	self:draw_hud()
	
	self.near_vehicles = {}
	
	SoundManager.play_music()
	
	self:draw_tap()
	
	Advertise.showBanner()
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

-- Add event listeners to start playing
function GameScene:start_playing()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	self.increase_speed = true
	self.paused = false
end

-- Remove event listeners
function GameScene:stop_playing()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:removeEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

-- Draw title
function GameScene:draw_title()
	local title = Sprite.new()
	self:addChild(title)
	self.title = title
	
	local title1 = TextField.new(GameScene.font_title, getString("SPEEDY"))
	title1:setTextColor(0xffffff)
	title1:setShadow(2,1, 0x000fff)
	title1:setRotation(-30)
	title:addChild(title1)
	local title_animation1 = MovieClip.new{{1, 20, title1, {x = {-100, (width - title1:getWidth()) * 0.5, "linear"}, y = 180}}}
	self.title_animation1 = title_animation1
	
	local title2 = TextField.new(GameScene.font_title, getString("ROAD"))
	title2:setTextColor(0xffffff)
	title2:setShadow(2,1, 0x00fff)
	title2:setRotation(-30)
	title:addChild(title2)
	
	local title_animation2 = MovieClip.new{{1, 20, title2, {x = {width, (width - title2:getWidth()) * 0.5, "linear"}, y = 230}}}
	self.title_animation2 = title_animation2
end

-- Remove title from screen
function GameScene:remove_title()
	local title = self.title
	if (title and self:contains(title)) then
		self.title_animation1:gotoAndStop(1)
		self.title_animation1:gotoAndStop(1)
		self:removeChild(self.title)
	end
end

-- Draw "Tap to start"
function GameScene:draw_tap()
	local text = TextField.new(GameScene.font, getString("touch_speed"))
	text:setTextColor(0x000000)
	local blink = MovieClip.new{
					{1, 30, text, {alpha={1,0.2,"linear"}}},
					{31, 60, text, {alpha={0.2,1,"linear"}}}
	}
	blink:setGotoAction(60, 1)	
	text:setPosition((width - text:getWidth()) * 0.5, 340)
	self:addChild(blink)
	
	blink:addEventListener(Event.MOUSE_UP, function(event)
		event:stopPropagation()
		self:removeChild(blink)
		blink = nil
		
		SoundManager.play_effect("revup")
		
		self:remove_title()
		
		-- Wait 0.5 second and play
		local timer = Timer.new(500, 1)
		timer:addEventListener(Event.TIMER, function()
			self:start_playing()
		end)
		timer:start()
	end)
end

-- Draw road formed by blocks
function GameScene:draw_road()
	local road = Sprite.new()
	local block_list = {}

	--local num = math.random(3,4)
	--local num = 8
	local num = 1
	
	-- Rendering blocks
	for a=0,12 do
		
		if (a > 2) then
			num = 6
		end
		
		local block = Block.new(num)
		block:setPosition(twoDToIso(0, TILE_HEIGHT * a))
		table.insert(block_list, block)
		road:addChild(block)
		
		num = num -1
		if (num < 0) then
			num = math.random(0,3)
		end
	end

	road:setPosition(-50, -260)
	
	self.road = road
	self.block_list = block_list
	
	self:addChild(road)
end

-- Draw player car
function GameScene:draw_player()
	local car = Player.new()
	--local x = 7 * TILE_WIDTH + width * 0.5 - TILE_WIDTH * 0.7
	--local y = -TILE_HEIGHT * 0.4
	--print(x,y)
	
	--car:setPosition(twoDToIso(x, y))
	car:setPosition(30, 262)
	self:addChild(car)
	--local block = self.block_list[#self.block_list-4]
	--print("block:getPosition()", block:getPosition())
	--block:setColorTransform(1, 0, 0)
	--block:addChild(car)
	self.car = car
	
	self.car_width = car:getWidth() * 0.5
	self.car_height = car:getWidth() * 0.5
	self.car_x, self.car_y = isoTo2D(car:getPosition())
	
	SoundManager.play_effect("engine", true)
end

-- Draw hud
function GameScene:draw_hud()
	local hud = Hud.new()
	self:addChild(hud)
	self.hud = hud
end

-- User taps on the screen
function GameScene:onMouseDown(event)
	self.increase_speed = false
	SoundManager.stop_effect()
	SoundManager.play_effect("brake")
end

-- User stops touching the screen
function GameScene:onMouseUp(event)
	self.increase_speed = true
	SoundManager.stop_effect()
	SoundManager.play_effect("accel")
end

-- Moving road
function GameScene:onEnterFrame(event)
	if (self.paused) then
		return
	end	
	
	local counter = self.counter
	local road = self.road
	local block_list = self.block_list
	
	-- Check collision
	local collision = self:check_collision()
	if (collision) then
		return
	end
	
	-- Check only last added block
	local block = block_list[#block_list]
	local x,y = road:localToGlobal(block:getPosition())
	
	if (y >= 150) then
		
		counter = counter + 1
		
		-- Update hud
		self.hud:update(self.speed)
		
		if (block and road:contains(block)) then	
			
			road:removeChild(block)
			
			-- Create a different new block
			self.num = self.num -1
			block = Block.new(self.num)
			
			if (self.num < 0) then
				self.num = math.random(1,3)
			end
			
			block:setPosition(twoDToIso(0, -TILE_HEIGHT * counter))
			road:addChild(block)
			
			for a=1,#block_list-1 do
				road:addChild(block_list[a])
			end
			
			table.remove(block_list, #block_list)
			table.insert(block_list, 1, block) -- Use another block
		end
	else
		-- Update blocks and vehicles
		self:update()
	end
	
	self.counter = counter
	
	local speed = self.speed
	road:setPosition(road:getX() - speed.x, road:getY() + speed.y)
		
	if (self.increase_speed and speed.y < MAX_SPEED) then
		-- Increase speed		
		speed.x = speed.x + 0.2
		speed.y = speed.y + 0.1
	elseif (speed.y > NORMAL_SPEED) then
		-- Decrease speed		
		speed.x = speed.x - 2
		speed.y = speed.y - 1
	elseif (speed.y < NORMAL_SPEED) then
		speed = { x = NORMAL_SPEED * 2, y = NORMAL_SPEED}
		SoundManager.play_effect("engine", true)
	end
	
	-- Activate engine sound again
	if (not SoundManager.is_playing()) then
		SoundManager.play_effect("engine", true)
	end
	
	self.speed = speed		
end

-- Update blocks and vehicles
function GameScene:update()
	local speed = self.speed
	local block_list = self.block_list
	
	-- Update vehicles on blocks
	for a=1,#block_list do
		block_list[a]:update()
	end
		
	-- Update near vehicles
	local near_vehicles = self.near_vehicles
	if (near_vehicles and #near_vehicles > 0) then
		for a=#near_vehicles,1 do
			local vehicle = near_vehicles[a]
			local x, y = vehicle:getPosition()
			if (x < -50 or x > width + 50) then
				-- Not visible
				table.remove(near_vehicles, a)
			else
				vehicle:setPosition(vehicle:getX() - speed.x, vehicle:getY() + speed.y)
			end
		end
	end
end

-- Check collision between car player and vehicles
function GameScene:check_collision()
	local road = self.road
	local block_list = self.block_list
	local car = self.car
	local car_width = self.car_width
	local car_height = self.car_height
	local car_x,car_y = self.car_x, self.car_y --isoTo2D(car:getPosition()) -- Always the same
	
	for a=#block_list-3,1,-1 do
		
		local block = block_list[a]
		block_x, block_y = isoTo2D(road:localToGlobal(block:getPosition()))
				
		if (car_y + TILE_HEIGHT > block_y) then
			--or car_y < block_y) then
			local vehicle_list = block.vehicle_list
			if (vehicle_list) then
				--block:setColorTransform(0,1,0)
				
				for b=1,#vehicle_list do
					local vehicle = vehicle_list[b]
										
					local tmpX, tmpY = isoTo2D(vehicle:getPosition())
					local x, y = block_x + tmpX, block_y + tmpY
					
					-- Near vehicles moving from right to left
					if (vehicle.direction == 1) and (x + y > car_x + car_y) and (math.abs(x-car_x) < 30) then
						--vehicle:setColorTransform(0,1,0)
						block:removeChild(vehicle)
						
						vehicle:setPosition(twoDToIso(x, y))
						self:addChild(vehicle)
						
						table.insert(self.near_vehicles, vehicle)
					end
					
					-- Possible collision					
					if (car_x < x + car_height and x < car_x + car_width and
						car_y < y + car_width and y < car_y + car_height) then 
						
						self:collision_response()
						
						--print("COLLISION HAPPENS", car_x, car_y, x, y)
						--print(twoDToIso(x,y), car:getPosition())
						--vehicle:collide()						
						return true
					end
				end
				
				break
			end
		end
	end
	
	-- Collision with near vehicles
	local near_vehicles = self.near_vehicles
	for a=1,#near_vehicles do
		local vehicle = near_vehicles[a]
		local x,y = isoTo2D(vehicle:getPosition())
		if (car_x < x + car_height and x < car_x + car_width and
						car_y < y + car_width and y < car_y + car_height) then
			self:collision_response()
			return true	
		end
	end
	
	return false
end

-- Car stops moving and play again
function GameScene:collision_response()
	self.paused = true

	SoundManager.stop_music()
	SoundManager.stop_effect()
	SoundManager.play_effect("crash")
	
	self:stop_playing()

	local distance = tonumber(self.hud:get_distance())
	local score = Score.new(distance)
	self:addChild(score)
	
	MovieClip.new{{1, 10, score, {x = {-width, 0, "linear"}}}}
	
	--self:play_again()
end

-- Show pause mode
function GameScene:play_again()
	self.paused = true
	
	local timer = Timer.new(5000, 1)
	timer:addEventListener(Event.TIMER, 
				function()
					sceneManager:changeScene(scenes[1], 1, SceneManager.flipWithFade, easing.linear)
				end)
	timer:start()
end

-- Go to paused mode
function GameScene:onKeyDown(event)
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		event:stopPropagation()
		
		if self.paused then
			local alertDialog = AlertDialog.new(
				getString("quit"),
				getString("sure"),
				getString("cancel"),
				getString("yes")
			)
		
			alertDialog:addEventListener(Event.COMPLETE, function(event)
				if (event.buttonIndex) then
					application:exit()
				end
			end)
			alertDialog:show()
		end
	end
end
