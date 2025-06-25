VolumeByDistance = Core.class(Sprite)


function VolumeByDistance:init(scene)

	self.scene = scene
	self.hearingRange = 400

	local t = Timer.new(20,math.huge)
	t:addEventListener(Event.TIMER, self.updateVolume, self)
	t:start()
	self.timer = t

	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
end





function VolumeByDistance:updateVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do

		if(self.scene.playerMovement.heroX and not(self.scene.gameEnded)) then
		

		
	-- if it has a body
	
			if(v.body) then
				
				if(not(v.body.destroyed)) then
					local spriteX, spriteY = v.body:getPosition()
					local xDiff = math.abs(self.scene.playerMovement.heroX - spriteX)
					local yDiff = math.abs(self.scene.playerMovement.heroY - spriteY)
					v.volDist = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))
				end

			else
			
				local spriteX, spriteY = v:getPosition()
				local xDiff = math.abs(self.scene.playerMovement.heroX - spriteX)
				local yDiff = math.abs(self.scene.playerMovement.heroY - spriteY)
				v.volDist = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))

			end
			
			if(v.test) then
				--print(v.volDist)
			end
			
			-- Work out percentace close to the sprite
			
			if(v.volDist) then
			
				local perc = 100-((v.volDist / self.hearingRange) * 100)
				
				v.volume = (v.maxVolume/100)*perc
				
							if(v.test) then
				--print(v.volume)
			end
				
				if(v.volume < 0) then
					v.volume = 0
				end
			
			end

			if(v.channel1) then
				v.channel1:setVolume(v.volume*self.scene.soundVol)
			end
			
			if(v.channel2) then
				v.channel2:setVolume(v.volume*self.scene.soundVol)
			end
			
		end


	end
	

	
end






function VolumeByDistance:kill()

	self.timer:stop()

	--tomtom
		
	if(self.scene.spritesWithVolume) then
		for i,v in pairs(self.scene.spritesWithVolume) do
		
			if(v.channel1) then
				v.channel1:setVolume(0)
				v.channel1 = nil
			end
				
			if(v.channel2) then
				v.channel2:setVolume(0)
				v.channel2 = nil
			end
			
			end
		end
	

end





function VolumeByDistance:pause()
	
end



function VolumeByDistance:resume()

end



function VolumeByDistance:exit()

	self:kill()

end