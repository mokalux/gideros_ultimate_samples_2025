Hero = Core.class(Sprite)

function Hero:init()

	local pack = TexturePack.new("gfx/hero.txt", "gfx/hero.png")
	
	self.animMovingRight = {
		Bitmap.new(pack:getTextureRegion("hero_07.png")),
		Bitmap.new(pack:getTextureRegion("hero_08.png")),
		Bitmap.new(pack:getTextureRegion("hero_09.png")),
	}
	self.animMovingLeft = {
		Bitmap.new(pack:getTextureRegion("hero_04.png")),
		Bitmap.new(pack:getTextureRegion("hero_05.png")),
		Bitmap.new(pack:getTextureRegion("hero_06.png")),
	}
	
	self.animStopedLeft = Bitmap.new(pack:getTextureRegion("hero_05.png"))
	self.animJumpingLeft = Bitmap.new(pack:getTextureRegion("hero_04.png"))
	
	self.animStopedRight = Bitmap.new(pack:getTextureRegion("hero_08.png"))
	self.animJumpingRight = Bitmap.new(pack:getTextureRegion("hero_07.png"))
	
	self.body = world:createBody {type = b2.DYNAMIC_BODY, fixedRotation = true}
	self.body.name = "hero"
	local shape = b2.PolygonShape.new()
	shape:setAsBox(20,32,32,32,0)
	
	self.body:createFixture {shape = shape, density = 1, restitution = 0.2, friction = 0.1}
	
	self.frame = 1
	self:addChild(self.animStopedRight)
	self.subframe = 0
	self.onGround = false
	self.moving = false
	self.direction = true
	self.jumping = false
	
	self:addEventListener(Event.ENTER_FRAME, self.animate, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

function Hero:setX(x)
	self:set("x", x)
	self.body:setPosition(self:getX(), self:getY())
end

function Hero:setY(y)
	self:set("y", y)
	self.body:setPosition(self:getX(), self:getY())
end

function Hero:animate()
	--print(self.moving)

	if self.jumping then
		self:removeChildAt(1)
		if self.direction then
			self:addChild(self.animJumpingRight)
		else
			self:addChild(self.animJumpingLeft)
		end
		self.frame = 1
		self.subframe = 0
	elseif self.moving then 	
	
		self.subframe = self.subframe + 1

		if self.subframe > 2 then
			self:removeChildAt(1)
			
			self.frame = self.frame + 1
			if self.frame > #self.animMovingRight then
				self.frame = 1
			end
			if self.direction then
				self:addChild(self.animMovingRight[self.frame])
			else
				self:addChild(self.animMovingLeft[self.frame])
			end
			
			self.subframe = 0
		end
	else
		self:removeChildAt(1)
		if self.direction then
			self:addChild(self.animStopedRight)
		else
			self:addChild(self.animStopedLeft)
		end
		self.frame = 1
		self.subframe = 0
	end	
		
	self:setPosition(self.body:getPosition())	
end

function Hero:onKeyDown(event)	
	self.body:setAwake(true)
	self.body:setActive(true)
	if event.keyCode == KeyCode.UP then
		if not self.jumping then
			print("jumping")
			self.jumping = true
			self.body:setLinearVelocity(0, -10);
		end		
	end	
end