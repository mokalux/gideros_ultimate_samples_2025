application:setOrientation(Application.PORTRAIT)

-- bg
local mybg = Bitmap.new(Texture.new("gfx/texture.png"))
mybg:setAnchorPoint(0.5, 0.5)
mybg:setAlpha(0.25)
mybg:setPosition(application:getContentWidth() / 2, application:getContentHeight() / 2)
-- datas
local data = {}
for i = 1, 1024 do
	data[i] = row(
		{
			icon = "gfx/maurice.png",
			title = "Item ".. i,
			desc = "description ("..i..")",
		}
	)
end

-- scrollable list
local myList = ListView.new(
	{
		width = application:getContentWidth() - 32,
		height = 8 * application:getContentHeight() / 10,
--		friction = 0.97,
		friction = 0.99,
		bgColor = 0xaaaaff,
		rowSnap = true, -- experimental feature
		data = data
	}
)
myList:setPosition(16, 0)

-- pixels
local mypixel = Pixel.new(0xaaaa00, 1, application:getContentWidth(), 3 * application:getContentHeight() / 10)
mypixel:setPosition(0, 8 * application:getContentHeight() / 10)

-- infos
mybmp = Bitmap.new(Texture.new("gfx/empty_icon.png"))
mybmp:setAnchorPoint(0.5, 0.5)
mybmp:setScale(0.5)
mybmp:setPosition(mybmp:getWidth(), mypixel:getY() + mypixel:getHeight() / 2 - mybmp:getHeight() / 2)

mytitle = TextField.new(nil, "CLICK AN ARROW")
mytitle:setScale(2)
mytitle:setPosition(mybmp:getX() + mybmp:getWidth(), mybmp:getY() - mytitle:getHeight())

mydesc = TextField.new(nil, "...")
mydesc:setScale(1.5)
mydesc:setPosition(mytitle:getX(), mytitle:getY() + 1.5 * mytitle:getHeight())

-- stage
stage:addChild(mybg)
stage:addChild(myList)
stage:addChild(mypixel)
stage:addChild(mybmp)
stage:addChild(mytitle)
stage:addChild(mydesc)
