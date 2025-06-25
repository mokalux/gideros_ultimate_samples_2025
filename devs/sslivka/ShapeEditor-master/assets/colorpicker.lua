ColorPicker = Core.class(Sprite)

function ColorPicker:init()
	self.colors = {0xBFBBA7, 0x8FBFB8, 0x97BF95, 0xBFA3BF, 0xD69D9C, 0xC9C287}
	self.currColor = self.colors[1] --current color
	self.colW = 31 --column width
	self.colH = 22 --column height
	self.ind = 2 --indent size
	self.m = 1 -- collumn count
	local ip, fp = math.modf(#self.colors/self.m)
	self.n = ip
	if fp > 0 then
		self.n = self.n + 1
	end
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
end

function ColorPicker:drawRec(x, y, w, h, bw, bc, ba, fs, fc, fa)
	local shape = Shape.new()
	shape:setLineStyle(bw, bc, ba)
	shape:setFillStyle(fs, fc, fa)
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
	self.btn = self:drawRec(0, 4, self.colW, 26, 1, 0x000000, 1, Shape.SOLID, color, 1)
	self:addChild(self.btn)
	self.btnIcon = Bitmap.new(Texture.new("hue.png", true))
	self.btnIcon:setPosition(0, 0)
	self:addChild(self.btnIcon)
end

function ColorPicker:drawPallete()
	self.pallete = self:drawRec(0, self.colH + self.ind + 7,
		self.m*self.colW + self.ind*(self.m + 1), self.n*self.colH + self.ind*(self.n + 1), 
		0, 0x000000, 1, Shape.NONE, 0xDDDDDD, 1)
	self.pallete.colors = {}
	self:addChild(self.pallete)
	self.pallete:setVisible(false)
	local x, y = 0, self.colH + self.ind + 7
	for i = 1, self.n do
		y = y + self.ind
		for j = 1, self.m do
			if (i - 1)*self.m + j > #self.colors then
				return
			end
			local ci = (i - 1)*self.m + j
			self.pallete.colors[ci] = self:drawRec(x, y, self.colW, self.colH, 1, 0x000000, 1, Shape.SOLID, self.colors[ci], 1)
			self.pallete:addChild(self.pallete.colors[ci])
			x = x + self.colW
			x = x + self.ind
		end
		x = 0
		y = y + self.colH
	end
end

function ColorPicker:onAddedToStage(e)
	self:removeEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:drawButton(self.currColor)
	self:drawPallete()
	self:changeColor()
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
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
				e:stopPropagation()
				return
			end
		end
		self.pallete:setVisible(false)
		e:stopPropagation()
	end
end

function ColorPicker:changeColor()
	self.e = Event.new("COLOR_CHANGED")
	self.e.color = self.currColor
	self:dispatchEvent(self.e)
end
