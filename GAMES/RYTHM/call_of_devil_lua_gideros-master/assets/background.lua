Background = Background or Core.class(Sprite)

--[[
	level 

--]]

function Background:init(options)
	
	local level = options.level
	
	local bg = Bitmap.new(Texture.new("assets/images/background.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setScale(1.15, 1)
	bg:setPosition(level.level_width/2, level.level_height/2)
	
	application:setBackgroundColor(0x39414f)
	
	self:addChild(bg)
	
end