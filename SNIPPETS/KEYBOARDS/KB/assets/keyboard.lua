--[[

Keyboard 

evs 2012

]]

Keyboard = Core.class(Sprite)

local keyClick
local callback
local font
local cursor
local textField
local fieldWidth
local bg
local rect
local shifted
local appearanceSpeed
local timer
local this 

function Keyboard:init()

	this = self

 	keyClick = Sound.new("sounds/Tock.wav")
	
	-- callback, fallback function
	callback = function(text) print("Typed \"" .. text .. "\" - No Callback Function Specified!") end

	font = TTFont.new("fonts/arial-rounded.TTF", 22)
	cursor = TextField.new(font, " \4")
	
	self:addChild(cursor)
	cursor.showing = true
	
	textField = TextField.new(font, "")
	textField:setTextColor(0xfb9900) -- Gideros logo orange
	textField:setPosition(56, 26)
	fieldWidth = 352
	self:addChild(textField)
	
	bg = Sprite.new()
	rect = fillRect()
	bg:addChild(rect)
	bg:setPosition(0, application:getContentHeight())
	
	shifted = true -- shift flag
	appearanceSpeed = 960 / application:getDeviceHeight() * 10 -- 20 MovieClip frames on normal screen, 10 frames on retina
	
	setShift() -- create start keyboard
	self:addChild(bg)
	timer = Timer.new(500)
	timer:start()
	
	local function onTimer(event)
		
		if cursor.showing then
			
			cursor:setVisible(false)
			cursor.showing = false
			
		else
			
			cursor:setVisible(true)
			cursor.showing = true
			
		end
		
	end
	
	timer:addEventListener(Event.TIMER, onTimer)
	
end

function fillRect()

	local rect = Shape.new()
	
	rect:setFillStyle(Shape.SOLID, 0x8a929c, 1) -- background color

	-- simple rectangle
	rect:beginPath(Shape.NON_ZERO)
	rect:moveTo(0, 0)
	rect:lineTo(0, 164)
	rect:lineTo(application:getContentWidth(), 164)
	rect:lineTo(application:getContentWidth(), 0)
	rect:lineTo(0, 0)
	rect:closePath()
	rect:endPath()
	
	return rect

end

function Keyboard:clear()

	textField:setText("") -- clear text field

end

function Keyboard:show(callbackFunction)
	
	if callback then -- if callback function specified
		
		callback = callbackFunction -- set it
		
	end
	
	-- slide the keyboard in
	local mc = MovieClip.new{{1, appearanceSpeed  , bg, 
							 {y = {application:getContentHeight(), 
							  application:getContentHeight() - bg:getHeight(), "linear"}}}}
							  
	cursor:setPosition(textField:getX(), textField:getY())

end

function hidden(mc)

	shifted = true -- shift flag
	setShift()
		
	-- remove movie clip complete listener
	mc:removeEventListener(Event.COMPLETE, hidden) 
	
end

function hide()
	
	-- slide the keyboard out
	local mc = MovieClip.new{{1, appearanceSpeed, bg, 
							{y = {application:getContentHeight() - bg:getHeight(), 
							 application:getContentHeight(),  "linear"}}}}
							
	-- listen for movie clip complete						
	mc:addEventListener(Event.COMPLETE, hidden, mc)
	
end

function drawKey(key)

	-- create a bitmap for a key
	local bmKey = Bitmap.new(Texture.new("images/keys/" .. key.image))

	bmKey:setPosition(key.x, key.y)
	
	-- return key bitmap
	return bmKey
	
end

function touchUp(key, event)

	-- clear the keys
	local kids = bg:getNumChildren();
	
	--  down to 2 = do not remove the first born (background color)
	for i = kids, 2, -1 do 
	
		bg:getChildAt(key.number + 1):setColorTransform(1, 1, 1, 1) -- de-highlight keys
		
	end			


end

function touch(key, event)

	if key:hitTestPoint(event.touches[1].x, event.touches[1].y) then
		
		keyClick:play() -- sound
		
		if key.item == "shift" then
			
			shifted =  not shifted
			--print("shift", shifted)
			
			if shifted then
				
				setShift()
				
			else
				
				setNormal()
					
			end
			
		elseif key.item == "#+=" then
			
			--print("#+=")
			
			setSymbols()
			
		elseif key.item == "123" then
			
			--print("123")
			
			setNumbers()
			
		elseif key.item == "ABC" then
			
			--print("ABC")
			
			if shifted then
				
				setShift()
				
			else
				
				setNormal()
				
			end
			
		elseif key.item == "del" then
			
			-- highlight delete key (index 1 is background so add 1)
			bg:getChildAt(key.number + 1):setColorTransform(185/255, 62/255, 62/255, 1) -- Gideros logo red
			
			--print("del")
			local delete = 0
			local text = textField:getText()
			
			if text:len() > 0  then -- make sure string exists
				
				-- if standard ASCII
				if text:byte(text:len()) >= 32 and text:byte(text:len()) <= 126 then
					
					delete = -2 -- delete back 2 from end
					
				else -- special characters € £ ¥ • either 2 or 3 ASCII codes
					
					for i = text:len(), 1, - 1 do -- loop backwards throught string
						
						if string.byte(text, i, i) == 194 then -- either £ (codes 194 and 163) or ¥ (codes 194 and 165)
							
							delete = -3 -- delete back 3 from end
							
							break -- leave loop
							
						elseif string.byte(text, i, i) == 226 then -- either € (codes 226, 130 and 172) or • (codes 226, 128 and 162)
							
							delete = -4 -- delete back 4 from end
							
							break -- leave loop
							
						end
						
					end
					
				end
				
			end
			
			text = text:sub(1, delete) -- remove deleted characters
			
			textField:setText(text) -- update text
			
		elseif key.item == ".?123" then
			
			--print(".?123")
			
			setNumbers()
			
		elseif key.item == "return" then
			
			--print("return" )
			
			-- highlight key (index 1 is background so add 1)
			bg:getChildAt(key.number + 1):setColorTransform(144/255, 203/255, 67/255, 1) -- Gideros logo green
			
			hide()
			callback(textField:getText())
			
		elseif textField:getWidth() < fieldWidth then
			
			if  shifted then 
				
				shifted = false
				setNormal()
				
			end -- take shift off
			
			textField:setText(textField:getText() .. key.item)
			
			-- highlight key (index 1 is background so add 1)
			bg:getChildAt(key.number + 1):setColorTransform(97/255, 159/255, 188/255, 1)  -- Gideros logo blue
			
		end
		
		--self.textfield:setX(application:getContentWidth() / 2 - self.textfield:getWidth() / 2 )  -- center
		cursor:setPosition(textField:getX() + textField:getWidth(), textField:getY())
		
		event:stopPropagation()
		
	end
	
end

function clear()

	-- clear the keys
	local kids = bg:getNumChildren();
	
	--  down to 2 = do not remove the first born (background color)
	for i = kids, 2, -1 do 
	
		bg:removeChildAt(i)
		
	end			

end

function setNormal()

	clear()
	
	local letters = {
					
					{item = "q", x = 3, y = 6, image = "Q.png"},
					{item = "w", x = 51, y = 6, image = "W.png"},
					{item = "e", x = 99, y = 6, image = "E.png"},
					{item = "r", x = 147, y = 6, image = "R.png"},
					{item = "t", x = 195, y = 6, image = "T.png"},
					{item = "y", x = 243, y = 6, image = "Y.png"},
					{item = "u", x = 291, y = 6, image = "U.png"},
					{item = "i", x = 339, y = 6, image = "I.png"},
					{item = "o", x = 387, y = 6, image = "O.png"},
					{item = "p", x = 435, y = 6, image = "P.png"},
					{item = "a", x = 27, y = 46, image = "A.png"},
					{item = "s", x = 75, y = 46, image = "S.png"},
					{item = "d", x = 123, y = 46, image = "D.png"},
					{item = "f", x = 171, y = 46, image = "F.png"},
					{item = "g", x = 219, y = 46, image = "G.png"},
					{item = "h", x = 267, y = 46, image = "H.png"},
					{item = "j", x = 315, y = 46, image = "J.png"},
					{item = "k", x = 363, y = 46, image = "K.png"},
					{item = "l", x = 411, y = 46, image = "L.png"},
					{item = "shift", x = 3, y = 86, image = "shift.png"},
					{item = "z", x = 75, y = 86, image = "Z.png"},
					{item = "x", x = 123, y = 86, image = "X.png"},
					{item = "c", x = 171, y = 86, image = "C.png"},
					{item = "v", x = 219, y = 86, image = "V.png"},
					{item = "b", x = 267, y = 86, image = "B.png"},
					{item = "n", x = 315, y = 86, image = "N.png"},
					{item = "m", x = 363, y = 86, image = "M.png"},
					{item = "del", x = 419, y = 86, image = "delete.png"},
					{item = ".?123", x = 3, y = 126, image = "numbers.png"},
					{item = " ", x = 101, y = 126, image = "spacebar.png"},
					{item = "return", x = 389, y = 126, image = "return.png"}
					
				}
				
	for index = 1, #letters, 1 do
		
		local key 
		
		key = drawKey(letters[index])
		key.number = index
		bg:addChild(key)
		key.item = letters[index].item
		key:addEventListener(Event.TOUCHES_BEGIN, touch, key)
		key:addEventListener(Event.TOUCHES_END, touchUp, key)
		
	end

end		

function setShift()

	clear()

	local shiftedLetters = {
							
							{item = "Q", x = 3, y = 6, image = "Q.png"},
							{item = "W", x = 51, y = 6, image = "W.png"},
							{item = "E", x = 99, y = 6, image = "E.png"},
							{item = "R", x = 147, y = 6, image = "R.png"},
							{item = "T", x = 195, y = 6, image = "T.png"},
							{item = "Y", x = 243, y = 6, image = "Y.png"},
							{item = "U", x = 291, y = 6, image = "U.png"},
							{item = "I", x = 339, y = 6, image = "I.png"},
							{item = "O", x = 387, y = 6, image = "O.png"},
							{item = "P", x = 435, y = 6, image = "P.png"},
							{item = "A", x = 27, y = 46, image = "A.png"},
							{item = "S", x = 75, y = 46, image = "S.png"},
							{item = "D", x = 123, y = 46, image = "D.png"},
							{item = "F", x = 171, y = 46, image = "F.png"},
							{item = "G", x = 219, y = 46, image = "G.png"},
							{item = "H", x = 267, y = 46, image = "H.png"},
							{item = "J", x = 315, y = 46, image = "J.png"},
							{item = "K", x = 363, y = 46, image = "K.png"},
							{item = "L", x = 411, y = 46, image = "L.png"},
							{item = "shift", x = 3, y = 86, image = "shiftSelected.png"},
							{item = "Z", x = 75, y = 86, image = "Z.png"},
							{item = "X", x = 123, y = 86, image = "X.png"},
							{item = "C", x = 171, y = 86, image = "C.png"},
							{item = "V", x = 219, y = 86, image = "V.png"},
							{item = "B", x = 267, y = 86, image = "B.png"},
							{item = "N", x = 315, y = 86, image = "N.png"},
							{item = "M", x = 363, y = 86, image = "M.png"},
							{item = "del", x = 419, y = 86, image = "delete.png"},
							{item = ".?123", x = 3, y = 126, image = "numbers.png"},
							{item = " ", x = 101, y = 126, image = "spacebar.png"},
							{item = "return", x = 389, y = 126, image = "return.png"}
					
				}
				
	for index = 1, #shiftedLetters, 1 do
		
		local key 
		
		key = drawKey(shiftedLetters[index])
		key.number = index
		bg:addChild(key)
		key.item = shiftedLetters[index].item
		key:addEventListener(Event.TOUCHES_BEGIN, touch, key)
		key:addEventListener(Event.TOUCHES_END, touchUp, key)
		
	end

end

function setNumbers()

	clear()

	local numbers = {
					
					{item = "1", x = 3, y = 6, image = "1.png"},
					{item = "2", x = 51, y = 6, image = "2.png"},
					{item = "3", x = 99, y = 6, image = "3.png"},
					{item = "4", x = 147, y = 6, image = "4.png"},
					{item = "5", x = 195, y = 6, image = "5.png"},
					{item = "6", x = 243, y = 6, image = "6.png"},
					{item = "7", x = 291, y = 6, image = "7.png"},
					{item = "8", x = 339, y = 6, image = "8.png"},
					{item = "9", x = 387, y = 6, image = "9.png"},
					{item = "0", x = 435, y = 6, image = "0.png"},
					{item = "-", x = 2, y = 46, image = "minus.png"},
					{item = "/", x = 50, y = 46, image = "fs.png"},
					{item = ":", x = 98, y = 46, image = "colon.png"},
					{item = ";", x = 146, y = 46, image = "scolon.png"},
					{item = "(", x = 194, y = 46, image = "openBracket.png"},
					{item = ")", x = 242, y = 46, image = "closeBracket.png"},
					{item = "$", x = 290, y = 46, image = "dollar.png"},
					{item = "&", x = 338, y = 46, image = "ampersand.png"},
					{item = "@", x = 386, y = 46, image = "at.png"},
					{item = "\"", x = 434, y = 46, image = "speechMark.png"},
					{item = "#+=", x = 3, y = 86, image = "symbols.png"},
					{item = ".", x = 74, y = 86, image = "fullStop.png"},
					{item = ",", x = 142, y = 86, image = "comma.png"},
					{item = "?", x = 209, y = 86, image = "questionMark.png"},
					{item = "!", x = 277, y = 86, image = "exclamationMark.png"},
					{item = "'", x = 344, y = 86, image = "apostrophe.png"},
					{item = "del", x = 419, y = 86, image = "delete.png"},
					{item = "ABC", x = 3, y = 126, image = "ABC.png"},
					{item = " ", x = 101, y = 126, image = "spacebar.png"},
					{item = "return", x = 389, y = 126, image = "return.png"}
					
				}
				
	for index = 1, #numbers, 1 do
		
		local key 
		
		key = drawKey(numbers[index])
		key.number = index
		bg:addChild(key)
		key.item = numbers[index].item
		key:addEventListener(Event.TOUCHES_BEGIN, touch, key)
		key:addEventListener(Event.TOUCHES_END, touchUp, key)
			
	end
	
end

function setSymbols()

	clear()

	local symbols = {
					
					{item = "[", x = 3, y = 6, image = "openSquareBracket.png"},
					{item = "]", x = 51, y = 6, image = "closeSquareBracket.png"},
					{item = "{", x = 99, y = 6, image = "openBrace.png"},
					{item = "}", x = 147, y = 6, image = "closeBrace.png"},
					{item = "#", x = 195, y = 6, image = "hash.png"},
					{item = "%", x = 243, y = 6, image = "percent.png"},
					{item = "^", x = 291, y = 6, image = "hat.png"},
					{item = "*", x = 339, y = 6, image = "asterisk.png"},
					{item = "+", x = 387, y = 6, image = "plus.png"},
					{item = "=", x = 435, y = 6, image = "equals.png"},
					{item = "_", x = 2, y = 46, image = "underscore.png"},
					{item = "\\", x = 50, y = 46, image = "backslash.png"},
					{item = "|", x = 98, y = 46, image = "pipe.png"},
					{item = "~", x = 146, y = 46, image = "tilde.png"},
					{item = "<", x = 194, y = 46, image = "lessThan.png"},
					{item = ">", x = 242, y = 46, image = "greaterThan.png"},
					{item = "€", x = 290, y = 46, image = "euro.png"},
					{item = "£", x = 338, y = 46, image = "pound.png"},
					{item = "¥", x = 386, y = 46, image = "yen.png"},
					{item = "•", x = 434, y = 46, image = "bullet.png"},
					{item = "123", x = 3, y = 86, image = "123.png"},
					{item = ".", x = 74, y = 86, image = "fullStop.png"},
					{item = ",", x = 142, y = 86, image = "comma.png"},
					{item = "?", x = 209, y = 86, image = "questionMark.png"},
					{item = "!", x = 277, y = 86, image = "exclamationMark.png"},
					{item = "'", x = 344, y = 86, image = "apostrophe.png"},
					{item = "del", x = 419, y = 86, image = "delete.png"},
					{item = "ABC", x = 3, y = 126, image = "ABC.png"},
					{item = " ", x = 101, y = 126, image = "spacebar.png"},
					{item = "return", x = 389, y = 126, image = "return.png"}
					
				}

	for index = 1, #symbols, 1 do
		
		local key 
		
		key = drawKey(symbols[index])
		key.number = index
		bg:addChild(key)
		key.item = symbols[index].item
		key:addEventListener(Event.TOUCHES_BEGIN, touch, key)
		key:addEventListener(Event.TOUCHES_END, touchUp, key)
		
		
	end
	
end
