--[[
	TEXTFIELD EXTENSIONS
]]--

--[[ Completely overriding TextField ]]--

_TextField = TextField

TextField = Core.class(Sprite)

function TextField:init(...)
	local arg = {...}
	self._text = _TextField.new(...)
	self:addChild(self._text)
	self._font = arg[1]
	self._offsetX = 0
	self._offsetY = 0
	
	--local baseX, baseY = self._text:getBounds(stage)
	--self._text:setPosition(-baseX, -baseY)
end

function TextField:setText(...)
	self._text:setText(...)
	if self._shadow then
		self._shadow:setText(...)
	end
	return self
end

function TextField:getText()
	return self._text:getText()
end

function TextField:setTextColor(...)
	self._text:setTextColor(...)
	if self._shadow then
		self._shadow:setTextColor(...)
	end
	return self
end

function TextField:getTextColor()
	return self._text:getTextColor()
end

function TextField:setLetterSpacing(...)
	self._text:setLetterSpacing(...)
	if self._shadow then
		self._shadow:setLetterSpacing(...)
	end
	return self
end

function TextField:getLetterSpacing()
	return self._text:getLetterSpacing()
end

--[[ shadow implementation ]]--

function TextField:setShadow(offX, offY, color, alpha)
	if not self._shadow then
		self._shadow = _TextField.new(self._font, self._text:getText())
		self._shadow:setTextColor(self._text:getTextColor())
		self._shadow:setLetterSpacing(self._text:getLetterSpacing())
		self:addChildAt(self._shadow, 1)
	end
	
	self._shadow:setPosition(offX + self._text:getX(), offY + self._text:getY())
	
	if color then
		self._shadow:setTextColor(color)
		if alpha then
			self._shadow:setAlpha(alpha)
		end
	end
	return self
end
