--!NEEDS:utils.lua

AnimatedSprite = Core.class(Sprite)

-- Texture, frame width, frame height, [frames count]
function AnimatedSprite:init(texture, w, h, framesCount)
	self.frames = {}
	if not framesCount then
		self.framesCount = math.floor(texture:getWidth() / w * (texture:getHeight() / h))
	else
		self.framesCount = framesCount
	end
	local framesWide = math.floor(texture:getWidth() / w)
	local rowsHigh = math.floor(texture:getHeight() / h)
	for y = 1, rowsHigh do
		for x = 1, framesWide do
			local frameTexture = TextureRegion.new(texture, (x-1)*w, (y-1)*h, w, h)
			table.insert(self.frames, Bitmap.new(frameTexture))
		end
	end
	self.frameWidth = w
	self.frameHeight = h
	self.currentFrame = 1
	self:addChild(self.frames[1])
	
	self.delay = 0.07
	self.currentDelay = 0
end

function AnimatedSprite:play()

end

function AnimatedSprite:gotoFrame(frame)
	if frame < 1 then
		
		frame = self.framesCount
	elseif frame > self.framesCount then
		frame = 1 
	end
	self:removeChild(self.frames[self.currentFrame])
	self.currentFrame = frame
	self:addChild(self.frames[self.currentFrame])
end

function AnimatedSprite:update(dt)
	self.currentDelay = self.currentDelay + dt
	if self.currentDelay >= self.delay then
		self.currentDelay = self.currentDelay - self.delay
		if self.currentDelay >= self.delay then
			self.currentDelay = 0
		end
		self:gotoFrame(self.currentFrame + 1)
	end
end