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
application:setBackgroundColor(0x454579)
math.randomseed(os.timer())

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local boxTexture = Texture.new("tntBox.png")
local ballTexture = Texture.new("ball2.png")

local boxSprite1 = Bitmap.new(boxTexture)
local boxSprite2 = Bitmap.new(ballTexture)

local playerA = TTestObject.new(boxSprite1)
local playerB = TTestObject.new(boxSprite2)

local boxToC = tntCollision.boxToCircle

logo:setPosition(0,0)
stage:addChild(logo)

local size1X = 2
local size1Y = 2

local size2X = 4
local size2Y = 4

playerA:setScale(size1X, size1Y)
playerB:setScale(size2X, size2Y)



stage:addChild(playerA)
stage:addChild(playerB)
tntCollision.setCollisionAnchorPoint(anchorPointX, anchorPointY)

local function onEnterFrame(event)
    if boxToC(playerA.xPos, playerA.yPos, 46*size1X, 40*size1Y, playerB.xPos, playerB.yPos, 16*size2X) then
        playerA:setColorTransform(1,0,0)
        playerB:setColorTransform(1,0,0)
    else
        playerA:setColorTransform(1,1,1)
        playerB:setColorTransform(1,1,1)
    end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)