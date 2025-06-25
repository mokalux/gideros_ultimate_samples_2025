local utils = {}

function utils.getScreenSize()
	local width = application:getDeviceWidth()
	local height = application:getDeviceHeight()

	if string.find(application:getOrientation(), "landscape") then
		width, height = height, width
	end

	return width, height
end

function utils.wrapAngle(angle)
	if angle > 2 * math.pi then 
		angle = angle - 2 * math.pi
	end
	if angle < 0 then 
		angle = angle + 2 * math.pi
	end
	return angle
end

function utils.setDefaultIfNil(givenValue, defaultValue)
	if not givenValue then 
		return defaultValue
	else
		return givenValue
	end
end

utils.screenWidth, utils.screenHeight = utils.getScreenSize()
return utils