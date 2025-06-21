Page2 = gideros.class(Sprite)

function Page2:init()
	self.no = pageNo

	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/bk2.jpg", true)))	

	self.sun =  Bitmap.new(TextureRegion.new(Texture.new("gfx/sun.png", true )))	
	self.sun:setX(400)
	self.sun:setY(-50)

	self.txt = Bitmap.new(TextureRegion.new(Texture.new("txt/2txt.png", true)))	
	self.txt:setX(300)
	self.txt:setY(900)	

	self:addChild(self.background)
	self:addChild(self.sun)	
	self:addChild(self.txt)

end