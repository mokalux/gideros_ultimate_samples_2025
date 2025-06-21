--[[
*************************************************************
* This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
* Feel free to distribute and modify code, but keep reference to its creator
*
* StarRating provides a way to display rating using stars or any other custom image, 
* or provide an input for users to rate your app/content
*
* For more information, examples and online documentation visit: 
* http://appcodingeasy.com/Gideros-Mobile/Star-rating-for-Gideros-Mobile
**************************************************************
]]--

StarRating = gideros.class(Sprite)

function StarRating:init(config)
	-- settings
	self.conf = {
		empty = "images/empty.png",
		full = "images/full.png",
		maxRating = 5
	}
	
	--copy configuration
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key]= value
		end
	end
	
	self.conf.empty = Texture.new(self.conf.empty, true, {wrap = Texture.REPEAT})
	self.conf.full = Texture.new(self.conf.full, true, {wrap = Texture.REPEAT})
	
	local height = self.conf.empty:getHeight()
	local width = self.conf.empty:getWidth()*self.conf.maxRating

	self.empty = Shape.new()
	self.empty:setFillStyle(Shape.TEXTURE, self.conf.empty)
	self.empty:beginPath()
	self.empty:moveTo(0,0)
	self.empty:lineTo(width,0)
	self.empty:lineTo(width,height)
	self.empty:lineTo(0,height)
	self.empty:lineTo(0,0)
	self.empty:endPath()
	self.empty:setPosition(0,0)
	
	self.full = Shape.new()
	self.full:setFillStyle(Shape.TEXTURE, self.conf.full)
	self.full:setPosition(0,0)
	
end

function StarRating:rate(callback)
	if not self:contains(self.empty) then
		self:addChild(self.empty)
	end
	
	--redraw stars on mouse down
	local function onMouseDown(e)
		if self:hitTestPoint(e.x, e.y) and not self.rated then
			self.full:clear()
			self.full:setFillStyle(Shape.TEXTURE, self.conf.full)
			local x, y = self:globalToLocal(e.x, e.y)
			local width = math.ceil(e.x/self.conf.empty:getWidth())*self.conf.empty:getWidth()
			local height = self:getHeight()
			self.full:beginPath()
			self.full:moveTo(0,0)
			self.full:lineTo(width,0)
			self.full:lineTo(width,height)
			self.full:lineTo(0,height)
			self.full:lineTo(0,0)
			self.full:endPath()
			if not self:contains(self.full) then
				self:addChild(self.full)
			end
		end
	end
	self:addEventListener(Event.MOUSE_DOWN, onMouseDown)
	
	--redraw stars on mouse move
	local function onMouseMove(e)
		if self:hitTestPoint(e.x, e.y) and not self.rated then
			self.full:clear()
			self.full:setFillStyle(Shape.TEXTURE, self.conf.full)
			local x, y = self:globalToLocal(e.x, e.y)
			local width = math.ceil(e.x/self.conf.empty:getWidth())*self.conf.empty:getWidth()
			local height = self:getHeight()
			self.full:beginPath()
			self.full:moveTo(0,0)
			self.full:lineTo(width,0)
			self.full:lineTo(width,height)
			self.full:lineTo(0,height)
			self.full:lineTo(0,0)
			self.full:endPath()
			if not self:contains(self.full) then
				self:addChild(self.full)
			end
		end
	end
	self:addEventListener(Event.MOUSE_MOVE, onMouseMove)
	
	--rate on mouse up
	local function onMouseUp(e)
		if self:hitTestPoint(e.x, e.y) and not self.rated then
			local x, y = self:globalToLocal(e.x, e.y)
			local rating = math.ceil(e.x/self.conf.empty:getWidth())
			self.rated = true
			if callback then
				callback(rating)
			end
		end
	end
	self:addEventListener(Event.MOUSE_UP, onMouseUp)
end

function StarRating:reset()
	self.rated = false
end

function StarRating:clear()
	self:reset()
	self.full:clear()
end

function StarRating:display(rating)
	if not self:contains(self.empty) then
		self:addChild(self.empty)
	end
	
	self.full:clear()
	self.full:setFillStyle(Shape.TEXTURE, self.conf.full)
	local width = math.floor((rating/self.conf.maxRating)*self:getWidth()+0.5)
	local height = self:getHeight()
	self.full:beginPath()
	self.full:moveTo(0,0)
	self.full:lineTo(width,0)
	self.full:lineTo(width,height)
	self.full:lineTo(0,height)
	self.full:lineTo(0,0)
	self.full:endPath()
	if not self:contains(self.full) then
		self:addChild(self.full)
	end
end
