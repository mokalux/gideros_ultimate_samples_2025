cameraDrag = gideros.class(Sprite)

function cameraDrag:init()
	cameraDragSelf=self
	
	self:playFromLevel()
	
end


-- Stop the camera from moving any more
function cameraDrag:stopFromLevel()
	cameraDragSelf:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown, cameraDragSelf)
	cameraDragSelf:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove, cameraDragSelf)
	cameraDragSelf:removeEventListener(Event.MOUSE_UP, self.onMouseUp, cameraDragSelf)
end


-- Play the camera from moving any more
function cameraDrag:playFromLevel()
print("Reinicia")
	cameraDragSelf:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, cameraDragSelf)
	cameraDragSelf:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, cameraDragSelf)
	cameraDragSelf:addEventListener(Event.MOUSE_UP, self.onMouseUp, cameraDragSelf)
end

function cameraDrag:getDesplazamiento(x,y)
	self:getDesplazamientoX(x)
	self:getDesplazamientoY(y)
end


function cameraDrag:getDesplazamientoX(x)
	desplazamientoXTemp=lastXDes-x	
	desplazamientoX=desplazamientoX+desplazamientoXTemp
	print(lastXDes,x,desplazamientoX)
end

function cameraDrag:getDesplazamientoY(y)
	desplazamientoYTemp=lastYDes-y
	desplazamientoY=desplazamientoY+desplazamientoYTemp
end


function cameraDrag:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.isFocus = true
		lastXDes= event.x
		lastYDes= event.y
		
		self.x0 = event.x
		self.y0 = event.y
		
		event:stopPropagation()
	end
end

function cameraDrag:onMouseMove(event)
	
	if self.isFocus then
		local dx = event.x - self.x0
		local dy = event.y - self.y0
		
		self:setX(self:getX() + dx)
		self:setY(self:getY() + dy)

		self.x0 = event.x
		self.y0 = event.y

		event:stopPropagation()
	end
end

function cameraDrag:onMouseUp(event)
	if(event.x~=nil)then
	self:getDesplazamiento(event.x,event.y)
	end
	
	if self.isFocus then
		self.isFocus = false
		event:stopPropagation()
	end
end





