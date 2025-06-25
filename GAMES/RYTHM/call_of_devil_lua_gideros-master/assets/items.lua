Items = Items or Core.class(Sprite)

function Items:init(options)

	self.level = options.level

	local scale = conf.ITEM_SCALE
	local speed = conf.SPEED_ITEM_FRAME
	
	local item_width = 50
	
	local item1_button_spritesheet = Texture.new("assets/images/item1.png")
	
	local anim = {
		Bitmap.new(TextureRegion.new(item1_button_spritesheet,  0,  0, 50, 50)),
		Bitmap.new(TextureRegion.new(item1_button_spritesheet,  50, 0, 50, 50)),
		Bitmap.new(TextureRegion.new(item1_button_spritesheet,  0,  50, 50, 50)),
		Bitmap.new(TextureRegion.new(item1_button_spritesheet, 50,  50, 50, 50)),
	}
	
	for i = 1, #anim do
        anim[i]:setAnchorPoint(0.5, 0.5)
        anim[i]:setScale(scale, scale)
    end

	
	self.item1_mc_up = MovieClip.new {
		{ 		 1, 	1 *	speed,   anim[1]},
		{speed + 1,   	2 * speed,   anim[2]},
	}
	
	self.item1_mc_down = MovieClip.new {
		{2 * speed + 1,  3 * speed,   anim[3]},
		{3 * speed + 1,  4 * speed,   anim[4]},
	}
	
	self.item1_mc_up:gotoAndPlay(1)
	
	self.item1_mc_up:setGotoAction(2 * speed, 1)
	self.item1_mc_down:setGotoAction(4 * speed, 2 * speed + 1)
	
	
	self.item1_button = Button.new(self.item1_mc_up, self.item1_mc_down)
	self.item1_button:setPosition(item_width / 2, conf.MID_HEIGHT * 1 / 3)
	
	local item2_button_spritesheet = Texture.new("assets/images/item2.png")
	
	local anim = {
		Bitmap.new(TextureRegion.new(item2_button_spritesheet,   0,  0,  50, 50)),
		Bitmap.new(TextureRegion.new(item2_button_spritesheet,  50,  0,  50, 50)),
		Bitmap.new(TextureRegion.new(item2_button_spritesheet,   0,  50, 50, 50)),
		Bitmap.new(TextureRegion.new(item2_button_spritesheet,  50,  50, 50, 50)),
	}
	
	for i = 1, #anim do
        anim[i]:setAnchorPoint(0.5, 0.5)
        anim[i]:setScale(scale, scale)
    end
		
	self.item2_mc_up = MovieClip.new {
		{ 		 1, 	1 *	speed,   anim[1]},
		{speed + 1,   	2 * speed,   anim[2]},
	}
	
	self.item2_mc_down = MovieClip.new {
		{2 * speed + 1,  3 * speed,   anim[3]},
		{3 * speed + 1,  4 * speed,   anim[4]},
	}
	
	self.item2_mc_up:gotoAndPlay(1)
	
	self.item2_mc_up:setGotoAction(2 * speed, 1)
	self.item2_mc_down:setGotoAction(4 * speed, 2 * speed + 1)
	
	
	self.item2_button = Button.new(self.item2_mc_up, self.item2_mc_down)
	self.item2_button:setPosition(conf.WIDTH - item_width / 2, conf.MID_HEIGHT * 1 / 3)
		
	
	self.item1_button:addEventListener("click", 
		function() 

			local state_1 = self.item1_button:contains(self.item1_button.upState)
			local state_2 = self.item2_button:contains(self.item2_button.upState)
			
			if conf.DEBUG then 
				print("clicked 1") 
				print(state_1, state_2)
			end
			
			self.item1_button:updateVisualState(not state_1)
			self.item2_button:updateVisualState(state_2)
			
			if state_1 and not state_2 then
				self.item2_button:updateVisualState(true)
				return
			end
			
			
			self.level:dispatchEvent(Event.new("TAP_ITEM"))
		end)
	
	
	self.item2_button:addEventListener("click", 
		function() 
			local state_1 = self.item1_button:contains(self.item1_button.upState)
			local state_2 = self.item2_button:contains(self.item2_button.upState)
			
			if conf.DEBUG then 
				print("clicked 2") 
				print(state_1, state_2)
			end
			
			self.item1_button:updateVisualState(state_1)
			self.item2_button:updateVisualState(not state_2)
			
			if state_2 and not state_1 then
				self.item1_button:updateVisualState(true)
				return
			end
			
			self.level:dispatchEvent(Event.new("TAP_ITEM"))
			
		end)
			
		
	-- init 
	self.item1_button:updateVisualState(true)
	
	self:addChild(self.item1_button)
	self:addChild(self.item2_button)
	
	
end