Pentagram = Pentagram or Core.class(Sprite)

function Pentagram:init(options)

	self.level = options.level
	
	local spritesheet = Texture.new("assets/images/pentagram2.png")
	
	local anim = {
		Bitmap.new(TextureRegion.new(spritesheet,   0, 0, 100, 100)),
		Bitmap.new(TextureRegion.new(spritesheet, 100, 0, 100, 100)),
		Bitmap.new(TextureRegion.new(spritesheet, 200, 0, 100, 100)),
		Bitmap.new(TextureRegion.new(spritesheet, 300, 0, 100, 100)),
		Bitmap.new(TextureRegion.new(spritesheet, 400, 0, 100, 100)),
		Bitmap.new(TextureRegion.new(spritesheet, 500, 0, 100, 100)),
	}
	
	local scale = 1.5
	
	for i = 1, #anim do
        anim[i]:setAnchorPoint(0.5, 0.5)
        anim[i]:setScale(scale, scale)
    end
	
	self.pentagram_width = anim[1]:getWidth()
	
	local speed_frame = 30
	
	self.positions = {
		1,
		1 *	speed_frame + 1, -- 21 | 2
		2 * speed_frame + 1, -- 41
		3 * speed_frame + 1, -- 61 | 4
		4 * speed_frame + 1, -- 81
		5 * speed_frame + 1, -- 101 | 6
	}
	
	self.state = 1
	
	self.pentagram_mc = MovieClip.new{
		{ self.positions[1], 		speed_frame, 	anim[1]},
		{ self.positions[2], 	2 * speed_frame,   	anim[2]},
		{ self.positions[3], 	3 * speed_frame,   	anim[3]},
		{ self.positions[4], 	4 * speed_frame,   	anim[4]},
		{ self.positions[5], 	5 * speed_frame,  	anim[5]},
		{ self.positions[6], 	6 * speed_frame, 	anim[6]},
	}
		
	self.pentagram_mc:gotoAndPlay(1)
	
	self.pentagram_mc:setGotoAction(2 * speed_frame, self.positions[1])
	self.pentagram_mc:setGotoAction(4 * speed_frame, self.positions[3])
	self.pentagram_mc:setGotoAction(6 * speed_frame, self.positions[5])
	
	self.pentagram_mc:setPosition(conf.MID_WIDTH, conf.HEIGHT / 4 * 3)
	
	self:addChild(self.pentagram_mc)

end

function Pentagram:changeDoorStatus(cur_y, min_y)

	print(cur_y, min_y)
	
	local diff = cur_y - min_y
	if diff > 150 then
		if self.state ~= 1 then
			self.pentagram_mc:gotoAndPlay(self.positions[1])
			self.state = 1
		end
	elseif diff <= 150 and diff > 100 then
		if self.state ~= 2 then
			self.pentagram_mc:gotoAndPlay(self.positions[3])
			self.state = 2
		end
	elseif diff > 50 then 
		if self.state ~= 3 then
			self.pentagram_mc:gotoAndPlay(self.positions[5])
			self.state = 3
		end
	end
	
end