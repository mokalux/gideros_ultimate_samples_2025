Page0 = gideros.class(Sprite)

function Page0:init( pageNo, parent)
	self.no = pageNo

	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/background.png", true)))	

	self:addChild(self.background)
end
