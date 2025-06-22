--[[
	-----------------------------------------------
	Clock Ellipse
	-----------------------------------------------
	Source:		by Hubert Ronald
	SDK:		Gideros
	Type:		Sample
	Licensed:	Free to distribute and modify code! 
			but keep reference to its creator
	pageWeb:	bowsailboat.com
	-----------------------------------------------
	NOTE:
		for more information about Parametric
		Equation of an Ellipse see this link
		http://www.mathopenref.com/coordparamellipse.html
	-----------------------------------------------
]]

---------------------------------------------
-- COLOR: RGB TO HEX
---------------------------------------------
function rgb(r, g, b)
	return ((r*256)+g)*256+b
end

---------------------------------------------
-- SET BACKGROUND
---------------------------------------------
application:setBackgroundColor(rgb(0, 0, 0))


----------------------------------------
-- LOCK ORIENTATION
----------------------------------------
stage:setOrientation(Stage.PORTRAIT)


----------------------------------------
--	FIX DIMENSION DEVICE
----------------------------------------
_W, _H = application:getContentWidth(), application:getContentHeight()
Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()


--[[
	----------------------------------------
	--	CLASS DRAW ARC
	----------------------------------------
	-- thanks to @ndoss
	-- http://giderosmobile.com/forum/discussion/346/snippet-arccircleellipse#Item_1
]]
Arc = gideros.class(Shape)
function Arc:init(t)
   local x          = t.x or t.y or 0
   local y          = t.y or t.x or 0
   local fillStyle  = t.fillStyle or { Shape.SOLID, 0x000000, 0.5 }
   local lineStyle  = t.lineStyle or { 2, 0xffffff, 0.5  }
   local xradius    = t.xradius or t.radius or 100
   local yradius    = t.yradius or t.radius or 100
   local sides      = t.sides or (xradius + yradius)/2 
   local startAngle = t.startAngle or 0
   local arcAngle   = t.arcAngle or 1
 
   self:setFillStyle(unpack(fillStyle))
   self:setLineStyle(unpack(lineStyle))
 
   local angleStep = arcAngle / sides
 
   self:setPosition(x,y)
   local xx = math.cos(startAngle*2*math.pi) * xradius
   local yy = math.sin(startAngle*2*math.pi) * yradius
 
   self:beginPath()
   self:moveTo(xx, yy)
   for i = 1,sides do
      local angle = startAngle + i * angleStep
      self:lineTo(math.cos(angle*2*math.pi) * xradius,
                  math.sin(angle*2*math.pi) * yradius)
   end
   self:endPath()
 
   if t.alpha then
      self:setAlpha(t.alpha)
   end
   if t.parent then
      t.parent:addChild(self)
   end
 
   return self
end


----------------------------------------
--	DRAW ELLIPSE
----------------------------------------
local radiusY = 300 -- y
local radiusX = 74 -- x
Arc.new{x=_W/2+2*radiusX,y=_H/2+radiusY,xradius=radiusX, yradius=radiusY, sides=sides,
              fillStyle = { Shape.SOLID, rgb(200, 200, 200), 0.3 },
              lineStyle = { 0, rgb(200, 200, 200), 0.3 },
              parent = stage}



----------------------------------------
--	CLASS DRAW SEGMENT
----------------------------------------
Segment = Core.class(Shape)

function Segment:init(config)
	-- Settings to control the line
	self.conf = {
		Width =  1.5,
		Color = rgb(255, 255, 255),
		Alpha = 1,
	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key]= value
		end
	end
	
	self:setVisible(false)
end

-- Draw line
function Segment:draw(dots)
	self:beginPath()
	self:setLineStyle(self.conf.Width, self.conf.Color, self.conf.Alpha)
	self:moveTo(dots.x[1],dots.y[1])
	self:lineTo(dots.x[2],dots.y[2])
	self:endPath()
	self:setVisible(true)
end

-- hide line
function Segment:hide()
	self:clear()
	self:setVisible(false)
end


----------------------------------------
--	DRAW NEEDLE
----------------------------------------
local needle = Segment.new()
stage:addChild(needle)
needle:draw({x={_W/2+2*radiusX, _W/2+2*radiusX},y={_H/2+radiusY, _H/2}})


----------------------------------------
--	FRAME CLOCK CONFIG
----------------------------------------
local cos = math.cos
local sin = math.sin
local rad = math.rad
countFPS = 0 -- 60 ~= 1 sec
theta = 270 -- Reference of axes in mobile is different

stage:addEventListener(Event.ENTER_FRAME, 
	function()
		countFPS = countFPS + 1
		if countFPS == 10 then -- change 10 if you need more or less velocity
			needle:hide()
			theta = theta + 1
			
			needle:draw({
						x={_W/2+2*radiusX, _W/2+2*radiusX+radiusX*cos(rad(theta))},
						y={_H/2+radiusY, _H/2+radiusY+radiusY*sin(rad(theta))}
						})
			countFPS = 0
		end
	
	end)
