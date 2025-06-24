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
vx= .5
vy=.5
application:setKeepAwake(true)
application:setBackgroundColor(0x454579)
math.randomseed(os.timer())

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
logo:setPosition(0,0)
stage:addChild(logo)

local boxTexture = Texture.new("tntBox2.png")
local boxSprite1 = Bitmap.new(boxTexture)
local boxSprite2 = Bitmap.new(boxTexture)
 
local playerB = TTestObject.new(boxSprite1)
local playerA = TTestObject.new(boxSprite2)

local oBoxToObox = tntCollision.oBoxToObox

playerA:setXYScale(1,1)
playerB:setXYScale(0.5,0.5)

stage:addChild(playerA)
stage:addChild(playerB)

--playerA.m = math.random(0, 360)
--playerB.m = math.random(0, 360)

playerA.xPos = 160
playerA.yPos = 100

playerB.xPos = 160
playerB.yPos = 310

playerA:setPosition(playerA.xPos,playerA.yPos)
playerB:setPosition(playerB.xPos,playerB.yPos)

tntCollision.setCollisionAnchorPoint(vx, vy)

local function onEnterFrame(event)
	if oBoxToObox(playerA.xPos, playerA.yPos, 128* playerA.scaleX, 128* playerA.scaleY, playerA.m,
                   playerB.xPos, playerB.yPos, 128* playerB.scaleX, 128* playerB.scaleY, playerB.m) then	
		playerA:setAlpha(.3)
		playerB:setAlpha(.3)
	else
		playerA:setAlpha(1)
		playerB:setAlpha(1)
	end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)