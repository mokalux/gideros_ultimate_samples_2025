--[[
	InputKeyboard v0.4
	(C) 2012 Mathz Data och Webbutveckling, Mathz Franzén
	Classes for creating an inputbox which activates a keyboard on focus.
	This is intended for use with Gideros Mobile ( http://http://www.giderosmobile.com )

	INFO:
	This script is developed by Mathz Franzén. @mathz in the gideros forum
	Thankyou to @evs (gideros forum) for the inspiration to at all realise this could be possible to do.
	@evs's own version of a virtual keyboard can be found at: http://www.giderosmobile.com/forum/discussion/comment/9097#Comment_9097
	It's definitly worth checking out since he only allow Landscape and my script only Portrait!

	Since this is my constitutes my first small step on the Gideros platform, and also one of the first in the world of LUA you can
	expect to find one or two (or >=3) stupid solutions.
	Contributions from other authors are therefore highly appreciated. 
	
	The graphics is inspired by the keyboard on my SGS2, but to 100% created by me in Photoshop and can therefore be redistributed under
	the same conditions as the code (see below)

	LEGAL:
	All types of redistributions and modifications are allowed as long as these criterias are met:
		1. Keep this reference to the original creator and other contributors that is mentioned whitin this document (until now @evs)
		2. Add references to any future contributors
		3. When using this script (modified or unmodified) i would appreciate to have the opportunity to see the final result.
		4. It is encouraged, but not mandatory to make any changes to the script available to the public, for example by sending it to me
		   by email ( my email can be found at http://www.giderosmobile.com/forum/profile/mathz ) or posting the code in the gideros forum

		So in short: never remove contributors, always add and try to be nice to the community by share modifications.

	USAGE:
		Create new inputbox: KeyBoard.new(language)
						 Parameters: language 	 (string)(optional) Locale string
									 The locale string is a combination of ISO 639-1 and ISO 3166-1. For example, en_US, ja_JP.
									 Default string is en_GB
									 To use another locale the file local\"localcode".lua muste exist with a definition of the keyboard
		Change language:	 KeyBoard:setLang(language, create)
						 Parameters: language 	 (string)(optional) Locale string, se info above
									 create		 (boolean) States if the keyboard should be created directly, if set to false you have
												           to use KeyBoard:Create() to see the new keyboard layout
		Create new inputbox: InputBox.new(xpos,ypos,width,height)
						 Parameters: xpos:   	 (number)Horiontal position
									 ypos:   	 (number)Vertical position
									 width:  	 (number) Width of inputbox
									 height: 	 (number) Height of inputbox
		
		Set colors:			 InputBox:setBoxColors(background, border, borderWidth, alpha)
						 Parameters: background: (number)Background color
									 border:	 (number)Border color
									 borderWidth:(number)Border width
									 alpha:		 (number)Alpha transparency
		Set focus colors:	 InputBox:setActiveBoxColors(background, border, borderWidth, alpha)
						 Parameters: background: (number)Background color
									 border:	 (number)Border color
									 borderWidth:(number)Border width
									 alpha:		 (number)Alpha transparency
		Get current text:	 InputBox:getText()
		Set text:			 InputBox:setText(text)
						 Parameters: text: 		 (string)The text
		Set max letters		 InputBox:setMaxLetters(maxLetters)
						 Parameters: background: (number)Maximal amount of letters to allow
		Set password field	 InputBox:PasswordField(pField)
						 Parameters: pField: 	 (boolean)True = Inputbox is used as passwordfield
		Set keyboard		 InputBox:SetKeyBoard(keyboard)
						 Parameters: keyboard: 	(KeyBoard)The keyboard to use for this inputbox
	
	KNOWN LIMITIONS/PROBLEMS:
		1. Text can continue outside the boundaries of the box
		2. Only portrait mode is supported.
		3. Developed for Scale mode "Fit width", other scale modes could potentially be a problem.
		4. Developed for width 480px

	HISTORY:
	v0.1	First version (Mathz)
	v0.2	Using TTF fonts instead of images for keys (Mathz)
	v0.3	Localization of keyboard (Mathz)
	v0.3a	Keyboard files moved to correct directory
	v0.4	1. Show alternatie letters when pressing longer on a key
			2. Automatically deleting more characters when holding the DEL key pressed
			3. Fixed some potential memory leaks
	v0.4a	Set default keyboard to users location, en_GB if location doesn't exist
]]--
InputBox = Core.class(Sprite)

function InputBox:init(x,y,width,height)
	self.passWordField = false
	self.maxLetters = 1024
	self.width = width
	self.height = height
	self:setPosition(x,y)
	self.background = Shape.new()
	self:addChild(self.background)
	self.active = Shape.new()
	self.active:setVisible(false)
	self:addChild(self.active)
	
	local fontSize = height - (height/9)
	local font = TTFont.new("arial.ttf",fontSize,true)
	self.textField = TextField.new(font,"")
	self.textField:setPosition(5, 4.5 * fontSize / 5)
	self:addChild(self.textField)
	self.textContent = ""
	self:addEventListener(Event.MOUSE_UP,self.onMouseUp, self)
end

function InputBox:setBoxColors(background, border, borderWidth, alpha)
	drawBox(self.background, background, border, borderWidth, alpha, self.width, self.height)
end

function InputBox:setActiveBoxColors(background, border, borderWidth, alpha)
	drawBox(self.active, background, border, borderWidth, alpha, self.width, self.height)
end

function InputBox:getText() return self.textContent end

function InputBox:setText(text)
	self.textContent = text
	if self.passWordField then self.textField:setText(string.rep("*", self.textContent:len()))
	else self.textField:setText(text)
	end
end

function InputBox:setMaxLetters(maxLetters) self.maxLetters = maxLetters end

function InputBox:PasswordField(pField)
	self.passWordField = pField
	self.textField:setText(string.rep("*", self.textContent:len()))
end

function InputBox:SetKeyBoard(keyboard) self.keyboard = keyboard end

function InputBox:onMouseUp(event)
	if self:hitTestPoint(event.x, event.y) then
		local event = Event.new("ShowKeyboard")
		event.inputbox = self
		self.keyboard:dispatchEvent(event)
	end
end

function InputBox:Activate()
	self.background:setVisible(false)
	self.active:setVisible(true);
end

function InputBox:DeActivate()
	self.background:setVisible(true)
	self.active:setVisible(false);
end

function drawBox(box, background, border, borderWidth, alpha, width, height)
	if borderWidth > 0 then box:setLineStyle(borderWidth, border, alpha) end
	box:setFillStyle(Shape.SOLID, background, alpha)
	box:beginPath(Shape.NON_ZERO)
	box:moveTo(0,0)
	box:lineTo(width,0)
	box:lineTo(width, height)
	box:lineTo(0, height)
	box:lineTo(0, 0)
	box:endPath()
end

SubKeySelector = Core.class(Sprite)
function SubKeySelector:init(mainKey, subKeys,keyWidth)
	local font = TTFont.new("arial.ttf",30,true)
	self.Keys = {}
	self.Active = 0
	self.Fields = Sprite.new()
	self.direction = 1
	self.keyWidth = keyWidth
	for i,k in pairs(subKeys) do
		self.Keys[i] = TextField.new(font,k)
		self.Keys[i]:setTextColor(0xaaaaaa)
		self.Fields:addChild(self.Keys[i])
	end
	self.box = Shape.new()
	drawBox(self.box, 0x000000, 0xadadad, 1 / application:getLogicalScaleX(), 0.9, self.keyWidth*#self.Keys, 50)
	self:addChild(self.box)
	self:addChild(self.Fields)
	self:setActive(1)
	font = nil
end

function SubKeySelector:cleanUp()
	self:removeChild(self.box)
	self.box = nil
	for i,k in pairs(self.Keys) do 
		self.Fields:removeChild(self.Keys[i])
		self.Keys[i] = nil
	end
	self:removeChild(self.Fields)
	self.Fields = nil
	self = nil
end

function SubKeySelector:Show()
	local posx = 0
	if self.direction == -1 then posx = (#self.Keys - 1) * self.keyWidth end
	for i,k in pairs(self.Keys) do
		self.Keys[i]:setPosition(posx + ((self.keyWidth-self.Keys[i]:getWidth())/2),0)
		posx = posx + self.keyWidth * self.direction
	end
	self.box:setPosition(0,-38)
	self:setVisible(true)
end

function SubKeySelector:getMaxKeys() return #self.Keys end

function SubKeySelector:setActive(active)
	if self.Active ~= active then
		if self.Active > 0 then self.Keys[self.Active]:setTextColor(0xaaaaaa) end
		self.Active = active
		self.Keys[self.Active]:setTextColor(0xffffff)
	end
end

function SubKeySelector:getActive() return self.Active end

function SubKeySelector:getSelectedKey() return self.Keys[self.Active]:getText() end

function SubKeySelector:setDirection(direction)
	self.direction = direction
	self:setActive(1)
end

function SubKeySelector:getDirection() return self.direction end


Letter = Core.class(Sprite)

function Letter:init(theLetter,width,height, font)
	self.textField = TextField.new(font,theLetter)
	local posX = (width - self.textField:getWidth()) / 2 - 1

	local shadowShift = 1
	if application:getLogicalScaleX() >= 1.25 then shadowShift = 0.75 end
	if application:getLogicalScaleX() > 1.6 then shadowShift = 0.5 end
	
	self.textField:setTextColor(0x000000)
	self.textField:setPosition(posX, height * 0.75)
	self:addChild(self.textField)
	self.textField = TextField.new(font,theLetter)
	self.textField:setTextColor(0xFFFFFF)
	self.textField:setPosition(posX + shadowShift , height * 0.75 + shadowShift)
	self:addChild(self.textField)
end


Key = Core.class(Sprite)

function Key:init(mainKey,subKeys, parent,colLeft,rowTop, font, layer)
	self.layer = layer
	self.BigSmallSwitcher = false
	self.NumericalSwitcher = false
	self.parent = parent
	self.active = false
	self.timer = Timer.new(50, 6)
	self.text = mainKey
	self.subKeys = subKeys
	self.subKeysShown = false
	self.startPosX = 0

	local keyType = 1
	if mainKey == parent.UPPER or mainKey == parent.LOWER or mainKey == parent.DEL
			or mainKey == parent.TEXT or mainKey == parent.NUMBERS or mainKey == parent.HIDE
			or mainKey == parent.ENTER then keyType = 2
	elseif mainKey == parent.SPACE then keyType = 3
	end
	if mainKey == parent.LOWER then self.keyBack = Bitmap.new(parent.keyImages[mainKey])
	else self.keyBack = Bitmap.new(parent.keyImages["BACKGROUND"][keyType])
	end
	self.selKey = Bitmap.new(parent.keyImages["HIGHLIGHT"][keyType])
	self.keyBack:setPosition(colLeft,rowTop)
	self.selKey:setPosition(colLeft,rowTop)
	self.selKey:setVisible(false)
	self:addChild(self.keyBack)
	self:addChild(self.selKey)

	local keyExists = true
	if mainKey and mainKey:len() <= 2 then
		self.keyLetters = Letter.new(mainKey,self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.NUMBERS then
		self.keyLetters = Letter.new("?12",self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.TEXT then
		self.keyLetters = Letter.new("abc",self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.HIDE then	--Down arrow Unicode: 0xE28693	
		self.keyLetters = Letter.new("\226\134\147",self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.UPPER then	--Up arrow Unicode: 0xE28691	
		self.keyLetters = Letter.new("\226\134\145",self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.DEL then		--Delete Unicode: 0xE296A0
		self.keyLetters = Letter.new("\226\150\160",self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.SPACE then
		self.keyLetters = Letter.new(self.lang,self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.LOWER then
		self.keyLetters = Letter.new("\226\134\145",self:getWidth(), parent.keyHeight, font)
	elseif mainKey == parent.ENTER then	--Enter unicode: 0xE29692
		self.keyLetters = Letter.new("\226\150\146",self:getWidth(), parent.keyHeight, font)
	else
		--No key present!
		keyExists = false
	end
	if keyExists then
		self.keyLetters:setPosition(colLeft,rowTop)
		self:addChild(self.keyLetters)
	end
	self.keyBack:addEventListener(Event.MOUSE_UP,self.onMouseUp, self)
	self.keyBack:addEventListener(Event.MOUSE_DOWN,self.onMouseDown, self)
	self.keyBack:addEventListener(Event.MOUSE_MOVE,self.onMouseMove, self)
end

function Key:removeEventListeners()
	self.keyBack:removeEventListener(Event.MOUSE_UP,self.onMouseUp, self)
	self.keyBack:removeEventListener(Event.MOUSE_DOWN,self.onMouseDown, self)
	self.keyBack:removeEventListener(Event.MOUSE_MOVE,self.onMouseMove, self)
end

function Key:setBMSwitcher(switcher) self.BigSmallSwitcher = switcher end

function Key:setNUMSwitcher(switcher) self.NumericalSwitcher = switcher end

function Key:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) and self.layer == self.parent.activeLayout then
		self.startPosX = self.keyBack:localToGlobal(1,1)
		self.selKey:setVisible(true)
		self.active = true
		event:stopPropagation()
		if #self.subKeys > 0 then
			if self.timer then self.timer:reset() end
			if not self.timer:hasEventListener(Event.TIMER) then
				self.timer:addEventListener(Event.TIMER,self.onMousePressing, self)
			end
			self.timer:start()
		elseif self.text == self.parent.DEL then
			if not self.timer:hasEventListener(Event.TIMER) then
				self.timer:setDelay(300)
				self.timer:setRepeatCount(0)
				self.timer:addEventListener(Event.TIMER,self.onDelPressing, self)
			end
			self.timer:start()
		end
	end
end

function Key:onDelPressing(event)
	if self.timer:getCurrentCount() == 3 then self.timer:setDelay(250) end
	if self.timer:getCurrentCount() == 7 then self.timer:setDelay(200) end
	if self.timer:getCurrentCount() == 12 then self.timer:setDelay(150) end
	if self.timer:getCurrentCount() == 20 then self.timer:setDelay(100) end
	if self.timer:getCurrentCount() == 60 then self.timer:setDelay(30) end
	self:KeyStroke(self.text)
end

function Key:onMouseMove(event)
	if self.active then
		if self.subKeysShown then
			local selKey = math.min(math.ceil(self.subKeySel:getDirection()*(event.x - self.startPosX) / self.parent.keyWidth), self.subKeySel:getMaxKeys())
			if selKey <= 0 then selKey = 1 end
			self.subKeySel:setActive(selKey)
		elseif not self:hitTestPoint(event.x, event.y) then
			self:leftKey()
			event:stopPropagation()
		end
	end
end

function Key:onMousePressing(event)
	if self.timer:getCurrentCount() == 4 then	
		self.subKeySel = SubKeySelector.new(self.text,self.subKeys, self.parent.keyWidth)
		self.parent:addChild(self.subKeySel)
		if self.startPosX + self.subKeySel:getMaxKeys() * self.parent.keyWidth > application:getLogicalWidth() then
			self.subKeySel:setDirection(-1)
			self.startPosX = self.startPosX + self.parent.keyWidth
			self.subKeySel:setPosition(self.startPosX - self.subKeySel:getMaxKeys()*self.parent.keyWidth,self.keyBack:getY() - 4)
		else
			self.subKeySel:setPosition(self.startPosX,self.keyBack:getY() - 4)
		end
		self.subKeySel:Show()
		self.subKeysShown = true
		self.subKeyDirecton = 1
	end
end

function Key:leftKey()
	self.timer:reset()
	if self.subKeySel then
		self.parent:removeChild(self.subKeySel)
		self.subKeySel:cleanUp()
	end
	self.subKeySel = nil
	self.active = false
	self.subKeysShown = false
	self.timer:removeEventListener(Event.TIMER,self.onMousePressing, self)
	collectgarbage()
	Timer.delayedCall(100, function()
		self.selKey:setVisible(false)
	end)
end

function Key:onMouseUp(event)
	if self.subKeysShown then
		self.subKeysShown = false
		self:KeyStroke(self.subKeySel:getSelectedKey())
		self:leftKey()
		event:stopPropagation()
	elseif self:hitTestPoint(event.x, event.y) and self.layer == self.parent.activeLayout and self.active then
		self:leftKey()
		self:KeyStroke(self.text)
		collectgarbage()
	end
end

function Key:KeyStroke(text)
	local newLetter = text
	if newLetter == self.parent.UPPER or newLetter == self.parent.LOWER then
		self.parent:dispatchEvent(Event.new("switchBM"))
	elseif newLetter == self.parent.NUMBERS or newLetter == self.parent.TEXT then
		self.parent:dispatchEvent(Event.new("switchNUM"))
	elseif newLetter == self.parent.DEL then
		local lastByte = string.byte(string.sub(self.parent.inputbox.textContent,self.parent.inputbox.textContent:len(),self.parent.inputbox.textContent:len()))
		local delLength = 1
		if lastByte and lastByte >=128 and lastByte <=192 then
			delLength = 2 -- The character to remove uses two bytes in the string
		end
		self.parent.inputbox.textField:setText(string.sub(self.parent.inputbox.textField:getText(),1,self.parent.inputbox.textField:getText():len()-delLength))
		self.parent.inputbox.textContent = string.sub(self.parent.inputbox.textContent,1,self.parent.inputbox.textContent:len()-delLength)
	elseif newLetter == self.parent.SPACE then
		local letter = " "
		if self.parent.inputbox.passWordField then letter = "*" end
		self.parent.inputbox.textField:setText(self.parent.inputbox.textField:getText()..letter)
		self.parent.inputbox.textContent = self.parent.inputbox.textContent.." "
	elseif newLetter == self.parent.HIDE then
		self.parent:Hide()
	elseif self.parent.inputbox.textField:getText():len() < self.parent.inputbox.maxLetters then
		local letter = newLetter
		if self.parent.inputbox.passWordField then letter = "*" end
		self.parent.inputbox.textField:setText(self.parent.inputbox.textField:getText()..letter)
		self.parent.inputbox.textContent = self.parent.inputbox.textContent..newLetter
	end	
end

KeyBoard = Core.class(Sprite)
function KeyBoard:init(language)
	self.hSpacing = {0,0,0}
	self.cChildren = {0,0,0}
	self.TEXT = "TEXT"
	self.NUMBERS = "NUMBERS"
	self.SPACE = "SPACE"
	self.HIDE = "HIDE"
	self.DEL = "DEL"
	self.UPPER = "UPPERCASE"
	self.LOWER = "LOWERCASE"
	self.ENTER = "ENTER"
	self.EXTRASPACE = "ES"
	self.lang = application:getLocale()
	-- Load all keyimages
	self.keyImages = {}
	self.keyImages[self.LOWER] = Texture.new("img/"..self.LOWER..".png")	
	self.keyImages["BACKGROUND"] = {}
	self.keyImages["HIGHLIGHT"] = {}
	self.keyImages["BACKGROUND"][1] = Texture.new("img/key.png")
	self.keyImages["HIGHLIGHT"][1] = Texture.new("img/keyHigh.png")
	self.keyImages["BACKGROUND"][2] = Texture.new("img/key2.png")
	self.keyImages["HIGHLIGHT"][2] = Texture.new("img/keyHigh2.png")
	self.keyImages["BACKGROUND"][3] = Texture.new("img/key3.png")
	self.keyImages["HIGHLIGHT"][3] = Texture.new("img/keyHigh3.png")

	self.activeLayout = 1

	local tmpKey = Bitmap.new(self.keyImages["BACKGROUND"][1])
	self.keyWidth = tmpKey:getWidth()
	self.keyHeight =tmpKey:getHeight()
	tmpKey = nil

	self:setLang(language, false)
	self.rows = 4
	self.vSpacing = 7.18
	self.big = false
	self.numerical = false
	self.topBorder = application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY() - (self.rows * self.keyHeight + (self.rows + 1) * self.vSpacing)
	self:setPosition(0,application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY())
	self.movieFrames = (application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY() - self.topBorder) / 20

	self.background = Shape.new()
	self.background:setFillStyle(Shape.SOLID, 0x0a0a0a)
	self.background:beginPath(Shape.NON_ZERO)

	self.background:moveTo(0, 0)
	self.background:lineTo(application:getLogicalWidth(), 0)
	self.background:lineTo(application:getLogicalWidth(), application:getLogicalHeight())
	self.background:lineTo(0, application:getLogicalHeight()) 
	self.background:lineTo(0, 0)
	self.background:endPath()
	self:addChild(self.background)
	self.layers = {}
	for i=1,3 do
		self.layers[i] = Sprite.new()
		self:addChild(self.layers[i])
	end
	self:addEventListener("switchBM", self.onBMSwitch, self)
	self:addEventListener("switchNUM", self.onNUMSwitch, self)
	self:addEventListener("ShowKeyboard", self.onShow, self)
end

function KeyBoard:setLang(language, create)
	local defLang = "en_GB"
	if language == nil then language = self.lang end
	-- Load keyboard matrix
	local langFile = loadfile("locale/"..language..".lua")
	if langFile == nil then
		language = defLang
		langFile = loadfile("locale/"..language..".lua")
	end
	self.lang = language
	langFile()
	self.keys = keyLang(self)
	for i=1,3 do
		self.hSpacing[i] = (application:getLogicalWidth() - self.keyWidth * #self.keys[i][1]) / (#self.keys[i][1] + 1)
	end
	if create then self:Create(self.inputbox) end
end

function KeyBoard:onBMSwitch()
	if self.big then self.activeLayout = 1
	else self.activeLayout = 2
	end
	self.big = not self.big
	self:ShowActiveLayer()
end

function KeyBoard:onNUMSwitch()
	if self.numerical then
		if self.big then self.activeLayout = 2
		else self.activeLayout = 1
		end
	else
		self.activeLayout = 3
	end
	self.numerical = not self.numerical
	self:ShowActiveLayer()
end

function KeyBoard:ShowActiveLayer()
	for i=1,3 do
		if i == self.activeLayout then self.layers[i]:setVisible(true)
		else self.layers[i]:setVisible(false)
		end
	end
end

function removeChildren(object)
	while object:getNumChildren() > 0 do
		removeChildren(object:getChildAt(object:getNumChildren()))
		object:removeChildAt(object:getNumChildren())
	end
end

function KeyBoard:Create(inputBox)
	local colLeft =  0
	local rowTop = - self.keyHeight
	local font = TTFont.new("arial.ttf",30,true)
	local mainKey = ""
	local subKeys = {}
	self.inputbox = inputBox

	for b,layer in pairs(self.keys) do
		rowTop = - self.keyHeight
		for i=1,self.layers[b]:getNumChildren() do
			local key = self.layers[b]:getChildAt(i)
			key:removeEventListeners()
		end
		removeChildren(self.layers[b])
		collectgarbage()
		for rowNo,row in pairs(layer) do
			colLeft =  self.hSpacing[b]
			rowTop = rowTop + self.vSpacing + self.keyHeight
			for i,letter in pairs(row) do			
				if type(letter) ~= "table" then
					mainKey = letter
					subKeys = {}
				else
					mainKey = letter[1]
					subKeys = letter[2]
				end
				if mainKey == self.EXTRASPACE then
					colLeft = colLeft + (self.keyWidth + self.hSpacing[b]) / 2
				else
					local theKey = Key.new(mainKey,subKeys, self,colLeft,rowTop,font,b)
					self.layers[b]:addChild(theKey)
					colLeft = colLeft + theKey:getWidth() + self.hSpacing[b]
				end
			end
		end
	end
	self.layers[2]:setVisible(false)
	self.layers[3]:setVisible(false)
end

function KeyBoard:Hide() 
	MovieClip.new{{1, self.movieFrames, self, {y = {self.topBorder, application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY(),  "linear"}}}}
	self.inputbox:DeActivate()
end

function KeyBoard:Show()
	if math.floor(self:getY()) ~= math.floor(self.topBorder) then
		MovieClip.new{{1, self.movieFrames, self, {y = {application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY(), self.topBorder,  "linear"}}}}
	end
	if self.inputbox ~= nil then
		self.inputbox:Activate()
	end
end

function KeyBoard:onShow(event)
	if self.inputbox ~= nil then self.inputbox:DeActivate() end
	self.inputbox = event.inputbox
	self:Show()
end
