-- ######################################## --
-- TNT Collision v1.05                      --
-- Copyright (C) 2014 By Gianluca D'Angelo  --
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
application:setBackgroundColor(0x0)
math.randomseed(os.timer())

local logo = Bitmap.new(Texture.new("backgroundlogo.png"))
local txTower = Texture.new("gfx/tower.png")

local sprTower = Bitmap.new(txTower)

local objTower = TTestObject.new(sprTower)

logo:setPosition(0,0)
stage:addChild(logo)


objTower:setPosition(objTower.xPos, objTower.yPos)
stage:addChild(objTower)
tntCollision.setCollisionAnchorPoint(.5, .5)

