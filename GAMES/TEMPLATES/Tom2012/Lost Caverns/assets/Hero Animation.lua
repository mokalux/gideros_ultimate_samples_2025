HeroAnimation = Core.class(Sprite);

function HeroAnimation:init(scene)

	self.scene = scene
	
	-- Test mode
	--self.test = true
	
	self.facing="right"
	--self.num=1 -- temp	

	
end




function HeroAnimation:onExit()

--print("ha exit")
--self:stopBob()

	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	


	
end


function HeroAnimation:updateAnimation()

--	print(self.scene.aimingClaw, self.scene.firingClaw, self.scene.retractingClaw,self.scene.holdingObject)

	--self.num = self.num+1 -- temp delete
	local hero = self.scene.hero

	if(not(self.scene.gameEnded)) then

		-- falling

		if(self.scene.hero.falling) then



			if(self.test) then
				print("Anim: falling")
			end

			-- Stop parts bobbing
			
			self.scene.hero.rearArmSprite:setAlpha(0)

			self:stopBob()
			self:headBobStop()

			hero.ears:setAnimation("HERO_EARS_FALLING")
			hero.legs:setAnimation("HERO_LEGS_FALLING")
			
			if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw) then

				hero.frontArmAnimation:setAnimation("HERO_FRONT_ARM_FALLING")
				self.scene.hero.frontArm:setScaleY(1)
				
				hero.frontArm:setRotation(0)

				if(self.scene.hero.direction=="left") then
					hero.frontArm:setPosition(5,-6)
				else 
					hero.frontArm:setPosition(-5,-6)
				end
				

				
			end
			
			if(self.scene.hero.direction=="left") then
				hero.legsSprite:setPosition(-7,-1)
				hero.earsSprite:setPosition(-5, -27)
			else 
				hero.legsSprite:setPosition(5,-1)
				hero.earsSprite:setPosition(5, -27)
			end
			
			hero.ears:playAnimation()
			
			if(self.animation ~= "falling") then
				hero.legs:playAnimation()
						-- This fix stops the arms going out of sync
				self.scene.hero.frontArmAnimation:stopAnimation(1)
				self.scene.hero.rearArm:stopAnimation()
				hero.frontArmAnimation:playAnimation(1)
			end
			
			self.animation = "falling"


		-- flying

		elseif(hero.flying) then

			if(self.test) then
				print("Anim: flying")
			end

			self.animation = "flying"
			
			self.scene.hero.rearArmSprite:setAlpha(0)
			
			-- Stop parts bobbing

			self:stopBob()
			self:headBobStop()
			
			hero.ears:setAnimation("HERO_EARS_FLYING")
			hero.legs:setAnimation("HERO_LEGS_FLYING")
			
			--print(self.scene.aimingClaw,self.scene.firingClaw,self.scene.retractingClaw,self.scene.pauseClaw)
			
			if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
			
				hero.frontArmAnimation:setAnimation("HERO_FRONT_ARM_FLYING")
				self.scene.hero.frontArm:setScaleY(1)
				hero.frontArm:setRotation(0)
				hero.frontArmAnimation:playAnimation()
				
				if(self.scene.hero.direction=="left") then
					hero.frontArm:setPosition(11,-2)
				else 
					hero.frontArm:setPosition(-11,-2)
				end
				
			end

			
			if(self.scene.hero.direction=="left") then
				hero.legsSprite:setPosition(2,6)
				hero.earsSprite:setPosition(-3, -12)
			else 
				hero.legsSprite:setPosition(-1,6)
				hero.earsSprite:setPosition(5, -12)
			end

			
			hero.ears:playAnimation()
			hero.legs:playAnimation()

			
		-- walking

		elseif(self.scene.playerMovement.numFeetContacts>0 and (#self.scene.leftButtonTouches>0 or #self.scene.rightButtonTouches>0) and not(self.scene.playerMovement.movingUp)) then

			if(self.animation~="walking") then
				
				if(self.test) then
					print("Anim: walking")
				end
				
				self.scene.hero.rearArmSprite:setAlpha(1)
				
				-- Stop parts bobbing

				self:stopBob()
				
				-- Make head bob
				
				self:headBobStart()

				self.animation = "walking"
				hero.ears:setAnimation("HERO_EARS_WALKING")
				hero.earsSprite:setPosition(0, 0)
				
				hero.legs:setAnimation("HERO_LEGS_WALKING")
				hero.legsSprite:setPosition(0, 0)   
				
				if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
				
					hero.frontArm:setRotation(0)
					hero.frontArmAnimation:setAnimation("HERO_FRONT_ARM_WALKING")
					hero.rearArm:setAnimation("HERO_REAR_ARM_WALKING")
					
					hero.frontArmAnimation:stopAnimation()
					hero.frontArmAnimation:playAnimation(1)
					hero.rearArm:stopAnimation()
					hero.rearArm:playAnimation(12)
					
				end


				
				
				
				
				
				
				
				
				hero.ears:playAnimation(1)
				hero.legs:playAnimation(1)
			end -- end if not already walking
			
			
		
			
			
			if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
			
				hero.frontArm:setRotation(0)
				self.scene.hero.frontArm:setScaleY(1)
				
				if(self.scene.hero.direction=="left") then
					hero.frontArm:setPosition(6,0)
					hero.rearArmSprite:setPosition(-1,-3)
				else 
					hero.frontArm:setPosition(-6,0)
					hero.rearArmSprite:setPosition(1,-3)
				end	
				
			end

			
			if(self.scene.hero.direction=="left") then
				hero.legsSprite:setPosition(-3,0)
			else 
				hero.legsSprite:setPosition(0,0)
			end	
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			


		-- not doing anything, standing

		elseif(self.scene.playerMovement.numFeetContacts>0
		and (#self.scene.leftButtonTouches==0
		and #self.scene.rightButtonTouches==0)
		and self.animation ~= "standing"
		and not(self.scene.playerMovement.movingUp)
		and (self.scene.playerMovement.yVel>-1)
		) then

		--print("standing feet contacts",self.scene.playerMovement.numFeetContacts)



			if(self.test) then
				print("Anim: standing")
			end

			self.scene.hero.rearArmSprite:setAlpha(1)
			
			-- make parts bob

			self:startBob()
			self:headBobStop()

			self.animation = "standing"
			hero.ears:setAnimation("HERO_EARS_STANDING")
			hero.ears:playAnimation()
			
			hero.rearArm:setAnimation("HERO_REAR_ARM_STANDING")
			hero.rearArm:setScaleY(1)
			
			hero.earsSprite:setPosition(0,0)
			hero.legs:setAnimation("HERO_LEGS_STANDING")
			hero.legsSprite:setPosition(0,0)
			hero.legs:playAnimation()
			
			if(self.scene.hero.direction=="left") then
				hero.rearArmSprite:setPosition(-3,0)
				
			else 
				hero.rearArmSprite:setPosition(5,0)
			end
			
	end

end


	




--------------------------------------------------------------
-- Change front arm animation
--------------------------------------------------------------

-- aiming claw

if(self.scene.aimingClaw) then

	hero.frontArmAnimation:setAnimation("HERO_FRONT_ARM_AIMING")

	-- Stop parts bobbing

	self:stopBob()

		if(self.scene.hero.direction=="left") then

			self.scene.hero.frontArm:setScaleX(1)
			self.scene.hero.frontArm:setScaleY(-1)
			hero.frontArm:setPosition(6,-8)
			
		else 

			self.scene.hero.frontArm:setScaleX(1)
			self.scene.hero.frontArm:setScaleY(1)
			hero.frontArm:setPosition(-6,-8)
		end	

end

-- firing / retracting claw



if(self.scene.firingClaw or self.scene.retractingClaw or self.scene.pauseClaw) then

	-- Stop parts bobbing

	self:stopBob()
	hero.frontArmAnimation:setAnimation("HERO_FRONT_ARM_FIRING")
	
	if(self.scene.hero.direction=="left") then
		self.scene.hero.frontArm:setScaleY(-1)
		hero.frontArm:setPosition(6,-8)
	else
		self.scene.hero.frontArm:setScaleY(1)
		hero.frontArm:setPosition(-6,-8)

	end	
	
end



-- arm standing

if(self.scene.playerMovement.numFeetContacts>0 and (#self.scene.leftButtonTouches==0 and #self.scene.rightButtonTouches==0)  and not(self.scene.playerMovement.movingUp)) then

	if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then

		self:startBob()

		if(not(self.scene.holdingObject)) then
			hero.frontArmAnimation:setAnimation("HERO_FRONT_ARM_STANDING")
			self.scene.hero.frontArm:setScaleY(1)
			hero.frontArm:setRotation(0)

	
			if(self.scene.hero.direction=="left") then
				hero.frontArm:setPosition(2,0)
				self.scene.hero.frontArm:setScaleX(-1)
			else 
				hero.frontArm:setPosition(-2,0)
				self.scene.hero.frontArm:setScaleX(1)
			end
			
		end
		
	end
	
end




--[[
-- arm falling

if(self.scene.playerMovement.numFeetContacts==0 and not(self.scene.playerMovement.movingUp)) then

	if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then

		print("arm normal")
	
	end
	
end
--]]








-- Flip when needed

if(self.scene.hero.direction=="left" and self.facing ~= "left") then
	self:flipLeft()

			
elseif(self.scene.hero.direction=="right" and self.facing ~= "right") then
	self:flipRight()

end

if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
	if(self.facing=="right" and self.scene.armFacing=="left")  then
		hero.frontArm:setScaleX(1)
	elseif(self.facing=="left" and self.scene.armFacing=="right")  then
		hero.frontArm:setScaleX(-1)
	end
end



-- work out if the joystick is left or right

if(self.scene.aimingClaw and self.animation=="standing" and self.scene.touchingJoypad) then

	if(self.scene.interface.direction > 1.5 and self.scene.interface.direction < 4.6) then

		if(self.facing ~= "left") then
			self:flipLeft()
		end
	else
		if(self.facing ~= "right") then
			self:flipRight()
		end
	end
end



--print(self.scene.hero.heroBody:getScaleX(), self.scene.hero.frontArm:getScaleX(), self.scene.hero.frontArm:getRotation())
	
-- if we've collected rock and arm is facing wrong direction

	if(self.scene.holdingObject and not(self.scene.touchingJoypad)) then
	
	self.heroScaleX = self.scene.hero.heroBody:getScaleX()
	


	--right
	

	
			if(self.heroScaleX == 1) then

				self.scene.hero.frontArm:setRotation(0)
				
				if(self.scene.theObject.type ~= "key.png") then
					self.scene.theObject:setScaleY(1)
				end


	-- left
			elseif(self.heroScaleX == -1) then
			
				self.scene.hero.frontArm:setRotation(180)
				
				if(self.scene.theObject.type ~= "key.png") then
					self.scene.theObject:setScaleY(-1)
				end
				
			end
		

		

	end


	-- Fix for arm
	if(not(self.scene.aimingClaw) and not(self.scene.firingClaw) and not(self.scene.retractingClaw)) then
		if(self.facing=="left" and self.scene.hero.frontArm:getScaleX()==1) then
			self.scene.hero.frontArm:setScaleX(-1)
		end
	end



-- end update animation

end




--------------------------------------------------------------
-- Update xScale (flip)
--------------------------------------------------------------

-- Function that does the flip

function HeroAnimation:flipLeft()

	local hero = self.scene.hero
	self.facing = "left" -- so it doesn't repeat every frame
	self.scene.hero.direction = "left"
	hero.earsSprite:setScaleX(-1)
	hero.legsSprite:setScaleX(-1)
	hero.heroBody:setScaleX(-1)
	hero.rearArm:setScaleX(-1)
	--hero.backClaw:setPosition(23,-18)

	if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
		hero.frontArm:setScaleX(-1)
		self.scene.armFacing = "left"

	end

	
	-- if hero is holding an object. we need to rotate arm too
	
	if(self.scene.holdingObject) then

		self.scene.hero.frontArm:setRotation(180)
		self.scene.facing = "left"
		self.scene.hero.direction="left"
	end

end










function HeroAnimation:flipRight()
	
	local hero = self.scene.hero
	self.facing = "right" -- so it doesn't repeat every frame
	self.scene.hero.direction="right"
	hero.earsSprite:setScaleX(1)
	hero.legsSprite:setScaleX(1)
	hero.heroBody:setScaleX(1)
	hero.rearArm:setScaleX(1)
	--hero.backClaw:setScaleX(1)
	hero.backClaw:setPosition(-23,-18)
	
	

	if(not self.scene.aimingClaw and not self.scene.firingClaw and not self.scene.retractingClaw and not self.scene.pauseClaw) then
		hero.frontArm:setScaleX(1)
		self.scene.armFacing = "right"
	end


	-- if hero is holding an object. we need to rotate arm too
	
	if(self.scene.holdingObject) then
		self.scene.hero.frontArm:setRotation(0)
		self.scene.facing = "right"
		self.scene.hero.direction="right"
	end

end



function HeroAnimation:stopBob()

	self.scene.hero.frontArmBob:setPaused(true)
	self.scene.hero.rearArmSpriteBob:setPaused(true)
	self.scene.hero.earsBob:setPaused(true)
	self.scene.hero.bodyBob:setPaused(true)

end


function HeroAnimation:startBob()

	if(not(self.scene.gameEnded)) then

		self.scene.hero.frontArmBob:setPaused(false)
		self.scene.hero.rearArmSpriteBob:setPaused(false)
		self.scene.hero.earsBob:setPaused(false)
		self.scene.hero.bodyBob:setPaused(false)
		
	end

end



function HeroAnimation:headBobStart()

	if(not(self.headBobbing)) then
	
		self.headBobbing = true
		self.scene.hero.bodyWalkBob:setPaused(false)
		self.scene.hero.earsWalkBob:setPaused(false)
		
	end

end


function HeroAnimation:headBobStop()



	if(self.headBobbing) then
	
		self.headBobbing = false
		self.scene.hero.bodyWalkBob:setPaused(true)
		self.scene.hero.earsWalkBob:setPaused(true)
		
	end

end






