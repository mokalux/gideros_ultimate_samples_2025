local font = TTFont.new("fonts/Roboto-Medium-webfont.ttf", 24)
local fontSub = TTFont.new("fonts/Roboto-Medium-webfont.ttf", 18)

function row(item)
	local row = Sprite.new()

	local itembmp = Bitmap.new(Texture.new(item.icon))
	itembmp:setScale(0.75)
	itembmp:setPosition(0, 0)
	row:addChild(itembmp)

	local itemtitle = TextField.new(font, item.title)
	itemtitle:setPosition(itembmp:getX() + itembmp:getWidth() + 4, itembmp:getY() + itemtitle:getHeight())
	row:addChild(itemtitle)

	local itemdesc = TextField.new(fontSub, item.desc)
	itemdesc:setPosition(itembmp:getX() + itembmp:getWidth() + 4,
				itembmp:getY() + itemtitle:getHeight() + itemdesc:getHeight() + 4)
	row:addChild(itemdesc)

	-- clickable button (arrow button)
	local arrow = Texture.new("gfx/arrow_right.png")
	local arrow_pressed = Texture.new("gfx/arrow_right_down.png")
	local button = Button.new(Bitmap.new(arrow), Bitmap.new(arrow_pressed))
	button:setScale(3, 2)
	button:setPosition(application:getContentWidth() - button:getWidth(), itembmp:getY())
	button:addEventListener("click", function()
		mybmp:setTexture(Texture.new(item.icon))
		mytitle:setText(item.title)
		mydesc:setText(item.desc)
	end)
	row:addChild(button)

	return row
end

