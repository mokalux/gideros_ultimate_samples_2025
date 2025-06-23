--[[
ButtonTextP9UDDT
A Button class with text, Pixel, images 9patch (Up, Down, Disabled) and Tooltip
This code is CC0
github: mokalux
v 0.1.5: 2020-08-25 replaced font params with ttf params for better control
v 0.1.41: 2020-08-19 added tooltip text scale and color
v 0.1.4: 2020-06-08 removed useless variables + the class was somehow broken :/
v 0.1.3: 2020-03-30 added tooltiptext
v 0.1.2: 2020-03-29 added nine patch
v 0.1.1: 2020-03-28 added pixel
v 0.1.0: 2020-03-28 init (based on the initial gideros generic button class)
]]
ButtonTextP9UDDT = Core.class(Sprite)

function ButtonTextP9UDDT:init(xparams)
	-- the params table
	self.params = xparams or {}
	-- pixel?
	self.params.pixelcolorup = xparams.pixelcolorup or nil -- color
	self.params.pixelcolordown = xparams.pixelcolordown or self.params.pixelcolorup -- color
	self.params.pixelcolordisabled = xparams.pixelcolordisabled or 0x555555 -- color
	self.params.pixelalpha = xparams.pixelalpha or 1 -- number
	self.params.pixelscalex = xparams.pixelscalex or 1 -- number
	self.params.pixelscaley = xparams.pixelscaley or 1 -- number
	self.params.pixelpaddingx = xparams.pixelpaddingx or 12 -- number
	self.params.pixelpaddingy = xparams.pixelpaddingy or 12 -- number
	-- textures?
	self.params.imgup = xparams.imgup or nil -- img up path
	self.params.imgdown = xparams.imgdown or self.params.imgup -- img down path
	self.params.imgdisabled = xparams.imgdisabled or self.params.imgup -- img disabled path
	self.params.imagealpha = xparams.imagealpha or 1 -- number
	self.params.imgscalex = xparams.imgscalex or 1 -- number
	self.params.imgscaley = xparams.imgscaley or 1 -- number
	self.params.imagepaddingx = xparams.imagepaddingx or nil -- number (nil = auto, the image width)
	self.params.imagepaddingy = xparams.imagepaddingy or nil -- number (nil = auto, the image height)
	-- text?
	self.params.text = xparams.text or nil -- string
	self.params.ttf = xparams.ttf or nil -- ttf
	self.params.textcolorup = xparams.textcolorup or 0x0 -- color
	self.params.textcolordown = xparams.textcolordown or self.params.textcolorup -- color
	self.params.textcolordisabled = xparams.textcolordisabled or 0x777777 -- color
	self.params.textscalex = xparams.textscalex or 1 -- number
	self.params.textscaley = xparams.textscaley or self.params.textscalex -- number
	-- EXTRAS
	self.params.isautoscale = xparams.isautoscale or 1 -- number (default 1 = true)
	self.params.hover = xparams.hover or 0 -- number (default 0 = false)
	self.params.defaultpadding = xparams.defaultpadding or 12 -- number
	self.params.tooltiptext = xparams.tooltiptext or nil -- string
	self.params.tooltiptextscale = xparams.tooltiptextscale or 2
	self.params.tooltiptextcolor = xparams.tooltiptextcolor or 0x0
	-- LET'S GO!
	if self.params.isautoscale == 0 then self.params.isautoscale = false else self.params.isautoscale = true end
	if self.params.hover == 0 then self.params.hover = false else self.params.hover = true end
	-- warnings
	if not self.params.imgup and not self.params.imgdown and not self.params.imgdisabled
		and not self.params.pixelcolorup and not self.params.text and not self.params.tooltiptext then
		print("*** WARNING: YOUR BUTTON IS EMPTY! ***")
	else
		-- draws a pixel around the button to catch the mouse leaving the button
		self.catcher = Pixel.new(0x0, 0.25, 1, 1)
		self:addChild(self.catcher)
		-- button sprite holder
		self.sprite = Sprite.new()
		self:addChild(self.sprite)
		self:setButton()
	end
	-- update visual state
	self.focus = false
	self.disabled = false
	self:updateVisualState(false)
	-- event listeners
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.MOUSE_HOVER, self.onMouseHover, self)
	if not self.params.hover and not self.params.tooltiptext then
--		print("*** no mouse hover effect ***")
		self:removeEventListener(Event.MOUSE_HOVER, self.onMouseHover, self)
	end
end

-- FUNCTIONS
function ButtonTextP9UDDT:setText(xtext)
	local textwidth, textheight
	local bmps = {}
	self.text:setText(xtext)
	self.text:setAnchorPoint(0.5, 0.5)
	textwidth, textheight = self.text:getWidth(), self.text:getHeight()
	-- pixel
	if self.params.pixelcolorup or self.params.pixelcolordown then
		self.pixel:setDimensions(textwidth + self.params.pixelpaddingx, textheight + self.params.pixelpaddingy)
		self.pixel:setAnchorPoint(0.5, 0.5)
		self.pixel:setAlpha(self.params.pixelalpha)
	end
	-- then images
	if self.params.imgup then
		local texup = Texture.new(self.params.imgup)
		if self.params.isautoscale and self.params.text then
			self.bmpup = Pixel.new(texup,
				textwidth + (self.params.imagepaddingx or self.params.defaultpadding),
				textheight + (self.params.imagepaddingy or self.params.defaultpadding))
		else
			self.bmpup = Pixel.new(texup, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpup] = 1
	end
	if self.params.imgup then
		local texdown = Texture.new(self.params.imgdown)
		if self.params.isautoscale and self.params.text then
			self.bmpdown = Pixel.new(texdown,
				textwidth + (self.params.imagepaddingx or self.params.defaultpadding),
				textheight + (self.params.imagepaddingy or self.params.defaultpadding))
		else
			self.bmpdown = Pixel.new(texdown, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpdown] = 2
	end
	if self.params.imgup then
		local texdisabled = Texture.new(self.params.imgdisabled)
		if self.params.isautoscale and self.params.text then
			self.bmpdisabled = Pixel.new(texdisabled,
				textwidth + (self.params.imagepaddingx or self.params.defaultpadding),
				textheight + (self.params.imagepaddingy or self.params.defaultpadding))
		else
			self.bmpdisabled = Pixel.new(texdisabled, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpdisabled] = 3
	end
	-- image batch
	for k, _ in pairs(bmps) do
		k:setAnchorPoint(0.5, 0.5)
		k:setAlpha(self.params.imagealpha)
		local split = 9 -- magik number
		k:setNinePatch(math.floor(k:getWidth()/split), math.floor(k:getWidth()/split),
			math.floor(k:getHeight()/split), math.floor(k:getHeight()/split))
		self.sprite:addChild(k)
	end
	-- finally add text on top of all
	if self.params.text then self.sprite:addChild(self.text) end
	-- fit the mouse catcher a little bigger than the button
	self.catcher:setDimensions(self.sprite:getWidth() + 8 * 2.5, self.sprite:getHeight() + 8 * 2.5) -- magik
	self.catcher:setAnchorPoint(0.5, 0.5)
end

function ButtonTextP9UDDT:setButton()
	local textwidth, textheight
	local bmps = {}
	-- text
	if self.params.text then
		self.text = TextField.new(self.params.ttf, self.params.text, self.params.text)
		self.text:setAnchorPoint(0.5, 0.5)
		self.text:setScale(self.params.textscalex, self.params.textscaley)
		self.text:setTextColor(self.params.textcolorup)
		textwidth, textheight = self.text:getWidth(), self.text:getHeight()
	end
	-- first add pixel
	if self.params.pixelcolorup then
		if self.params.isautoscale and self.params.text then
			self.pixel = Pixel.new(
				self.params.pixelcolor, self.params.pixelalpha,
				textwidth + self.params.pixelpaddingx,
				textheight + self.params.pixelpaddingy)
		else
			self.pixel = Pixel.new(
				self.params.pixelcolor, self.params.pixelalpha,
				self.params.pixelpaddingx,
				self.params.pixelpaddingy)
		end
		self.pixel:setAnchorPoint(0.5, 0.5)
		self.pixel:setAlpha(self.params.pixelalpha)
		self.pixel:setScale(self.params.pixelscalex, self.params.pixelscaley)
		self.sprite:addChild(self.pixel)
	end
	-- then images
	if self.params.imgup then
		local texup = Texture.new(self.params.imgup)
		if self.params.isautoscale and self.params.text then
			self.bmpup = Pixel.new(texup,
				textwidth + (self.params.imagepaddingx or self.params.defaultpadding),
				textheight + (self.params.imagepaddingy or self.params.defaultpadding))
		else
			self.bmpup = Pixel.new(texup, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpup] = 1
	end
	if self.params.imgdown then
		local texdown = Texture.new(self.params.imgdown)
		if self.params.isautoscale and self.params.text then
			self.bmpdown = Pixel.new(texdown,
				textwidth + (self.params.imagepaddingx or self.params.defaultpadding),
				textheight + (self.params.imagepaddingy or self.params.defaultpadding))
		else
			self.bmpdown = Pixel.new(texdown, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpdown] = 2
	end
	if self.params.imgdisabled then
		local texdisabled = Texture.new(self.params.imgdisabled)
		if self.params.isautoscale and self.params.text then
			self.bmpdisabled = Pixel.new(texdisabled,
				textwidth + (self.params.imagepaddingx or self.params.defaultpadding),
				textheight + (self.params.imagepaddingy or self.params.defaultpadding))
		else
			self.bmpdisabled = Pixel.new(texdisabled, self.params.imagepaddingx, self.params.imagepaddingy)
		end
		bmps[self.bmpdisabled] = 3
	end
	-- image batch
	for k, _ in pairs(bmps) do
		k:setAnchorPoint(0.5, 0.5)
		k:setAlpha(self.params.imagealpha)
		local split = 9 -- magik number
		k:setNinePatch(math.floor(k:getWidth()/split), math.floor(k:getWidth()/split),
			math.floor(k:getHeight()/split), math.floor(k:getHeight()/split))
		self.sprite:addChild(k)
	end
	-- finally add text on top of all
	if self.params.text then self.sprite:addChild(self.text) end
	-- and the tooltip text
	if self.params.tooltiptext then
		self.tooltiptext = TextField.new(nil, self.params.tooltiptext)
		self.tooltiptext:setAnchorPoint(0.3, -2)
		self.tooltiptext:setScale(self.params.tooltiptextscale)
		self.tooltiptext:setTextColor(self.params.tooltiptextcolor)
		self.tooltiptext:setVisible(false)
--		self.sprite:addChild(self.tooltiptext) -- best to add here?
		self:addChild(self.tooltiptext) -- or here to self?
	end
	-- fit the mouse catcher a little bigger than the button
	self.catcher:setDimensions(self.sprite:getWidth() + 8 * 2.5, self.sprite:getHeight() + 8 * 2.5) -- magik
	self.catcher:setAnchorPoint(0.5, 0.5)
end

-- VISUAL STATE
function ButtonTextP9UDDT:updateVisualState(xstate)
	if self.disabled then -- button is disabled
		if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
		if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
		if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(true) end
		if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolordisabled) end
		if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordisabled) end
	elseif not self.params.hover and self.params.tooltiptext then -- button does not hover but has a tooltip text
		if xstate and self.isclicked then -- button down state
			if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
			if self.params.imgdown ~= nil then self.bmpdown:setVisible(true) end
			if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
			if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolordown) end
			if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordown) end
		else -- button up state
			if self.params.imgup ~= nil then self.bmpup:setVisible(true) end
			if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
			if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
			if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolorup) end
			if self.params.text ~= nil then self.text:setTextColor(self.params.textcolorup) end
		end
	else
		if xstate then -- button down state
			if self.params.imgup ~= nil then self.bmpup:setVisible(false) end
			if self.params.imgdown ~= nil then self.bmpdown:setVisible(true) end
			if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
			if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolordown) end
			if self.params.text ~= nil then self.text:setTextColor(self.params.textcolordown) end
		else -- button up state
			if self.params.imgup ~= nil then self.bmpup:setVisible(true) end
			if self.params.imgdown ~= nil then self.bmpdown:setVisible(false) end
			if self.params.imgdisabled ~= nil then self.bmpdisabled:setVisible(false) end
			if self.params.pixelcolorup ~= nil then self.pixel:setColor(self.params.pixelcolorup) end
			if self.params.text ~= nil then self.text:setTextColor(self.params.textcolorup) end
		end
	end

--	if self.params.tooltiptext and not self.disabled then -- you can choose this option: hides to tooltip when button is disabled
	if self.params.tooltiptext then -- or this option: shows the tooltip even when button is disabled
		if xstate then -- button hover state
			if self.disabled then
				self.tooltiptext:setText("( "..self.params.tooltiptext.." )")
			else
				self.tooltiptext:setText(self.params.tooltiptext)
			end
			self.tooltiptext:setVisible(true)
		else -- button no hover state
			self.tooltiptext:setText("")
			self.tooltiptext:setVisible(false)
		end
	end
end

-- disabled
function ButtonTextP9UDDT:setDisabled(xdisabled)
	if self.disabled == xdisabled then return end
	self.disabled = xdisabled
	self.focus = false
	self:updateVisualState(false)
end

function ButtonTextP9UDDT:isDisabled()
	return self.disabled
end

-- MOUSE LISTENERS
function ButtonTextP9UDDT:onMouseDown(e)
	if self:hitTestPoint(e.x, e.y) and self:getParent():isVisible() then
		self.focus = true
		self.isclicked = true -- 200608
		self:updateVisualState(true)
		e:stopPropagation()
	end
end
function ButtonTextP9UDDT:onMouseMove(e)
	if self:hitTestPoint(e.x, e.y) and self:getParent():isVisible() then
		self.focus = true
--		self.isclicked = false -- 200608 to delete
--		e:stopPropagation() -- 20200820 to delete: prevents hover effect
	else
		self.focus = false
--		e:stopPropagation() -- you may want to remove this line
	end
	self:updateVisualState(self.focus)
end
function ButtonTextP9UDDT:onMouseUp(e)
	if self.focus and self.isclicked then
		self.focus = false
		self.isclicked = false -- 200608
		if not self.disabled then
			self:dispatchEvent(Event.new("click")) -- button is clicked
		end
		e:stopPropagation()
	end
end
function ButtonTextP9UDDT:onMouseHover(e)
	if self.catcher:hitTestPoint(e.x, e.y) and self.catcher:isVisible() then
		self.focus = false
	end
	if self.sprite:hitTestPoint(e.x, e.y) and self.sprite:isVisible() then
		if self.params.tooltiptext then self.tooltiptext:setPosition(self.sprite:globalToLocal(e.x, e.y)) end
		self.focus = true
	end
	self:updateVisualState(self.focus)
end

--[[
-- SAMPLE
	-- BUTTON QUIT
	local mybtnquit = ButtonTextP9UDDT.new({
		pixelcolorup=0x0, pixelpaddingx=3, pixelpaddingy=3,
		text="QUIT", ttf=mycompositefont,
		textcolorup=0xffffff, textcolordown=0xff00ff,
		hover=true,
	})
	mybtnquit:setPosition(64, 64)
	stage:addChild(mybtnquit)
	mybtnquit:addEventListener("click", function() self:goExit() end)
	mybtnquit:setDisabled(true)
]]
