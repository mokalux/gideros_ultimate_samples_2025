Rain = Rain or Core.class(Sprite)

function Rain:init(options)
	
	self.level = options.level

	local spritesheet = Texture.new("assets/images/rain.png")
	
	local anim = {
		Bitmap.new(TextureRegion.new(spritesheet, 0,   0, 480, 320)),
		Bitmap.new(TextureRegion.new(spritesheet, 480, 0, 480, 320)),
	}
	
	local scale = conf.RAIN_SCALE
	
	for i = 1, #anim do
        anim[i]:setAnchorPoint(0.5, 0.5)
        anim[i]:setScale(scale, 1)
    end
	
	self.rain_width = anim[1]:getWidth()
	
	local speed = conf.SPEED_RAIN_FRAME
	
	self.rain_mc = MovieClip.new{
		{			1, 		speed, anim[1]},
		{	speed + 1, 	2 * speed, anim[2]},
	}
	
	self.rain_mc:gotoAndPlay(1)
	self.rain_mc:setGotoAction(2 * speed, 1)
	
	self.rain_mc:setPosition(conf.MID_WIDTH, conf.MID_HEIGHT) 
	
	self:addChild(self.rain_mc)
	
end