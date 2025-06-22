Hud = Core.class(Sprite)

function Hud.setup()
	Hud.font = getTTFont("fonts/quantico_bold_italic.ttf", 25)
end

-- Constructor
function Hud:init()
	local score = TextField.new(Hud.font, "0")
	score:setTextColor(0xffffff)
	score:setShadow(1,1, 0x000000)
	score:setPosition(20, 30)
	
	self:addChild(score)
	self.score = score
	
	-- Meters
	local unit = TextField.new(Hud.font, getString("meters"))
	unit:setTextColor(0xffffff)
	unit:setShadow(1,1, 0x000000)
	unit:setPosition(score:getX() + score:getWidth() + 6, score:getY())
	self:addChild(unit)
	self.unit = unit
end

-- Update score
function Hud:update(speed)

	local speed_x = speed.x
	local score = self.score
	
	local value = math.floor(score:getText() + speed_x)	
	score:setText(value)
	
	self.unit:setPosition(score:getX() + score:getWidth() + 6, score:getY())
end

-- Get distance
function Hud:get_distance()
	return tonumber(self.score:getText())
end