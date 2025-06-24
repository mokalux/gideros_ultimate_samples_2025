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

anchorPointX = .5
anchorPointY = .5

application:setKeepAwake(true)
application:setBackgroundColor(0x122F57)
math.randomseed(os.timer())

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))

local ballTexture = Texture.new("ball.png", true)

local boxSprite1 = Bitmap.new(ballTexture)
local boxSprite2 = Bitmap.new(ballTexture)

local playerA = TTestObject.new(boxSprite1)
local playerB = TTestObject.new(boxSprite2)

local circleToCircle = tntCollision.circleToCircle

logo:setPosition(0,0)
stage:addChild(logo)

playerA:setScale(1.5)

stage:addChild(playerA)
stage:addChild(playerB)

tntCollision.setCollisionAnchorPoint(anchorPointX, anchorPointY)

local function onEnterFrame(event)
	if circleToCircle(playerA.xPos, playerA.yPos, 64*1.5,  playerB.xPos, playerB.yPos, 64) then
		playerA:setAlpha(.3)
		playerB:setAlpha(.3)
	else
		playerA:setAlpha(1)
		playerB:setAlpha(1)
	end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)