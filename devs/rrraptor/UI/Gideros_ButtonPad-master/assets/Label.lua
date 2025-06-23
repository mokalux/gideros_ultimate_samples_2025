--Centered textfiled

local sw = application:getContentWidth()

Label = Core.class(Sprite)

function Label:init(font, text, color, x, y, scaleX, scaleY)
	
	self.text = TextField.new(font, text)
	self.text:setLayout({flags = FontBase.TLF_REF_TOP|FontBase.TLF_CENTER, w = sw})
	self.text:setScale(scaleX, scaleY)
	self.text:setTextColor(color)
	self:addChild(self.text)
	
	self:setAnchorPosition((sw/2) * scaleX, 0)
	self:setPosition(x, y)
end

function Label:updateText(text)
	self.text:setText(text)
end