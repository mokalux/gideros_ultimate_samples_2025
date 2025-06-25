require "microphone"

-- the future sound
local sound = nil
local channel = nil

-- add a level meter
local levelMeter = LevelMeter.new()
stage:addChild(levelMeter)
levelMeter:setY(30)

-- the microphone
local microphone = Microphone.new(nil, 22050, 1, 16)
microphone:setOutputFile("|D|record.wav")
microphone:addEventListener(Event.DATA_AVAILABLE, function(event)
--	print("*")
	levelMeter:setLevel(event.peakAmplitude)
end)

-- a record button
local record = ButtonUDD.new(
	Bitmap.new(Texture.new("gfx/record-up.png")), -- up state
	Bitmap.new(Texture.new("gfx/record-down.png")), -- down state
	Bitmap.new(Texture.new("gfx/record-disabled.png")) -- disabled state
)
record:setPosition(70, 130)
stage:addChild(record)

local recordStop = ButtonUDD.new(
	Bitmap.new(Texture.new("gfx/stop-up.png")),
	Bitmap.new(Texture.new("gfx/stop-down.png"))
)
recordStop:setPosition(70, 130)

-- a play button
local play = ButtonUDD.new(
	Bitmap.new(Texture.new("gfx/play-up.png")),
	Bitmap.new(Texture.new("gfx/play-down.png")),
	Bitmap.new(Texture.new("gfx/play-disabled.png"))
)
play:setPosition(70, 200)
play:setDisabled(true)
stage:addChild(play)

local playStop = ButtonUDD.new(
	Bitmap.new(Texture.new("gfx/stop-up.png")),
	Bitmap.new(Texture.new("gfx/stop-down.png"))
)
playStop:setPosition(70, 200)

-- buttons listener functions
local function onRecord()
	play:setDisabled(true)
	record:removeFromParent()
	stage:addChild(recordStop)
	microphone:start()
end
record:addEventListener(Event.CLICK, onRecord)

local function onRecordStop()
	play:setDisabled(false)
	recordStop:removeFromParent()
	stage:addChild(record)
	microphone:stop()
	levelMeter:setLevel(0)
	play:setDisabled(false)
end
recordStop:addEventListener(Event.CLICK, onRecordStop)

local function onPlayStop()
	record:setDisabled(false)
	playStop:removeFromParent()
	stage:addChild(play)
	channel:stop()
end
playStop:addEventListener(Event.CLICK, onPlayStop)

local function onPlay()
	record:setDisabled(true)
	play:removeFromParent()
	stage:addChild(playStop)
	sound = Sound.new("|D|record.wav")
	channel = sound:play()
	channel:addEventListener(Event.COMPLETE, onPlayStop)
end
play:addEventListener(Event.CLICK, onPlay)
