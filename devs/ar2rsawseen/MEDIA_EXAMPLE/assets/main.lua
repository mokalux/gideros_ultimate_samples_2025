--require plugin
require "media"

--just a function to create text button
function createText(str, y, callback)
	local text = TextField.new(nil, str)
	text:setScale(3)
	text:setPosition(40, y)
	stage:addChild(text)
	
	text:addEventListener(Event.MOUSE_DOWN, function(self, e)
		if self:hitTestPoint(e.x, e.y) then
			print("call")
			callback()
		end
	end, text)
end

--here we will store Bitmap instance
local bmp
local shouldResize = true

-- create our "menu"
createText("Check camera", 150, function() -- CRASH
	print("CHECK CAMERA")
	print(mediamanager:isCameraAvailable())
end)

createText("Take picture", 200, function() -- CRASH
	print("TAKE PICTURE WITH CAMERA")
	shouldResize = false
	mediamanager:takePicture()
end)

createText("Take thumbnail", 250, function() -- CRASH
	print("MAKE THUMBNAIL FROM CAMERA")
	shouldResize = true
	mediamanager:takePicture()
end)

createText("Take screenshot", 300, function() -- WORKS NO PERMISSIONS NEEDED
	print("SCREENSHOT")
	shouldResize = true
	mediamanager:takeScreenshot()
end)

createText("Get picture", 350, function() -- WORKS NEED PERMISSIONS
	print("GET PICTURE")
	shouldResize = false
	mediamanager:getPicture()
end)

createText("Save picture", 400, function() -- WORKS NEED PERMISSIONS SAVES TO ANDROID PICTURE INTERNAL MEMORY
	print("SAVE PICTURE (ball)")
	mediamanager:postPicture("gfx/ball.png")
end)

createText("Play Video", 450, function() -- NOT WORKING
	print("PLAY VIDEO")
	mediamanager:playVideo("gfx/test.mp4")
end)

--when some picture was selected by user
mediamanager:addEventListener(Event.MEDIA_RECEIVE, function(e)

	--print path
	print("path 01: "..e.path)

	local path = ""

	local media = Media.new(e.path)
	print("media sizes", media:getWidth(), media:getHeight())
	--media:flipVertical()
	--media:flipHorizontal()
	--media:trim(0xffffff)
	media:drawText(8, 8, "Test Text", 0xff0000, 32)
	media:drawLine(4, 4, 16, 16, 0xff0000)
	if shouldResize then
		media:resize(200, 200, false)
	end
	print(media:getPixel(1, 1))
	for x = 50, 100 do
		for y = 50, 100 do
			media:setPixel(x, y, 255, 0, 0, 0.5) -- change color to semi transparent red
		end
	end
	media:drawImage(100, 100, "gfx/ball.png")
	media:save()
	path = media:getPath()
	print("path 02: "..path)

--[[
	local mreal = Media.new(200, 200)
	mreal:drawImage(0,0, media)
	mreal:drawImage(0, 256, "gfx/ball.png")
	mreal:save()
	path = mreal:getPath()
	print("path 03: "..path)
]]

	--remove previous Bitmap
	if bmp then
		bmp:removeFromParent()
		bmp = nil
	end

	--add selected image to the stage
	bmp = Bitmap.new(Texture.new(path, true))
	bmp:setPosition(10, 10)
	stage:addChildAt(bmp, 1)
	application:setBackgroundColor(0xff0000)
end)

--user canceled selecting image
mediamanager:addEventListener(Event.MEDIA_CANCEL, function()
	print("User canceled media input")
end)

mediamanager:addEventListener(Event.VIDEO_COMPLETE, function()
	print("Video completed")
end)

-- FLOOD FILL
local text = TextField.new(nil, "Click on ball to floodFill it")
text:setScale(2)
text:setPosition(100, 50)
stage:addChild(text)

--delete previos copy (path = .../Local/Temp/gideros/Media/documents/ball.png)
local media = Media.new("gfx/ball.png")
--print(media:getPath())
mediamanager:deleteFile(media:getPath())

-- create a new media from our image path
local media = Media.new("gfx/ball.png")
media:resize(256, 256, false)
media:save()
local bmp = Bitmap.new(Texture.new(media:getPath(), true))
stage:addChild(bmp)

stage:addEventListener(Event.MOUSE_DOWN, function(e)
	if bmp:hitTestPoint(e.x, e.y) then
		print("flood")
--		media:floodFill(e.x, e.y, 0xff0000, 0.5, 100, true)
--		media:floodFill(e.x, e.y, 0xffff00, 1, 8, true)
		media:floodFill(e.x, e.y, 0xffff00, 1, 8, false)
		media:save()
		bmp:removeFromParent()
		bmp = Bitmap.new(Texture.new(media:getPath(), true))
		stage:addChild(bmp)
	end
end)

