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
local size1X = 1
local size1Y = 1.3

local size2X = 1.6
local size2Y = 1


application:setKeepAwake(true)
application:setBackgroundColor(0x454579)
math.randomseed(os.timer())

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local boxTexture = Texture.new("tntBox2.png")

local boxSprite1 = Bitmap.new(boxTexture)
local boxSprite2 = Bitmap.new(boxTexture)

local playerA = TTestObject.new(boxSprite1)
local playerB = TTestObject.new(boxSprite2)

local boxToBox = tntCollision.boxToBox

logo:setPosition(0,0)
stage:addChild(logo)

playerA:setScale(size1X, size1Y)
playerB:setScale(size2X, size2Y)

playerA:setPosition(0,0)
stage:addChild(playerA)
stage:addChild(playerB)
tntCollision.setCollisionAnchorPoint(anchorPointX, anchorPointY)

local function onEnterFrame(event)
	if boxToBox(playerA.xPos, playerA.yPos, 128*size1X, 128*size1Y,
	            playerB.xPos, playerB.yPos, 128*size2X, 128*size2Y) then
		playerA:setColorTransform(1,0,0)
		playerB:setColorTransform(1,0,0)
	else
		playerA:setColorTransform(1,1,1)
		playerB:setColorTransform(1,1,1)
	end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)