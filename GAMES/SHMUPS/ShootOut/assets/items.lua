Items = Core.class(Sprite)

function Items:init(sprite, key)

-- one: energy, two: fire, three: health
self.key = key 
self.sprite = sprite
self.move = 0

local pack = TexturePack.new("objects/items/ship_items.txt", "objects/items/ship_items.png")

self.anim = {
	-- energy --
	Bitmap.new(pack:getTextureRegion("energy_1.png")),
	Bitmap.new(pack:getTextureRegion("energy_2.png")),
	Bitmap.new(pack:getTextureRegion("energy_3.png")),
	Bitmap.new(pack:getTextureRegion("energy_4.png")),
	
	-- fire --
	Bitmap.new(pack:getTextureRegion("fire_power_1.png")),
	Bitmap.new(pack:getTextureRegion("fire_power_2.png")),
	Bitmap.new(pack:getTextureRegion("fire_power_3.png")),
	Bitmap.new(pack:getTextureRegion("fire_power_4.png")),
	
	-- health --
	
	Bitmap.new(pack:getTextureRegion("health_1.png")),
	Bitmap.new(pack:getTextureRegion("health_2.png")),
	Bitmap.new(pack:getTextureRegion("health_3.png")),
	Bitmap.new(pack:getTextureRegion("health_4.png")),
}

self.itemAnim = MovieClip.new {
	{1, 4, self.anim[1]},
	{4, 8, self.anim[2]},
	{8, 12, self.anim[3]},
	{12, 16, self.anim[4]},
	{16, 20, self.anim[3]},
	{20, 24, self.anim[2]},
	
	{24, 28, self.anim[5]},
	{28, 32, self.anim[6]},
	{32, 36, self.anim[7]},
	{36, 40, self.anim[8]},
	{40, 44, self.anim[7]},
	{44, 48, self.anim[6]},
	
	{48, 62, self.anim[9]},
	{62, 66, self.anim[10]},
	{66, 70, self.anim[11]},
	{70, 74, self.anim[12]},
	{74, 78, self.anim[11]},
	{78, 82, self.anim[10]},
}

self:setPosition(160, -100)
self.itemAnim:setAnchorPoint(0.5,0.5)
self:addChild(self.itemAnim)

self:addEventListener(Event.ENTER_FRAME, self.setAndMove, self)

end

function Items:setAndMove()
	
	self.move += 0.010
	self:setY(self:getY() + self.move)
	
	if self.key == 1 then

		self.itemAnim:setGotoAction(23, 1)
		
		if self:collidesWith(self.sprite) then
			print('worked energy')
			
			self:removeChild(self.itemAnim)
			self.move = 0
			
			self.sprite:Shield()
			self.sprite.shieldOn = true
		end
		
	elseif self.key == 2 then

		self.itemAnim:setGotoAction(47, 24)
		
		if self:collidesWith(self.sprite) then
			print('worked fire')
			local sndPowerUp = Sound.new("sound/sound_efx/powerup.wav")
			sndPowerUp:play()
			self:removeChild(self.itemAnim)
			self.sprite.power = 2
			self.move = 0
		end

	elseif self.key == 3 then

		self.itemAnim:setGotoAction(81, 48)
		
		if self:collidesWith(self.sprite) then
			print('worked health')
			local sndHeart = Sound.new("sound/sound_efx/heart_gain.wav")
			sndHeart:play()
			self:addEventListener(Event.ENTER_FRAME, self.restoreHealth, self)
			self.itemAnim:removeFromParent()
			self.move = 0			
		end
	end
	
	if self:getY() > (480 + self:getHeight()) then
		self.itemAnim:removeFromParent()
		self.move = 0
	end
	--print(self.move)
end

local count = 0

function Items:restoreHealth()
	count += 1
	
	if count > 6 then
		if self.sprite.shipDamage < 11 and self.sprite.shipDamage > 1 then
			self.sprite:onDamage(-0.5)
			count = 0
			print("health ",self.sprite.shipDamage)
		else
			self:removeEventListener(Event.ENTER_FRAME, self.restoreHealth, self)
		end
	end

end

function Items.collidesWith(self, sprite2)
 
	local x,y,w,h = self:getBounds(stage)
	local x2,y2,w2,h2 = sprite2:getBounds(stage)
	x2 = x2 - 4
	y2 = y2 + 35
	--print(x2, y2)
	-- self bottom < other sprite top
	if y + h < y2 then
		return false
	end
	-- self top > other sprite bottom
	if y > y2 + h2 then
		return false
	end
	-- self left > other sprite right
	if x > x2 + w2 then
		return false
	end
	-- self right < other sprite left
	if x + w < x2 then
		return false
	end
	
	--print('self bounds:',x,y,w,h,' sprite2 bounds:',x2,y2,w2,h2)
	return true
end