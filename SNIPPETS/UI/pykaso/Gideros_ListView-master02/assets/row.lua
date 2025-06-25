local font = TTFont.new("fonts/Roboto-Medium-webfont.ttf", 24)
local fontSub = TTFont.new("fonts/Roboto-Medium-webfont.ttf", 18)

local arrow = Texture.new("gfx/arrow_right.png")
local arrow_pressed = Texture.new("gfx/arrow_right_down.png")

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
	local button = Button.new(Bitmap.new(arrow), Bitmap.new(arrow_pressed))
	button:setScale(3, 2)
	button:setPosition(application:getContentWidth() - button:getWidth(), itembmp:getY())
	button:addEventListener("click", function()
		mybmp:setTexture(Texture.new(item.icon))
--		mybmp:setPosition(0.1 * application:getContentWidth() / 2, 8.4 * application:getContentHeight() / 10)
		mytitle:setText(item.title)
--		mytitle:setAnchorPoint(0.5, 0.5)
--		mytitle:setPosition(application:getContentWidth() / 2, 8.4 * application:getContentHeight() / 10 + mytitle:getHeight())
		mydesc:setText(item.desc)
--		mydesc:setAnchorPoint(0.5, 0.5)
--		mydesc:setPosition(application:getContentWidth() / 2, 9.1 * application:getContentHeight() / 10 + mydesc:getHeight())
	end)
	row:addChild(button)

	return row
end

