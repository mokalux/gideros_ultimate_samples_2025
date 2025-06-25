SplashartScene = Core.class(Sprite)

function SplashartScene:init()
	
	self.logo = Bitmap.new(Texture.new("images/logo.png", true))
	self.logo:setAnchorPoint(0.5,0.5)
	self.logo:setPosition(conf.width/2, conf.height/2)
	self:addChild(self.logo)
	
	self.timeup = Timer.new(1800,1)
	self.timeup:addEventListener(Event.TIMER_COMPLETE, function()
		sceneManager:changeScene("start", 0.5, SceneManager.crossfade, conf.easing)
	end)
	self.timeup:start()
end