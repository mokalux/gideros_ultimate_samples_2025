EndScene = Core.class(Sprite)

function EndScene:init()
	conf.adcount = conf.adcount+1
	if conf.adcount ==6 then
		conf.adcount = 0
	end
	if conf.adcount== 5 then
		admob:showAd("interstitial")
	end
	
	
	self.bg = Bitmap.new(Texture.new("images/bg_shroom.png", true))
	self.bg:setAnchorPoint(0.5, 0.5)
	self.bg:setPosition(conf.width/2, conf.height/2)
	self:addChild(self.bg)
	
	self.board = Bitmap.new(Texture.new("images/board.png", true))
	self.board:setAnchorPoint(0.5, 0.5)
	self.board:setPosition(conf.width/2, conf.height/2)
	self:addChild(self.board)
	
	self.rateimg =Bitmap.new(Texture.new("images/ratebtn1.png", true))
	self.ratebtn = Button.new(self.rateimg)
	self.rateimg:setAnchorPoint(0.5,0.5)
	self.rateimg:setScale(1.05)
	self.ratebtn:setPosition(conf.width/2,conf.height/1.075)
	self:addChild(self.ratebtn)
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
	
	
	self.replay = Bitmap.new(Texture.new("images/Replay.png", true))
	self.replaybtn = Button.new(self.replay)
	self.replay:setAnchorPoint(0.5, 0.5)
	self.replay:setPosition(conf.width/2, self.board:getY()+self.board:getY()*0.5)
	self.replaybtn:addEventListener("down", function()
		self.replay:setScale(0.9)
	end)
	self.replaybtn:addEventListener("move", function()
		self.replay:setScale(1)
	end)
	self.replaybtn:addEventListener("click", function()
		self.replay:setScale(1)
		sounds:play("click")
		sceneManager:changeScene("level", 0, conf.transition, conf.easing)
	end)
	self:addChild(self.replaybtn)
	
	
	--uptxt
	self.normalText = TextField.new(conf.fonteasy,"Dont hit")
	self.normalText:setTextColor(0xFFFFFF)
	self.normalText:setPosition(6, (conf.height*0.1)+40)
	self.normalText:setScale(1.8)
	self.normalText:setLetterSpacing(2.75)
	self:addChild(self.normalText)
	
	--downtxt
	self.ghst = TextField.new(conf.fonteasy,"the Ghost")
	self.ghst:setTextColor(0xFFFFFF)
	self.ghst:setPosition(6, (conf.height*0.1)+120)
	self.ghst:setScale(1.8)
	self.ghst:setLetterSpacing(2.75)
	self:addChild(self.ghst)
	
	--lilghost
	self.ghost = Bitmap.new(Texture.new("images/ghost.png", true))
	self.ghost:setAnchorPoint(0.5, 0.5)
	self.ghost:setPosition(conf.width/2, conf.height/3)
	self:addChild(self.ghost)
	
	local Your = TextField.new(conf.fonthard, "Score: " .. conf.yscore)
	Your:setTextColor(0xE54149)
	Your:setPosition(40,400)
	Your:setScale(1.2)
	local High = TextField.new(conf.fonthard, "HighScore:" .. conf.highscore)
	High:setTextColor(0xE54149)
	High:setPosition(40,450)
	High:setScale(1.2)
	
	self:addChild(Your)
	self:addChild(High)
end