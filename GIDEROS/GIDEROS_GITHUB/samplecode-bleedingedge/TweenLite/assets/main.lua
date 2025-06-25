local sprite = Bitmap.new(Texture.new("box.png"))
stage:addChild(sprite)

local t = TweenNano.new(sprite, 5,
	{
		x=200,
		y=300,
		alpha=0,
		delay=3,
	}
)
