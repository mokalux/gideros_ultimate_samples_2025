shapeEditor = Sprite.new()

function shapeEditor:inTriangle(p, v1, v2, v3)
	local a = (v1.x - p.x) * (v2.y - v1.y) - (v2.x - v1.x) * (v1.y - p.y)
	local b = (v2.x - p.x) * (v3.y - v2.y) - (v3.x - v2.x) * (v2.y - p.y)
	local c = (v3.x - p.x) * (v1.y - v3.y) - (v1.x - v3.x) * (v3.y - p.y)
	return (a >= 0 and b >= 0 and c >= 0) or (a <= 0 and b <= 0 and c <= 0)
end

function shapeEditor:inPolygon(p, v)
	local c = 0
	local x0 = v[#v].x - p.x
	local y0 = v[#v].y - p.y
	for i = 1, #v do
		local x1 = v[i].x - p.x
		local y1 = v[i].y - p.y
		if (y0 > 0 and y1 <= 0 and x1 * y0 > y1 * x0) or (y1 > 0 and y0 <= 0 and x0 * y1 > y0 * x1) then
			c = c + 1
		end
		x0 = x1
		y0 = y1
	end
	return (c % 2) == 1
end

function shapeEditor:ckw(v)
	local sum = 0
	for i = 2, #v do
		sum = sum + (v[i].x - v[i - 1].x) * (v[i].y + v[i - 1].y)
	end
	sum = sum + (v[1].x - v[#v].x) * (v[1].y + v[#v].y)
	if sum > 0 then
		for i = 1, #v / 2 do
			v[i], v[#v + 1 - i] =  v[#v + 1 - i], v[i]
		end
	end
	return v
end

function table.copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

function shapeEditor:run()
	if self.canvas.vertices:getNumChildren() < 3 then return end
	local v = {}
	for i = 1, self.canvas.vertices:getNumChildren() do
		v[#v + 1] = {x = self.canvas.vertices:getChildAt(i):getX(), y = self.canvas.vertices:getChildAt(i):getY()}
	end
	local vCopy = table.copy(v)
	local t = {}
	self.canvas.trianglesContour:clear()
	self.canvas.trianglesContour:setLineStyle(1, 0x2F2F2F, 1)
	self.canvas.trianglesContour:beginPath()
	local v1, v2, v3 = 1, 2, 3
	while #vCopy > 3 do
		local success = true
		for i = 1, #vCopy do
			if i ~= v1 and i ~= v2 and i ~= v3 then
				if self:inTriangle(vCopy[i], vCopy[v1], vCopy[v2], vCopy[v3]) then
					success = false
					do break end
				end
			end
		end
		if not self:inPolygon({x = (vCopy[v1].x + vCopy[v2].x + vCopy[v3].x) / 3, 
			y = (vCopy[v1].y + vCopy[v2].y + vCopy[v3].y) / 3}, vCopy) then
			success = false
		end
		if success then
			self.canvas.trianglesContour:moveTo(vCopy[v1].x, vCopy[v1].y)
			self.canvas.trianglesContour:lineTo(vCopy[v3].x, vCopy[v3].y)
			t[#t + 1] = self:ckw({vCopy[v1], vCopy[v2], vCopy[v3]})
			table.remove(vCopy, v2)
		end
		v1 = v1 + 1
		if v1 > #vCopy then v1 = 1 end
		v2 = v1 + 1
		if v2 > #vCopy then v2 = 1 end
		v3 = v2 + 1
		if v3 > #vCopy then v3 = 1 end
	end
	self.canvas.trianglesContour:endPath()
	print("-----------------------------------------------------")
	t[#t + 1] = self:ckw(vCopy)
	print("-- polygon:")
	for i = 1, #v do
		print(string.format(pattern1 or "{x = %.5f, y = %.5f},", 
			v[i].x/self.canvas.img:getWidth() - (apx or 0),
			v[i].y/self.canvas.img:getHeight() - (apy or 0)))
	end
	print("-- triangles:")
	for i = 1, #t do
		print(string.format(pattern2 or "{{x = %.5f, y = %.5f}, {x = %.5f, y = %.5f}, {x = %.5f, y = %.5f},},", 
			t[i][1].x/self.canvas.img:getWidth() - (apx or 0),
			t[i][1].y/self.canvas.img:getHeight() - (apy or 0),
			t[i][2].x/self.canvas.img:getWidth() - (apx or 0),
			t[i][2].y/self.canvas.img:getHeight() - (apy or 0),
			t[i][3].x/self.canvas.img:getWidth() - (apx or 0),
			t[i][3].y/self.canvas.img:getHeight() - (apy or 0)))
	end
end

function shapeEditor.openImage(path)
	shapeEditor.canvas.img:setTexture(Texture.new(path, true))
	shapeEditor.canvas:setPosition(application:getDeviceWidth()/2 - shapeEditor.canvas:getWidth()/2, 75)
	shapeEditor.canvas.ap:setPosition((apx or 0)*shapeEditor.canvas.img:getWidth(),
		(apy or 0)*shapeEditor.canvas.img:getHeight())
	while shapeEditor.canvas.vertices:getNumChildren() > 0 do
		shapeEditor.canvas.vertices:getChildAt(1):removeFromParent()
	end
	shapeEditor.canvas.polygonContour:draw()
	shapeEditor.canvas.trianglesContour:clear()
end

shapeEditor.toolBar = Sprite.new()
function shapeEditor.toolBar:init()
	self.btnOpen = Bitmap.new(Texture.new("open.png", true))
	self.btnOpen:setPosition(0, 0)
	self.btnOpen:addEventListener(Event.MOUSE_DOWN, function(self, e)
		if self:hitTestPoint(e.x, e.y) then
			local textInputDialog = TextInputDialog.new("Open file", "File name:", shapeEditor.canvas.img.path or "c:\\imgs\\star.png", "Cancel", "OK")
			textInputDialog:addEventListener(Event.COMPLETE, function(self, e)
				if e.buttonText == "OK" then
					local ok, ret = pcall(shapeEditor.openImage, string.gsub(e.text, "\\", "\\\\"))
					if ok then
						shapeEditor.canvas.img.path = e.text
					else
						local alertDialog = AlertDialog.new("Error", e.text .. " - file not found", "OK")
						alertDialog:show()
					end
				end
			end, textInputDialog)
			textInputDialog:show()
		end
	end, self.btnOpen)
	self:addChild(self.btnOpen)
	self.colorPicker = ColorPicker.new()
	self:addChild(self.colorPicker)
	self.colorPicker:setPosition(50, 0)
	self.colorPicker:addEventListener("COLOR_CHANGED", function(self)
		application:setBackgroundColor(self.e.color)
	end, self.colorPicker)
	self.btnZoomIn = Bitmap.new(Texture.new("zoomin.png", true))
	self.btnZoomIn:setPosition(100, 0)
	self.btnZoomIn:addEventListener(Event.MOUSE_DOWN, function(self, e)
		if self:hitTestPoint(e.x, e.y) then
			shapeEditor.canvas:setScale(shapeEditor.canvas:getScale() + 0.1)
			shapeEditor.canvas:setPosition(application:getDeviceWidth()/2 - shapeEditor.canvas:getWidth()/2, 75)
		end
	end, self.btnZoomIn)
	self:addChild(self.btnZoomIn)
	self.btnZoomOut = Bitmap.new(Texture.new("zoomout.png", true))
	self.btnZoomOut:setPosition(150, 0)
	self.btnZoomOut:addEventListener(Event.MOUSE_DOWN, function(self, e)
		if self:hitTestPoint(e.x, e.y) and shapeEditor.canvas:getScale() > 1 then
			shapeEditor.canvas:setScale(shapeEditor.canvas:getScale() - 0.1)
			shapeEditor.canvas:setPosition(application:getDeviceWidth()/2 - shapeEditor.canvas:getWidth()/2, 75)
		end
	end, self.btnZoomOut)
	self:addChild(self.btnZoomOut)
	self.btnRun = Bitmap.new(Texture.new("run.png", true))
	self.btnRun:setPosition(200, 0)
	self.btnRun:addEventListener(Event.MOUSE_DOWN, function(self, e)
		if self:hitTestPoint(e.x, e.y) then
			shapeEditor:run()
		end
	end, self.btnRun)
	self:addChild(self.btnRun)
	self:setPosition(application:getDeviceWidth()/2 - self:getWidth()/2, 10)
end
shapeEditor.toolBar:init()

local t0 = os.time()
shapeEditor.canvas = Sprite.new()
function shapeEditor.canvas:init()
	self.img = Bitmap.new(Texture.new("star.png", true))
	self:addChild(self.img)
	self.ap = Bitmap.new(Texture.new("o.png", true))
	self.ap:setAnchorPoint(0.49, 0.49)
	self.ap:setPosition((apx or 0)*self.img:getWidth(), (apy or 0)*self.img:getHeight())
	self:addChild(self.ap)
	self.polygonContour = Shape.new()
	self:addChild(self.polygonContour)
	function self.polygonContour:draw()
		self:clear()
		if shapeEditor.canvas.vertices:getNumChildren() > 1 then
			self:setLineStyle(1, 0x2F2F2F, 1)
			self:setFillStyle(Shape.SOLID, 0x000000, 0.25)
			self:beginPath()
			self:moveTo(shapeEditor.canvas.vertices:getChildAt(1):getX(), shapeEditor.canvas.vertices:getChildAt(1):getY())
			for i = 2, shapeEditor.canvas.vertices:getNumChildren() do
				self:lineTo(shapeEditor.canvas.vertices:getChildAt(i):getX(), shapeEditor.canvas.vertices:getChildAt(i):getY())
			end
			self:closePath()
			self:endPath()
		end
	end
	self.trianglesContour = Shape.new()
	self:addChild(self.trianglesContour)
	self.vertices = Sprite.new()
	self:addChild(self.vertices)
	self.vertex1 = Texture.new("vertex1.png", true)
	self.vertex2 = Texture.new("vertex2.png", true)
	self:setPosition(application:getDeviceWidth()/2 - self:getWidth()/2, 75)
	self:addEventListener(Event.MOUSE_DOWN, function(self, e)
		local x, y = self:globalToLocal(e.x, e.y)
		for i = 1, self.vertices:getNumChildren() do
			if self.vertices:getChildAt(i):hitTestPoint(e.x, e.y) then
				if (os.time() - t0) == 0 and self.vertices:getChildAt(i).isFocus then
					self.trianglesContour:clear()
					self.vertices:removeChildAt(i)
					if self.vertices:getNumChildren() == 0 then
						return
					elseif i == 1 then
						self.vertices:getChildAt(self.vertices:getNumChildren()).isFocus = true
						self.vertices:getChildAt(self.vertices:getNumChildren()):setTexture(self.vertex2)
					else
						self.vertices:getChildAt(i - 1).isFocus = true
						self.vertices:getChildAt(i - 1):setTexture(self.vertex2)
					end
					self.polygonContour:draw()
					return
				end
				for j = 1, self.vertices:getNumChildren() do
					self.vertices:getChildAt(j).isFocus = false
					self.vertices:getChildAt(j):setTexture(self.vertex1)
				end
				self.vertices:getChildAt(i).x0 = x
				self.vertices:getChildAt(i).y0 = y
				self.vertices:getChildAt(i).isFocus = true
				self.vertices:getChildAt(i).isDragging = true
				self.vertices:getChildAt(i):setTexture(self.vertex2)
				t0 = os.time()
				return
			end
		end
		if self.img:hitTestPoint(e.x, e.y) then
			self.trianglesContour:clear()
			local pos = 1
			if self.vertices:getNumChildren() > 0 then
				for i = 1, self.vertices:getNumChildren() do
					if self.vertices:getChildAt(i).isFocus then
						self.vertices:getChildAt(i).isFocus = false
						self.vertices:getChildAt(i):setTexture(self.vertex1)
						pos = i + 1
						do break end
					end
				end
			end
			self.vertices:addChildAt(Bitmap.new(self.vertex2), pos)
			self.vertices:getChildAt(pos).x0 = x
			self.vertices:getChildAt(pos).y0 = y
			self.vertices:getChildAt(pos).isFocus = true
			self.vertices:getChildAt(pos).isDragging = true
			self.vertices:getChildAt(pos):setAnchorPoint(0.49, 0.49)
			self.vertices:getChildAt(pos):setPosition(x, y)
			self.polygonContour:draw()
			return
		end
	end, self)
	function dragging(obj, x, y)
		local dx = x - obj.x0
		local dy = y - obj.y0
		obj:setX(obj:getX() + dx)
		obj:setY(obj:getY() + dy)
		if x < shapeEditor.canvas.img:getX() then
			obj:setX(shapeEditor.canvas.img:getX())
		end
		if x > (shapeEditor.canvas.img:getX() + shapeEditor.canvas.img:getWidth()) then
			obj:setX(shapeEditor.canvas.img:getX() + shapeEditor.canvas.img:getWidth())
		end
		if y < shapeEditor.canvas.img:getY() then
			obj:setY(shapeEditor.canvas.img:getY())
		end
		if y > (shapeEditor.canvas.img:getY() + shapeEditor.canvas.img:getHeight()) then
			obj:setY(shapeEditor.canvas.img:getY() + shapeEditor.canvas.img:getHeight())
		end
		obj.x0 = x
		obj.y0 = y
	end
	self:addEventListener(Event.MOUSE_MOVE, function(self, e)
		local x, y = self:globalToLocal(e.x, e.y)
		for i = 1, self.vertices:getNumChildren() do
			if self.vertices:getChildAt(i).isDragging then
				self.trianglesContour:clear()
				dragging(self.vertices:getChildAt(i), x, y)
				self.polygonContour:draw()
				return
			end
		end
	end, self)
	self:addEventListener(Event.MOUSE_UP, function(self, e)
		for i = 1, self.vertices:getNumChildren() do
			if self.vertices:getChildAt(i).isDragging then
				self.vertices:getChildAt(i).isDragging = false
				return
			end
		end
	end, self)
end
shapeEditor.canvas:init()

function shapeEditor:init()
	self:addChild(self.canvas)
	self:addChild(self.toolBar)
	self:setPosition(0, 0)
	stage:addChild(self)
end
shapeEditor:init()
