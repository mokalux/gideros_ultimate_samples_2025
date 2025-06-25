local appWidth = application:getLogicalWidth()
local appHeight = application:getLogicalHeight()

local conf = {
		addBackground=true,
		backgroundFillColor = 0x2FE5EF,
		backgroundLineColor = 0x23AAB1,
		radius = 64*2,
		fillColor = 0x1EEFA8,
		lineColor = 0x16B17D,
		lineThickness = 12,
		fillAlpha = 1,
		totalMillisecond = 10000, -- 1000 = 10 seconds
		tick = 10, -- 1, Effects Performance
		autoStart = true
	}

local circleTime = CircleTime.new(conf)
--print(appWidth,appHeight)
circleTime:setX((appWidth /2)- conf.radius)
circleTime:setY((appHeight /2) - conf.radius)

stage:addChild(circleTime)
