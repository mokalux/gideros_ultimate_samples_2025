--[[
	
	
	
	
	
	

	
	
	

--------------------------------------------------------------
-- Hero touches door
--------------------------------------------------------------

if(self.scene.doorOpen) then

	self.scene.doorX, self.scene.doorY = self.scene.door.doorAnim:localToGlobal(0,0)
	
	self.scene.heroX, self.scene.heroY = self.scene.hero:localToGlobal(0,0)

	if(self.circleCollision(self.scene.heroX, self.scene.heroY, 20, self.scene.doorX, self.scene.doorY, 30)) then
		
		self.scene.door:heroHitDoor()

	end

end


-- hero not touching door

if(self.scene.heroTouchingDoor) then
	if(not(self.circleCollision(self.scene.heroX, self.scene.heroY, 20, self.scene.doorX, self.scene.doorY, 30))) then
		
		self.scene.door:heroMovedOffDoor()

	end
end




--------------------------------------------------------------
-- Hero holding key, hits door
--------------------------------------------------------------

if(self.scene.holdingObject and self.scene.theObject.type == "key.png" and not(self.scene.retractingClaw) and not(self.scene.theObject.used)) then

	local doorX, doorY = self.scene.doors[self.scene.theObject.id]:localToGlobal(0,0)
	--doorX = doorX - 20
	local keyX, keyY = self.scene.theObject:localToGlobal(0,0)

	local xDiff = doorX - keyX
	local yDiff = doorY - keyY

	local distance = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))

	if(distance < 45) then

		self.scene.theObject.used = true
		
		-- remove key
		
		self.scene.theObject.body.destroyed = true
		self.scene.theObject:getParent():removeChild(self.scene.theObject)
		self.scene.holdingObject = false
		self.scene.heroAnimation:updateAnimation()
		self.scene.aimingClaw = false
		
		print("door open")
		
	end
--]]





