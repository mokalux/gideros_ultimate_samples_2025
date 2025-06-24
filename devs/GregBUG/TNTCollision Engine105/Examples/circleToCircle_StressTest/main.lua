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

local maxBox = 42
local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local boxTexture = Texture.new("ball2.png")

logo:setPosition(0,0)
stage:addChild(logo)
 
local players = {}

for j = 1, maxBox do
	players[j] = TTestObject.new(Bitmap.new(boxTexture))
	stage:addChild(players[j] )
end

local ccCollision =  tntCollision.circleToCircle
local s,e = 0,0
local function onEnterFrame(event)
	--s = os.timer()*1000
	for outer = 1, maxBox-1 do
		for inner = outer+1, maxBox do
			local pinner = players[inner]
			local pouter = players[outer]
		
			if ccCollision(pinner.xPos, pinner.yPos, 16*pinner.xScale,  pouter.xPos,  pouter.yPos, 16*pouter.xScale) then
						pinner.inCollision = true
						pouter.inCollision = true
			end
		end
	end
--	e = os.timer()*1000
	
	--print(e-s)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)