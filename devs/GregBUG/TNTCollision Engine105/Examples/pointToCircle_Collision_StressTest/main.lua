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

local maxPoints = 50

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local boxTexture = Texture.new("ball.png")
local pointTexture = Texture.new("point.png")
local boxSprite = Bitmap.new(boxTexture)

logo:setPosition(0,0)
stage:addChild(logo)
boxSprite:setPosition(160,240)
boxSprite:setScale(1)
boxSprite:setAnchorPoint(anchorPointX, anchorPointY)
stage:addChild(boxSprite)

local players = {}
for j = 1, maxPoints do
	players[j] = TTestObject.new(Bitmap.new(pointTexture))
	stage:addChild(players[j] )
end

--local bbCollision = tntCollision.boxToBox

tntCollision.setCollisionAnchorPoint(anchorPointX, anchorPointY)

local s, e = 0,0


--local function onEnterFrame(event)
--	e = s
--	s = os.timer()*1000
--	print(s-e)
--end

--stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)