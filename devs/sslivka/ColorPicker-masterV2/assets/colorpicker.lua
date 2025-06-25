ColorPicker = Core.class(Sprite)


-----------------------------------------------
-- HSL to RGB 
---------------------------------------

local function hue_to_rgb(p, q, t)
	if(t < 0) then t = t + 1 end
	if(t > 1) then t = t - 1 end
	if(t < 1/6) then return p + (q - p) * 6 * t end
	if(t < 1/2) then return q end
	if(t < 2/3) then return p + (q - p) * (2/3 - t) * 6 end
	return p
end

--h [0,360], s[0(1?),100], l[0,100]
function hsl_to_rgb(h, s, l)
	h = h/360
	s = s/100
	l = l/100
	local r, g, b
	if(s == 0) then
		--achromatic
		r = 1
		g = 1
		b = l
	else
		local q
		if l < 0.5 then
			q = l * (1 + s)
		else
			q = l + s - l * s
		end
		local p = 2 * l - q
		r = hue_to_rgb(p, q, h + 1/3)
		g = hue_to_rgb(p, q, h)
		b = hue_to_rgb(p, q, h - 1/3)
	end
	return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

-----------------------------------------------
-- rgb to hex & back
---------------------------------------

local function rgbToHex(r,g,b)
local hex=r*256*256+g*256+b
return hex
end


function hexToRgb(hex)
local blue=hex%256
local green=(hex-blue)/256 %256
local red=(hex-blue-256*green)/256^2
return red,green,blue
end 

--generate a table of colors, with s = saturation
local function generatecolors(s)
	local h 
	local l = 0 
	if not s then s = 100  end --saturation default
	local colors = {}
	local ccounter = 0 
	for h = 0, 360, 10 do	--for each hue value+10 to 360	
			for l =100,0, -10 do
				ccounter = ccounter+1
				local r,g,b = hsl_to_rgb(h,s,l)
				hexcol = rgbToHex(r,g,b)
				colors[ccounter]= hexcol 
			end
	end
	return colors
end

function ColorPicker:init()
	

	self.saturation = 100 --default value	
	self.colors = generatecolors(self.saturation)
	
	self.currColor = self.colors[1] --current color
	self.colW = 26 --column width
	self.colH = 15 --column height
	self.ind = 0 --indent size
	self.m = 11 -- collumn count
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
if self.pallete then self.pallete:removeFromParent() self.pallete=nil end
if self.saturationSlider then 
	self.saturationSlider:removeEventListener("update", self.updateSValue, self)
	self.saturationSlider:removeFromParent() self.saturationSlider=nil 
end

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
	
	--add slider
		local yp = self.n*self.colH+50

		local slit = self:drawRec(0, 0, self.colW*self.m, 2, 2, 0x000000, 1, 0x000000, 1)
		local knob = self:drawRec(-10, -16, 20, 32, 5, 0x000000, 0.8, 0x000000, 0)

		self.saturationSlider = Slider.new( slit, knob, true, 2, 100 )

		self.saturationSlider:setPosition( 10, yp )
		self.saturationSlider:setVisible(false)
		self:addChild( self.saturationSlider )

		self.saturationSlider:setValue( self.saturation )


		
		self.saturationSlider:addEventListener("update", self.updateSValue, self)
end

function ColorPicker:updateSValue()
	self.saturation = self.saturationSlider:getValue() --/ 100		-- in range of [0, 1]
	self.colors = generatecolors(self.saturation)
	self:drawPallete()
	self.pallete:setVisible(true)
	self.saturationSlider:setVisible(true)
	
end

function ColorPicker:onMouseDown(e)
	if self.btn:hitTestPoint(e.x, e.y) then
		self.pallete:setVisible(not self.pallete:isVisible())
		self.saturationSlider:setVisible(not self.saturationSlider:isVisible())
		return
	end
	if self.pallete:isVisible() then
		for i = 1, #self.pallete.colors do
			local color = self.pallete.colors[i]
			if color:hitTestPoint(e.x, e.y) then
				self.currColor = self.colors[i]
				self:drawButton(self.currColor)
				self.pallete:setVisible(false)
				self.saturationSlider:setVisible(false)
				self:changeColor()
				return
			end
		end
	end
end

function ColorPicker:changeColor()
	self.e = Event.new("COLOR_CHANGED")
	self.e.color = self.currColor
	self.e.rgbColor = {hexToRgb(self.currColor)}
	self:dispatchEvent(self.e)
end

