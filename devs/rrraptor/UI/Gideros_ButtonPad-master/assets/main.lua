application:setBackgroundColor(0x323232)

local displayHeight = 100
local SW = application:getContentWidth()
local SH = application:getContentHeight() - displayHeight

pad = Pad.new{
	w = SW, h = SH, 
	rows = 5, columns = 4, color = 0x272727,
	margin = 4, innerMargin = 2
}
pad:setY(displayHeight)
-- add numbers from 1 to 9
local i = 1
for y = 4, 2, -1 do
	for x = 1, 3 do 
		pad:addButton{
			x = x - 1, y = y - 1, name = "N_"..i,
			bgColor = 0x323232, txtColor = 0xffffff,
			text = tostring(i), scaleX  = 4, scaleY  = 4
		}
		i += 1
	end
end
pad:addButton{ x = 0, y = 0, scaleX = 4, scaleY = 4, bgColor = 0x323232, txtColor = 0xffffff, name = "Erase", text = "<" }
pad:addButton{ x = 1, y = 0, scaleX = 4, scaleY = 4, bgColor = 0x323232, txtColor = 0xffffff, name = "/", text = "/" }
pad:addButton{ x = 2, y = 0, scaleX = 4, scaleY = 4, bgColor = 0x323232, txtColor = 0xffffff, name = "*", text = "*" }
pad:addButton{ x = 3, y = 0, scaleX = 2, scaleY = 2, bgColor = 0x323232, txtColor = 0xffffff, name = "-", text = "-" }
pad:addButton{ x = 3, y = 1, scaleX = 2, scaleY = 2, bgColor = 0x323232, txtColor = 0xffffff, gridheight = 2, name = "+", text = "+" }
pad:addButton{ x = 3, y = 3, scaleX = 2, scaleY = 2, bgColor = 0x323232, txtColor = 0xffffff, gridheight = 2, name = "Enter", text = "E" }
pad:addButton{ x = 2, y = 4, scaleX = 2, scaleY = 2, bgColor = 0x323232, txtColor = 0xffffff, name = "dot", text = "." }
pad:addButton{ x = 0, y = 4, scaleX = 2, scaleY = 2, bgColor = 0x323232, txtColor = 0xffffff, gridwidth = 2, name = "N_0", text = "0" }

local displayFiled = TextField.new(nil, "")
displayFiled:setScale(4)
displayFiled:setTextColor(0xffffff)
displayFiled:setPosition(5, displayHeight - 5)
stage:addChild(displayFiled)

function padClick(e)
	local name = e.name 
	local btext = e.text 
	local text = displayFiled:getText()
	
	if (name ~= "Erase") then
		displayFiled:setText(text..btext)
	else
		text = text:sub(1, text:len() - 1)
		displayFiled:setText(text)
	end
end

pad:addEventListener("click", padClick)
stage:addChild(pad)