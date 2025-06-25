SpritesOffScreen = Core.class(Sprite)

function SpritesOffScreen:init(scene,maxXDist,maxYDist)

	-- work out device specifics
	
	self.scaleMode = application:getLogicalScaleX() -- will be 2 for 2x
	
	-- REMEMBER these values are for portrait, even if game is in landscape
	
	screenWidth = application:getDeviceHeight() / self.scaleMode
	screenHeight = application:getDeviceWidth() / self.scaleMode
	
	self.halfScreenWidth = screenWidth / 2
	self.halfScreenHeight = screenHeight / 2
	
	-- now work out the boundaries of the device screenHeight
	-- remember its only 0 when the device is 480 wide
	
	self.timerBuffer = 50 -- to hide timer based lag
	
	self.xBuffer = ((screenWidth - logicalW) / 2) + self.timerBuffer
	self.yBuffer = ((screenHeight - logicalH) / 2) + self.timerBuffer

	self.scene = scene
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	-- initial setup
	
	for i,v in pairs(self.scene.sprites) do

		if(not(v.myWidth)) then
		
			local x,y,width,height = v:getBounds(self.scene)
			v.myWidth = width
			v.myHeight = height
			
		end
	end
	
	Timer.delayedCall(100, self.setup, self)

end




function SpritesOffScreen:setup()

	local t = Timer.new(450,math.huge)
	t:addEventListener(Event.TIMER, self.cullOffScreenSprites, self)
	t:start()
	self.t = t

end


function SpritesOffScreen:cullOffScreenSprites()

if(not(self.scene.gameEnded)) then

	-- this is for when hero is near top of screen or far left of screen
	
	--print(self.scene.camera.offsetX)
	
	local xSideOffset = math.abs(self.halfScreenWidth - (self.scene.playerMovement.heroX+self.scene.camera.offsetX))
	local ySideOffset = self.halfScreenHeight - (self.scene.playerMovement.heroY+self.scene.camera.offsetY)

--print(xSideOffset)

	-- sprites
	
	for i,v in pairs(self.scene.sprites) do
	
		--if(self.scene.playerMovement.heroX) then
			--if(not(v.ignoreCull)) then
		
				local spriteX, spriteY = v:getPosition()
				
				local xDist = math.abs(self.scene.playerMovement.heroX - spriteX)
				local yDist = math.abs(self.scene.playerMovement.heroY - spriteY)
				
				if(not(v.myWidth)) then
				
					local x,y,width,height = v:getBounds(self.scene)
					v.myWidth = width
					v.myHeight = height
					
				end

				if(xDist > (v.myWidth/2)+self.halfScreenWidth+self.xBuffer+xSideOffset or yDist > (v.myHeight/2)+self.halfScreenHeight+self.yBuffer+ySideOffset) then
					
					v:setVisible(false)

					
					-- if there's tweens, pause / unpause
					
					--[[if(v.tweens) then
						for ti,tv in pairs(v.tweens) do
							tv:setPaused(true)
						end
					end
						--]]
				else
				

					v:setVisible(true)

					
					--[[if(v.tweens) then
						for ti,tv in pairs(v.tweens) do
							tv:setPaused(false)
						end
					end
--]]
				end
		--	end
		--end
		
	
	end
	
	
	
	-- now do the same for door particle emitters
	
	for i,v in pairs(self.scene.particleEmitters) do

		if(v.isDoor) then

			local spriteX, spriteY = v.parent:getPosition()
			
			--print(spriteX)
			
			--print(self.scene.playerMovement.heroX)
			if(self.scene.playerMovement.heroX) then
			
				local xDist = math.abs(self.scene.playerMovement.heroX - spriteX)
				local yDist = math.abs(self.scene.playerMovement.heroY - spriteY)
				

				if(self.scene.levelNumber==11) then
					self.minPartX = 200
					self.minPartY = 200
				else
					self.minPartX = 500
					self.minPartY = 400
				end

				
				if(xDist > self.minPartX or yDist > self.minPartY) then

					v:stop()
				else

					if(v.running) then

						v:start()
						
					end
					
				end
			
			end

		end

	end
	
	end
	
end




function SpritesOffScreen:pause()
	
end



function SpritesOffScreen:resume()

end



function SpritesOffScreen:exit()

	self.t:stop()
		
end