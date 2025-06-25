Buttons = Core.class(Sprite)

function Buttons:init(scene,upImage,downImage)

self.scene = scene;

local button = Bitmap.new(self.scene.atlas[2]:getTextureRegion(upImage));
local buttonPressed = Bitmap.new(self.scene.atlas[2]:getTextureRegion(downImage));
self:addChild(button);


self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)

end


function Buttons:onTouchesBegin(event)

if(not self.scene.paused) then

	if(self:hitTestPoint(event.touch.x, event.touch.y)) then

--[[
		if(self.type=="upButton") then
			print("up button")
			table.insert(self.scene.upButtonTouches, event.touch.id)
			self.scene.playerMovement:moveUp()
		end
		--]]
		
		if(self.type=="leftButton") then

			table.insert(self.scene.leftButtonTouches, event.touch.id)
			self.scene.playerMovement:moveLeft()
			if(not(self.leftButtonPressed)) then
				self.leftButtonPressed = true
				self.scene.leftButtonPressed:setVisible(true)
			end
		end
		
		if(self.type=="rightButton") then
		table.insert(self.scene.rightButtonTouches, event.touch.id)
		self.scene.playerMovement:moveRight()
			if(not(self.rightButtonPressed)) then
				self.rightButtonPressed = true
				self.scene.rightButtonPressed:setVisible(true)
			end
		end

--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
--print("number of touches on upButton:", #self.scene.upButtonTouches)

	end
	
end

end

-- Touch was released on one of the buttons

function Buttons:onTouchesEnd(event)

--if(not self.scene.paused) then

	if(self.type=="upButton") then
		for i,v in pairs(self.scene.upButtonTouches) do
			if(event.touch.id == v) then
				table.remove(self.scene.upButtonTouches,i) -- remove this touch from table
			end
		end
	end
	
	if(self.type=="leftButton") then

		for i,v in pairs(self.scene.leftButtonTouches) do
			if(event.touch.id == v) then
			
				table.remove(self.scene.leftButtonTouches,i) -- remove this touch from table
			end
		end
	end
	
	if(self.type=="rightButton") then
	
		for i,v in pairs(self.scene.rightButtonTouches) do
			if(event.touch.id == v) then
				table.remove(self.scene.rightButtonTouches,i) -- remove this touch from table
			end
		end
	end
	
		-- change to up state
	
	if(#self.scene.leftButtonTouches==0) then
		if(self.leftButtonPressed) then
			self.leftButtonPressed = false
			self.scene.leftButtonPressed:setVisible(false)
		end
	end
	
	if(#self.scene.rightButtonTouches==0) then
		if(self.rightButtonPressed) then
			self.rightButtonPressed = false
			self.scene.rightButtonPressed:setVisible(false)
		end
	end
	
	
	
--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
--print("number of touches on upButton:", #self.scene.upButtonTouches)

--end

end



function Buttons:onTouchesMove(event)

if(not self.scene.paused) then

-- slid off button

	if(not self:hitTestPoint(event.touch.x, event.touch.y)) then

		if(self.type=="upButton") then
			for i,v in pairs(self.scene.upButtonTouches) do
				if(event.touch.id == v) then
					table.remove(self.scene.upButtonTouches,i) -- remove this touch from table
				end
			end
		end
		
		if(self.type=="leftButton") then
			for i,v in pairs(self.scene.leftButtonTouches) do
				if(event.touch.id == v) then
					table.remove(self.scene.leftButtonTouches,i) -- remove this touch from table
				end
			end
		end
		
		if(self.type=="rightButton") then
			for i,v in pairs(self.scene.rightButtonTouches) do
				if(event.touch.id == v) then
					table.remove(self.scene.rightButtonTouches,i) -- remove this touch from table
				end
			end
		end
		
	end
	
	-- change to up state
	
	if(#self.scene.leftButtonTouches==0) then
		if(self.leftButtonPressed) then
			self.leftButtonPressed = false
			self.scene.leftButtonPressed:setVisible(false)
		end
	end
	
	if(#self.scene.rightButtonTouches==0) then
		if(self.rightButtonPressed) then
			self.rightButtonPressed = false
			self.scene.rightButtonPressed:setVisible(false)
		end
	end
	
--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
--print("number of touches on upButton:", #self.scene.upButtonTouches)




-- A new touch moved over this button

	if(self:hitTestPoint(event.touch.x, event.touch.y) and self.type=="upButton") and #self.scene.upButtonTouches==0 then
	table.insert(self.scene.upButtonTouches, event.touch.id)
	self.scene.playerMovement:moveUp()
	end
	
	if(self:hitTestPoint(event.touch.x, event.touch.y) and self.type=="leftButton") and #self.scene.leftButtonTouches==0 then
		if(not(self.leftButtonPressed)) then
			self.leftButtonPressed = true
			self.scene.leftButtonPressed:setVisible(true)
		end
	table.insert(self.scene.leftButtonTouches, event.touch.id)
	self.scene.playerMovement:moveLeft()
	end
	
	if(self:hitTestPoint(event.touch.x, event.touch.y) and self.type=="rightButton") and #self.scene.rightButtonTouches==0 then
	
		if(not(self.rightButtonPressed)) then
			self.rightButtonPressed = true
			self.scene.rightButtonPressed:setVisible(true)
		end
	table.insert(self.scene.rightButtonTouches, event.touch.id)
	self.scene.playerMovement:moveRight()
	end

--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
--print("number of touches on upButton:", #self.scene.upButtonTouches)

end

end

