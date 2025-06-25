Scrolling = Core.class(Sprite);

function Scrolling:init(scene)

-- Variables

self.scene = scene;


self.mapLeftEdge = 0;
self.mapRightEdge = 0;

--self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end


--[[
-- Enterframe loop

function Scrolling:onEnterFrame()

local xSpeed = self.scene.hero.xSpeed; -- get speed from hero

	if(self.scene.hero.direction == "left") then -- if player is moving left
	
		print("left")

		if(self.scene.hero:getX() < 240 + (self.scene.hero:getWidth()/2)) then -- if hero is past half of screen
		
			self.mapLeftEdge = self.scene.tilemap:getX() - (self.scene.tilemap:getWidth()/2)
		
			if(self.mapLeftEdge < 0) then
			self.scene.hero.canMove = false;

				self.scene.tilemap:setX(self.scene.tilemap:getX() + xSpeed)
				print(xSpeed)

			else
				if(self.scene.hero:getX() > 37) then
					self.scene.hero.canMove = true
				else
				self.scene.hero.direction = "stopped";
				end
			end
		else
		--self.scene.hero:setX(self.scene.hero:getX() - xSpeed)
		end

	end
	
	if(self.scene.hero.direction == "right") then
	
	--print("right")

		if(self.scene.hero:getX() > (240 - (self.scene.hero:getWidth() / 2))) then
			self.scene.hero.canMove = false;
			self.mapRightEdge = self.scene.tilemap:getX() + (self.scene.tilemap:getWidth()/2) -1
	
			if(self.mapRightEdge > application:getContentWidth()) then
				self.scene.tilemap:setX(self.scene.tilemap:getX() - xSpeed)
				--print(self.scene.tilemap:getX())
			else
				if(self.scene.hero:getX() < 240) then
					self.scene.hero.canMove = true
				else
				self.scene.hero.direction = "stopped";
				end
			end
		else
		--self.scene.hero:setX(self.scene.hero:getX() + xSpeed)
		end

	end
	
end


--]]










