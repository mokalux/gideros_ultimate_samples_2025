local function takeUniform(str, count)
	local _,length = str:gsub("[^\128-\193]", "")
	local freq = count/length
	local sum = 0.5
	local concat = {}

--	for chr in str:gfind("([%z\1-\127\194-\244][\128-\191]*)") do
	for chr in str:gmatch("([%z\1-\127\194-\244][\128-\191]*)") do
		sum = sum + freq
		if sum > 1 then concat[#concat + 1] = chr sum = sum - 1 end
	end
	return table.concat(concat), #concat
end

local function splitToWords(str)
	local words = {}
	local init = 1
	while true do
		local s, e = str:find(" [^ ]", init)
		words[#words + 1] = str:sub(init, s)
		if s == nil then break end
		init = e
	end
	return words
end

local function splitToParagraphs(str)
	local paragraphs = {}
	local init = 1
	while true do
		local s = str:find("\10", init)
		paragraphs[#paragraphs + 1] = str:sub(init, s and (s - 1))
		if s == nil then break end
		init = s + 1
	end
	return paragraphs
end

local function splitToLines(str, font, width)
	local substr, subcount = takeUniform(str, 250)
	local tf = TextField.new(font, substr)
	local letterChunks = math.floor(subcount * width / tf:getWidth())
	local lines = {}
    testcolor = {}
	local paragraphs = splitToParagraphs(str)
	for i = 1,#paragraphs do
		local line = "" local len = 0
		--print(paragraphs[i], i)
		atchar = string.find(paragraphs[i],"@@")
		paragraphs[i] = string.gsub(paragraphs[i],"@@","")
		if atchar ~= nil then testcolor[i] = 1
		else testcolor[i] = 0
		end
		--print(test[i])
		local words = splitToWords(paragraphs[i])
		for j = 1,#words do
			local word = words[j]
			local _,wordlen = word:gsub("[^\128-\193]", "")
			if len + wordlen >= letterChunks then
				lines[#lines + 1] = line
				line = word
				len = wordlen
			else
				line = line..word
				len = len + wordlen
			end	
		end
		lines[#lines + 1] = line
		--print(i, lines[i])
	end
	return lines
end

TextWrap2 = Core.class(Sprite)

function TextWrap2:init(text, areaWidth, areaHeight, lineSpacing, letterSpacing, align, font, mainColor, color1)
	------------------------------- Default values ----------------------------------
	if not lineSpacing then lineSpacing = 16 end
	if not letterSpacing then letterSpacing = 1 end
	if not align then align = "left" end
	if not font then font = nil end
	if not mainColor then mainColor = 0x000000 end
	if not color1 then color1 = 0x000000 end
	---------------------------------------------------------------------------------
	self.text = text
	self.areaWidth = areaWidth
	self.areaHeight = areaHeight
	self.lineSpacing = lineSpacing
	self.letterSpacing = letterSpacing
	self.align = align
	self.font = font
	self.mainColor = mainColor
	self.color1 = color1

	self.scrollX = 0
	self.scrollY = 0
	self.textFields = {}
	self:setText(text)
end

function TextWrap2:setText(text)
	self.text = text
	if self.innerSprite ~= nil then self:removeChild(self.innerSprite) end
	self.innerSprite = Sprite.new()
	self:addChild(self.innerSprite)
	self.innerSprite:setPosition(-self.scrollX, -self.scrollY)
	self.lines = splitToLines(self.text, self.font, self.areaWidth)
	self.line1 = math.floor(self.scrollY / self.lineSpacing)
	self.line2 = math.floor((self.scrollY + self.areaHeight) / self.lineSpacing) + 1
	self.line1 = math.min(math.max(self.line1, 1), #self.lines)
	self.line2 = math.min(math.max(self.line2, 1), #self.lines)
	for i = self.line1,self.line2 do
		local textField = TextField.new(self.font, self.lines[i])
		textField:setY(i * self.lineSpacing)
		---------------------- Added By Talis -------------------------------------
		-- Checking the alignment of text and formatting position according to that
		if self.align == "left" then textField:setX(0)
		elseif self.align == "right" then textField:setX(self.areaWidth-textField:getWidth())
		elseif self.align == "center" then textField:setX((self.areaWidth-textField:getWidth())/2)
		end
		-- Checking for the lines has special color or not
		if testcolor[i] == 1 then textField:setTextColor(self.color1)
		else textField:setTextColor(self.mainColor)
		end
		----------------------------------------------------------------------------
		self.innerSprite:addChild(textField)		
		self.textFields[i] = textField
	end
end

function TextWrap2:getText() return self.text end
function TextWrap2:setTextColor(textColor) self.textColor = textColor end
function TextWrap2:getTextColor() return self.textColor end
function TextWrap2:setLetterSpacing(letterSpacing) self.letterSpacing = letterSpacing end
function TextWrap2:getLetterSpacing() return self.letterSpacing end
function TextWrap2:setLineSpacing(lineSpacing) self.lineSpacing = lineSpacing end
function TextWrap2:getLineSpacing() return self.lineSpacing end
function TextWrap2:setFont(font) self.font = font end
function TextWrap2:getFont() return self.font end
function TextWrap2:setArea(width, height) end

function TextWrap2:setScrollPosition(x, y)
	self.scrollX = x
	self.scrollY = y
	self.innerSprite:setPosition(-self.scrollX, -self.scrollY)
	local line1 = math.floor(self.scrollY / self.lineSpacing)
	local line2 = math.floor((self.scrollY + self.areaHeight) / self.lineSpacing) + 1
	local line1 = math.min(math.max(line1, 1), #self.lines)
	local line2 = math.min(math.max(line2, 1), #self.lines)
	if line1 == self.line1 and line2 == self.line2 then return end
	if line1 < self.line1 then
		for i = line1,self.line1-1 do
			local textField = TextField.new(self.font, self.lines[i])
			textField:setY(i * self.lineSpacing)
			---------------------- Added By Talis ------------------------------------
			-- Checking the alignment of text and formatting position according to that
			if self.align == "left" then textField:setX(0)
			elseif self.align == "right" then textField:setX(self.areaWidth-textField:getWidth())
			elseif self.align == "center" then textField:setX((self.areaWidth-textField:getWidth())/2)
			end
			-- Checking for the lines has special color or not
			if testcolor[i] == 1 then textField:setTextColor(self.color1)
			else textField:setTextColor(self.mainColor)
			end
			--------------------------------------------------------------------------
			self.innerSprite:addChild(textField)		
			self.textFields[i] = textField			
		end
	else
		for i = self.line1,line1-1 do
			self.innerSprite:removeChild(self.textFields[i])
			self.textFields[i] = nil
		end
	end
	if line2 < self.line2 then
		for i = line2+1,self.line2 do
			self.innerSprite:removeChild(self.textFields[i])
			self.textFields[i] = nil
		end
	else
		for i = self.line2+1,line2 do
			local textField = TextField.new(self.font, self.lines[i])
			textField:setY(i * self.lineSpacing)
			---------------------- Added By Talis ------------------------------------
			-- Checking the alignment of text and formatting position according to that
			if self.align == "left" then textField:setX(0)
			elseif self.align == "right" then textField:setX(self.areaWidth-textField:getWidth())
			elseif self.align == "center" then textField:setX((self.areaWidth-textField:getWidth())/2)
			end
			-- Checking for the lines has special color or not
			if testcolor[i] == 1 then textField:setTextColor(self.color1)
			else textField:setTextColor(self.mainColor)
			end
			--------------------------------------------------------------------------
			self.innerSprite:addChild(textField)		
			self.textFields[i] = textField			
		end
	end
	self.line1 = line1
	self.line2 = line2
	collectgarbage("step")
end
