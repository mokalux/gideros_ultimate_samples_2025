local defaultPadParams = {
	margin = 0,
	innerMargin = 0,
	color = 0,
}
local defaultButtonParams = {
	baseW = 0, baseH = 0,
	bgColor = 0, 
	txtColor = 0, 
	text = "", name = "", 
	margin = 0,
	gridwidth = 1, gridheight = 1,
	offsetX = 0, offsetY = 0,
	scaleX = 1, scaleY = 1
}


Pad = Core.class(Sprite)

-- params (table):
--		w (number): pixel width of the pad
--		h (number): pixel height of the pad
--		rows (number): number of rows 
--		columns (number): number of columns
--		texture (Texture): nine patch texture [optional]
--		color (number): pad color [default: black]
--		margin (number): margin (same for each side) [default: 0]
--		innerMargin (number): button margin [default: 0]
function Pad:init(params)
	-----------------------------------------
	---------- INITIALIZE LAYOUT ------------ 
	-----------------------------------------
	params = params or {}
	append(params, defaultPadParams)
	self.innerMargin = params.innerMargin
	
	-- calculate layout base cell size
	self.baseW = ((params.w - params.margin * 2) / params.columns) - 2*self.innerMargin
	self.baseH = ((params.h - params.margin * 2) / params.rows) - 2*self.innerMargin
	
	local columnWeights = {}
	local rowWeights = {}
	local columnWidths = {}
	local rowHeights = {}
	
	for i = 1, params.columns do 
		columnWeights[i] = 1
		columnWidths[i] = self.baseW
	end
	for i = 1, params.rows do 
		rowWeights[i] = 1
		rowHeights[i] = self.baseH
	end
	
	self.padHolder = Pixel.new(params.color, 1, params.w, params.h)
	if (params.texture) then 
		self.padHolder:setTexture(params.texture)
		self.padHolder:setNinePatch(16)
	end
	self.padHolder:setLayoutParameters{
		columnWeights = columnWeights,
		rowWeights = rowWeights,
		columnWidths = columnWidths,
		rowHeights = rowHeights,
		insetTop = params.margin,
		insetLeft = params.margin,
		insetBottom = params.margin,
		insetRight = params.margin,
	}
	self:addChild(self.padHolder)
	-----------------------------------------
	-----------------------------------------
	-----------------------------------------
	
	-- buttons container
	self.buttons = {}
	-- event to dispatch 
	self.__evt = Event.new("click")
	-- first touch id (to prevent multitouch)
	self.first_id = -1
	-- button that was touched in "touchBegin" event
	self.touchedBtn = nil
	
	self:addEventListener(Event.TOUCHES_BEGIN, self.touchBegin, self)
	self:addEventListener(Event.TOUCHES_END, self.touchEnd, self)
end
-- Add button to pad
-- params (table): 
--		x, y (number): The 0-based indexes of the column/row the button must be placed into
--		gridwidth (number): The number of column this button will take [default: 1]
--		gridheight (number): The number of row this button will take [default: 1]
--		button params (see Button.lua)
function Pad:addButton(params)
	params = params or {}
	append(params, defaultButtonParams)
	
	-- calculate correct size for button depending on gridwidth and gridheight
	params.w = (self.baseW*params.gridwidth) + (params.gridwidth-1)*(self.innerMargin*2)
	params.h = (self.baseH*params.gridheight) + (params.gridheight-1)*(self.innerMargin*2)
	
	-- create button 
	local p = Button.new(params)
	-- setup layout constraints
	p:setLayoutConstraints{
		gridx = params.x,
		gridy = params.y,
		gridwidth = params.gridwidth,
		gridheight = params.gridheight,
		anchor = Sprite.LAYOUT_ANCHOR_CENTER,
		fill = Sprite.LAYOUT_FILL_BOTH,
		insetTop = self.innerMargin,
		insetLeft = self.innerMargin,
		insetBottom = self.innerMargin,
		insetRight = self.innerMargin,
	}
	-- add button to list
	self.buttons[#self.buttons+1] = p
	-- add button to pad
	self.padHolder:addChild(p)
end

function Pad:touchBegin(e)
	-- disable mutitouch
	if (self.first_id == -1) then
		local x, y = e.touch.x, e.touch.y
		self.first_id = e.touch.id
		-- chech if button clicked
		for i,b in ipairs(self.buttons) do 
			if (b:hitTestPoint(x, y)) then 
				self.touchedBtn = b
				break
			end
		end
	end
end

function Pad:touchEnd(e)
	if (self.first_id == e.touch.id) then
		local x, y = e.touch.x, e.touch.y
		self.first_id = -1
		if (self.touchedBtn and self.touchedBtn:hitTestPoint(x, y)) then
			self.__evt.name = self.touchedBtn.name
			self.__evt.text = self.touchedBtn:getText()
			self:dispatchEvent(self.__evt)
		end
		self.touchedBtn = nil
	end
end
