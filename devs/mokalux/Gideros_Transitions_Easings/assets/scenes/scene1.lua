Scene1 = Core.class(Sprite)

function Scene1:init()
	-- BG
	application:setBackgroundColor(0x0)
	local bmp = Bitmap.new(Texture.new("gfx/gideros-mobile-1000x2000.png"))
	bmp:setScale(0.425)
	bmp:setAlpha(1)
	bmp:setAnchorPoint(0.5, 0.5)
	bmp:setPosition(myappwidth / 2, myappheight / 2)
	self:addChild(bmp)
	-- button function
	local buttons = {}
	local myttf = TTFont.new("fonts/JetBrainsMono-Regular.ttf", 32)
	local myttf2 = TTFont.new("fonts/JetBrainsMono-Regular.ttf", 64)
	local myttf3 = TTFont.new("fonts/JetBrainsMono-Bold.ttf", 30)
	local myttf4 = TTFont.new("fonts/JetBrainsMono-Bold.ttf", 64)
	local function Buttons(xtext, xtooltiptext)
		local btn = ButtonTextP9UDDT.new({
			pixelcolorup=0xcccccc, pixelcolordown=0xffffff, pixelalpha=0.7,
			text=xtext, ttf=myttf,
			hover=true, tooltiptext=xtooltiptext, tooltiptextscale=3, tooltiptextcolor=0xff0000,
		})
		table.insert(buttons, btn)
		return btn
	end
	-- text function
	local texts = {}
	local function Texts(xtext)
		local text = TextField.new(myttf3, xtext)
		text:setAnchorPoint(0.5, 0.5)
--		text:setScale(3.5)
		text:setTextColor(0xffff00)
		table.insert(texts, text)
		return text
	end
	-- buttons
	local btnprevt = Buttons("< TRANS.", "previous transition")
	local btnnextt = Buttons("TRANS. >", "next transition")
	local btnpreve = Buttons("< EASING", "previous easing")
	local btnnexte = Buttons("EASING >", "next easing")
	local btntimer = Buttons("TIMER "..mytimer)
	local btntimerm01 = Buttons("-0.1 ")
	local btntimerm05 = Buttons("-0.5 ")
	local btntimerp01 = Buttons("+0.1 ")
	local btntimerp05 = Buttons("+0.5 ")
--	local btnrepeat = Buttons("REPLAY", 0xBF4141, 0xBF4141, "play or replay the transition")
	local btnrepeat = ButtonTextP9UDDT.new({
		pixelcolorup=0xffff00, pixelcolordown=0x00ff00,
		text="REPLAY", ttf=myttf4,
		hover=true, tooltiptext="play or replay the transition", tooltiptextscale=3, tooltiptextcolor=0xffffff,
	})
	self:addChild(btnrepeat)
	-- texts
	local textt = Texts(mytransition.."-"..mytransitionstxt[mytransition])
	local texte = Texts(myeasing.."-"..myeasingstxt[myeasing])
	-- buttons position
	btnprevt:setPosition(btnprevt:getWidth() / 2, 1 * myappheight / 10)
	btnnextt:setPosition(myappwidth - btnnextt:getWidth() / 2, 1 * myappheight / 10)
	btnpreve:setPosition(btnpreve:getWidth() / 2, 2.5 * myappheight / 10)
	btnnexte:setPosition(myappwidth - btnnexte:getWidth() / 2, 2.5 * myappheight / 10)
	btntimer:setPosition(myappwidth / 2, 7 * myappheight / 10)
	btntimerm01:setPosition(3 * btntimerm01:getWidth() / 2, 7 * myappheight / 10)
	btntimerm05:setPosition(btntimerm05:getWidth() / 2, 7 * myappheight / 10)
	btntimerp01:setPosition(myappwidth - 3 * btntimerp01:getWidth() / 2, 7 * myappheight / 10)
	btntimerp05:setPosition(myappwidth - btntimerp05:getWidth() / 2, 7 * myappheight / 10)
	btnrepeat:setPosition(myappwidth / 2, 9 * myappheight / 10)
	-- texts position
	textt:setPosition(myappwidth / 2, 1.5 * myappheight / 10)
	texte:setPosition(myappwidth / 2, 2.9 * myappheight / 10)
	-- add to scene
	for i = 1, #buttons do
		self:addChild(buttons[i])
	end
	for i = 1, #texts do
		self:addChild(texts[i])
	end
	-- buttons listener function
	local function Listeners(xscene)
		scenemanager:changeScene(xscene, mytimer, mytransitions[mytransition], myeasings[myeasing])
		mySavePrefs()
	end
	-- listeners
	local function xround(val, n)
		if (n) then return math.floor( (val * 10^n)+0.5 ) / (10^n)
		else return math.floor(val+0.5)
		end
	end
	btnrepeat:addEventListener("click", function()
		Listeners("scene2")
	end)
	btnprevt:addEventListener("click", function()
		mytransition -= 1
		if mytransition < 1 then mytransition = #mytransitions end
		Listeners("scene2")
	end)
	btnnextt:addEventListener("click", function()
		mytransition += 1
		if mytransition > #mytransitions then mytransition = 1 end
		Listeners("scene2")
	end)
	btnpreve:addEventListener("click", function()
		myeasing -= 1
		if myeasing < 1 then myeasing = #myeasings end
		Listeners("scene2")
	end)
	btnnexte:addEventListener("click", function()
		myeasing += 1
		if myeasing > #myeasings then myeasing = 1 end
		Listeners("scene2")
	end)
	btntimer:addEventListener("click", function()
		mytimer += 1
		if mytimer > 10 then mytimer = 0 end
		btntimer:setText("TIMER "..xround(mytimer, 2))
		mySavePrefs()
	end)
	btntimerm01:addEventListener("click", function()
		mytimer -= 0.1
		if mytimer < 0 then mytimer = 0 end
		btntimer:setText("TIMER "..xround(mytimer, 2))
		mySavePrefs()
	end)
	btntimerm05:addEventListener("click", function()
		mytimer -= 0.5
		if mytimer < 0 then mytimer = 0 end
		btntimer:setText("TIMER "..xround(mytimer, 2))
		mySavePrefs()
	end)
	btntimerp01:addEventListener("click", function()
		mytimer += 0.1
		if mytimer > 10 then mytimer = 10 end
		btntimer:setText("TIMER "..xround(mytimer, 2))
		mySavePrefs()
	end)
	btntimerp05:addEventListener("click", function()
		mytimer += 0.5
		if mytimer > 10 then mytimer = 10 end
		btntimer:setText("TIMER "..xround(mytimer, 2))
		mySavePrefs()
	end)
	-- scene listeners
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- GAME LOOP
function Scene1:onEnterFrame(e)
end

-- EVENT LISTENERS
function Scene1:onTransitionInBegin()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Scene1:onTransitionInEnd()
	self:myKeysPressed()
end

function Scene1:onTransitionOutBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Scene1:onTransitionOutEnd()
end

-- KEYS HANDLER
function Scene1:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		-- for mobiles and desktops
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then
--			sceneManager:changeScene("menu", 1, mytransitions[2], myeasing.outBack)
		end
	end)
end
