--[[
*************************************************************
 * This script is developed by Scouser, it uses modules 
 * created by other developers but I have made minor / subtle
 * changes to get the effects I required.
 * Feel free to distribute and modify code, 
 * but keep reference to its creator
**************************************************************
]]--


checkBox = Core.class(Sprite)

local imgBase = getImgBase()
local font = getFont()

local chkTexture = Texture.new(imgBase.."check_tick.png")
local clrTexture = Texture.new(imgBase.."check_box.png")

function checkBox:init(tx, ty, label, col, fn)

	self.area = Sprite:new()
	self.checked = false

	local sText = TextField.new(font, label)
	sText:setPosition(tx+20,ty)
	sText:setTextColor(0xffffff);
	self.area:addChild(sText)

	self.chkSet = actionButton(chkTexture, tx, ty-28)
	self.chkClr = actionButton(clrTexture,tx, ty-28)

	self.chkSet = Bitmap.new(chkTexture)
	self.chkSet:setPosition(tx, ty-28)
	self.chkSet:setAnchorPoint(0.5, 0)
	
	self.chkClr = Bitmap.new(clrTexture)
	self.chkClr:setPosition(tx, ty-28)
	self.chkClr:setAnchorPoint(0.5, 0)
	
	self:setCheck(self.checked)
	self:addChild(self.area)
	
	self:setCol(col)

	self.callback = fn


	self.area:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self.area:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self.area:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
end

function checkBox:onExitEnd()
	self.area:removeEventListener(Event.MOUSE_UP, self.onMouseUp)
	self.area:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove)
	self.area:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown)
	collectgarbage()
end


function checkBox:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		event:stopPropagation()
	end
end

function checkBox:onMouseMove(event)
	if not self:hitTestPoint(event.x, event.y) then
		self.focus = false
	end
end

function checkBox:onMouseUp(event)
	if self.focus then
		self.focus = false
		event:stopPropagation()
		self:setCheck(not self.checked)
		if self.callback then self.callback(self) end
	end
end

function checkBox:setCheck(checked)
	self.checked = checked
	if checked then 
		if self.area:contains(self.chkClr) then self.area:removeChild(self.chkClr) end
		if not self.area:contains(self.chkSet) then self.area:addChild(self.chkSet) end
	else 
		if self.area:contains(self.chkSet) then self.area:removeChild(self.chkSet) end
		if not self.area:contains(self.chkClr) then self.area:addChild(self.chkClr) end
	end
end

function checkBox:setCol(col)
	self.area:setColorTransform(col.r, col.g, col.b, col.a)
end

function checkBox:getCheck() return self.checked end

