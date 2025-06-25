application:setBackgroundColor(0xa0b0ff)

local floor = math.floor

stage:addChild(Game.new())

local fps = TextField.new(nil, "")
fps:setScale(2)
fps:setPosition(2, 20)
stage:addChild(fps)

local frame = 0
local timer = os.timer()
local currentTimer = 0
local function displayFps()
	frame = frame + 1
	if frame == 20 then
		currentTimer = os.timer()
		fps:setText(floor(20 / (currentTimer - timer) + 0.5))
		frame = 0
		timer = currentTimer	
	end
end
 
stage:addEventListener(Event.ENTER_FRAME, displayFps)

collectgarbage()
