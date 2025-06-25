Background = Core.class(Sprite)

function Background:init(scene,bgImage,bgW,bgH,fgImage,fgW,fgH)

	-- Background image
	
	--print(fgImage,scaleMode)
	
	if(scaleMode==2) then
		--fgImage = string.gsub(fgImage, ".png", "@2x.png")
	end
	

	
	local shape = Shape.new()

	if(bgImage ~= "none") then
	
		local shapeTexture = Texture.new(bgImage, true, {wrap = Texture.REPEAT})
		shape:setFillStyle(Shape.TEXTURE, shapeTexture)
		shape:beginPath()
		shape:lineTo(0,0)
		shape:lineTo(bgW,0)
		shape:lineTo(bgW,bgH)
		shape:lineTo(0,bgH)
		shape:closePath()
		shape:endPath()
		scene.bgLayer:addChild(shape)
		shape:setPosition(xOffset,yOffset)
		
	end

	
	-- Foreground image
	
	if(fgImage ~= "none") then
	
		local shapeTexture = Texture.new(fgImage, true, {wrap = Texture.REPEAT})
		local shape = Shape.new()
		shape:setFillStyle(Shape.TEXTURE, shapeTexture)
		shape:beginPath()
		shape:lineTo(0,0)
		shape:lineTo(fgW,0)
		shape:lineTo(fgW,fgH)
		shape:lineTo(0,fgH)
		shape:closePath()
		shape:endPath()
		scene.fgLayer:addChild(shape)
		shape:setPosition(xOffset,yOffset)
		
	end

end

