local textc = TextField.new(nil, "key chars: ")
textc:setScale(4)
textc:setPosition(10, 130)
stage:addChild(textc)

local function onKeyChar(event)
	textc:setText("key chars: "..event.text)
	for k, v in pairs(event) do
		print(k, v)
	end
end
stage:addEventListener(Event.KEY_CHAR, onKeyChar)
