-- ######################################## --
-- TNT Collision v1.00                      --
-- Copyright (C) 2012 By Gianluca D'Angelo  --
-- All right Reserved.                      --
-- YOU CAN USE IN FREE OR COMMERCIAL GAMES  --
-- PLEASE DONATE TO KEEP THIS PROJECT ALIVE --
-- ---------------------------------------- --
-- for bug, tips, suggestion contact me at  --
-- gregbug@gmail.com or                     --
-- support@tntparticlesengine.com           --
-- ---------------------------------------- --
-- coded for Gideros Mobile SDK             --
-- ######################################## --


require "tntCollision"

application:setKeepAwake(true)
application:setBackgroundColor(0x000000)
math.randomseed(os.timer())

anchorPointX = .5
anchorPointY = .5
local maxBox = 1000

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local boxTexture = Texture.new("tntBox.png")

logo:setPosition(0,0)
stage:addChild(logo)

local players = {}
for j = 1, maxBox do
	players[j] = TTestObject.new(Bitmap.new(boxTexture))
	stage:addChild(players[j] )
end

local bbCollision = tntCollision.boxToBox
tntCollision.setCollisionAnchorPoint(anchorPointX, anchorPointY)

local s, e = 0,0
local function onEnterFrame(event)
	s = os.timer()*1000
	local n=0
	for outer = 1, maxBox-1 do
		for inner = outer+1, maxBox do
		--	n=n+1
	
			local pinner = players[inner]
			local pouter = players[outer]
			if bbCollision(pinner.xPos, pinner.yPos, 46*pinner.xScale, 40*pinner.yScale,
						   pouter.xPos, pouter.yPos, 46*pouter.xScale, 40*pouter.yScale) then
						pinner.inCollision = true
						pouter.inCollision = true
			end
		
		end
	end
	--print(n.." collision checks per frame ")
	e = os.timer()*1000
	print(e-s)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)