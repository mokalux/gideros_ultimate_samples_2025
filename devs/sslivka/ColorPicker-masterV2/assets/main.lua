local colorPicker = ColorPicker.new()
stage:addChild(colorPicker)
colorPicker:setPosition(10, 10)
function onColorChanged(e)
	application:setBackgroundColor(e.color)
end
colorPicker:addEventListener("COLOR_CHANGED", onColorChanged)
