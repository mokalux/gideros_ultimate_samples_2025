Score = Core.class(Sprite)

local LEADERBOARD_ID = "CgkIo43jzp0SEAIQCA" -- Google Play leaderboard id
local ACHIEVEMENTS = {}
ACHIEVEMENTS[500] = "CgkIo43jzp0SEAIQAQ"
ACHIEVEMENTS[1000] = "CgkIo43jzp0SEAIQAg"
ACHIEVEMENTS[2000] = "CgkIo43jzp0SEAIQAw"
ACHIEVEMENTS[3000] = "CgkIo43jzp0SEAIQBA"
ACHIEVEMENTS[5000] = "CgkIo43jzp0SEAIQBQ"
ACHIEVEMENTS[7500] = "CgkIo43jzp0SEAIQBg"
ACHIEVEMENTS[10000] = "CgkIo43jzp0SEAIQBw"
					
local android = application:getDeviceInfo() == "Android"
if (android) then
	require "googleplay"
end

local width = application:getContentWidth()
local height = application:getContentHeight() 

function Score.setup()

	Score.textures = {
						play = Texture.new("gfx/menu/right.png", true),
						share = Texture.new("gfx/menu/share2.png", true),
						leaderboard = Texture.new("gfx/menu/leaderboards.png", true),
						moregames = Texture.new("gfx/menu/more_games.png", true),
						achievements = Texture.new("gfx/menu/trophy.png", true)
					}
	Score.font = getTTFont("fonts/quantico_regular.ttf", 24)
end

-- Constructor
function Score:init(distance)
	
	self.show_achievement = false
	self.show_leaderboard = false
	
	Advertise.hideBanner()
	
	-- Sometimes show interstitial
	local ad_type = math.random(2)
	if (ad_type == 2) then
		Advertise.showInterstitial()
	end
	
	self.distance = distance
	
	self:draw_background()
	self:draw_distance()
	self:draw_options()
	
end

-- Draw alpha background	
function Score:draw_background()
	
	local color = 0x000000
	local alpha = 0.3

	local mesh = Mesh.new() 
	mesh:setVertices(1, -30, 100, 2, width + 30, 100, 3, width + 30, height + 45, 4, -30, height + 45) 
	mesh:setIndexArray(1, 2, 3, 1, 3, 4) 
	mesh:setColorArray(color, alpha, color, alpha, color, alpha, color, alpha) 
	self:addChild(mesh)
end

-- Draw best distance square
function Score:draw_distance()

	local distance = self.distance -- Current distance
	local saved_distance = gamestate:get_distance() -- Saved distance
	
	local color = 0x990000
	local alpha = 0.9
	
	local mesh = Mesh.new() 
	mesh:setVertices(1, 0, 50, 2, width, 50, 3, width, 100, 4, 0, 100) 
	mesh:setIndexArray(1, 2, 3, 1, 3, 4) 
	mesh:setColorArray(color, alpha, color, alpha, color, alpha, color, alpha) 
	self:addChild(mesh)
	
	if (distance > saved_distance) then
		-- New best distance
		local text_title = TextField.new(Score.font, getString("new_distance"))
		text_title:setTextColor(0xffffff)
		text_title:setPosition((width-text_title:getWidth()) * 0.5, 85)
		self:addChild(text_title)
		
		gamestate:set_distance(self.distance)
	else
		-- Show best distance
		local text_title = TextField.new(Score.font, getString("best")..gamestate:get_distance()..getString("meters"))
		text_title:setTextColor(0xffffff)
		text_title:setPosition((width-text_title:getWidth()) * 0.5, 85)
		self:addChild(text_title)
	end
	
	self:report_distance()
end

-- Report best distance to Google Play
function Score:report_distance()
	-- Submit best distance
	if (googleplay and googleplay:isAvailable()) then
		local distance = gamestate:get_distance()
		googleplay:reportScore(LEADERBOARD_ID, distance, true)
		
		for k,v in pairs(ACHIEVEMENTS) do
			if (distance >= tonumber(k)) then
				print("submit achievement", k)
				googleplay:reportAchievement(ACHIEVEMENTS[k], 0, true)
			end
		end
	end
end

-- Draw options
function Score:draw_options()
		
	if (googleplay and googleplay:isAvailable()) then
		self:draw_achievements()
		self:draw_leaderboard()
		googleplay:addEventListener(Event.LOGIN_COMPLETE, 
				function()
					print("LOGIN COMPLETE")
					if (self.show_leaderboard) then
						googleplay:showLeaderboard(LEADERBOARD_ID)
					elseif (self.show_achievement) then
						googleplay:showAchievements()
					end
				end)
		googleplay:addEventListener(Event.LOGIN_ERROR, 
				function()
					print("LOGIN ERROR")
				end)
	end
	
	self:draw_moregames()
	self:draw_play()
	
	if android then
		self:draw_share()
	end
end

-- Draw achievements button
function Score:draw_achievements()
	local textures = Score.textures
	local button = Bitmap.new(textures.achievements)
	button:setScale(0.7)
	button:setPosition(125, 170)
	self:addChild(button)
	
	button:addEventListener(Event.MOUSE_DOWN, function(event)
		if (button:hitTestPoint(event.x, event.y)) then
			event:stopPropagation()
			
			local playerId = googleplay:getPlayerId() or ""
			if (playerId == "") then
				googleplay:login()
				self.show_achievement = true
			else
				googleplay:showAchievements()
			end
		end
	end)
end

-- Draw leaderboard button
function Score:draw_leaderboard()
	local textures = Score.textures
	local button = Bitmap.new(textures.leaderboard)
	button:setScale(0.7)
	button:setPosition(125, 260)
	self:addChild(button)
	
	button:addEventListener(Event.MOUSE_DOWN, function(event)
		if (button:hitTestPoint(event.x, event.y)) then
			event:stopPropagation()
			
			local playerId = googleplay:getPlayerId() or ""
			if (playerId == "") then
				googleplay:login()
				self.show_leaderboard = true
			else
				googleplay:showLeaderboard(LEADERBOARD_ID)
			end
		end
	end)
end

-- Draw more games button
function Score:draw_moregames()
	local textures = Score.textures
	local button_moregames = Bitmap.new(textures.moregames)
	button_moregames:setScale(0.7)
	button_moregames:setPosition(20, 350)
	self:addChild(button_moregames)
	
	button_moregames:addEventListener(Event.MOUSE_DOWN, function(event)
		if (button_moregames:hitTestPoint(event.x, event.y)) then
			event:stopPropagation()
			Advertise.more_games()
		end
	end)
end

-- Draw play button
function Score:draw_play()
	local textures = Score.textures
	local button_play = Bitmap.new(textures.play)
	button_play:setScale(0.7)
	button_play:setPosition(125, 350)
	self:addChild(button_play)
	
	button_play:addEventListener(Event.MOUSE_DOWN, function(event)
		if (button_play:hitTestPoint(event.x, event.y)) then
			event:stopPropagation()
			sceneManager:changeScene(scenes[1], 1, SceneManager.moveFromRightWithFade, easing.linear)
		end
	end)
end

-- Draw native share button
function Score:draw_share()
	local textures = Score.textures
	local button_share = Bitmap.new(textures.share)
	button_share:setScale(0.7)
	button_share:setPosition(230, 350)
	self:addChild(button_share)
	
	button_share:addEventListener(Event.MOUSE_DOWN, function(event)
		if (button_share:hitTestPoint(event.x, event.y)) then
			event:stopPropagation()
				
			-- Share score
			-- http://developer.android.com/intl/es/training/sharing/send.html
			local share = ui.Share.new("Download and play the amazing Speedy Road game")											
		end
	end)
end
