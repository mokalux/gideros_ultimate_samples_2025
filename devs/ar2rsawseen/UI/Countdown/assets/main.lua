-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!! THERE IS A BUG WITH THE DAYS !!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

local tahoma = TTFont.new("tahoma.ttf", 15)

--you need to create text field 
--where to output specific units
--you can provide some text with time unit
--which will be hidden when unit reaches zero
--you don't need to use all possible time units
--if you don't use one, it will be 
--automatically recalculated to lower ones
local years = TextField.new(nil, "{y} years left")
local months = TextField.new(nil, "{m} months left")
local weeks = TextField.new(nil, "{w} weeks left")
local days = TextField.new(nil, "{d} days left")
local hours = TextField.new(tahoma, "{h} hours left")
local minutes = TextField.new(nil, "minutes {i}")
local seconds = TextField.new(nil, "")
--textfield, or sprite or anything 
--that is hidden and can be made visible using
--setVisible(true) method when countdown ends
local ended = TextField.new(nil, "Countdown Ended")

-- position
years:setPosition(20, 0)
months:setPosition(20, 20)
weeks:setPosition(20, 40)
days:setPosition(20, 60)
hours:setPosition(20, 85)
minutes:setPosition(20, 105)
seconds:setPosition(20, 125)
ended:setPosition(20, 160)

--create coutndown
local cd = Countdown.new({
	--time to specific timestamp
	--time = 1639324800
	
	--or provide time left
	year = 1,
	month = 0,
	week = 0,
	day = 0,
	hour = 0,
	min = 0,
	sec = 5,
	
	--textfields where to output countdown
	label_year = years,
	label_month = months,
	label_week = weeks,
	label_day = days,
	label_hour = hours,
	label_min = minutes,
	label_sec = seconds,
	--TextField to show when countdown ended
	label_end = ended,
	--hide ended units
	hide_zeros = true,
	--use leading zeros for hours, minutes and seconds
	leading_zeros = true,
	--callback function on countdown end
	onend = function() print("Ended") end,
	--callback function on each coutndown step
	--provides seconds left till end of countdown
--	onstep = function(seconds) print(seconds) end
})

cd:setPosition(0,10)
stage:addChild(cd)
