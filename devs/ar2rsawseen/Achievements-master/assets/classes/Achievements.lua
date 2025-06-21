Achievements = Core.class(EventDispatcher)

--define your achievements here
local achs = {
	red10 = {
		name = "Red clicker 10", --achievement name
		objective = "Click red button 10 times", --objective
		completed = 0, --is it completed yer
		count = 0, --progress of achievement
		total = 10 --total count needed
	},
	green10 = {
		name = "Green clicker 10",
		objective = "Click green button 10 times",
		completed = 0,
		count = 0,
		total = 10
	},
	blue10 = {
		name = "Blue clicker 10",
		objective = "Click blue button 10 times",
		completed = 0,
		count = 0,
		total = 10
	},
	yellow10 = {
		name = "Yellow clicker 10",
		objective = "Click yellow button 10 times",
		completed = 0,
		count = 0,
		total = 10
	},
	red50 = {
		name = "Red clicker 50",
		objective = "Click red button 50 times",
		completed = 0,
		count = 0,
		total = 50
	},
	green50 = {
		name = "Green clicker 50",
		objective = "Click green button 50 times",
		completed = 0,
		count = 0,
		total = 50
	},
	blue50 = {
		name = "Blue clicker 50",
		objective = "Click blue button 50 times",
		completed = 0,
		count = 0,
		total = 50
	},
	yellow50 = {
		name = "Yellowclicker 50",
		objective = "Click yellow button 50 times",
		completed = 0,
		count = 0,
		total = 50
	},
	red100 = {
		name = "Red clicker 100",
		objective = "Click red button 100 times",
		completed = 0,
		count = 0,
		total = 100
	},
	green100 = {
		name = "Green clicker 100",
		objective = "Click green button 100 times",
		completed = 0,
		count = 0,
		total = 100
	},
	blue100 = {
		name = "Blue clicker 100",
		objective = "Click blue button 100 times",
		completed = 0,
		count = 0,
		total = 100
	},
	yellow100 = {
		name = "Yellow clicker 10",
		objective = "Click yellow button 100 times",
		completed = 0,
		count = 0,
		total = 100
	},
	nosleep = {
		name = "No sleep for you",
		objective = "Open app between 01:00AM - 07:00AM",
		completed = 0,
		count = 0,
		total = 1
	},
	allbuttons = {
		name = "Button smasher",
		objective = "Press all available buttons in game",
		completed = 0,
		count = 0,
		total = 6,
		filter = {red = true, green = true, blue = true, yellow = true, ach = true, back=true} --filter used to deal with different predefined types of clicks
	}
}

--ios game auth
local gameAuth = false

function Achievements:init(player)
	if application:getDeviceInfo() == "iOS" and not gameAuth then
		if not gamekit then
			require "gamekit"
			gamekit:addEventListener("authenticateComplete", function()
				gameAuth = true
			end)
		end
		gamekit:authenticate()
	end
	
	self.player = player or "player"
	self.ach = dataSaver.load("|D|achievements"..self.player)
	if self.ach == nil then
		self.changed = true
		self.ach = achs
		self:save()
	end
	self.completed = Event.new("complete")
end

function Achievements:get(name)
	return self.ach[name]
end

function Achievements:getAll()
	return self.ach
end

function Achievements:complete(name, types, save)
	if self.ach[name] and self.ach[name].completed ~= 1 then
		local ach = self.ach[name]
		if ach.filter == nil or ach.filter[types] then
			if ach.filter then
				ach.filter[types] = nil
			end
			if type(types) == "number" then
				ach.count = ach.count + types
			else
				ach.count = ach.count + 1
			end
			if gameAuth then
				local c = ach.count
				local t = ach.total
				if c > t then
					c = t
				end
				gamekit:reportAchievement(name, c/t, false)
			end
			if ach.count >= ach.total then	
				self.completed.name = self.ach[name].name
				self:dispatchEvent(self.completed)
				self.ach[name].completed = 1
			end
			self.changed = true
			if save then
				self:save()
			end
		end
	end
end

function Achievements:save()
	if self.changed then
		dataSaver.save("|D|achievements"..self.player, self.ach)
		self.changed = false
	end
end
