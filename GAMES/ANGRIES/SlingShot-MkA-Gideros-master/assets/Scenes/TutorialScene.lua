--!NEEDS:classes/easing.lua

TutorialScene = Core.class(Sprite)

function TutorialScene:init()
	--bg
	self.bg = Bitmap.new(Texture.new("images/bg_shroom.png", true))
	self.bg:setAnchorPoint(0.5, 0.5)
	self.bg:setPosition(conf.width/2, conf.height/2)
	self.bgbtn = Button.new(self.bg)
	self:addChild(self.bgbtn)
	
	--images
	local head  = Bitmap.new(Texture.new("images/touch0.png",true))
	head:setPosition(100,200)
	self:addChild(head)
	
	local hand  = Bitmap.new(Texture.new("images/hand.png",true))
	hand:setPosition(400,(conf.height/2)+300)
	
	local sprite  = Bitmap.new(Texture.new("images/First.png",true))
	sprite:setAnchorPoint(0.5,0.5)
	sprite:setPosition(conf.width/2, (conf.height/2)+200)
	self:addChild(sprite)
	self:addChild(hand)
	
	--text
	self.t2p = TextField.new(conf.fonteasy,"Tap to play")
	self.t2p:setTextColor(0xFFFFFF)
	self.t2p:setPosition(6, (conf.height*0.1)+80)
	self.t2p:setScale(1.6)
	self.t2p:setLetterSpacing(2.75)
	self:addChild(self.t2p)
	
	--tween tracker
	self.currTween = 1
	
	--repeat
	function yesitstheonlyway()
		sceneManager:changeScene("tut", 0,conf.transition, nil)
	end
	
	--4 tween
	function yikes()
		self.currTween = 3
		conf.main2ball = GTween.new(sprite, 0.7, {x =180, y = 280}, {onComplete = yesitstheonlyway})
		conf.main2ball.dispatchEvents = true
	end
	
	--2,3 tweens
	self.double = function()
		self.currTween =2
		local  mainpull = GTween.new(sprite, 1, {x = 320, y = (conf.height/2)+300}, {})
		conf.handpull = GTween.new(hand, 1, {x = 320, y = (conf.height/2)+300}, {})
		conf.handpull:addEventListener("complete",yikes,self)
		conf.handpull.dispatchEvents = true
	end
	
	--first tween
	local  hand2main = GTween.new(hand, 1, {x = conf.width/2, y = (conf.height/2)+200}, {onComplete = self.double})
	hand2main.dispatchEvents = true
	
	--
	self.bgbtn:addEventListener("click", function()
		if self.currTween == 1 then
			hand2main:setPaused(true)
		elseif self.currTween ==2 then
			conf.handpull:setPaused(true)
		else 
			conf.main2ball:setPaused(true)
		end
		sounds:play("click")
		sceneManager:changeScene("level", 0, conf.transition, conf.easing)
	end)
end