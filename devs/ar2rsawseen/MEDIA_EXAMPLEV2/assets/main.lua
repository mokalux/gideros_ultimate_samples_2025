--require plugin
require "media"

local myappwidth = application:getContentWidth()
local myappheight = application:getContentHeight()
local mycallback = 0
local bmp

--just a function to create text button
function createText(str, y, callback)
	local text = TextField.new(nil, str)
	text:setAnchorPoint(0.5, 0.5)
	text:setScale(5, 5)
	text:setPosition(1.75 * myappwidth / 4, y)
	stage:addChild(text)
	
	text:addEventListener(Event.MOUSE_DOWN, function(self, e)
		if self:hitTestPoint(e.x, e.y) then
			callback()
		end
	end, text)
end

-- create our "menu"
createText("Check camera", 1 * 64, function() -- WORKS
	print("CHECK CAMERA") -- NO CALLBACK
	mycallback = 1
	print(mediamanager:isCameraAvailable())
end)

createText("Take picture", 2.1 * 64, function() -- WORKS ONLY THUMBNAIL!
	print("TAKE PICTURE WITH CAMERA")
	mycallback = 2
	mediamanager:takePicture()
end)

createText("Take thumbnail", 3.1 * 64, function() -- WORKS
	print("MAKE THUMBNAIL FROM CAMERA")
	mycallback = 3
	mediamanager:takePicture()
end)

createText("Take screenshot", 4.1 * 64, function() -- WORKS NO PERMISSIONS NEEDED BUT SAVE TO GIDEROS APP FOLDER
	print("SCREENSHOT")
	mycallback = 4
	mediamanager:takeScreenshot()
end)

createText("Get picture", 5.1 * 64, function() -- WORKS NEED PERMISSIONS READ
	print("GET PICTURE")
	mycallback = 5
	mediamanager:getPicture()
end)

createText("Save picture", 6.1 * 64, function() -- WORKS NEED PERMISSIONS WRITE
	print("SAVE PICTURE")
	mycallback = 6
	-- draw your gfx (here I draw a simple pixel)
	local source = Pixel.new(0xffff00, 0.75, 128, 128)
	-- create a render target and draw to it
	local rt = RenderTarget.new(source:getWidth(), source:getHeight())
	rt:draw(source)
	-- save your render target to gideros documents folder
	local myfilepath = "|D|mysavedpicture2.png"
	rt:save(myfilepath)
	-- create a new media and save your gfx
	-- android saved path = internal storage/pictures
	-- NEED permission write external storage
	local media = Media.new(myfilepath)
	mediamanager:postPicture(myfilepath)

	-- show your gfx on stage
	if bmp then -- remove previous Bitmap
		bmp:removeFromParent()
		bmp = nil
	end
	bmp = Bitmap.new(rt, true)
	bmp:setPosition(0, myappheight - bmp:getHeight())
	stage:addChildAt(bmp, 1)
end)

createText("Play Video", 7.1 * 64, function() -- WORKS?
	print("PLAY VIDEO")
	mycallback = 7
	mediamanager:playVideo("videos/test.mp4", false)

--[[
	pheora=require "Theora"
	local videoSource=pheora.new("videos/file_example_OGG_480_1_7mg.ogg")
	local videoStream=videoSource:play()
	local videoSprite=videoStream:getVideo()
	videoSprite:setPosition(0, 64)
	stage:addChild(videoSprite)
]]
end)

-- EVENT LISTENERS
mediamanager:addEventListener(Event.MEDIA_RECEIVE, function(e)
	print("mycallback:", mycallback)

	local path = ""

	if mycallback == 1 then -- is camera available?
		-- nothing here

	elseif mycallback == 2 then -- take picture (thumbnail)
		local media = Media.new(e.path)
		path = media:getPath()
		if bmp then -- remove previous Bitmap
			bmp:removeFromParent()
			bmp = nil
		end
		bmp = Bitmap.new(Texture.new(path, true))
		bmp:setPosition(0, myappheight - bmp:getHeight())
		stage:addChildAt(bmp, 1)

	elseif mycallback == 3 then -- make thumbnail
		local media = Media.new(e.path)
		path = media:getPath()
		if bmp then -- remove previous Bitmap
			bmp:removeFromParent()
			bmp = nil
		end
		bmp = Bitmap.new(Texture.new(path, true))
		bmp:setPosition(0, myappheight - bmp:getHeight())
		stage:addChildAt(bmp, 1)

	elseif mycallback == 4 then -- take screenshot and save
		local media = Media.new(e.path)
		media:resize(myappwidth / 2, myappheight / 2, true)
		media:save()
--		print("media size", media:getWidth(), media:getHeight())
		path = media:getPath()
		if bmp then -- remove previous Bitmap
			bmp:removeFromParent()
			bmp = nil
		end
		bmp = Bitmap.new(Texture.new(path, true))
		bmp:setPosition(0, myappheight - bmp:getHeight())
		stage:addChildAt(bmp, 1)

	elseif mycallback == 5 then -- get picture from file explorer / gallery
		local media = Media.new(e.path)
		media:resize(myappwidth / 2, myappheight / 2, true)
		media:save()
		path = media:getPath()
		if bmp then -- remove previous Bitmap
			bmp:removeFromParent()
			bmp = nil
		end
		bmp = Bitmap.new(Texture.new(path, true))
		bmp:setPosition(0, myappheight - bmp:getHeight())
		stage:addChildAt(bmp, 1)

	elseif mycallback == 6 then -- save picture to file / gallery
		-- nothing here

	elseif mycallback == 7 then -- play video
		-- nothing here

	else
		-- nothing here
	end
end)

--user canceled selecting image
mediamanager:addEventListener(Event.MEDIA_CANCEL, function()
	print("User cancelled media input")
end)


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
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
bmp:setPosition(256, 320)
stage:addChild(bmp)

stage:addEventListener(Event.MOUSE_DOWN, function(e)
	if bmp:hitTestPoint(e.x, e.y) then
		print("flood")
--		media:floodFill(e.x, e.y, 0xff0000, 0.5, 100, true)
--		media:floodFill(e.x, e.y, 0xffff00, 1, 8, true)
		media:floodFill(e.x, e.y, 0xffff00, 1, 8, false)
		media:save()
		print(media:getPath()) -- where on android?
		bmp:removeFromParent()
		bmp = Bitmap.new(Texture.new(media:getPath(), true))
--		bmp:setPosition(256, 320)
		stage:addChild(bmp)
	end
end)
]]


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
-- EVENT LISTENERS
mediamanager:addEventListener(Event.MEDIA_RECEIVE, function(e)

	print("callback")

	--print path
	print("path 01: "..e.path)

	local path = ""

	local media = Media.new(e.path)
	print("media sizes", media:getWidth(), media:getHeight())
	media:flipVertical()
	media:flipHorizontal()
	media:trim(0xffffff)
	media:drawText(8, 8, "Test Text", 0xff0000, 32)
	media:drawLine(4, 4, 16, 16, 0xff0000)
	media:resize(200, 200, false)
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
]]
