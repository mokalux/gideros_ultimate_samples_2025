GreenBug = Core.class(Sprite)

function GreenBug:init(scene,x,y,atlas)

	self.scene = scene
	self.scene.behindRube:addChild(self)

	
	local sprite = Sprite.new()
	self:addChild(sprite)
	local mainSprite = sprite
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug rear leg.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(-12,0)
	self:addChild(img)
	self.rear1 = img
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug front leg.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(-14,2)
	self:addChild(img)
	self.front1 = img
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug rear leg.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(14,0)
	img:setScaleX(-1)
	self:addChild(img)
	self.rear2 = img
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug front leg.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(16,2)
	img:setScaleX(-1)
	self:addChild(img)
	self.front2 = img
	
	
	local sprite = Sprite.new()
	self:addChild(sprite)
	self.headSprite = sprite
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug body.png"))
	img:setAnchorPoint(.5,.5)
	self.headSprite:addChild(img)
	--self.headSprite:setVisible(false)
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug eye.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(-6,-2)
	self.headSprite:addChild(img)
	self.eye1 = img
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("green bug eye.png"))
	img:setAnchorPoint(.5,.5)
	img:setPosition(9,0)
	self.headSprite:addChild(img)
	self.eye2 = img

	self:addTweens()
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end





function GreenBug:addTweens()

	self.tweens = {}

	local huge = math.huge
	
	local tween = GTween.new(self.headSprite, .8, {y = self.headSprite:getY()-2},{reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	
	local tween = GTween.new(self.rear1, .4, {rotation = self.rear1:getRotation()+30, y = self.rear1:getY()-3},{delay = 1, reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	
	local tween = GTween.new(self.rear2, .6, {rotation = self.front1:getRotation()-30, y = self.rear2:getY()-2},{delay = 1, reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	
	local tween = GTween.new(self.front1, .7, {rotation = self.front1:getRotation()+20, y = self.front1:getY()-3.5},{delay = 1, reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	
	local tween = GTween.new(self.front2, .8, {rotation = self.front2:getRotation()-25, y = self.front2:getY()-2.9},{delay = 1, reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	
	local tween = GTween.new(self.eye1, 2, {rotation = self.eye1:getRotation()-180},{reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)
	
	local tween = GTween.new(self.eye2, 2, {rotation = self.eye2:getRotation()-180},{reflect=true, repeatCount = huge, ease = easing.inOutQuadratic})
	table.insert(self.tweens, tween)

end




function GreenBug:pause()

	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end

end




function GreenBug:resume()

	if(not(self.scene.gameEnded)) then
		for i,v in pairs(self.tweens) do
			v:setPaused(false)
		end
	end
	
end



-- cleanup function

function GreenBug:exit()
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
end





