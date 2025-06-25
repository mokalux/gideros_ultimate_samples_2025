Item = gideros.class(Sprite)

local lw = application:getLogicalWidth()
local lh = application:getLogicalHeight()
local MinX = -application:getLogicalTranslateX() / application:getLogicalScaleX()
local MinY = -application:getLogicalTranslateY() / application:getLogicalScaleY()
local MaxX,MaxY = lw - MinX,lh - MinY;
local W, H = MaxX - MinX, MaxY - MinY;
local CenterX,CenterY = MinX + W/2, MinY + H/2

print( CenterY )
local event_item_out_of_screen = "item_out_of_screen";

Item.State = 
{
	
	Pause = 1,
	Running = 2,
}
function Item:init(color,w,h)
	-- body
	self.shape = Shape.new(color) -- create the shape
	self.shape:beginPath()         -- begin a path
	self.shape:setLineStyle(0)     
	self.shape:setFillStyle(Shape.SOLID, color) 
	self.shape:moveTo(0,0)     -- move pen to start of line
	self.shape:lineTo(w,0)     -- draw top of rectangle
	self.shape:lineTo(w,h)     -- NEW: draw right side of rectangle
	self.shape:lineTo(0,h)     -- NEW: draw bottom of rectangle
	self.shape:lineTo(0,0)     -- NEW: draw left side of triangle
	self.shape:endPath()           -- end the path
	self:addChild(self.shape)

	self.state = Item.State.Running
	self.w, self.h = w,h;
end

function Item:pause()
	-- body
	self.state = Item.State.Pause;
end

function Item:update(deltaTime,moveSpeed)
	 if self and self.state == Item.State.Running then 
	 	if self:getY() > CenterY then -- change this to MaxY or something else...
			local event = Event.new(event_item_out_of_screen)
			self:dispatchEvent(event);
	 	else
	 		self:setY(self:getY() + deltaTime*moveSpeed)
	 	end
	 end
end
