--!NEEDS:config.lua

StartScene = Core.class(Sprite)

function StartScene:init()

	--uptxt
	self.normalText = TextField.new(conf.fonteasy,"Dont hit")
	self.normalText:setTextColor(0xFFFFFF)
	self.normalText:setPosition(6, (conf.height*0.1)+40)
	self.normalText:setScale(1.8)
	self.normalText:setLetterSpacing(2.75)
	
	--downtxt
	self.ghst = TextField.new(conf.fonteasy,"the Ghost")
	self.ghst:setTextColor(0xFFFFFF)
	self.ghst:setPosition(6, (conf.height*0.1)+120)
	self.ghst:setScale(1.8)
	self.ghst:setLetterSpacing(2.75)
	
	--lilghost
	self.ghost = Bitmap.new(Texture.new("images/ghost.png", true))
	self.ghost:setAnchorPoint(0.5, 0.5)
	self.ghost:setPosition(conf.width/2, conf.height/3)
	
	--background
	self.bg = Bitmap.new(Texture.new("images/bg_shroom.png", true))
	self.bg:setAnchorPoint(0.5, 0.5)
	self.bg:setPosition(conf.width/2, conf.height/2)
	
	--playButton
	self.playimg =Bitmap.new(Texture.new("images/Play.png", true))
	self.play = Button.new(self.playimg)
	self.playimg:setAnchorPoint(0.5,0.5)
	self.play:setPosition(conf.width/2, conf.height/1.75)
	self.play:addEventListener("down", function()
		self.playimg:setScale(0.9)
	end)
	self.play:addEventListener("move", function()
		self.playimg:setScale(1)
	end)
	self.play:addEventListener("click", function()
		self.playimg:setScale(1)
		sounds:play("click")
		sceneManager:changeScene("tut", 0, conf.transition, conf.easing)
	end)
	
	--rateus
	self.rateimg =Bitmap.new(Texture.new("images/ratebtn1.png", true))
	self.ratebtn = Button.new(self.rateimg)
	self.rateimg:setAnchorPoint(0.5,0.5)
	self.ratebtn:setPosition(conf.width/2, (conf.height/1.75)+150)
	self.ratebtn:addEventListener("down", function()
		self.rateimg:setScale(0.9)
	end)
	self.ratebtn:addEventListener("move", function()
		self.rateimg:setScale(1)
	end)
	self.ratebtn:addEventListener("click", function()
		self.rateimg:setScale(1)
		sounds:play("click")
		application:openUrl("https://play.google.com/store/apps/details?id=com.lunargamesstudio.donthittheghost")
	end)
	
	--showingUP
	self:addChild(self.bg)
	self:addChild(self.play)
	self:addChild(self.ghst)
	
	--define what to animate 
	local animate = {} 
	animate.y = (conf.height/3) + 30
	
	--define GTween properties 
	local properties = {} 
	properties.delay = 0
	properties.ease = easing.linear
	properties.repeatCount = math.huge
	properties.dispatchEvents = true
	properties.reflect = true
	
	local tween = GTween.new(self.ghost, 1, animate, properties)
	--adding
	self:addChild(self.ratebtn)
	self:addChild(self.ghost)
	self:addChild(self.normalText)
end