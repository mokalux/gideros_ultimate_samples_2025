  
	local scrollX = 0
	
	local middle = Bitmap.new( Texture.new("middle.png", true) )

	local top = Bitmap.new( Texture.new("top.png", true) )
	top:setAlpha(0.5)

	local backTexture = Texture.new("back.png", false, {wrap = Texture.REPEAT})
    local region = TextureRegion.new(backTexture, 0, 0, 512, 512)
    local back = Bitmap.new(region)
    back.region = region

	stage:addChild(back)
	stage:addChild(middle)
	stage:addChild(top)
	
	local function update()
		local x = scrollX - 4
		
		local region = back.region
		region:setRegion(x % 512, 0, 512, 512)
		back:setTextureRegion(region)
		
		scrollX = x
	end
  
	stage:addEventListener(Event.ENTER_FRAME, update)