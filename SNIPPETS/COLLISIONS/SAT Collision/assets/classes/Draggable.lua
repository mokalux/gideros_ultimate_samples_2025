
--[[

name:   Antix Draggable
vers:   1.0
desc:   A bitmap that can be dragged about by its center
auth:   by Cliff Earl
date:   March 2016
legal:  (c) 2016 Antix Software

Draggable.new(texture, [options])
Since  Draggable is an  extension of  the Gideros  Bitmap class  you need to 
pass  a TextureBase  or TextureRegion  as the  first parameter. The  options 
paramater is  is optional (excuse  the pun) and  is a table containing extra 
settings for the Draggable being created. Valid options are...

name       - A string value representing the Draggables name
x          - x position of Draggable
y          - y position of Draggable
MinX       - Left boundry for Draggable
MaxX       - Right boundry for Draggable
MinY       - Upper boundry for Draggable
MaxY       - Lower boundry for Draggable
dragRadius - radius from center of Draggable that will initiate dragging
onPressed  - function to execute when the Draggable is pressed
onDragged  - function to execute when the Draggable is dragged
onRelease  - function to execute when the Draggable is relased

example:
myDrag = Draggable.new(Texture.new("box.png", true), {x = 160, y = 128})

--]]

Draggable = Core.class(Bitmap)

function Draggable:init(texture, options) -- STARTUP
  self:setAnchorPoint(0.5, 0.5)
  
  self.enabled = true
  self.focus = false
  self.id = -1
  
  self.handleX = 0
  self.handleY = 0

  self.minX = 0
  self.minY = 0
  
  self.dragRadius = 16

  if options then
    self.name = options.name or "draggable" -- SET SUPPLIED OPTIONS
    self:setX(options.x or 0)
    self:setY(options.y or 0)
    self.minX = options.minX or 0
    self.minY = options.minY or 0
    self.maxX = options.maxX or application:getContentWidth()
    self.maxY = options.maxY or application:getContentHeight()
    self.dragRadius = options.dragRadius or 16
    self.onPressed = options.onPressed or nil
    self.onDragged = options.onDragged or nil
    self.onReleased = options.onReleased or nil
  else
    self.name = "draggable" -- SET DEFAULT OPTIONS
    self.maxX = application:getContentWidth()
    self.maxY = application:getContentHeight()
    self.onPressed = nil
    self.onDragged = nil
    self.onReleased = nil
  end
  
  self:addEventListener(Event.TOUCHES_BEGIN, self.pressed, self) -- ADD EVENT HANDLERS
  self:addEventListener(Event.TOUCHES_MOVE, self.dragged, self)
  self:addEventListener(Event.TOUCHES_END, self.released, self)
end

function Draggable:dispose() -- SHUTDOWN
  self.enabled = false
  
  self:removeEventListener(Event.TOUCHES_BEGIN, self.pressed, self) -- REMOVE EVENT HANDLERS
  self:removeEventListener(Event.TOUCHES_MOVE, self.dragged, self)
  self:removeEventListener(Event.TOUCHES_END, self.released, self)
  
  self.onPressed = nil
  self.onDragged = nil
  self.onReleased = nil
  
  self.handleX = nil
  self.handleY = nil
  
  self.minX = nil
  self.minY = nil
  self.maxX = nil
  self.maxY = nil
  
  self.enabled = nil
  self.focus = nil
  self.id = nil
end

function Draggable:enable(state) -- ENABLE / DISABLE
  self.enabled = state
end

function Draggable:pressed(e)
  if not self:isVisible() or not self.enabled then return end
  
  local function pointInCircle(tx, ty, cx, cy, r)
    if (ty-cy) * (ty-cy) / (r * r) + (tx-cx) * (tx-cx) / (r * r) <= 1 then return true end
    return false
  end
  
	if pointInCircle(e.touch.x, e.touch.y, self:getX(), self:getY(), 16) then -- NEEDS TO BE TOUCHED WITHIN SPECIFIED RADIUS OF ITS CENTER
    e:stopPropagation()
    self.id = e.touch.id
    self.focus = true
        
		self.handleX = e.touch.x
		self.handleY = e.touch.y
    
    if self.onPressed then
--      print("onPressed ("..e.touch.id..")")
      self.onPressed(self) -- PERFORM ACTION
    end
  end
end

function Draggable:dragged(e)
  if not self:isVisible() or not self.enabled then return end
  
  local function clamp(n, min, max)
    return n < min and min or (n > max and max or n)
  end
  
  if e.touch.id == self.id then
    self.focus = true
    e:stopPropagation()
    
    local dx = e.touch.x - self.handleX
    local dy = e.touch.y - self.handleY

    self:setX( clamp(self:getX() + dx, self.minX, self.maxX) )
    self:setY( clamp(self:getY() + dy, self.minY, self.maxY) )
    
    self.handleX = e.touch.x
    self.handleY = e.touch.y

    if self.onDragged then
--      print("onDragged ("..e.touch.id..")")
      self.onDragged(self) -- PERFORM ACTION
    end
   end
end

function Draggable:released(e)
  if not self:isVisible() or not self.enabled then return end
  
  if e.touch.id == self.id and self.focus and self:hitTestPoint(e.touch.x, e.touch.y) then
    e:stopPropagation()
    self.focus = false
    self.id = -1
    
    if self.onReleased then
--      print("onReleasedd ("..e.touch.id..")")
      self.onReleased(self) -- PERFORM ACTION
    end
  end
end
