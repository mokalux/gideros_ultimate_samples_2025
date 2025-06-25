PlayerMovement = Core.class(Sprite);

function PlayerMovement:init(scene)


self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)


self.scene = scene 


self.xSpeed = 0
self.ySpeed = 0
print(self)

-- Variables

self.speed = 2

local heroX, heroY = self.scene.hero.body:getPosition()

end

function PlayerMovement:moveLeft()

self.braking = "left"
self.movingRight = false;
self.movingLeft = true;
self.xSpeed = -2

end

function PlayerMovement:moveRight()

self.braking = "right"
self.movingLeft = false;
self.movingRight = true;
self.xSpeed = 2

end

function PlayerMovement:moveUp()
self.movingUp = true;
end


function PlayerMovement:onEnterFrame()

-- Left and right moves

self.heroX, self.heroY = self.scene.hero.body:getPosition();

-- Make the moves

self.scene.hero.body:setPosition(self.heroX+self.xSpeed, self.heroY)
--self.scene.hero:setPosition(self.heroX+self.xSpeed, self.heroY)

if(self.movingUp) then
self.scene.hero.body:setLinearVelocity(0,-5)
self.scene.hero.onGround = false;
end



if(#self.scene.upButtonTouches==0) then
	self.movingUp = false;
end


--print(self.
-- Do braking
-- NOTE - need to do different braking on ground to in air



if(self.scene.hero.onGround) then -- turn off braking in air

	if(#self.scene.leftButtonTouches==0 and #self.scene.rightButtonTouches==0) then

		if(self.braking == "left") then

			self.xSpeed = self.xSpeed + .1;
			if(self.xSpeed > 0) then
				self.xSpeed = 0;
				self.movingLeft = nil
				self.braking = nil
			end

		end
		
		if(self.braking == "right") then

			self.xSpeed = self.xSpeed - .1;
			if(self.xSpeed < 0) then
				self.xSpeed = 0;
				self.movingRight = nil
				self.braking = nil
			end

		end
		
	end
end

-- Update camera
self.scene.camera:moveCameraTo(self.heroX,self.heroY)

end