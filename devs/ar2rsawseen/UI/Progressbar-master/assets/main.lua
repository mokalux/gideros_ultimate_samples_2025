local bar = Progressbar.new(
	{
		width = 200,
		height = 40,
		minValue = 0,
		maxValue = 100,
		value = 100, 
		radius = 8,
		textFont = nil,
		textColor = 0xffffff,
		showValue = true,
		textBefore = "Life: ",
		textAfter = " %",
		animIncrement = 1, -- 1
		animInterval = 10, -- 10
	}
)

bar:setPosition(10, 10)
stage:addChild(bar)

bar:animateValue(100)
bar:animateValue(20)
bar:animateValue(80)
bar:animateValue(10)
