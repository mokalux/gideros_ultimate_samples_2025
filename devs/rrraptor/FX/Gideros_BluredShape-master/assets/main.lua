local bg = Bitmap.new(Texture.new("image.jpg", true))
--bg:setScale(bg:getWidth() / app:getContentHeight())
stage:addChild(bg)

local sh1 = GShape.new("circle", 128)
sh1:setPosition(128, 128)
--local sh2 = GShape.new("rrect", 200, 300, 16)
--sh2:setPosition(0, 256)
local sh3 = GShape.new("rect", 256, 128)
sh3:setPosition(200, 256)
stage:addChild(sh1)
--stage:addChild(sh2)
stage:addChild(sh3)
function mouse(e)
	if (e.button == KeyCode.MOUSE_LEFT) then
		sh3:updateBlur()
--		sh2:updateBlur()
		sh1:setPosition(e.x,e.y)
	elseif (e.button == KeyCode.MOUSE_RIGHT) then
		sh3:updateBlur()
		sh1:updateBlur()
--		sh2:setPosition(e.x,e.y)
		sh3:setPosition(e.x,e.y)
	else
--		sh2:updateBlur()
		sh1:updateBlur()
		sh3:setPosition(e.x,e.y)
	end
end

stage:addEventListener(Event.MOUSE_DOWN, mouse)
stage:addEventListener(Event.MOUSE_MOVE, mouse)
