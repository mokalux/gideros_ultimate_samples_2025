--genres to check
local genres = {"Puzzle", "Arcade"}
--platform current user have
local platform = "googleplay"
--your api key
local key = ""
local curGenre = 1
local url = ""
local cp = CrossPromo.new(key)

--we got response from server
cp:addEventListener(Event.COMPLETE, function(e)
	--check if there is any game for our paltform
	if e.data[1] and e.data[1][platform] and e.data[1][platform] ~= "" then
		--yes we have url
		url = e.data[1][platform]
		print("url", url)
		--now getting promo image (other values logo, bg)
		cp:getImage(e.data[1].promo)
	else
		--else try next genre
		curGenre = curGenre + 1
		if genres[curGenre] then
			cp:setGenre(genres[curGenre])
		else
			--if there is no genre, try any genre
			cp:setGenre("")
		end
		cp:request()
	end
end)

--we got image
cp:addEventListener(Event.IMAGE_COMPLETE, function(e)
	newGame = Sprite.new()
	--add click listener
	newGame:addEventListener(Event.MOUSE_DOWN, function(e)
		if newGame:hitTestPoint(e.x, e.y) then
			--open url on click
			application:openUrl(url)
		end
	end)
	--create Bitmap from provided image
	local bmp = Bitmap.new(Texture.new(e.path))
	bmp:setAnchorPoint(0.5, 0.5)
	
	--make it wiggle
	local scale = 0.4
	bmp:setScale(scale)
	local tween1 = GTween.new(bmp, 1, {scaleX = scale-0.05, scaleY = scale+0.05})
	local tween2 = GTween.new(bmp, 1, {scaleX = scale+0.05, scaleY = scale-0.05}, {autoPlay = false})
	tween1.nextTween = tween2
	tween2.nextTween = tween1
	newGame:addChild(bmp)
	
	--position it
	newGame:setPosition(0,0)
	
	--add to your scene or stage
	stage:addChild(newGame)
end)

cp:setIgnore("Test app")
cp:setGenre(genres[curGenre])
cp:request()
