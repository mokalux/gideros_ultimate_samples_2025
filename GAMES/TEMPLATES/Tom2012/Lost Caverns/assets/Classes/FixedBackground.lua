FixedBackground = Core.class(Sprite)

function FixedBackground:init(scene,image,w,h,xOffset,yOffset)

	self.scene = scene
	self.xOffset = xOffset
	self.yOffset = yOffset
	self.scene.fixedBG = self

	-- Background image

	local shape = Shape.new()
	
	local shapeTexture = Texture.new(image, true, {wrap = Texture.REPEAT})
	shape:setFillStyle(Shape.TEXTURE, shapeTexture)
	shape:beginPath()
	shape:lineTo(0,0)
	shape:lineTo(w,0)
	shape:lineTo(w,h)
	shape:lineTo(0,h)
	shape:closePath()
	shape:endPath()
	self.scene.fixedBGLayer:addChild(shape)

end

