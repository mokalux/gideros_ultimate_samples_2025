require "classes/dataSaver"

--module("settings", package.seeall)
settings = {}

--loading application settings
local mysettings
--background music
local music = {}
--sounds
local sounds = {}

function settings.load()
	mysettings = dataSaver.loadValue("sets")
	--if sets not define (first launch)
	--define defaults
	if(not mysettings) then
		mysettings = {}
		mysettings.sounds = true
		mysettings.sndVol = 1
		mysettings.music = true
		mysettings.musicChannel = nil
		mysettings.musicVol = 1
		mysettings.autosave = true
		mysettings.curLevel = 1
		mysettings.curPack = 1
		dataSaver.saveValue("sets", mysettings)
	end
	--play music if enabled
	if mysettings.music then
		music.channel = music.theme:play(0, 1000000)
		music.channel:setVolume(mysettings.musicVol)
	end
end

--load main theme
music.theme = Sound.new("audio/Braam - Retro Pulse.wav")

--turn music on
function settings.musicOn()
	if not mysettings.musicChannel then
--		mysettings.musicChannel = music.theme:play(0, 1000000)
		music.channel = music.theme:play(0, 1000000)
		music.channel:setVolume(mysettings.musicVol)
	end
	mysettings.music = true
	dataSaver.saveValue("sets", mysettings)
end

--turn music off
function settings.musicOff()
--	if mysettings.musicChannel then
	if music.channel then
--		mysettings.musicChannel:stop()
		music.channel:stop()
		mysettings.musicChannel = nil
	end
	mysettings.music = false
	dataSaver.saveValue("sets", mysettings)
end

-- set sfx volume
function settings.musicSetVolume(vol)
	print("musicSetVolume("..vol..")")
	mysettings.musicVol = vol/100
	if mysettings.musicChannel then
		music.channel:setVolume(mysettings.musicVol)
	end
	dataSaver.saveValue("sets", mysettings)
end	


--load all your sounds here
--after that you can simply play them as sounds.play("hit")
--sounds.complete = Sound.new("audio/complete.mp3")
--sounds.hit = Sound.new("audio/hit.wav")

--turn sounds on
function settings.soundOn()
	mysettings.sounds = true
	dataSaver.saveValue("sets", mysettings)
end

--turn sounds off
function settings.soundOff()
	mysettings.sounds = false
	dataSaver.saveValue("sets", mysettings)
end

--play sounds
function settings.soundPlay(sound)
	--check if sounds enabled
	if mysettings.sounds and sounds[sound] then
		mysettings.sndChannel = sounds[sound]:play()
		mysettings.sndChannel:setVolume(mysettings.sndVol)
	end
end

-- set sfx volume
function settings.soundSetVolume(vol)
	print("soundSetVolume("..vol..")")
	mysettings.sndVol = vol/100
	if mysettings.sndChannel then mysettings.sndChannel:setVolume(mysettings.sndVol) end
	dataSaver.saveValue("sets", mysettings)
end	

--turn autosave on
function settings.autosaveOn()
	mysettings.autosave = true
	dataSaver.saveValue("sets", mysettings)
end

--turn autosave off
function settings.autosaveOff()
	mysettings.autosave = false
	dataSaver.saveValue("sets", mysettings)
end

settings.getMusicState = function() return mysettings.music end
settings.musicGetVolume = function() return mysettings.musicVol*100 end
settings.getSoundState = function() return mysettings.sounds end
settings.soundGetVolume = function() return mysettings.sndVol*100 end
settings.getAutosaveState = function() return mysettings.autosave end

return settings
