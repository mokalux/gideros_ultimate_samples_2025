--[[
*************************************************************
 * This script is developed by Scouser, it uses modules 
 * created by other developers but I have made minor / subtle
 * changes to get the effects I required.
 * Feel free to distribute and modify code, 
 * but keep reference to its creator
**************************************************************
]]--

splineScreen = Core.class(Sprite)

local imgBase = getImgBase()
local ctrlPointTexture = Texture.new(imgBase.."ctrllevel.png")
local subPointTexture = Texture.new(imgBase.."sublevel.png")

local onCtrlPointTexture = Texture.new(imgBase.."onCtrllevel.png")
local onSubPointTexture = Texture.new(imgBase.."onlevel.png")

-- X,Y coordinate pairs (minimum of 4 required for a CRS)
--local ctrlPoints = {
--	240*1.5,300*1.5,
--	20*1.5,300*1.5,
--	150*1.5,95*1.5,
--	300*1.5,220*1.5,
--	460*1.5,20*1.5,
--	240*1.5,20*1.5
--}
local ctrlPoints = {
	16*2,16*2,
	128*2,16*2,
	64*2,64*2,
	128*2,128*2,
	64*2,128*2,
	32*2,64*2
}

local count = 0
local level = 1
local delay = 10
local levelPath = 0
local numPoints = 0

local selectedSub
local selectedCtrl

function splineScreen:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new(imgBase.."opt_back.png"))
	self:addChild(screen)
	screen:setPosition(0,0)
	count = 0
	
	levelPath = catmullRomSpline.new(ctrlPoints, #ctrlPoints/2, 1/10, true)
	numPoints = levelPath:getNumPoints()

	print("Created "..numPoints.." points in path")

	local point
	local img
	local bmp

	for i=1, numPoints do
		point = levelPath:getPoint(i)
		if point.bIsCtrl then img = ctrlPointTexture
		else img = subPointTexture
		end
		bmp = Bitmap.new(img)
		bmp:setAnchorPoint(0.5, 0.5)
		bmp:setPosition(point.x, point.y)
		levelPath:setImage(i, bmp)
		self:addChild(bmp)
	end
	
	selectedCtrl = Bitmap.new(onCtrlPointTexture)
	selectedSub = Bitmap.new(onSubPointTexture)
	selectedCtrl:setAnchorPoint(0.5, 0.5)
	selectedSub:setAnchorPoint(0.5, 0.5)
	
	self:setLevel(1)
	
	self:removeEventListener("exitEnd", self.onExitEnd)
	
	self:addEventListener(Event.ENTER_FRAME, self.frameStart, self)
end


-- Let's get rid of all of the elements shall we. This is strictly not required
-- but I thought I'd put it in for completeness
function splineScreen:onExitEnd()
	self:removeEventListener(Event.ENTER_FRAME, self.frameStart, self)
	self:removeEventListener("exitEnd", self.onExitEnd)
	collectgarbage()
end

function splineScreen:setLevel(level)
	local point = levelPath:getPoint(level)
	local bmp
	
	if point.bIsCtrl then bmp = selectedCtrl
	else bmp = selectedSub
	end
	
	bmp:setPosition(point.x, point.y)
	self:addChild(bmp)
end

function splineScreen:clrLevel(level)
	local point = levelPath:getPoint(level)
	local bmp = selectedCtrl
	if point.bIsCtrl then bmp = selectedCtrl
	else bmp = selectedSub
	end
	self:removeChild(bmp)
end


function splineScreen:frameStart()
	count = count + 1
	if count > delay then 
		count = 0
		self:clrLevel(level)
		level = level + 1
		if level > numPoints then level = 1 end
		self:setLevel(level)
	end
end
