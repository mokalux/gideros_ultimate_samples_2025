--require "BhPopup"
--!NEEDS:classes/BhPopup.lua

-- Simple popup to display an animal graphic and it's name

AnimalPopup=Core.class(BhPopup)

local w, h=application:getContentWidth(), application:getContentHeight()

function AnimalPopup:onMouseUp(event)
	-- Close the popup on any touch inside
	if self:hitTestPoint(event.x, event.y) then
		self:exit()
	end
	event:stopPropagation()
end

function AnimalPopup:init(options, name)
	local bg=Bitmap.new(myTexturePack:getTextureRegion("PopupBackground.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(w/2, h/2)
	bg:setAlpha(0.8)
	self:addChild(bg)	
	
	local image=Bitmap.new(myTexturePack:getTextureRegion(name..".png"))
	image:setAnchorPoint(0.5, 0.5)
	image:setPosition(w/2, h/2)
	self:addChild(image)
	
	local text=TextField.new(TTFont.new("fonts/KenVector Future.ttf", 50), "This is a "..name)
	text:setPosition((w-text:getWidth())/2, h/2+210)
	text:setTextColor(0xffffff)
	self:addChild(text)
	
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end
