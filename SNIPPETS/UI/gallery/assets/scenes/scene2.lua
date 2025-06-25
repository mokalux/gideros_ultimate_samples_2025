Scene2 = gideros.class(Sprite)

function Scene2:init()
	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/2.jpg", true)))	
	self:addChild(self.background)

	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Scene2:onTransitionInBegin()
end

function Scene2:onTransitionInEnd()
end

function Scene2:onTransitionOutBegin()
end

function Scene2:onTransitionOutEnd()
end
