-- This class provides some static methods to manage audio
SoundManager = Core.class()

function SoundManager.setup()
	SoundManager.music = Sound.new("sounds/random-race.mp3")
	
	SoundManager.effects = {
							crash = Sound.new("sounds/crash.wav"),
							engine = Sound.new("sounds/car_engine.wav"),
							accel = Sound.new("sounds/car_accel.wav"),
							brake = Sound.new("sounds/car_brake.wav"),
							revup = Sound.new("sounds/car_revup.wav")
							}
end

-- Start playing main music
function SoundManager.play_music()
		
	local music = SoundManager.music
	local channel = SoundManager.channel
	if (channel) then
		channel:stop()
	end
	
	SoundManager.channel = music:play(0, math.huge)
	SoundManager.channel:setVolume(0.3)
end

-- Stop main music
function SoundManager.stop_music()
	local channel = SoundManager.channel
	if (channel) then
		channel:stop()
	end
end

-- Higher music volume
function SoundManager.high_music()
	local channel = SoundManager.channel
	if (channel) then
		channel:setVolume(1)
	end
end

-- Lower music volume
function SoundManager.low_music()
	local channel = SoundManager.channel
	if (channel) then
		channel:setVolume(0.2)
	end
end

-- Play effect sound
function SoundManager.play_effect(key, loop)

	if (loop) then
		SoundManager.channel_effect = SoundManager.effects[key]:play(0, huge)
	else
		SoundManager.channel_effect = SoundManager.effects[key]:play()
	end
end

-- Return true if effect is playing
function SoundManager.is_playing()
	local channel = SoundManager.channel_effect
	
	return channel:isPlaying()
end

-- Stop playing current effect
function SoundManager.stop_effect()
	local channel = SoundManager.channel_effect
	if (channel and channel:isPlaying()) then
		channel:setVolume(0)
		channel:stop()
	end
end
	
