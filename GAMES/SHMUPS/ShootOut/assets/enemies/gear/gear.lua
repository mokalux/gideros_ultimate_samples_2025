Gear = Core.class(Sprite)

function Gear:init(sprite)

	self.gear = Bitmap.new(Texture.new("enemies/gear/gear_1.png"))
	
	self.gear:setAnchorPoint(0.5,0.5)

	self.gearAnim = MovieClip.new{
	{1, 20, self.gear, {rotation = {1, 72}}},
	{20, 40, self.gear, {rotation = {72, 144}}},
	{40, 60, self.gear, {rotation = {144, 216}}},
	{60, 80, self.gear, {rotation = {216, 270}}},
	{80, 100, self.gear, {rotation = {270, 360}}},
	{100, 120, self.gear, {rotation = {360, 360}}},
	{120, 140, self.gear, {rotation = {-1, -72}}},
	{140, 160, self.gear, {rotation = {-72, -144}}},
	{160, 180, self.gear, {rotation = {-144, -216}}},
	{180, 200, self.gear, {rotation = {-216, -270}}},
	{200, 220, self.gear, {rotation = {-270, -360}}},
	{220, 240, self.gear, {rotation = {-360, -360}}},
	}
	self.gearAnim:setGotoAction(220, 1)
	self:addChild(self.gearAnim)
	
	self.efx_impact = Sound.new("sound/sound_efx/impact.wav")

	self.shot = nil
	
	self.damaged = 0
	
	self.firePower = 0.5

	self.decrement = self.firePower
	
	self.collided = false
	self.died = false
	
	self:setPosition(190, -100)
	
	self:setScale(0.8)
	
	self.width = self:getWidth()
	self.height = self:getHeight()
	
	-- pego a posicao do sprite e nomeio como alvo x e y--
	
	self.ship = sprite
	
	self.rx = self:getX()
	self.ry = self:getY()
	self.x = math.random(2, 300)
	self.y = math.random(0, 130)-300
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	--self:addEventListener(Event.ENTER_FRAME, self.onGearFire, self)
	--self:addEventListener(Event.TOUCHES_MOVE, self.onTouch, self)
end

function Gear:onEnterFrame(event)
	
	if self.gearAnim:getFrame() == 100 or self.gearAnim:getFrame() == 220 then
		self:onGearFire()
	end
	if self.gearAnim:getFrame() == 20 then
		self.rx = math.random(2, 300)
		self.ry = math.random(1, 120)
	end
	
	
	-- manage movements dinamically --
	if self.x > self.rx then		
		if self.x == self.rx then
			self:setX(self.rx)
		else
			self.x -= 1
			self:setX(self.x)
		end
	else		
		if self.x == self.rx then
			self:setX(self.rx)
		else
			self.x += 1
			self:setX(self.x)
		end
	end
	
	if self.y > self.ry then
		if self.y == self.ry then
			self:setY(self.ry)
		else
			self.y -= 1
			self:setY(self.y)
		end
	else		
		if self.y == self.ry then
			self:setY(self.ry)
		else
			self.y += 1
			self:setY(self.y)
		end
	end
	-- end movements management --
	 
	-- begin detect damage --
	
	if self.ship.shipAnim:getFrame() == 40 then
		self.ship.shipAnim:gotoAndPlay(1)
	end
	
	if self.ship.flag_fire then
		if self.ship.shot:collidesWith(self) then
			self.damaged += 1
			
			points += 1
			
			self.efx_impact:play()
			
			self.ship.shot:removeFromParent()
			if self.damaged > 80 then
				if not self.died then
					points += 20
					print(hiscore)
					self.died = true
				end
				self:removeFromParent()
			end
			print('damaged ', self.damaged)
		end
	end
end

function Gear:onDetectCollision(event)

	if self.shot:collidesWith(self.ship) then
		self.shot.fire:removeFromParent()
		
		if not self.ship.shieldOn then
			self.ship.shipAnim:gotoAndPlay(24)
		end
		application:vibrate(60)
		
		stage:removeEventListener(Event.ENTER_FRAME, self.shot.onFire, self.shot)

		self.collided = true
	end
		
	if self.collided then
		if self.ship.shieldOn then
			self.ship:Shield()
			self.ship:onShieldDamage(1)
		else
			self.ship:onDamage(self.decrement)
			application:vibrate(60)
		end
		
		self:removeEventListener(Event.ENTER_FRAME, self.onDetectCollision, self)
		self.collided = false
	end
end

function Gear:onGearFire(event)

	-- pego a posicao do inimigo que vai atirar, e somo com a altura e largura dividido por 2
	-- para que? para centralizar a posicao de saída do tiro
	local x, y = self:getPosition()
	-- defino o alvo, que é posicao da nave dividido pela posicao do inimigo, x e y respectivamente.
	local tx, ty 
	ty = self.ship:getY()/y
	tx = self.ship:getX()/x-(self:getWidth()/2)+1
	
	if tx < 0 then
		tx = (self.ship:getX()-x)/(x/2)
	end
	
	self.shot = Fire.new("enemies/enemy_fire.png", ty, tx, x, y+self.height/2) -- seto o alvo y e alvo x, e posicao do 'atirador' x e y
		-- pra que? Porque no metodo onFire, é aonde será definido da onde o tiro sairá, e a direcao que o tiro terá
	self.shot:onFire()
	
	if not self.quit then
		self:addEventListener(Event.ENTER_FRAME, self.onDetectCollision, self)
	end
end

function Gear.collidesWith(self, sprite2)
 
	local x,y,w,h = self:getBounds(stage)
	local x2,y2,w2,h2 = sprite2:getBounds(stage)
	
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