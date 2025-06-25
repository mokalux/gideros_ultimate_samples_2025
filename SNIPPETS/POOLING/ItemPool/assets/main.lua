local lw = application:getLogicalWidth()
local lh = application:getLogicalHeight()
local MinX = -application:getLogicalTranslateX() / application:getLogicalScaleX()
local MinY = -application:getLogicalTranslateY() / application:getLogicalScaleY()
local MaxX,MaxY = lw - MinX,lh - MinY;
local W, H = MaxX - MinX, MaxY - MinY;
local CenterX,CenterY = MinX + W/2, MinY + H/2


local ItemPoolManager = ItemPool.new({pool_size = 20});
stage:addChild(ItemPoolManager)

local function update(event)
	ItemPoolManager:update(event.deltaTime)
end

stage:addEventListener(Event.ENTER_FRAME, update)