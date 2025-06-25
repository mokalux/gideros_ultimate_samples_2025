Boss2 = Core.class(Sprite)

function Boss2:init(sprite)

	local pack = TexturePack.new("enemies/boss_2/flames_2.txt", "enemies/boss_2/flames_2.png")
	
	self.sprite = sprite
	
	self.propulsion = {
		
		Bitmap.new(pack:getTextureRegion("flame_2_1.png")),
		Bitmap.new(pack:getTextureRegion("flame_2_2.png")),
		Bitmap.new(pack:getTextureRegion("flame_2_3.png")),
		Bitmap.new(pack:getTextureRegion("flame_2_4.png")),
	}
	self.boss = Bitmap.new(Texture.new("enemies/boss_2/Boss.png"))
	self.efx_shoot = Sound.new("sound/sound_efx/hurt.wav")
			
	for i=1, #self.propulsion do
		self.propulsion[i]:setAnchorPoint(0.5,0.5)
		self.propulsion[i]:setRotation(90)
	end
	self.boss:setAnchorPoint(0.5,0.5)
	
	self.propulsion = MovieClip.new{
		{1, 4, self.propulsion[1]},
		{4, 8, self.propulsion[2]},
		{8, 12, self.propulsion[3]},
		{12, 16, self.propulsion[4]},
	}
	self.propulsion:setGotoAction(16, 1)
	
	self.efx_impact = Sound.new("sound/sound_efx/impact.wav")
	self.efx_explosion2 = Sound.new("sound/sound_efx/explosion2.wav")
	
	self.boss:setScale(0.6)
	
	self.counter = 0
	self.collided = false
	
	self.kickoff = -200
	
	self.boss:setPosition(160, self.kickoff)
	self.propulsion:setPosition(0, -(self.boss:getHeight()))
	self.boss:addChildAt(self.propulsion, 1)
	
	self.mainy = 350
	
	self:addChild(self.boss)
	
	self:addEventListener(Event.ENTER_FRAME, self.Move, self)
	
	self.decrement = 0.5
	

	self.fireLeft = {}
	self.fireRight = {}
	self.fireMain = nil
	
	self.bulletLeft = 1
	self.bulletRight = 1
	
	self.damaged = 0
	
	self.shootCount = 0
	self.moveCount = 0
	
	self.died = false
end

function Boss2:Move()
	
	self.counter += 1
	
		if self:getY() <= self.mainy then
			self:setY(self:getY()+1)
		end
		
		if self.counter > 600 then
			self.moveCount += 1
			self.shootCount +=1
			
			if self.moveCount == 100 then
				rdnY = math.random(-300, -200)
				rdnX = math.random(90, 230)
				self.moveCount = 0
			end
			
				
			if not self.died then	
				if self.shootCount == 80 or self.shootCount == 85 or self.shootCount == 90 then
					--self:onGearFireLeft(self.boss:getX(), self:getY()-180)
					
					if self.shootCount == 85 then
						self.bulletLeft = 2
						self.bulletRight = 2
					elseif self.shootCount == 90 then
						self.bulletLeft = 3
						self.bulletRight = 3
						self:onGearFireMain(self.boss:getX(), self.boss:getY()+380)
						self.efx_shoot:play()
					end
					
					self:onGearFireLeft(self.boss:getX()-70, self.boss:getY()+370)

					self:onGearFireRight(self.boss:getX()+70, self.boss:getY()+370)
					
				end
				
				if self.shootCount == 91 then
						self.shootCount = 0
						self.bulletLeft = 1
						self.bulletRight = 1
				end
			end
			-- boom time: boss' attack against ship
			if self.sprite.flag_fire then
				if self.sprite.shot:collidesWith(self) then
					self.damaged += 1
					points +=1
					self.sprite.shot:removeFromParent()
					self.efx_impact:play()
					
					if self.damaged > 1000 then
						application:vibrate(450)
						points +=100
						self.boss:removeFromParent()
						self.efx_explosion2:play()
						self.died = true
					end
				end				
			end
			
			-- move boss
			if self.boss:getY() > rdnY then
				if self.boss:getY() == rdnY then
					self.boss:setY(rdnY)
				else
					self.boss:setY(self.boss:getY()-2)
				end
			else
				if self.boss:getY() == rdnY then
					self.boss:setY(rdnY)
				else	
					self.boss:setY(self.boss:getY()+3)
				end
			end
			
			if self.boss:getX() > rdnX then
				if self.boss:getX() == rdnX then
					self.boss:setX(rdnX)
				else
					self.boss:setX(self.boss:getX()-2)
				end
			else
				if self.boss:getX() == rdnX then
					self.boss:setX(rdnX)
				else
					self.boss:setX(self.boss:getX()+3)
				end
			end
			--print(self.gearAnim:getX(), rdnX, self.gearAnim:getY(), rdnY)
		end
		
		if self.sprite.shipAnim:getFrame() == 40 then
			self.sprite.shipAnim:gotoAndPlay(1)
		end
end

function Boss2:onGearFireLeft(x, y)
	self.fireLeft[self.bulletLeft] = Fire.new("enemies/enemy_fire.png", 10, 0, x, y) -- seto o alvo y e alvo x, e posicao do 'atirador' x e y
		-- pra que? Porque no metodo onFire, é aonde será definido da onde o tiro sairá, e a direcao que o tiro terá
	
	self.fireLeft[self.bulletLeft]:onFire(self.sprite)

	self:addEventListener(Event.ENTER_FRAME, self.onDetectCollisionLeft, self)
end

function Boss2:onGearFireRight(x, y)
	self.fireRight[self.bulletRight] = Fire.new("enemies/enemy_fire.png", 10, 0, x, y) -- seto o alvo y e alvo x, e posicao do 'atirador' x e y
		-- pra que? Porque no metodo onFire, é aonde será definido da onde o tiro sairá, e a direcao que o tiro terá
	
	self.fireRight[self.bulletRight]:onFire(self.sprite)

	self:addEventListener(Event.ENTER_FRAME, self.onDetectCollisionRight, self)
end

function Boss2:onGearFireMain(x, y)
	
	self.fireMain = Fire.new("enemies/boss_2/enemy_fire_2.png", 6, 0, x, y) -- seto o alvo y e alvo x, e posicao do 'atirador' x e y
		-- pra que? Porque no metodo onFire, é aonde será definido da onde o tiro sairá, e a direcao que o tiro terá
	
	self.fireMain:onFire(self.sprite)

	self:addEventListener(Event.ENTER_FRAME, self.onDetectCollisionMain, self)
end

function Boss2:onDetectCollisionLeft()
		
	if self.fireLeft[self.bulletLeft]:collidesWith(self.sprite) then
		self.fireLeft[self.bulletLeft].fire:removeFromParent()
		
		if not self.sprite.shieldOn then
			self.sprite.shipAnim:gotoAndPlay(24)
		end
		
		stage:removeEventListener(Event.ENTER_FRAME, self.fireLeft[self.bulletLeft].onFire, self.fireLeft[self.bulletLeft])
		
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
		
		if self.bulletLeft < 3 then
			self.bulletLeft+=1
		elseif self.bulletLeft == 3 then
			self:removeEventListener(Event.ENTER_FRAME, self.onDetectCollisionLeft, self)
		end
		
		self.collided = false
	end
end

function Boss2:onDetectCollisionRight()
	
	if self.fireRight[self.bulletRight]:collidesWith(self.sprite) then
		self.fireRight[self.bulletRight].fire:removeFromParent()
		
		if not self.sprite.shieldOn then
			self.sprite.shipAnim:gotoAndPlay(24)
		end
			application:vibrate(60)
		
		stage:removeEventListener(Event.ENTER_FRAME, self.fireRight[self.bulletRight].onFire, self.fireRight[self.bulletRight])
		
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
		
		if self.bulletRight < 3 then
			self.bulletRight += 1
		elseif self.bulletRight == 3 then
			self:removeEventListener(Event.ENTER_FRAME, self.onDetectCollisionRight, self)
		end
		self.collided = false
	end
end

function Boss2:onDetectCollisionMain()
	
	if self.fireMain:collidesWith(self.sprite) then
		self.fireMain.fire:removeFromParent()
		
		if not self.sprite.shieldOn then
			self.sprite.shipAnim:gotoAndPlay(24)
		end		
		
		stage:removeEventListener(Event.ENTER_FRAME, self.fireMain.onFire, self.fireMain)
		
		self.collided = true
	end
		
	if self.collided then
		
		if self.sprite.shieldOn then
			self.sprite:Shield()
			self.sprite:onShieldDamage(1+0.5)
		else
			self.sprite:onDamage(self.decrement+0.5)
			application:vibrate(60)
		end

		self:removeEventListener(Event.ENTER_FRAME, self.onDetectCollisionMain, self)

		self.collided = false
	end
end