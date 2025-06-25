Scene3 = gideros.class(Sprite)

function Scene3:init()
	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/3.jpg", true)))	
	self:addChild(self.background)

	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Scene3:onTransitionInBegin()
end

function Scene3:onTransitionInEnd()
end

function Scene3:onTransitionOutBegin()
end

function Scene3:onTransitionOutEnd()
end
