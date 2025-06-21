--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--

--!NEEDS:classes/ScrollView.lua

achievementsScene = Core.class(ScrollView)

function achievementsScene:init()
	--back button
	local back = TextField.new(nil, "Back", true)
	back:setScale(2)
	local button = Button.new(back, back)
	button:addEventListener("click", function()
		ach:complete("allbuttons", "back")
		sceneManager:changeScene("startScene", 1, SceneManager.fade, nil)
	end)
	button:setPosition((application:getContentWidth() - (back:getWidth()+100)), 50)
	self:addChild(button)

	local title = TextField.new(nil, "Achievements", true)
	title:setScale(3)
	title:setPosition(20, 40)
	self.layer:addChild(title)
	local add = title:getY()

	local achs = ach:getAll()
	
	local layer = self.layer
	
	for i, a in pairs(achs) do
		if a.completed == 1 then
			local sprite = Sprite.new()
			layer.next = sprite
			
			local b = Shape.new()
			local width, height = 500, 50
			b:setFillStyle(Shape.SOLID, 0x000000, 0.6)
			b:setLineStyle(2, 0x8b9d9b)
			b:beginPath()
			b:moveTo(0,0)
			b:lineTo(width, 0)
			b:lineTo(width, height)
			b:lineTo(0, height)
			b:lineTo(0, 0)
			b:endPath()
			sprite:addChild(b)
			
			local title = TextField.new(nil, a.name)
			title:setScale(2)
			title:setTextColor(0x00486e)
			title:setPosition(20, 30)
			b:addChild(title)
			
			local title = TextField.new(nil, "Completed!")
			title:setScale(2)
			title:setTextColor(0xff6d02)
			title:setPosition(b:getWidth()-(title:getWidth() + 20), 30)
			b:addChild(title)
			
			b.objective = a.objective
			b.opened = false
			
			function b:open()
				self.opened = true
				local child = self:getParent().next
				if child then
					GTween.new(child, 0.1, {y = child:getY() + self.sheight}, {dispatchEvents = true})
				end
				self.tween = GTween.new(self.shape, 0.1, {scaleY = 1}, {dispatchEvents = true})
				self.tween:addEventListener("complete", function()
					self.tween = nil
				end)
			end
			
			function b:close()
				self.opened = false
				local child = self:getParent().next
				if child then
					GTween.new(child, 0.1, {y = child:getY() - self.sheight}, {dispatchEvents = true})
				end
				self.tween = GTween.new(self.shape, 0.1, {scaleY = 0}, {dispatchEvents = true})
				self.tween:addEventListener("complete", function()
					self.tween = nil
				end)
			end
			
			b.scene = self
			
			b:addEventListener(Event.MOUSE_DOWN, function(self, e)
				self.startY = e.y
			end, b)
			
			b:addEventListener(Event.MOUSE_UP, function(self, e) 
				if self:hitTestPoint(e.x, e.y) and not self.tween then
					if math.abs(e.y - self.startY) < 50 then
						if not self.opened then
							if not self.shape then
								local text = TextWrap.new(a.objective, self:getWidth()-60, "left", 2, nil)
								text:setScale(2)
								text:setTextColor(0x010d35)
								text:setPosition(20,40)
								local shape = Shape.new()
								shape:setFillStyle(Shape.SOLID, 0xffffff, 0.7)
								shape:beginPath()
								shape:moveTo(0,0)
								shape:lineTo(self:getWidth()+125, 0)
								shape:lineTo(self:getWidth()+125, text:getHeight() + 50)
								shape:lineTo(0, text:getHeight() + 50)
								shape:lineTo(0, 0)
								shape:endPath()
								shape:addChild(text)
								shape:setPosition(10, self:getHeight())
								self.sheight = shape:getHeight()
								shape:setScaleY(0)
								self:addChildAt(shape, 1)
								self.shape = shape
							end
							self:open()
						else
							self:close()
						end
					end
				end
			end, b)
			
			layer:addChildAt(sprite, 1)
			sprite:setPosition(0, b:getHeight())
			layer = sprite
		end
	end

	for i, a in pairs(achs) do
		if a.completed == 0 then
			local sprite = Sprite.new()
			layer.next = sprite
			
			local b = Shape.new()
			local width, height = 500, 50
			b:setFillStyle(Shape.SOLID, 0x000000, 0.6)
			b:setLineStyle(2, 0x8b9d9b)
			b:beginPath()
			b:moveTo(0,0)
			b:lineTo(width, 0)
			b:lineTo(width, height)
			b:lineTo(0, height)
			b:lineTo(0, 0)
			b:endPath()
			sprite:addChild(b)
			
			local title = TextField.new(nil, a.name)
			title:setScale(2)
			title:setTextColor(0x00486e)
			title:setPosition(20, 30)
			b:addChild(title)
			
			local title = TextField.new(nil, "Progress: "..a.count.."/"..a.total)
			title:setScale(2)
			title:setTextColor(0x005888)
			title:setPosition(b:getWidth()-(title:getWidth() + 20), 30)
			b:addChild(title)
			b.objective = a.objective
			b.opened = false
			
			function b:open()
				self.opened = true
				local child = self:getParent().next
				if child then
					GTween.new(child, 0.1, {y = child:getY() + self.sheight}, {dispatchEvents = true})
				end
				self.tween = GTween.new(self.shape, 0.1, {scaleY = 1}, {dispatchEvents = true})
				self.tween:addEventListener("complete", function()
					self.tween = nil
				end)
			end
			
			function b:close()
				self.opened = false
				local child = self:getParent().next
				if child then
					GTween.new(child, 0.1, {y = child:getY() - self.sheight}, {dispatchEvents = true})
				end
				self.tween = GTween.new(self.shape, 0.1, {scaleY = 0}, {dispatchEvents = true})
				self.tween:addEventListener("complete", function()
					self.tween = nil
				end)
			end
			
			b.scene = self
			
			b:addEventListener(Event.MOUSE_DOWN, function(self, e)
				self.startY = e.y
			end, b)
			
			b:addEventListener(Event.MOUSE_UP, function(self, e) 
				if self:hitTestPoint(e.x, e.y) and not self.tween then
					if math.abs(e.y - self.startY) < 50 then
						if not self.opened then
							if not self.shape then
								local text = TextWrap.new(a.objective, self:getWidth()-60, "left", 2, nil)
								text:setScale(2)
								text:setTextColor(0x010d35)
								text:setPosition(20,40)
								local shape = Shape.new()
								shape:setFillStyle(Shape.SOLID, 0xffffff, 0.7)
								shape:beginPath()
								shape:moveTo(0,0)
								shape:lineTo(self:getWidth()+125, 0)
								shape:lineTo(self:getWidth()+125, text:getHeight() + 50)
								shape:lineTo(0, text:getHeight() + 50)
								shape:lineTo(0, 0)
								shape:endPath()
								shape:addChild(text)
								shape:setPosition(10, self:getHeight())
								self.sheight = shape:getHeight()
								shape:setScaleY(0)
								self:addChildAt(shape, 1)
								self.shape = shape
							end
							self:open()
						else
							self:close()
						end
					end
				end
			end, b)
			
			layer:addChildAt(sprite, 1)
			sprite:setPosition(0, b:getHeight())
			layer = sprite
		end
	end
end
