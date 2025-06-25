Scene1 = gideros.class(Sprite)

function Scene1:init()
	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/1.jpg", true)))
	self:addChild(self.background)

	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Scene1:onTransitionInBegin()
end

function Scene1:onTransitionInEnd()
end

function Scene1:onTransitionOutBegin()
end

function Scene1:onTransitionOutEnd()
end
