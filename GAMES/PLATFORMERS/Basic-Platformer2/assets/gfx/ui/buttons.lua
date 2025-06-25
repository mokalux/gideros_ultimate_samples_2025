Buttons = Core.class(Sprite)

function Buttons:init(scene, upImage, downImage)
	self.scene = scene
	local button = Bitmap.new(self.scene.atlas2:getTextureRegion(upImage))
	local buttonPressed = Bitmap.new(self.scene.atlas2:getTextureRegion(downImage))
	self:addChild(button)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
end

function Buttons:onTouchesBegin(event)
	if(self:hitTestPoint(event.touch.x, event.touch.y)) then
		if(self.type=="upButton") then
			table.insert(self.scene.upButtonTouches, event.touch.id)
			self.scene.playerMovement:moveUp()
		end
		
		if(self.type=="leftButton") then
			table.insert(self.scene.leftButtonTouches, event.touch.id)
			self.scene.playerMovement:moveLeft()
		end
		
		if(self.type=="rightButton") then
			table.insert(self.scene.rightButtonTouches, event.touch.id)
			self.scene.playerMovement:moveRight()
		end

		--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
		--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
		--print("number of touches on upButton:", #self.scene.upButtonTouches)
	end
end

-- Touch was released on one of the buttons
function Buttons:onTouchesEnd(event)
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
	
	--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
	--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
	--print("number of touches on upButton:", #self.scene.upButtonTouches)
end

function Buttons:onTouchesMove(event)
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
	
	--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
	--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
	--print("number of touches on upButton:", #self.scene.upButtonTouches)

	-- A new touch moved over this button
	if(self:hitTestPoint(event.touch.x, event.touch.y) and self.type=="upButton") and #self.scene.upButtonTouches==0 then
		table.insert(self.scene.upButtonTouches, event.touch.id)
		self.scene.playerMovement:moveUp()
	end
	
	if(self:hitTestPoint(event.touch.x, event.touch.y) and self.type=="leftButton") and #self.scene.leftButtonTouches==0 then
		table.insert(self.scene.leftButtonTouches, event.touch.id)
		self.scene.playerMovement:moveLeft()
	end
	
	if(self:hitTestPoint(event.touch.x, event.touch.y) and self.type=="rightButton") and #self.scene.rightButtonTouches==0 then
		table.insert(self.scene.rightButtonTouches, event.touch.id)
		self.scene.playerMovement:moveRight()
	end

	--print("number of touches on leftButton:", #self.scene.leftButtonTouches)
	--print("number of touches on rightButton:", #self.scene.rightButtonTouches)
	--print("number of touches on upButton:", #self.scene.upButtonTouches)
end
