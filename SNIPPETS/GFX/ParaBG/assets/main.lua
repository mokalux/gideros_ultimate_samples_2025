--[[
	This code provides an example of how to use the ParaBG class.
		
	Please feel to use this code in your projects and games etc. 
]]

-- Set some default application settings to make sure it's the 
-- same for everyone.
application:setKeepAwake(true)
application:setOrientation("landscapeLeft")
application:setLogicalDimensions(320, 480)

-- Setup background images to use.
local bgs = {
	bg1 = "bg1.png",
	bg2 = "bg2.png"
}
	
-- Create a new Parallax background sprite with a speed of 5
local bg = ParaBG.new(bgs, 1)

-- Add background to scene--should be done before any 
-- sprites/controls so it's behind everything.
stage:addChild(bg)