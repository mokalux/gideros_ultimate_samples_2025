Moon = Moon or Core.class(Sprite)

function Moon:init(options)

	self.level = options.level

	local spritesheet = Texture.new("assets/images/moon.png")
	
	local anim = {
		Bitmap.new(TextureRegion.new(spritesheet, 0, 100, 100, 100)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 0, 100, 100)),
	}
	
	local scale = conf.MOON_SCALE
	
	for i = 1, #anim do
        anim[i]:setAnchorPoint(0.5, 0.5)
        anim[i]:setScale(scale, scale)
    end
	
	self.moon_width = anim[1]:getWidth()
	
	self.moon_mc = MovieClip.new{
		{1, 500, anim[1]},
		{501, 540, anim[2]},
	}
	
	self.moon_mc:gotoAndPlay(1)
	self.moon_mc:setGotoAction(540, 1)
	
	self.moon_mc:setPosition(conf.WIDTH + self.moon_width, conf.MID_HEIGHT) 
	
	self:addChild(self.moon_mc)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end

function Moon:onEnterFrame()
	
	local x, y = self.moon_mc:getX(), self.moon_mc:getY()
	
	if x < - self.moon_width then
		x = conf.WIDTH + self.moon_width
	end
		
	self.moon_mc:setPosition(x - 0.1, 50 + 5 * math.sin(x * 0.2 + 20))
	
end