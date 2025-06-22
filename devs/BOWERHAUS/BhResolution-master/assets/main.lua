
local cw, ch=application:getContentWidth(), application:getContentHeight()
local lw, lh=application:getLogicalWidth(), application:getLogicalHeight()

-- Load up background
bg=Bitmap.new(Texture.new("Images/bg.png"), true)
bg:setAnchorPoint(0.5, 0.5)
bg:setPosition(cw/2, ch/2)
if cw>ch then
	bg:setRotation(90)
end
stage:addChild(bg)

-- And asset
asset=Bitmap.new(Texture.new("Images/asset.png"), true)
asset:setAnchorPoint(0.5, 0.5)
asset:setPosition(cw/2, 250)
stage:addChild(asset)

function placeMarker(x, y, txo, tyo, fmt, color)
	txo=txo or 60
	tyo=tyo or 20

	local text=string.format(fmt or "(%s,%s)", x, y)
	local marker=Sprite.new()
	local pointer=Shape.new()
	pointer:beginPath()
	pointer:setLineStyle(2, color)
	pointer:moveTo(x, y)
	pointer:lineTo(x+tyo/2, y+tyo)
	pointer:lineTo(x+txo, y+tyo)
	pointer:endPath()
	marker:addChild(pointer)

	local font=TTFont.new("Tahoma.ttf", 24, true)
	local txt=TextField.new(font, text)
	local textx=x+txo
	if txo<0 then
		textx=x+txo-txt:getWidth()
	end
	local texty=y+tyo+txt:getHeight()/3
	txt:setPosition(textx, texty)
	marker:addChild(txt)
	stage:addChild(marker)
end

placeMarker(0, 0)
placeMarker(100, 100)
placeMarker(cw/2, ch/2, -80, -60, "contentC(%s, %s)")
placeMarker(cw, ch, -80, -100, "contentWH(%s, %s)")
placeMarker(cw/2, 250, 120, 60)