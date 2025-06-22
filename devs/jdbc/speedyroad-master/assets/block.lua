Block = Core.class(Sprite)

local width = application:getContentWidth()
local height = application:getContentHeight()

local TILE_WIDTH = 64
local TILE_HEIGHT = 64

local map = {
				{3, 3, 3, 3, 3, 4, 2, 4, 3, 3, 3, 3},
				{0, 0, 0, 5, 7, 6, 1, 7, 0, 0, 0, 0},
				{0, 0, 0, 5, 7, 5, 1, 7, 0, 9, 8, 0},
				{0, 9, 10, 10, 8, 6, 1, 7, 11, 11, 7, 0},
				{0, 0, 0, 5, 7, 6, 1, 7, 5, 7, 0, 0},
				{0, 12, 12, 12, 12, 0, 1, 7, 5, 9, 8, 0},
				}

local random = math.random

Block.TYPE_ROAD = 1
Block.TYPE_BUILDING = 5

function Block.setup()
	
	Block.textures = {
						Texture.new("gfx/tiles/landscapeTiles_075.png", true),
						Texture.new("gfx/tiles/cityTiles_081.png", true),
						Texture.new("gfx/tiles/cityTiles_089.png", true),
						Texture.new("gfx/tiles/cityTiles_073.png", true),
						Texture.new("gfx/tiles/cityTiles_064.png", true),
						Texture.new("gfx/tiles/buildingTiles_036.png", true),
						Texture.new("gfx/tiles/cityTiles_075.png", true),
						Texture.new("gfx/tiles/cityTiles_067.png", true),
						Texture.new("gfx/tiles/cityTiles_053.png", true),
						Texture.new("gfx/tiles/cityTiles_052.png", true),
						Texture.new("gfx/tiles/cityTiles_046.png", true),
						Texture.new("gfx/tiles/cityTiles_066.png", true),
						Texture.new("gfx/tiles/cityTiles_083.png", true),
					}
	Block.textures_car = {
							Texture.new("gfx/cars/garbage_SE.png", true),
							Texture.new("gfx/cars/ambulance_SE.png", true),
							Texture.new("gfx/cars/taxi_SE.png", true),
							Texture.new("gfx/cars/carBlue_SE.png", true),
							Texture.new("gfx/cars/police_SE.png", true),
						}
						
	Block.textures_extra = {
							Texture.new("gfx/tiles/buildingTiles_054.png", true),
							Texture.new("gfx/tiles/buildingTiles_005.png", true)
							}

end

-- Constructor
function Block:init(num)
	
	self.speed = math.random() * 1.5 + 1
	
	local textures = Block.textures
		
	local index
	if (num == 0) then 
		-- Draw road block
		index = Block.TYPE_ROAD
	else
		index = random(2, #map)
	end
		
	local row = map[index]
	for j=1,#row do
		local column = row[j]
		
		local x = j * TILE_WIDTH + width * 0.5
		local y = 0
					
		local tile = Bitmap.new(textures[column + 1])
		tile:setAnchorPoint(0.5, 0.5)
		tile:setPosition(twoDToIso(x, y))
		self:addChild(tile)
		
		if (column == Block.TYPE_BUILDING) then
			tile:setY(tile:getY() - 8)
			local second_floor = Bitmap.new(Block.textures_extra[1])
			second_floor:setAnchorPoint(0.5, 0.5)
			second_floor:setY(-48)
			tile:addChild(second_floor)
			
			local roof = Bitmap.new(Block.textures_extra[2])
			roof:setAnchorPoint(0.5, 0.5)
			roof:setY(-16)
			second_floor:addChild(roof)
		end
	end
	
	--print("----------------------")
	
	-- Draw vehicles
	
	if (index == Block.TYPE_ROAD) then
		self:draw_vehicles()
	end
	
end

-- Draw vehicles on the block
function Block:draw_vehicles()
	local vehicle_list = {}
		
	local textures_car = Block.textures_car
		
	local index
	local direction = random(0,1)
	if (direction == 0) then
		-- South
		index = -random(1,2)
	else
		-- North
		index = 13 + random(1,2)
	end
		
--	for a=1,5 do
	for a=1,2 do
		local vehicle = Vehicle.new(index, direction, self.speed)
		self:addChild(vehicle)
		
		-- Next vehicle index in the same direction
		if (direction == 0) then
			index = index + random(1,3)
		else
			index = index - random(1,3)
		end
			
		table.insert(vehicle_list, vehicle)
	end
				
	self.vehicle_list = vehicle_list
end

-- Moving vehicles
function Block:update()

	--local speed = self.speed -- All vehicles with same speed
	local vehicle_list = self.vehicle_list
	
	if (vehicle_list) then
		for a=1, #vehicle_list do
			local vehicle = vehicle_list[a] 
			vehicle:update()
		end
	end
end
