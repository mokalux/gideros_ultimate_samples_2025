DropSpiderThread = Core.class(Sprite)

function DropSpiderThread:init(scene,x,y)

	self.scene = scene
	
	if(not(self.scene.dropSpiderAtlas)) then
	
		self.scene.dropSpiderAtlas = TexturePack.new("Atlases/drop spider.txt", "Atlases/drop spider.png",true)

	end
	
		self.scene.rube1:addChild(self)
	
	local img = Bitmap.new(self.scene.dropSpiderAtlas:getTextureRegion("thread.png"))
	self:addChild(img)
	img:setAnchorPoint(.5,.5)
	
	img:setRotation(-4)

	local tween = GTween.new(img, 1.4, {rotation = 5},{ease = easing.inOutQuadratic, reflect=true, repeatCount = 99999999})
	local tween = GTween.new(img, .7, {y= self:getY()+5},{ease = easing.inOutQuadratic, reflect=true, repeatCount = 99999999})
		

end

