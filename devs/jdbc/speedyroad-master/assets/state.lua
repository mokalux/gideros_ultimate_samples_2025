GameState = Core.class()

GameState.KEY = "state"

-- Constructor
function GameState:init()
	
	--dataSaver.saveValue(GameState.KEY, nil)
	
	self:load_data()
end

-- Load data from disk
function GameState:load_data()
	self.state = dataSaver.loadValue(GameState.KEY)
	
	-- Create empty state
	if (not self.state) then
		self.state = { 
						distance = 0,
						car = 0,
						coins = 0
					}
	else
		print("best distance", self.state.distance)
	end
end

-- Save data to disk
function GameState:save_data()
	dataSaver.saveValue(GameState.KEY, self.state)
end

-- Set distance and saved it it is needed
function GameState:set_distance(distance)
	
	local state = self.state
	local saved_distance = state.distance or 0
	if (distance > saved_distance) then
		self.state.distance = distance
		self:save_data()
	end

end

-- Get saved distance
function GameState:get_distance()
	return self.state.distance
end

-- Get car index
function GameState:get_car()
	return self.state.car
end

-- Get coins
function GameState:get_coins()
	return self.state.coins
end
