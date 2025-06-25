SoundFader = Core.class(SoundChannel)

function SoundFader:init(sound, delay)

local channel = sound
local timeLine = 0
local delayTime = delay
local fading = 1

function fadeOut(event)
	timeLine += 1
	if timeLine > delayTime then
		fading-=0.1
		channel:setVolume(fading)
		timeLine = 0
	end
	
	if fading == 0 then
		channel:stop()
	end
	
	print(delayTime, fading)
end

stage:addEventListener(Event.ENTER_FRAME, fadeOut)

end