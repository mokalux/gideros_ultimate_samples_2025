-- Setup App
--application:setKeepAwake(true)
application:setBackgroundColor(0x000000)

-- Ads plugin
--require "ads"

-- setup tnt animator
local function is32bit()
	return string.dump(is32bit):byte(9) == 4
end

--[[
if is32bit() then require("Classes/tntanimator32")
else require("Classes/tntanimator64")
end
]]
require("Classes/tntanimator")

-- Set up TNT joypad
--[[
if is32bit() then require("Classes/tntvpad32")
else require("Classes/tntvpad64")
end
]]
require("Classes/tntvirtualpad")

require "box2d"

-- SCALING SECTION
scaleMode = application:getLogicalScaleX() -- will be 2 for 2x

-- REMEMBER these values are for portrait, even if game is in landscape
screenWidth = application:getDeviceHeight() / scaleMode
screenHeight = application:getDeviceWidth() / scaleMode

logicalW = application:getLogicalHeight()
logicalH = application:getLogicalWidth()

-- figure out aspect ratios on this device
aspectRatioX = screenWidth/logicalW
aspectRatioY = screenHeight/logicalH

-- figure out x y offset
xOffset = (logicalW - screenWidth) /2
yOffset = (logicalH - screenHeight) /2

-- decide if we're on android
if(string.sub(application:getDeviceInfo(), 1, 7)=="Android") then
	thisDevice = "Android"
end

-- Global volumes
defaultSoundVol = .7
defaultMusicVol = .7

-- SCALING SECTION
scaleMode = application:getLogicalScaleX() -- will be 2 for 2x

-- REMEMBER these values are for portrait, even if game is in landscape
screenWidth = application:getDeviceHeight() / scaleMode
screenHeight = application:getDeviceWidth() / scaleMode

logicalW = application:getLogicalHeight()
logicalH = application:getLogicalWidth()

-- figure out aspect ratios on this device
aspectRatioX = screenWidth/logicalW
aspectRatioY = screenHeight/logicalH

-- figure out x y offset
xOffset = (logicalW - screenWidth) /2
yOffset = (logicalH - screenHeight) /2

--------------------------------------------------
-- Play Sounds function
--------------------------------------------------

--------------------------------------------------
-- Function to unrequire modules
--------------------------------------------------

classes = {} -- stores list of required classes that can be deleted

function unrequire(m)
	_G[m] = nil
	package.loaded[m]  = nil
	collectgarbage()
end

--------------------------------------------------
-- Atlas Functions
--------------------------------------------------
atlasHolder = {}

function loadAtlas(index, name)
	if(not(atlasHolder)) then
		atlasHolder = {}
	end
	if(not(atlasHolder[index])) then
		atlasHolder[index] = TexturePack.new("Atlases/"..name..".txt", "Atlases/"..name..".png", true)
		print("loaded "..name.." into atlasHolder["..index.."]")
	else
		print("atlasHolder["..index.."] already in memory")
	end
end

function unloadAtlas(index)
	if(index=="all") then
		for i,v in pairs(atlasHolder) do
			if(i~=2) then
				v = nil
				print("remove", i)
			end
		end
	else
		if(atlasHolder) then
			atlasHolder[index] = nil
		end
	end
	collectgarbage()
	collectgarbage()
	print("unloaded atlasHolder["..index.."]")
end


function playSound(soundToPlay,volume)
	local sound = Sound.new(soundToPlay)
	local channel1 = sound:play()
	if(channel1) then
		channel1:setVolume(volume)
	end
end

--define scenes
sceneManager = SceneManager.new({
	["Splash Screen"] = splashScreen,
	["splashGideros"] = splashGideros,
	["Menu"] = menu,
	["Settings"] = settings,
	["Level Select World 1"] = levelSelectWorld1,
	["Level Title"] = levelTitle,
	["Level 1"] = level1,
	["Level 2"] = level2,
	["Level 3"] = level3,
	["Level 4"] = level4,
	["Level 5"] = level5,
	["Level 6"] = level6,
	["Level 7"] = level7,
	["Level 8"] = level8,
	["Level 10"] = level10,
	["Level 9"] = level9,
	["Level 11"] = level11,
	["Level 12"] = level12,
	["Level Complete"] = levelComplete,
	["Game Over"] = gameOver,
	["Game Over Out Of Time"] = gameOverOutOfTime,
})

--add manager to stage
stage:addChild(sceneManager)

-- Add black overlay. This will be faded in and out

blackOverlay = Shape.new()
blackOverlay:setFillStyle(Shape.SOLID, 0x000000)       
blackOverlay:beginPath()
blackOverlay:moveTo(xOffset,yOffset)
blackOverlay:lineTo((logicalW+math.abs(xOffset)), yOffset)
blackOverlay:lineTo((logicalW+math.abs(xOffset)), (logicalH+math.abs(yOffset)))
blackOverlay:lineTo(xOffset, (logicalH+math.abs(yOffset)))
blackOverlay:lineTo(xOffset,yOffset)
blackOverlay:endPath()
stage:addChild(blackOverlay)

-- Stores the titles shown on level title screens (global)

levelTitles = {}
levelTitles[1] = "The Old Elf Bridge"
levelTitles[2] = "Shadow Gorge"
levelTitles[3] = "Skull Crush Run"
levelTitles[4] = "Goblin's Pantry"
levelTitles[5] = "Witch Ruins"
levelTitles[6] = "The Wizard's Pet"
levelTitles[7] = "Haunted Elm Hollow"
levelTitles[8] = "The Hidden Orchard"
levelTitles[9] = "The Poisoned Mine"
levelTitles[10] = "The Drowning Stones"
levelTitles[11] = "Sandstone Trials"
levelTitles[12] = "Twelve Ruins"

playMusic = true

enableTitleScreen = true

-- level number we are on
levelNum = 1

sceneManager:changeScene("Splash Screen", 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Menu", 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Level "..levelNum, 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Settings", 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Level Complete", 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Level Select World 1", 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Game Over Out Of Time", 0, SceneManager.flipWithFade, easing.outBack)
--sceneManager:changeScene("Game Over", 0, SceneManager.flipWithFade, easing.outBack)


--[[
-- FPS
local font = Font.new("Fonts/timer red.fnt", "Fonts/timer red.png")
local fps = TextField.new(font, "")
fps:setPosition(20, 70)

local frame = 0
local timer = os.timer()
local qFloor = math.floor
local function displayFps()
	frame = frame + 1
	if frame == 60 then
		local currentTimer = os.timer()
		local text = qFloor(60 / (currentTimer - timer)).." test"
		fps:setText(text)
		frame = 0
		timer = currentTimer	
	end
end
--stage:addChild(fps)
--stage:addEventListener(Event.ENTER_FRAME, displayFps)
--]]

--[[
-- Memory leak checker
memNum = 0
floor = math.floor
monitorMem = function()
	memNum = memNum + 1
	if(memNum==20) then
		collectgarbage()
		collectgarbage()
		collectgarbage()
		memNum = 0
		print("MemUsage: ", floor(collectgarbage("count")))
	end
end
stage:addEventListener(Event.ENTER_FRAME, monitorMem)
--]]

unloadAtlas("all")
