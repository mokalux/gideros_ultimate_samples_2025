--function for creating menu buttons
menuButton = function(image1, image2, container, current, all)
	local newButton = Button.new(Bitmap.new(Texture.new(image1)), Bitmap.new(Texture.new(image2)))
	local startHeight = (current-1)*(container:getHeight())/all + (((container:getHeight())/all)-newButton:getHeight())/2 + application:getContentHeight()/16
	newButton:setPosition((application:getContentWidth()-newButton:getWidth())/2, startHeight)
	return newButton;
end 

menuButtonSheetSprite = function(bitMap1, bitMap2, container, current, all)
	local newButton = Button.new(bitMap1, bitMap2)
	local startHeight = (current-1)*(container:getHeight())/all + (((container:getHeight())/all)-newButton:getHeight())/2 + application:getContentHeight()/16
	newButton:setPosition((application:getContentWidth()-newButton:getWidth())/2, startHeight)
	return newButton;
end 

menuButtonSheetSpriteWhitTitle = function(bitMap1, bitMap2, container, current, all,bitMapTitle )

	local newButton = Button.new(bitMap1, bitMap2)
	local title = bitMapTitle
	
	local startHeight = (current-1)*(container:getHeight())/all + (((container:getHeight())/all)-newButton:getHeight())/2 + application:getContentHeight()/16
	newButton:setPosition((application:getContentWidth()-newButton:getWidth())/2+bitMapTitle:getWidth()/2+10, startHeight)	
	
	title:setPosition((application:getContentWidth()-bitMapTitle:getWidth())/2-newButton:getWidth()/2, startHeight)
	
	
	return newButton, title;
end 


function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function gc()
	
	collectgarbage()
	collectgarbage()
	collectgarbage()
	collectgarbage()
end