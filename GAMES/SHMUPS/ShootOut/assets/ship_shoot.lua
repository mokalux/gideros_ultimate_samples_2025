ShipShoot = Core.class(Sprite)

function ShipShoot:init(filename)

	self.shot = Bitmap.new(Texture.new(filename))
	--self.shot:setAnchorPoint(0.5, 0.5)
	stage:addChild(self.shot)
end

function onShootComplete(tween)
	local child = tween.target
	local parent = child:getParent()
	parent:removeChild(child)
end

function ShipShoot:Fire(x, y)
	y-=5
	self.shot:setPosition(x+10, y)
	
	--local tweenx = GTween.new (self.shot, 2, {y = 10}, {onComplete= onShootComplete})
end