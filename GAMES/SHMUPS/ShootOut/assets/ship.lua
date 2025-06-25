Ship = Core.class(Sprite)

function Ship:init(damage)

	local pack = TexturePack.new("objects/ship/ship_texture.txt", "objects/ship/ship_texture.png")
	
	self.anim = {
		
		Bitmap.new(pack:getTextureRegion("ship1.png")),
		Bitmap.new(pack:getTextureRegion("ship2.png")),
		Bitmap.new(pack:getTextureRegion("ship3.png")),
		Bitmap.new(pack:getTextureRegion("ship4.png")),
		Bitmap.new(pack:getTextureRegion("ship2.png")),
		-- ship damage --
		Bitmap.new(pack:getTextureRegion("ship1_damaged.png")),
		Bitmap.new(pack:getTextureRegion("ship2_damaged.png")),
		Bitmap.new(pack:getTextureRegion("ship3_damaged.png")),
		Bitmap.new(pack:getTextureRegion("ship4_damaged.png")),
	}
	
	self.shipAnim = MovieClip.new {
				{1, 4, self.anim[1]},
				{4, 8, self.anim[2]},
				{8, 12, self.anim[3]},
				{12, 16, self.anim[4]},
				{16, 20, self.anim[5]},
				{24, 28, self.anim[6]},
				{28, 32, self.anim[7]},
				{32, 36, self.anim[8]},
				{36, 40, self.anim[9]},
			}
	self.shipAnim:setGotoAction(20, 1)
	self.shipAnim:setAnchorPoint(0.5,0.5)
	self:addChild(self.shipAnim)
	
	local shieldItem = Bitmap.new(Texture.new("objects/items/shield.png"))

	self.shield = MovieClip.new {
		{1, 32, shieldItem, {alpha = {0.2, 0.5, "easeOut"}}},
		{32, 64, shieldItem, {alpha = {0.5, 0.2, "easeIn"}}}, 
	}
	self.shield:setGotoAction(64, 1)
	self.shield:setAnchorPoint(0.5,0.5)
	self.shield:setPosition(self.shipAnim:getWidth()/2, self.shipAnim:getHeight()/2)
	
	self.fire = "objects/ship/fire_1.png"
	
	self.power = 1
	
	if self.power == 2 then
		self.fire = "objects/ship/fire_2.png"
	end
	
	self.shieldOn = false
	
	self.shot = Fire.new(self.fire, -30, 0, self:getX()+(self:getWidth()/2), self:getY())
	
	self.damage = damage
	
	self.shipDamage = 1
	self.shieldDamage = 1
		
	self:setPosition(160, 327)
	
	self:setScale(0.8)
	
	self.flag_fire = false
	
	self.frame = 0
	
	stage:addEventListener(Event.TOUCHES_MOVE, self.onTouch, self)
	stage:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	stage:addEventListener(Event.ENTER_FRAME, self.onShipFire, self)
	stage:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function Ship.onTouch(self, event)

if self:hitTestPoint(event.touch.x, event.touch.y) then
		self.x = event.touch.x
		self.y = event.touch.y
		-- Make sure they don't drag it offscreen
		if self.x > 320-self:getWidth()/2 then
			self.x = 320-self:getWidth()/2
		end
		if self.x < self:getWidth()/2 then
			self.x = self:getWidth()/2
		end	
		if self.y < self:getHeight()/2 then
			self.y = self:getHeight()/2
		end
		if self.y > 479 then
			self.y = 480-self:getHeight()/2
		end
		
		self:setPosition(self.x, self.y)
		--print('x ' .. self:getX() .. 'y ' .. self:getY())
	end
end

function Ship:onMouseUp(event)
	self.flag_fire = false
end

function Ship:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.flag_fire = true
	end
end

function Ship.onShipFire(self)
	
	if self.power == 2 then
		self.fire = "objects/ship/fire_2.png"
	else
		self.fire = "objects/ship/fire_1.png"
	end

	if self.flag_fire then
		
		self.frame += 2
		if self.frame > 7 then
		
			local x, y = self:getPosition()
			--x = x + self:getWidth()/2
			
			self.shot = Fire.new(self.fire, -70	, 0, x, y)
			
			self.shot:onFire()
			self.frame = 0
		end
	end
end

function Ship:onDamage(value)
	self.damage.ndamage += value
	self.shipDamage += value	
end

function Ship:onShieldDamage(value)
	self.shieldDamage += value
end

function Ship:Shield(event)
	
	if not self.shieldOn then
		self.shipAnim:addChildAt(self.shield, 1)
		self.shieldOn = true
	end
	
	if self.shieldDamage == 25 then
		self.shield:removeFromParent()
		self.shieldDamage = 1
		self.shieldOn = false
	end
	
	print('self.shield ', self.shieldOn, 'self.shieldDamage ', self.shieldDamage)
end