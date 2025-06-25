application:setBackgroundColor(0x000000)
application:setKeepAwake(true)
appW=480
appH=854
centerX=240
centerY=427

local world=Sprite.new()
world:setPosition(centerX,centerY)
stage:addChild(world)

local scaler=1
local zoomArr={}

for i=1,10 do
	zoomArr[i]=Bitmap.new(Texture.new("zoom"..i..".jpg",true))
	zoomArr[i]:setAnchorPoint(.5,.5)
	zoomArr[i]:setScale(scaler)
	world:addChild(zoomArr[i])
	scaler/=2
end

--zoom world:
GTween.new(world, 6, {scaleX = 1000, scaleY = 1000}, {delay = 0, ease = easing.inCircular, onComplete = function() print("zoom finished") rotationAllowed=false end})

--rotate world:
rotationAllowed=true
rotationTimer = Timer.new(10,0)
rotationTimer:addEventListener(Event.TIMER, function()
	if rotationAllowed then
	world:setRotation(world:getRotation()+0.2)
		if world:getRotation()>=70 then rotationAllowed=false end
	else rotationTimer:stop() print(world:getRotation())
	end
end)

rotationTimer:start()