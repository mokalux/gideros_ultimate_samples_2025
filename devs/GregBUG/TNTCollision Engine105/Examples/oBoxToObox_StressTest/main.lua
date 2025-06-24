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
local maxBox = 24

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local boxTexture = Texture.new("tntBox.png")

logo:setPosition(0,0)
stage:addChild(logo)
 
local players = {}

for j = 1, maxBox do
	players[j] = TTestObject.new(Bitmap.new(boxTexture))
	stage:addChild(players[j] )
end

tntCollision.setCollisionAnchorPoint(0.5,0.5)

local bbCollision = tntCollision.oBoxToObox
local s,e = 0,0
local function onEnterFrame(event)
--n = 0
	--s = os.timer()*1000
	for outer = 1, maxBox-1 do	
		for inner = outer+1, maxBox do
		--n=n+1
			if not ((players[inner].inCollision) and (players[outer].inCollision)) then
			--	n=n+1
			--print(players[inner].xPos)
				if bbCollision(players[inner].xPos, players[inner].yPos, players[inner].width*players[inner].scaleX, players[inner].height*players[inner].scaleY, players[inner].m,
	                    	   players[outer].xPos, players[outer].yPos, players[outer].width*players[outer].scaleY, players[outer].height*players[outer].scaleY, players[outer].m) then	
						players[inner].inCollision = true
						players[outer].inCollision = true	
				--		break
				end
			end
		end
	end
	--e = os.timer()*1000
	--print(e-s)
--print(n)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)