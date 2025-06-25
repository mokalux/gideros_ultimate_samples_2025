--[[

A frame by frame bird animation example
The old frame is removed by Sprite:removeChild and the new frame is added by Sprite:addChild

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 

]]

application:setKeepAwake(true)
playfield=Mesh.new()

-- load texture, create bitmap from it and set as background
local background = Bitmap.new(Texture.new("gfx/sky_2.png"))
playfield:addChild(background)

-- these arrays contain the image file names of each frame
local frames1 = {
	"gfx/bird_black_01",
	"gfx/bird_black_02",
	"gfx/bird_black_03"}

local frames2 = {
	"gfx/bird_white_01",
	"gfx/bird_white_02",
	"gfx/bird_white_03"}

-- create 2 white and 2 black birds
local bird1 = Bird.new(frames1)
local bird2 = Bird.new(frames1)
local bird3 = Bird.new(frames2)
local bird4 = Bird.new(frames2)
local bird5 = Bird.new(frames1)
local bird6 = Bird.new(frames1)
local bird7 = Bird.new(frames2)
local bird8 = Bird.new(frames2)


-- add birds to the stage
playfield:addChild(bird1)
playfield:addChild(bird2)
playfield:addChild(bird3)
playfield:addChild(bird4)
playfield:addChild(bird5)
playfield:addChild(bird6)
playfield:addChild(bird7)
playfield:addChild(bird8)
stage:addChild(playfield)

--Lighting.setLight(240,160,-50,0.5)
--Lighting.setEye(240,160,-100,0.5)
Lighting.setLight(application:getContentWidth() - 64, 0, -50, 1)
Lighting.setEye(256, 512, -50)
