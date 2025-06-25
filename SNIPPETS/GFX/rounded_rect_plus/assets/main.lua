--ok worked wonderfully and here's the updated code to draw rectangle,arc,circle and roundedrect may be someone like it :)

-- bg
application:setBackgroundColor(0x520029)

function drawRect(left,top,width,height)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0xffffff, 0.5)
	shape:beginPath()
	shape:moveTo(0,0)
	shape:lineTo(width, 0)
	shape:lineTo(width, height)
	shape:lineTo(0, height)
 
	shape:closePath()
	shape:endPath()
	shape:setPosition(left,top)
	return shape
end

local myRect = drawRect(10,0,50,80)
myRect:setColorTransform(0,0,0,1)
stage:addChild(myRect)
myRect:setPosition(0,250)
 
function drawArc(xc,yc,xradius,yradius,startAngle,endAngle,isFill)
	if yradius == nil then
		yradius = xradius
	end
	if startAngle == nil then
		startAngle = 0
	end
	if endAngle == nil then
		endAngle = 360
	end
	if isFill == nil then
		isFill = true
	end
	local shape = Shape.new()
	if isFill then
		shape:setFillStyle(Shape.SOLID, 0xffffff, 0.5)
	else
		shape:setLineStyle(3, 0x000000)
	end
	shape:beginPath()
	for i=startAngle,endAngle do
		if i==1 then
			shape:moveTo(math.sin(math.rad(i)) * xradius, math.cos(math.rad(i)) * yradius)
		else
			shape:lineTo(math.sin(math.rad(i)) * xradius, math.cos(math.rad(i)) * yradius)
		end
	end
	if isFill then
		shape:closePath()
	end
	shape:endPath()
	shape:setPosition(xc,yc)
	return shape
end
 
--usage
local myArc = drawArc(250,110,50,100,40,220,false)
myArc:setColorTransform(0,1,0,1)
stage:addChild(myArc)
 
local myCircle = drawArc(150,55,50)
myCircle:setPosition(50,50)
myCircle:setColorTransform(0,1,0,1)
stage:addChild(myCircle)
 
function drawRoundedRect(left,top,width,height,radius)
	--radius = 10
--	local yc = top + height*0.5
--	local xc = left + width*0.5
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0xffffff, 1.5)
 
	local xPointArr = {}
	local yPointArr = {}
	local function getPoints(xc,yc,radius,startAngle,endAngle)
		for i=startAngle,endAngle do
			xPointArr[#xPointArr + 1],yPointArr[#yPointArr + 1] = xc + math.sin(math.rad(i)) * radius,yc + math.cos(math.rad(i)) * radius
		end
	end
 
	getPoints(width-radius*0.5,height-radius*0.5,radius,0,90)
	getPoints(width-radius*0.5,radius*0.5,radius,90,180)
	getPoints(radius*0.5,radius*0.5,radius,180,270)
	getPoints(radius*0.5,height-radius*0.5,radius,270,360)
 
	for i=1,#xPointArr do
		if i == 1 then
			shape:moveTo(xPointArr[i],yPointArr[i])
		else
			shape:lineTo(xPointArr[i],yPointArr[i])
		end
	end
 
	shape:closePath()
	shape:endPath()
 
	shape:setScale(width/shape:getWidth(),height/shape:getHeight())
	shape:setPosition(left,top)
 
	return shape
 
end
 
local myRoundedRect = drawRoundedRect(150, 200, 80, 160,10)
myRoundedRect:setColorTransform(1,1,0,1)
 
stage:addChild(myRoundedRect)
