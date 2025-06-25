--[[
    Script:  spotlight
	Description: Show how to create an animated spot light of the Gideros logo
	Author:  Michael Hartlef
	Contact: mike@fantomgl.com
--]]

-- Load the mask images (can be a gradient or a plain image)
--local mask = Bitmap.new(Texture.new("images/maskCircle2.png")) -- semi-transparent
local mask = Bitmap.new(Texture.new("images/carmo.png")) -- plain image
-- Set its anchor point in the center
mask:setAnchorPoint(0.5, 0.5)
-- Scale it up by a factor of 3
mask:setScale(3)
-- change alpha
mask:setAlpha(2)
-- Position the mask in the middle of the simulator
mask:setPosition(application:getLogicalHeight()/2,application:getLogicalWidth()/2)
-- Set its speed and direction values
mask.speedX = 2
mask.speedY = 1
mask.dirX=1
mask.dirY=1
--Add the mask to the stage
stage:addChild(mask)

--Now load the logo image
local logo = Bitmap.new(Texture.new("images/carmo.png"))
-- Set its anchor point to the center
logo:setAnchorPoint(0.5, 0.5)
-- Scale it down to a half
logo:setScale(10)
-- Position the logo in the middle of the simulator
logo:setPosition(application:getLogicalHeight()/2,application:getLogicalWidth()/2)
--Now set the blend mode
logo:setBlendMode(Sprite.MULTIPLY)
-- Add the logo to the stage
stage:addChild(logo)

-- Set the background color of the stage to black (you can experiment)
stage:setBackgroundColor(0.07, 0.07, 0.07) -- r, g, b

-- Define the onEnterFrame event function. This deals with the positioning of the mask
function onEnterFrame(event)
	-- Get the position of the maks
	local x, y = mask:getPosition()
	-- Calculate the new position
	x += (mask.speedX * mask.dirX)
	y += (mask.speedY * mask.dirY)
	-- Check if the mask reaches the edges of the canvas and then mirror its movement.
	if x < 0 then mask.dirX = 1 end
	if x > application:getLogicalHeight() then mask.dirX = -1 end
	if y < 0 then mask.dirY = 1 end
	if y > application:getLogicalWidth() then mask.dirY = -1 end
	-- Set the new position of the mask
	mask:setPosition(x,y)
end

-- Register an enterFrame event handler function
stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
