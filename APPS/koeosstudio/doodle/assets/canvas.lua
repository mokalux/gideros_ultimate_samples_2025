Canvas = Core.class(Sprite)

function Canvas:init(w, h)
	self.w, self.h	= w, h
	self.precision	= 64 -- 50
	self.data 		= {}
	self.path 		= {}
	self.dataIndex 	= 0
	self.color 		= 0xffffff
	self.penColor 	= 0x000000
	self.penSize 	= 20
	self.active 	= true
	
	self.paper = Pixel.new(self.color, 1, w, h)
	self:addChild(self.paper)
	
	self.pen = Shape.new()
	self:addChild(self.pen)
	
	-- Pen event
	local function onMouseDown(event)		
		if self.paper:hitTestPoint(event.x, event.y) and self.active then
			-- Check data
			if #self.data ~= self.dataIndex then
				for i = self.dataIndex + 1, #self.data do
					self.data[i] = nil
				end
			end
			
			-- self.path index 1, 2 are line settings
			self.path = {}
			self.path[1] = self.penSize
			self.path[2] = self.penColor
			
			-- Draw the first point
			self.pen:setLineStyle(self.penSize, self.penColor, 1)
			self.pen:beginPath()
			self.pen:moveTo(event.x, event.y)
			self.pen:lineTo(event.x, event.y)
			self.pen:endPath()
			table.insert(self.path, {event.x, event.y})	
			
			event:stopPropagation()
		end
	end

	local function onMouseMove(event)
		if self.paper:hitTestPoint(event.x, event.y) and self.active then
			table.insert(self.path, {event.x, event.y})
			self:fixLine(self.path, #self.path-1, #self.path)
			
			event:stopPropagation()
		end		
	end

	local function onMouseUp(event)
		if self.paper:hitTestPoint(event.x, event.y) and #self.path > 0 and self.active then
			if #self.path > 2 then
				table.insert(self.data, self.path)
				self.dataIndex = #self.data
				
				event:stopPropagation()
			end
		end
	end
	
	self:addEventListener(Event.MOUSE_DOWN, onMouseDown)
	self:addEventListener(Event.MOUSE_MOVE, onMouseMove)
	self:addEventListener(Event.MOUSE_UP, onMouseUp)
end


-- ===========================================================================
function Canvas:setColor(color)
	self.color = color
	self.paper:setColor(color)
end

-- ===========================================================================
function Canvas:setPenColor(color)
	self.penColor = color
end


-- ===========================================================================
function Canvas:setPenSize(size)
	self.penSize = size
end


-- ===========================================================================
function Canvas:fixLine(path, j, k)
	if #path > 3 and math.distance(path[j][1], path[j][2], 0, path[k][1], path[k][2], 0) < self.precision then
		self.pen:moveTo(path[j][1], path[j][2])
		self.pen:lineTo(path[k][1], path[k][2])
	end
	
	self.pen:endPath()
end
	

-- ===========================================================================
function Canvas:redraw()
	self.pen:clear()

	if #self.data > 0 then
		for i = 1, self.dataIndex do
			local path = self.data[i]
			
			self.pen:setLineStyle(path[1], path[2], 1)
			self.pen:beginPath()
			
			for j = 4, #path do
				self.pen:lineTo(path[j][1], path[j][2])
				self:fixLine(path, j-1, j)
			end
		end
	end
end


-- ===========================================================================
function Canvas:undo()
	if self.dataIndex > 0 then 
		self.dataIndex = self.dataIndex - 1
		self:redraw()
	end
end


-- ===========================================================================
function Canvas:redo()
	if self.dataIndex < #self.data then
		self.dataIndex  = self.dataIndex + 1
		self:redraw()
	end
end


-- ===========================================================================
function Canvas:clear()
	self.pen:clear()
	self.data = {}
end

--[[ I will implement this in the future
-- ===========================================================================
function Canvas:zoomIn()
	
end


-- ===========================================================================
function Canvas:zoomOut()
	
end


-- ===========================================================================
function Canvas:pan()

end
--]]