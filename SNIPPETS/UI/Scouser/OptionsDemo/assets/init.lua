--[[
*************************************************************
 * This script is developed by Scouser, it uses modules 
 * created by other developers but I have made minor / subtle
 * changes to get the effects I required.
 * Feel free to distribute and modify code, 
 * but keep reference to its creator
**************************************************************
]]--

-- lock orientation that you need
stage:setOrientation(Stage.LANDSCAPE_LEFT)

appHeight = application:getLogicalWidth()
appWidth = application:getLogicalHeight()

require "misc/settings"
--local settings = settings.load()
settings.load()

local imgBase = "images/"
local fontBase = "fonts/"
local audioBase = "audio/"

local font = Font.new(fontBase.."font24.txt", fontBase.."font24.png")
getFont = function() return font end
getImgBase = function() return imgBase end

actionButton = function(tex, xp, yp)
	local bmp = Bitmap.new(tex)
	bmp:setAnchorPoint(0.5, 0)
	local newButton = Button.new(bmp)
	newButton:setPosition(xp, yp)
	return newButton;
end 
