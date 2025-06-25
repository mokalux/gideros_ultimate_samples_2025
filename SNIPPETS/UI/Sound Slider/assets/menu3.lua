Menu3 = Core.class(Sprite)
-- Options
function Menu3:init()
	local bgImg = Bitmap.new(Texture.new("menu3_background.png"))
	bgImg:setAnchorPoint(0.5, 0.5)
	self:addChild(bgImg)
end