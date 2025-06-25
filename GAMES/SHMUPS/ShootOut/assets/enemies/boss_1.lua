Boss1 = Core.class(Sprite)

function Boss1:init(sprite, boss)

	local pack = TexturePack.new("enemies/gear/Gear.txt", "enemies/gear/Gear.png")
	
	self.sprite = sprite
	
	self.anim = {
		
		Bitmap.new(pack:getTextureRegion("gear_1.png")), -- down
		Bitmap.new(pack:getTextureRegion("gear_2.png")), -- right
		Bitmap.new(pack:getTextureRegion("gear_3.png")), -- up
	}
	
	for i=1, #self.anim do
		self.anim[i]:setAnchorPoint(0.5,0.5)
	end
	
	self.gearAnim = MovieClip.new{
	{1, 20, self.anim[1], {rotation = {1, 72}}},
	{20, 40, self.anim[1], {rotation = {72, 144}}},
	{40, 60, self.anim[1], {rotation = {144, 216}}},
	{60, 80, self.anim[1], {rotation = {216, 288}}},
	{80, 100, self.anim[1], {rotation = {288, 360}}},
	}
	self.gearAnim:setGotoAction(100, 1)
	
	self.gearAnim:stop()
	self.animated = false
	
	self.efx_impact = Sound.new("sound/sound_efx/impact.wav")
	self.efx_explosion2 = Sound.new("sound/sound_efx/explosion2.wav")
	
	self.gearLeft = MovieClip.new{
	{1, 20, self.anim[2], {rotation = {1, -72}}},
	{20, 40, self.anim[2], {rotation = {-72, -144}}},
	{40, 60, self.anim[2], {rotation = {-144, -216}}},
	{60, 80, self.anim[2], {rotation = {-216, -288}}},
	{80, 100, self.anim[2], {rotation = {-288, -360}}},
	}
	
	self.gearLeft:setGotoAction(100, 1)
	
	self.gearRight = MovieClip.new{
	{1, 20, self.anim[3], {rotation = {1, -72}}},
	{20, 40, self.anim[3], {rotation = {-72, -144}}},
	{40, 60, self.anim[3], {rotation = {-144, -216}}},
	{60, 80, self.anim[3], {rotation = {-216, -288}}},
	{80, 100, self.anim[3], {rotation = {-288, -360}}},
	}
	
	self.gearRight:setGotoAction(100, 1)
	
	self.gearRight:setScale(0.7)
	self.gearLeft:setScale(0.7)
	
	self.counter = 0
	self.collided = false
	
	self.kickoff = -200
	self.gearAnim:setPosition(160, self.kickoff)
	self.gearLeft:setPosition(self.gearLeft:getWidth()-5, 800)
	self.gearRight:setPosition(-60, 800)
	
	self.lefty = (self.gearLeft:getWidth()/2)
	self.righty = ((self.gearRight:getWidth()+5)/2)
	self.mainy = 250
	
	self.isboss = boss
	
	if not boss then
		self.gearLeft:setPosition(self.gearLeft:getWidth()-5, self.lefty)
		self.gearRight:setPosition(-60, self.righty)
	end
	
	self.gearAnim:addChildAt(self.gearLeft, 1)
	self.gearAnim:addChildAt(self.gearRight, 2)
	
	self:addChild(self.gearAnim)
	
	self:addEventListener(Event.ENTER_FRAME, self.Move, self)
	
	self.decrement = 0.5
	
	self.fire = {}
	self.i = 0
	
	self.leftdamaged = 0
	self.rightdamaged = 0
	self.maindamaged = 0
	
	self.died = {false, false, false}
	
end

local leftFrame, rightFrame
rdnY = math.random(-200, -180)
rdnX = math.random(90, 230)

function Boss1:Move()
	local stopped = false
	
	self.counter += 1
	
		if self:getY() <= self.mainy then
			self:setY(self:getY()+1)
			if not self.isboss then
				self.gearAnim:gotoAndPlay(1)
				stopped = true
				self.counter = 1100
			end
		end
		
		if self:getY() >= self.mainy then
			if self.gearLeft:getY() >= self.lefty and self.gearRight:getY() >= self.righty then
				self.gearLeft:setY(self.gearLeft:getY()-1)
				self.gearRight:setY(self.gearRight:getY()-1)
			else
				if self.counter <= 1100 then
					stopped = true
				else
					stopped = false
				end
			end
		end
		
		if stopped then
			leftFrame = self.gearLeft:getFrame()
			rightFrame = self.gearRight:getFrame()
			self.gearLeft:stop()
			self.gearRight:stop()
		end
		
		if self.counter > 1100 then
			if not self.animated then
				self.gearAnim:gotoAndPlay(1)
				self.gearLeft:gotoAndPlay(leftFrame)
				self.gearRight:gotoAndPlay(rightFrame)
				self.animated = true
			end
			if self.gearAnim:getFrame() == 100 then
				rdnY = math.random(-200, -180)
				rdnX = math.random(90, 230)
				if not self.died[1] then
					self.i = 1
					self:onGearFire(self.gearAnim:getX(), self:getY()-180)
				end
			end
			if self.gearLeft:getFrame() == 40 then
				if not self.died[2] then
					self.i = 2
--					self:onGearFire(self.gearAnim:getX()-60, self:getY()-160)
				end
			end
			if self.gearRight:getFrame() == 70 then
				if not self.died[3] then
					self.i = 3
--					self:onGearFire(self.gearAnim:getX()+60, self:getY()-160)
				end
			end
	-- boom time: boss' attack against ship
			if self.sprite.flag_fire then
				if self.sprite.shot:collidesWith(self.gearLeft) then
					self.leftdamaged += 1
					points +=1
						self.sprite.shot:removeFromParent()
						if self.leftdamaged < 200 then
							self.efx_impact:play()
						end
		-- collision detection
						if self.leftdamaged == 200 then
							application:vibrate(60)
							points +=10
							self.gearLeft:removeFromParent()
							self.died[2] = true
						end
				end
				
				if self.sprite.shot:collidesWith(self.gearRight) then
					self.rightdamaged += 1
					points +=1
					self.sprite.shot:removeFromParent()
					self.efx_impact:play()

					if self.rightdamaged == 200 then
						application:vibrate(60)
						points +=10
						self.gearRight:removeFromParent()
						self.died[3] = true
					end
				end 
					--print(self.rightdamaged, self.gearLeft:getPosition())
					if self.rightdamaged >= 200 and self.leftdamaged >= 200 then
						if self.sprite.shot:collidesWith(self) then
						self.maindamaged += 1
						points +=1
						self.sprite.shot:removeFromParent()
						self.efx_impact:play()

						if self.maindamaged > 400 then
							application:vibrate(450)
							points +=100
							self.gearAnim:removeFromParent()
							self.efx_explosion2:play()
							self.died[1] = true
						end
					end 
				end
				
				
			end
			
			-- move boss
			if self.gearAnim:getY() > rdnY then
				if self.gearAnim:getY() == rdnY then
					self.gearAnim:setY(rdnY)
				else
					self.gearAnim:setY(self.gearAnim:getY()-1)
				end
			else
				if self.gearAnim:getY() == rdnY then
					self.gearAnim:setY(rdnY)
				else	
					self.gearAnim:setY(self.gearAnim:getY()+2)
				end
			end
			
			if self.gearAnim:getX() > rdnX then
				if self.gearAnim:getX() == rdnX then
					self.gearAnim:setX(rdnX)
				else
					self.gearAnim:setX(self.gearAnim:getX()-1)
				end
			else
				if self.gearAnim:getX() == rdnX then
					self.gearAnim:setX(rdnX)
				else
					self.gearAnim:setX(self.gearAnim:getX()+2)
				end
			end
			--print(self.gearAnim:getX(), rdnX, self.gearAnim:getY(), rdnY)
		end
		
		if self.sprite.shipAnim:getFrame() == 40 then
			self.sprite.shipAnim:gotoAndPlay(1)
		end
end

function Boss1:onDetectCollision()
	
	--print('collision ', self.i)
	if self.fire[self.i]:collidesWith(self.sprite) then
		self.fire[self.i].fire:removeFromParent()
		
		if not self.sprite.shieldOn then
			self.sprite.shipAnim:gotoAndPlay(24)
		end	
		application:vibrate(60)
		
		stage:removeEventListener(Event.ENTER_FRAME, self.fire[self.i].onFire, self.fire[self.i])
		
		self.collided = true
	end

	if self.collided then
		if self.sprite.shieldOn then
			self.sprite:Shield()
			self.sprite:onShieldDamage(1)
		else
			self.sprite:onDamage(self.decrement)
			application:vibrate(60)
		end

		self:removeEventListener(Event.ENTER_FRAME, self.onDetectCollision, self)
		self.collided = false
	end
end

function Boss1:onGearFire(x, y)
	print(x, y, self.i)
	self.fire[self.i] = Fire.new("enemies/enemy_fire.png", 10, 0, x, y) -- seto o alvo y e alvo x, e posicao do 'atirador' x e y
		-- pra que? Porque no metodo onFire, é aonde será definido da onde o tiro sairá, e a direcao que o tiro terá
	
	if self.i == 1 then
		self.fire[self.i]:setScale(1)
	end
	self.fire[self.i]:onFire()

	self:addEventListener(Event.ENTER_FRAME, self.onDetectCollision, self)
end
