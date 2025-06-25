TargetText = Core.class(Sprite)

function TargetText:init(scene,image)

	self.scene = scene

	local image = Bitmap.new(self.scene.atlas[2]:getTextureRegion(image))
	image:setAnchorPoint(.5,.5)
	self:addChild(image)
	self.scene.textLayer:addChild(self)
	image:setPosition(800,application:getContentHeight()/4.3)
	self.tween1 = GTween.new(image, .4, {x=application:getContentWidth()/2})
	Timer.delayedCall(2500, function()
		self.tween1 = GTween.new(image, .5, {x=-1000})
	end)
	
	Timer.delayedCall(3000, function()
		if(not(self.scene.hitDoor)) then
			self:getParent():removeChild(self)
		end
	end)

end