-- -------------------------------------------------------
-- Quick "old skool" Raster / Copper bar demo!
-- Jon Howard (jon@whitetreegames.com / www.whitetreegames.com)
-- -------------------------------------------------------

application:setBackgroundColor(0)
WIDTH = application:getContentWidth()
HEIGHT = application:getContentHeight()
centerX = WIDTH * 0.5
centerY = HEIGHT * 0.5

barImg = Texture.new("bar.png")

numBars = 10
barOffsetScale = 2
barHeightScale = 1

iI = 1 / numBars

bars = { }

for i=1,numBars do
	bars[i] = Bitmap.new(barImg)
	bars[i]:setScaleX(WIDTH)
	bars[i]:setScaleY(barHeightScale)
	bars[i]:setAnchorPoint(0,0.5)
	stage:addChild(bars[i])
end

logoImg = Texture.new("logo.png")	-- has to be 256x256 for this to work (or at least a power of 2)

lines = { }
local ly = centerY-128
local lx = centerX-128
local iscaler = 150

for i=1,256 do
	local l = Shape.new()
	l:setFillStyle(Shape.TEXTURE,logoImg)
	l:beginPath(Shape.NON_ZERO)
	l:moveTo(0,i)
	l:lineTo(256,i)
	l:lineTo(256,i+1)
	l:lineTo(0,i+1)
	l:closePath()
	l:endPath()
		
	l:setPosition(lx,ly)
	stage:addChild(l)
	lines[i] = l
end

function loop(event)
	local t = os.timer() 
	local l,sx,x,y,ni,r,g,b 

	-- Do the raster bar effect!
	ni = 0
	for i=1,numBars do
		
		-- Bounce the bars on sine wave (driven by os.timer)
		y = centerY + (centerY * math.cos(t + (ni * barOffsetScale)))
		bars[i]:setY(y)
	
		-- Dynamically adjust the colour
		r = (192 + (64 * math.sin(t*3.7+ni*1.3))) / 256
		g = (192 + (64 * math.sin(t*3.7+ni*4.2))) / 256
		b = (192 + (64 * math.cos(t*3.7+ni*3.7))) / 256
		
		bars[i]:setColorTransform(r,g,b,1)
		
		ni = ni + iI
	end
	
	-- Mess with the image!
	for i=1,256 do
		l = lines[i]
		x = (32 * math.sin(t + (i/iscaler)))
		sx = 0.75 + (0.3 * (math.sin(t) + (i/iscaler)))

		l:setScaleX(sx)
		l:setX(centerX - (l:getWidth() * 0.5) + x)
	end
	
	iscaler = 50 + (33 * math.sin(t))
	
	
end

stage:addEventListener(Event.ENTER_FRAME,loop)

--[[
-- -------------------------------------------------------------------------
-- local methods required to put an FPS counter on the screen...

local frame = 0
local timer = os.timer()
local qFloor = math.floor
local fps	

-- -------------------------------------------------------------------------

local function updateFPS(self,e)
	frame = frame + 1
	if frame == 60 then
		local currentTimer = os.timer()
		fps:setText(""..qFloor(60 / (currentTimer - timer)))
		local width = fps:getWidth()
		fps:setPosition(WIDTH-(width+10), 28)	--HEIGHT-10)
		frame = 0; timer = currentTimer	
	end
end

-- -------------------------------------------------------------------------

local function initFPS(group)
	fps = TextField.new(nil,"")
	fps:setTextColor(0x00FFFF)
	fps:setScale(3,3)
	fps:addEventListener(Event.ENTER_FRAME,updateFPS,nil)
	group:addChild(fps)
end

initFPS(stage)	-- Add a quick FPS counter on the screen (REMOVE for final build)
--]]

-- End of file...