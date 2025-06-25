levelSelectWorld1 = Core.class(Sprite)

function levelSelectWorld1:init()

--------------------------------------------------------------
-- Setup
--------------------------------------------------------------

self.worldNumber = 1

local atlas1 = TexturePack.new("Atlases/Atlas 1.txt", "Atlases/Atlas 1.png", true);
self.atlas1 = atlas1

--------------------------------------------------------------
-- Load the savegame file
--------------------------------------------------------------

-- If save file exists
			
local file = io.open("|D|saveGame.json", "r" )

if(file) then
	self.saveGame = dataSaver.load("|D|saveGame") -- load it
	io.close( file )
else
	self.saveGame = {} -- create blank table
end
			




-- Add gradient

local bg = Bitmap.new(self.atlas[1]:getTextureRegion("level select bg.png"));
self:addChild(bg)
bg:setScaleX(400)

-- Title
local title = Bitmap.new(self.atlas[1]:getTextureRegion("world 1 title.png"));
title:setAnchorPoint(.5,0)
self:addChild(title)
title:setPosition(application:getContentWidth()/2, 10)

-- Level select icons

local icon1 = LevelSelectDoor.new(self,1)
self:addChild(icon1)
icon1:setPosition(75,110)
icon1:openDoor()

local icon2 = LevelSelectDoor.new(self,2)
self:addChild(icon2)
icon2:setPosition(185,110)

local icon3 = LevelSelectDoor.new(self,3)
self:addChild(icon3)
icon3:setPosition(295,110)

local icon4 = LevelSelectDoor.new(self,4)
self:addChild(icon4)
icon4:setPosition(405,110)





local icon5 = LevelSelectDoor.new(self,5)
self:addChild(icon5)
icon5:setPosition(75,220)

local icon6 = LevelSelectDoor.new(self,6)
self:addChild(icon6)
icon6:setPosition(185,220)

local icon7 = LevelSelectDoor.new(self,7)
self:addChild(icon7)
icon7:setPosition(295,220)

local icon8 = LevelSelectDoor.new(self,8)
self:addChild(icon8)
icon8:setPosition(405,220)


fadeFromBlack()

end