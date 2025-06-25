ColorPicker = Core.class(Sprite)

function ColorPicker:init()
	self.colors = {
		0xFFFFFF, 0x99CCFF, 0xCCFFFF, 0xFFFF99, 0xFFCC99, 0xFF99CC,
		0xC0C0C0, 0x993366, 0x00CCFF, 0x00FFFF, 0x00FF00, 0xFFFF00,
		0xFFCC00, 0xFF00FF, 0x999999, 0x800080, 0x3366FF, 0x33CCCC,
		0x339966, 0x99CC00, 0xFF9900, 0xFF0000, 0x808080, 0x666699,
		0x0000FF, 0x008080, 0x008000, 0x808000, 0xFF6600, 0x800000,
		0x333333, 0x333399, 0x000080, 0x333300, 0x993300, 0x000000
	}
	self.currColor = self.colors[1] --current color
	self.colW = 31 --column width
	self.colH = 22 --column height
	self.ind = 2 --indent size
	self.m = 6 -- collumn count
	local ip, fp = math.modf(#self.colors/self.m)
	self.n = ip
	if fp > 0 then
		self.n = self.n + 1
	end
	self:drawButton(self.currColor)
	self:drawPallete()
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
end

function ColorPicker:drawRec(x, y, w, h, bw, bc, ba, fc, fa)
	local shape = Shape.new()
	shape:setLineStyle(bw, bc, ba)
	shape:setFillStyle(Shape.SOLID, fc, fa)
	shape:beginPath()
	shape:moveTo(x, y)
	shape:lineTo(x + w, y)
	shape:lineTo(x + w, y + h)
	shape:lineTo(x, y + h)
	shape:closePath()
	shape:endPath()
	return shape
end

function ColorPicker:drawButton(color)
	self.btn = self:drawRec(0, 0, self.colW, self.colH, 1, 0x000000, 1, color, 1)
	self:addChild(self.btn)
end

function ColorPicker:drawPallete()
	self.pallete = self:drawRec(0, self.colH + self.ind,
		self.m*self.colW + self.ind*(self.m + 1), self.n*self.colH + self.ind*(self.n + 1), 
		1, 0x000000, 1, 0xDDDDDD, 1)
	self.pallete.colors = {}
	self:addChild(self.pallete)
	self.pallete:setVisible(false)
	local x, y = 0, self.colH + self.ind
	for i = 1, self.n do
		y = y + self.ind
		for j = 1, self.m do
			if (i - 1)*self.m + j > #self.colors then
				return
			end
			x = x + self.ind
			local ci = (i - 1)*self.m + j
			self.pallete.colors[ci] = self:drawRec(x, y, self.colW, self.colH, 1, 0x000000, 1, self.colors[ci], 1)
			self.pallete:addChild(self.pallete.colors[ci])
			x = x + self.colW
		end
		x = 0
		y = y + self.colH
	end
end

function ColorPicker:onMouseDown(e)
	if self.btn:hitTestPoint(e.x, e.y) then
		self.pallete:setVisible(not self.pallete:isVisible())
		return
	end
	if self.pallete:isVisible() then
		for i = 1, #self.pallete.colors do
			local color = self.pallete.colors[i]
			if color:hitTestPoint(e.x, e.y) then
				self.currColor = self.colors[i]
				self:drawButton(self.currColor)
				self.pallete:setVisible(false)
				self:changeColor()
				return
			end
		end
	end
end

function ColorPicker:changeColor()
	self.e = Event.new("COLOR_CHANGED")
	self.e.color = self.currColor
	self:dispatchEvent(self.e)
end
