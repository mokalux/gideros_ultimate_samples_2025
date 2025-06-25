Puf = gideros.class(Sprite)

Puf.textures = {
	Texture.new("gfx/puf/puf1.png"),
	Texture.new("gfx/puf/puf2.png"),
	Texture.new("gfx/puf/puf3.png"),
	Texture.new("gfx/puf/puf4.png"),
	Texture.new("gfx/puf/puf5.png"),
}

function Puf:init()
	self.frames = {}
	for i = 1, #self.textures do
		self.frames[i] = Bitmap.new(self.textures[i])
		self.frames[i]:setAnchorPoint(0.5, 0.5)
	end

	self.nframes = #self.frames

	self.frame = 1
	self:addChild(self.frames[1])
	
	self.subframe = 0

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
end

function Puf:onEnterFrame()
	self.subframe = self.subframe + 1
	
	if self.subframe == 5 then
		self:removeChild(self.frames[self.frame])

		self.frame = self.frame + 1

		if self.frame > self.nframes then
			self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
			self:getParent():removeChild(self)
			return
		end
		
		self:addChild(self.frames[self.frame])
		
		self.subframe = 0
	end
end