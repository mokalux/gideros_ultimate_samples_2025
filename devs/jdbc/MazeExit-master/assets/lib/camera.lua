
Camera = Core.class()

Camera.Drag = 0
Camera.Zoom = 1
Camera.Follow = 2

-- Constructor
function Camera:init(world, mode, allowZoom, minZoom, maxZoom, startZoom)
	self.world = world
	self.minZoom = minZoom or 0.2
	self.maxZoom = maxZoom or 2
	self.allowZoom = allowZoom or true
	self.scale = startZoom or 1
	self.mode = mode or Camera.Drag
	--the camera position
	self.x = 0
	self.y = 0
	--the world coordinates the camera is focusing on
	self.targetX = 0
	self.targetY = 0
	--the current speed of the camera when draging the camera
	self.speedX = 0
	self.speedY = 0
	--How long it takes for the camera to slow down when you stop draging it. (lesser is longer)
	self.Friction = 0.9
	
	self:setScale(0)

	--events for camera movement
	world:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	world:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
end


--Set the camera mode so you can drag the camera with your finger
function Camera:setDragMode()
	self.mode = Camera.Drag
end


--Turns off the drag mode.
function Camera:setFollowMode()
	self.mode = Camera.Follow
end


--Turns off/on zoom with pinching
function Camera:allowZoom(bool)
	self.allowZoom = bool
end


--sets the target of the camera, the target will be in the middle of the screen(call every frame if you want it to follow it)
function Camera:setTarget(x, y)
	self:setTargetX(x)
	self:setTargetY(y)
end


--translates screen coordinates to world coordinates
function Camera:translate(x, y)
	return self.world:globalToLocal(x, y)
end


--Set how zoomed in or out the camera is, bigger number is bigger zoom
function Camera:setZoom(zoom)
	self.scale = zoom
	self:setScale(0)
end


--Updates the position of the camera, run this on every frame
function Camera:update()
	if self.mode == Camera.Drag then
		self.targetX = self.targetX + self.speedX / self.scale
		self.targetY = self.targetY + self.speedY / self.scale
		self.speedX = self.speedX * self.Friction
		self.speedY = self.speedY * self.Friction
	end
	
	--calculate the difference between current camera position and the target position
	local diffx = self.targetX * self.scale - self.x
	local diffy = self.targetY * self.scale - self.y

	--add the difference to the camera position
	self.x = self.x + diffx
	self.y = self.y + diffy
	
	--move the camera and add half the screen size to get target in the middle
	self.world:setPosition(-self.x + application:getContentWidth()/2, -self.y + application:getContentHeight()/2)
end


function Camera:setTargetX(x)
	self.targetX = x 
end

function Camera:setTargetY(y)
	self.targetY = y
end


--dont use this to change the zoom, use setZoom()
function Camera:setScale(scale)
	self.scale = self.scale + scale / 300
	if self.scale > self.maxZoom then
		self.scale = self.maxZoom
	elseif self.scale < self.minZoom then
		self.scale = self.minZoom
	end
	self.world:setScale(self.scale, self.scale)
end


function Camera:onTouchesBegin(event)
	if #event.allTouches <= 1 and self.mode == Camera.Drag then
		self.state = Camera.Drag
		self.x0 = event.touch.x
		self.y0 = event.touch.y
	elseif #event.allTouches > 1 and self.allowZoom then
		self.state = Camera.Zoom
		--calculate the distance between the first 2 fingers
		local x = event.allTouches[1].x - event.allTouches[2].x
		local y = event.allTouches[1].y - event.allTouches[2].y
		self.distance0 = math.sqrt(x * x + y * y)
	end
end


function Camera:onTouchesMove(event)
	if self.state == Camera.Drag then
		--add the how long the finger has moved to the cameras speed
		self.speedX = self.speedX + (self.x0 - event.touch.x) / 7
		self.speedY = self.speedY + (self.y0 - event.touch.y) / 7
		--reset x0, y0 to calculate from this point the next move
		self.x0 = event.touch.x
		self.y0 = event.touch.y
	elseif self.state == Camera.Zoom and self.allowZoom then
		--if there is more than one finger pressed
		if #event.allTouches > 1 then
			--calculate the distance between the first 2 fingers
			local x = event.allTouches[1].x - event.allTouches[2].x
			local y = event.allTouches[1].y - event.allTouches[2].y
			local distance = math.sqrt(x * x + y * y)
			--set scale to the difference in distance between this move and last move
			self:setScale(distance - self.distance0)
			--save the new distance
			self.distance0 = distance
		end
	end
end