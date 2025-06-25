grid = Core.class(Sprite)

function grid:init(w)
local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0xaaaaaa , 0.8)
	shape:setLineStyle(0)
shape:beginPath()
shape:moveTo(0,0)
shape:lineTo(0, w)
shape:lineTo(w, w)
shape:lineTo(w, 0)
shape:closePath()
shape:endPath()
	
self:addChild(shape)
end